import Foundation
import AppKit
import Combine

@MainActor
class ClipboardManager: ObservableObject {
    @Published var items: [ClipboardItem] = []
    @Published var isMonitoring = true

    private var lastText: String = ""
    private var timer: Timer?
    private let maxItems = 50

    private var lastCopiedText: String? = nil
    private var lastCopiedFile: String? = nil
    private var lastCopiedImageHash: Int? = nil
    private var isCopyingFromApp = false
    private var clipboardIgnoreUntil: Date? = nil

    init() {
        let pasteboard = NSPasteboard.general
        if let files = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL], let file = files.first {
            lastCopiedFile = file.path
        } else if let image = pasteboard.readObjects(forClasses: [NSImage.self], options: nil)?.first as? NSImage {
            lastCopiedImageHash = image.tiffRepresentation?.hashValue ?? 0
        } else if let text = pasteboard.string(forType: .string), !text.isEmpty {
            lastCopiedText = text
        }
        startMonitoring()
    }

    func startMonitoring() {
        isMonitoring = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                self.checkClipboard()
            }
        }
        timer?.fire()
    }

    func stopMonitoring() {
        isMonitoring = false
        timer?.invalidate()
        timer = nil
    }

    private func checkClipboard() {
        guard isMonitoring else { return }
        if let until = clipboardIgnoreUntil, Date() < until {
            return
        }
        if isCopyingFromApp {
            isCopyingFromApp = false
            return
        }
        let pasteboard = NSPasteboard.general
        if let files = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL], let file = files.first {
            let ext = file.pathExtension.lowercased()
            if ["png", "jpg", "jpeg", "gif", "bmp", "tiff", "heic", "webp"].contains(ext) ||
               ext == "svg" ||
               FileManager.default.fileExists(atPath: file.path, isDirectory: nil) {
                if file.path == lastCopiedFile { return }
                addItem(content: .file(file))
                return
            }
        }
        if let image = pasteboard.readObjects(forClasses: [NSImage.self], options: nil)?.first as? NSImage {
            let hash = image.tiffRepresentation?.hashValue ?? 0
            if hash == lastCopiedImageHash { return }
            addItem(content: .image(image))
            return
        }
        if let text = pasteboard.string(forType: .string), !text.isEmpty {
            if text == lastCopiedText { return }
            if !items.contains(where: { if case .text(let t) = $0.content { return t == text } else { return false } }) {
                addItem(content: .text(text))
            }
        }
    }

    func sortItems() {
        items = items.sorted { (a, b) in
            if a.pinned != b.pinned {
                return a.pinned && !b.pinned
            }
            return a.lastCopied > b.lastCopied
        }
    }

    private func addItem(content: ClipboardContent) {
        let now = Date()
        if let existingIndex = items.firstIndex(where: { $0.content.preview == content.preview }) {
            items[existingIndex].lastCopied = now
            items[existingIndex].copyCount += 1
            let updated = items.remove(at: existingIndex)
            items.insert(updated, at: 0)
        } else {
            let newItem = ClipboardItem(content: content, date: now)
            items.insert(newItem, at: 0)
            if items.count > maxItems {
                items = Array(items.prefix(maxItems))
            }
        }
        sortItems()

        switch content {
        case .text(let text):
            lastCopiedText = text
        case .image(let image):
            lastCopiedImageHash = image.tiffRepresentation?.hashValue ?? 0
        case .file(let url):
            lastCopiedFile = url.path
            clipboardIgnoreUntil = Date().addingTimeInterval(1.5) // cooldown for files
        }

        print("Added clipboard item: \(content.preview)")
    }

    func copyToClipboard(_ item: ClipboardItem) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        isCopyingFromApp = true
        clipboardIgnoreUntil = Date().addingTimeInterval(1.0)
        
        switch item.content {
        case .text(let text):
            pasteboard.setString(text, forType: .string)
            lastCopiedText = text
        case .image(let image):
            pasteboard.writeObjects([image])
            lastCopiedImageHash = image.tiffRepresentation?.hashValue ?? 0
        case .file(let url):
            pasteboard.writeObjects([url as NSURL])
            lastCopiedFile = url.path
            clipboardIgnoreUntil = Date().addingTimeInterval(1.5)
        }
    }

    func clearHistory() {
        items.removeAll()
        lastCopiedText = nil
        lastCopiedFile = nil
        lastCopiedImageHash = nil
        NSPasteboard.general.clearContents()
    }

    func removeItem(_ item: ClipboardItem) {
        items.removeAll { $0.id == item.id }
        sortItems()
        if items.isEmpty {
            lastCopiedText = nil
            lastCopiedFile = nil
            lastCopiedImageHash = nil
            NSPasteboard.general.clearContents()
        }
    }
}
