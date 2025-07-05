import Foundation
import AppKit

struct ClipboardItem: Identifiable, Hashable {
    let id: UUID
    let content: ClipboardContent
    var firstCopied: Date
    var lastCopied: Date
    var copyCount: Int
    let preview: String
    
    init(content: ClipboardContent, date: Date = Date()) {
        self.id = UUID()
        self.content = content
        self.firstCopied = date
        self.lastCopied = date
        self.copyCount = 1
        self.preview = content.preview
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ClipboardItem, rhs: ClipboardItem) -> Bool {
        lhs.id == rhs.id
    }
}

enum ClipboardContent {
    case text(String)
    case image(NSImage)
    case file(URL)
    
    var isDirectory: Bool {
        switch self {
        case .file(let url):
            var isDir: ObjCBool = false
            FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir)
            return isDir.boolValue
        default:
            return false
        }
    }
    
    var preview: String {
        switch self {
        case .text(let string):
            return string.count > 50 ? String(string.prefix(50)) + "..." : string
        case .image:
            return "📷 Image"
        case .file(let url):
            if isDirectory {
                return "📁 \(url.lastPathComponent)"
            } else {
                return "📄 \(url.lastPathComponent)"
            }
        }
    }
    
    var type: String {
        switch self {
        case .text:
            return "Text"
        case .image:
            return "Image"
        case .file(let url):
            return isDirectory ? "Folder" : "File"
        }
    }
} 