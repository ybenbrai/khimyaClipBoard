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

    // Read file URLs
    if let files = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL], !files.isEmpty {
        let validFiles = files.filter { file in
            let ext = file.pathExtension.lowercased()
            return ["png", "jpg", "jpeg", "gif", "bmp", "tiff", "heic", "webp"].contains(ext) ||
                   ext == "svg" ||
                   FileManager.default.fileExists(atPath: file.path, isDirectory: nil)
        }

        if validFiles.count > 1 {
            let filePaths = validFiles.map { $0.path }.sorted()
            let currentPaths = lastCopiedFile?.components(separatedBy: "|").sorted() ?? []
            if filePaths != currentPaths {
                addItem(content: .multiFile(validFiles))
            }
            return // ✅ Skip any text fallback
        } else if let file = validFiles.first {
            if file.path != lastCopiedFile {
                addItem(content: .file(file))
            }
            return // ✅ Skip any text fallback
        }
    }

    // Read image
    if let image = pasteboard.readObjects(forClasses: [NSImage.self], options: nil)?.first as? NSImage {
        let hash = image.tiffRepresentation?.hashValue ?? 0
        if hash != lastCopiedImageHash {
            addItem(content: .image(image))
        }
        return
    }

    // Read text
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
        
        // Special handling for multi-file deduplication
        if case .multiFile(let newFiles) = content {
            let newPaths = newFiles.map { $0.path }.sorted()
            
            // Check if we already have this exact multi-file selection
            if let existingIndex = items.firstIndex(where: { item in
                if case .multiFile(let existingFiles) = item.content {
                    let existingPaths = existingFiles.map { $0.path }.sorted()
                    return existingPaths == newPaths
                }
                return false
            }) {
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
        } else {
            // Original logic for other content types
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
        case .multiFile(let files):
            lastCopiedFile = files.map { $0.path }.joined(separator: "|")
            clipboardIgnoreUntil = Date().addingTimeInterval(1.5)
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
        case .multiFile(let files):
            pasteboard.writeObjects(files.map { $0 as NSURL })
            lastCopiedFile = files.map { $0.path }.joined(separator: "|")
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
