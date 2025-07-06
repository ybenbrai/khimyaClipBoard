import SwiftUI

struct ClipboardHistoryView: View {
    @ObservedObject var clipboardManager: ClipboardManager
    @State private var currentTime = Date()
    @State private var selectedItem: ClipboardItem? = nil
    @State private var showClearConfirmation = false
    @State private var sortDescending = true
    @State private var showDeleteConfirmation = false
    @State private var itemToDelete: ClipboardItem? = nil
    @State private var timeUpdateTimer: Timer?

    var body: some View {
        Group {
            if clipboardManager.items.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "doc.on.clipboard")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 72, height: 72)
                        .foregroundColor(Color.secondary.opacity(0.5))
                    Text("Your clipboard is empty")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Text("Start copying text or links to build your history.")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(NSColor.windowBackgroundColor))
            } else {
                HStack(spacing: 0) {
                    // Sidebar
                    VStack(spacing: 0) {
                        header
                        Divider()
                        ScrollViewReader { proxy in
                            List(selection: $selectedItem) {
                                ForEach(clipboardManager.items) { item in
                                    ClipboardItemView(
                                        item: item,
                                        currentTime: currentTime,
                                        isSelected: selectedItem?.id == item.id,
                                        onSelect: { selectedItem = item },
                                        onPin: { togglePin(item) },
                                        onCopy: { clipboardManager.copyToClipboard(item) },
                                        onDelete: { itemToDelete = item; showDeleteConfirmation = true }
                                    )
                                    .tag(item as ClipboardItem?)
                                    .id(item.id)
                                }
                            }
                            .listStyle(SidebarListStyle())
                            .onChange(of: clipboardManager.items.first?.id) { firstId in
                                if let firstId = firstId {
                                    withAnimation { proxy.scrollTo(firstId, anchor: .top) }
                                }
                            }
                            .onAppear {
                                if let firstId = clipboardManager.items.first?.id {
                                    proxy.scrollTo(firstId, anchor: .top)
                                }
                            }
                        }
                    }
                    .frame(minWidth: 300, idealWidth: 320, maxWidth: 340)
                    .background(Color(NSColor.windowBackgroundColor))

                    Divider()

                    // Details
                    VStack(spacing: 0) {
                        if let selected = selectedItem ?? clipboardManager.items.first {
                            ClipboardDetailsView(item: selected, currentTime: currentTime)
                                .background(Color(NSColor.textBackgroundColor))
                        } else {
                            Spacer()
                        }
                    }
                    .frame(minWidth: 380, maxWidth: .infinity)
                }
                .frame(minWidth: 700, minHeight: 400)
                .background(Color(NSColor.windowBackgroundColor))
            }
        }
        .onAppear { startTimeUpdate() }
        .onDisappear { stopTimeUpdate() }
        .sheet(isPresented: $showDeleteConfirmation) {
            ConfirmClearModal(
                message: "Are you sure you want to delete this item? This cannot be undone.",
                confirmLabel: "Delete",
                onConfirm: {
                    if let item = itemToDelete {
                        clipboardManager.removeItem(item)
                        itemToDelete = nil
                    }
                    showDeleteConfirmation = false
                },
                onCancel: {
                    showDeleteConfirmation = false
                    itemToDelete = nil
                }
            )
        }
        .sheet(isPresented: $showClearConfirmation) {
            ConfirmClearModal(
                message: "Are you sure you want to delete all clipboard items? This cannot be undone.",
                confirmLabel: "Clear All",
                onConfirm: {
                    clipboardManager.clearHistory()
                    showClearConfirmation = false
                },
                onCancel: {
                    showClearConfirmation = false
                }
            )
        }
    }

    private var header: some View {
        HStack(spacing: 8) {
            Image(systemName: "rectangle.on.rectangle")
                .font(.system(size: 16))
                .foregroundColor(.accentColor)
            Text("Khimya Clipboard")
                .font(.system(size: 15, weight: .medium))
            Spacer()
            Button(action: { toggleSortOrder() }) {
                Image(systemName: sortDescending ? "arrow.down" : "arrow.up")
                    .foregroundColor(.secondary)
            }
            .buttonStyle(PlainButtonStyle())
            .help("Sort Order")

            Button(action: {
                showClearConfirmation = true
            }) {
                Image(systemName: "trash.slash")
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle())
            .help("Clear all history")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }

    private func startTimeUpdate() {
        timeUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task { @MainActor in
                currentTime = Date()
            }
        }
    }

    private func stopTimeUpdate() {
        timeUpdateTimer?.invalidate()
    }

    private func togglePin(_ item: ClipboardItem) {
        if let idx = clipboardManager.items.firstIndex(where: { $0.id == item.id }) {
            clipboardManager.items[idx].pinned.toggle()
            clipboardManager.sortItems()
        }
    }

    private func toggleSortOrder() {
        sortDescending.toggle()
        clipboardManager.items = clipboardManager.items.sorted { (a, b) in
            if a.pinned != b.pinned {
                return a.pinned && !b.pinned
            }
            return sortDescending ? (a.lastCopied > b.lastCopied) : (a.lastCopied < b.lastCopied)
        }
    }
}
