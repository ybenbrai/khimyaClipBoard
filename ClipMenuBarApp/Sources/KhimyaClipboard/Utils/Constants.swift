import Foundation

enum Constants {
    enum UI {
        static let popoverWidth: CGFloat = 320
        static let popoverHeight: CGFloat = 400
        static let maxClipboardItems = 10
        static let clipboardCheckInterval: TimeInterval = 0.5
    }
    
    enum App {
        static let name = "Khimya Clipboard"
        static let version = "1.0.0"
        static let bundleIdentifier = "com.khimya.clipboard"
    }
    
    enum Icons {
        static let menuBarIcon = "doc.on.clipboard.fill"
        static let textIcon = "doc.text"
        static let imageIcon = "photo"
        static let fileIcon = "doc"
        static let copyIcon = "doc.on.doc"
        static let deleteIcon = "trash"
        static let playIcon = "play.circle"
        static let pauseIcon = "pause.circle"
        static let clearIcon = "trash.circle"
    }
} 