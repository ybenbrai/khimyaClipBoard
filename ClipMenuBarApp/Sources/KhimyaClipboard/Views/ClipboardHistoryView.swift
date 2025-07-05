import SwiftUI

struct ClipboardHistoryView: View {
    @ObservedObject var clipboardManager: ClipboardManager
    @State private var currentTime = Date()
    @State private var selectedItem: ClipboardItem? = nil
    @State private var showClearConfirmation = false
    @State private var showAboutModal = false
    @State private var hoveringTrash = false
    var isModalPresented: Binding<Bool>?
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            Divider()
            HStack(spacing: 0) {
                // Left panel: List
                VStack(spacing: 0) {
                    Divider()
                    ScrollViewReader { proxy in
                        List(selection: $selectedItem) {
                            ForEach(clipboardManager.items) { item in
                                ClipboardItemView(
                                    item: item,
                                    currentTime: currentTime,
                                    isSelected: selectedItem?.id == item.id,
                                    onSelect: { selectedItem = item },
                                    onCopy: { clipboardManager.copyToClipboard(item) },
                                    onDelete: { clipboardManager.removeItem(item) }
                                )
                                .tag(item as ClipboardItem?)
                                .id(item.id)
                            }
                        }
                        .listStyle(SidebarListStyle())
                        .padding(.vertical, 0)
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
                .frame(width: 384)
                .background(Color(NSColor.windowBackgroundColor))
                // Right panel: Details
                Divider()
                if let selected = selectedItem ?? clipboardManager.items.first {
                    ClipboardDetailsView(item: selected, currentTime: currentTime)
                        .frame(minWidth: 408, maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(NSColor.textBackgroundColor))
                } else {
                    Spacer()
                }
            }
        }
        .frame(minWidth: 792, minHeight: 480)
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear { startTimeUpdate() }
        .onDisappear { stopTimeUpdate() }
        .sheet(isPresented: $showClearConfirmation, onDismiss: {
            isModalPresented?.wrappedValue = false
        }) {
            ConfirmClearModal {
                clipboardManager.clearHistory()
                showClearConfirmation = false
                isModalPresented?.wrappedValue = false
            } onCancel: {
                showClearConfirmation = false
                isModalPresented?.wrappedValue = false
            }
        }
        .sheet(isPresented: $showAboutModal, onDismiss: {
            isModalPresented?.wrappedValue = false
        }) {
            AboutModal {
                showAboutModal = false
                isModalPresented?.wrappedValue = false
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Khimya Clipboard")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            Spacer()
            Button(action: {
                showClearConfirmation = true
                isModalPresented?.wrappedValue = true
            }) {
                Image(systemName: "trash.circle")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle())
            .help("Clear all history")
            .disabled(clipboardManager.items.isEmpty)
            .onHover { hovering in
                hoveringTrash = hovering
                if hovering { NSCursor.pointingHand.push() } else { NSCursor.pop() }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
    
    private func startTimeUpdate() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task { @MainActor in
                currentTime = Date()
            }
        }
    }
    private func stopTimeUpdate() {}
} 