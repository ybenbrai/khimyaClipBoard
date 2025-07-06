import Foundation
import AppKit
import SwiftUI

struct ClipboardItem: Identifiable, Hashable {
    let id: UUID
    let content: ClipboardContent
    var firstCopied: Date
    var lastCopied: Date
    var copyCount: Int
    let preview: String
    var pinned: Bool = false
    
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
                return url.lastPathComponent
            } else {
                return url.lastPathComponent
            }
        }
    }
    
    var type: String {
        switch self {
        case .text:
            return "Text"
        case .image:
            return "Image"
        case .file(_):
            return isDirectory ? "Folder" : "File"
        }
    }
    
    var typeIcon: (name: String, color: Color) {
        switch self {
        case .text:
            return ("doc.text", .blue)
        case .image:
            return ("photo", .green)
        case .file(let url):
            if isDirectory {
                return ("folder", .orange)
            } else {
                let ext = url.pathExtension.lowercased()
                switch ext {
                // Documents
                case "pdf":
                    return ("doc.richtext", .red)
                case "doc", "docx":
                    return ("doc.text", .blue)
                case "xls", "xlsx":
                    return ("chart.bar.doc.horizontal", .green)
                case "ppt", "pptx":
                    return ("chart.bar", .orange)
                case "txt":
                    return ("doc.plaintext", .gray)
                case "rtf":
                    return ("doc.richtext", .purple)
                case "md", "markdown":
                    return ("doc.markdown", .blue)
                
                // Web
                case "html", "htm":
                    return ("doc.html", .orange)
                case "css":
                    return ("doc.css", .blue)
                case "js", "javascript":
                    return ("doc.javascript", .yellow)
                case "json":
                    return ("doc.json", .green)
                case "xml":
                    return ("doc.xml", .orange)
                case "php":
                    return ("doc.php", .purple)
                
                // Archives
                case "zip", "rar", "7z", "tar", "gz", "bz2", "xz":
                    return ("doc.zipper", .purple)
                
                // Media
                case "mp3", "wav", "aac", "flac", "m4a", "ogg":
                    return ("music.note", .pink)
                case "mp4", "avi", "mov", "mkv", "wmv", "flv", "webm":
                    return ("video", .red)
                case "png", "jpg", "jpeg", "gif", "bmp", "tiff", "heic", "webp":
                    return ("photo", .green)
                case "svg":
                    return ("photo.artframe", .purple)
                
                // Code
                case "py", "python":
                    return ("doc.python", .blue)
                case "swift":
                    return ("doc.swift", .orange)
                case "java":
                    return ("doc.java", .red)
                case "cpp", "c", "h", "hpp":
                    return ("doc.cpp", .blue)
                case "rb", "ruby":
                    return ("doc.ruby", .red)
                case "go":
                    return ("doc.go", .blue)
                case "rs", "rust":
                    return ("doc.rust", .orange)
                case "sql":
                    return ("doc.sql", .blue)
                case "sh", "bash", "zsh", "fish":
                    return ("terminal", .green)
                case "yml", "yaml":
                    return ("doc.yaml", .blue)
                case "toml":
                    return ("doc.toml", .purple)
                case "ini", "conf", "config":
                    return ("doc.config", .gray)
                case "log":
                    return ("doc.text.below.ecg", .red)
                case "csv":
                    return ("chart.bar.doc.horizontal", .green)
                case "tsv":
                    return ("chart.bar.doc.horizontal", .green)
                case "dat":
                    return ("doc.data", .purple)
                case "bin":
                    return ("doc.binary", .gray)
                
                // Executables
                case "exe", "app", "dmg", "pkg", "msi", "deb", "rpm":
                    return ("app.badge", .green)
                case "dll", "so", "dylib":
                    return ("gear", .blue)
                case "iso", "img":
                    return ("opticaldisc", .purple)
                
                // Data
                case "vcf", "contact":
                    return ("person.crop.circle", .blue)
                case "ics", "calendar":
                    return ("calendar", .orange)
                case "eml", "email":
                    return ("envelope", .blue)
                case "url", "webloc":
                    return ("link", .blue)
                
                // macOS/iOS
                case "plist":
                    return ("doc.plist", .purple)
                case "strings":
                    return ("doc.strings", .blue)
                case "storyboard", "xib":
                    return ("doc.storyboard", .orange)
                case "xcassets":
                    return ("photo.stack", .blue)
                case "xcworkspace", "xcodeproj":
                    return ("app.badge.plus", .blue)
                case "ipa":
                    return ("app.badge", .blue)
                case "apk":
                    return ("app.badge", .green)
                
                // Development
                case "gitignore":
                    return ("git", .orange)
                case "lock":
                    return ("lock.doc", .red)
                case "env":
                    return ("doc.env", .green)
                case "dockerfile":
                    return ("shippingbox", .blue)
                case "docker-compose":
                    return ("shippingbox.fill", .blue)
                case "package.json", "package-lock.json":
                    return ("doc.json", .green)
                case "requirements.txt":
                    return ("doc.text", .blue)
                case "gemfile", "gemfile.lock":
                    return ("doc.ruby", .red)
                case "cargo.toml", "cargo.lock":
                    return ("doc.rust", .orange)
                case "go.mod", "go.sum":
                    return ("doc.go", .blue)
                case "pom.xml":
                    return ("doc.java", .red)
                case "build.gradle":
                    return ("doc.java", .red)
                case "composer.json", "composer.lock":
                    return ("doc.php", .purple)
                case "pubspec.yaml", "pubspec.lock":
                    return ("doc.dart", .blue)
                case "mix.exs":
                    return ("doc.elixir", .purple)
                case "project.pbxproj":
                    return ("app.badge.plus", .blue)
                case "info.plist":
                    return ("doc.plist", .purple)
                case "entitlements":
                    return ("doc.entitlements", .orange)
                case "provisionprofile":
                    return ("doc.provisionprofile", .blue)
                case "certificatesigningrequest":
                    return ("doc.certificate", .green)
                case "p12", "pem", "crt", "key":
                    return ("doc.certificate", .green)
                case "mobileprovision":
                    return ("doc.provisionprofile", .blue)
                
                // System
                case "framework":
                    return ("gear", .blue)
                case "bundle":
                    return ("shippingbox", .purple)
                case "plugin":
                    return ("puzzlepiece", .orange)
                case "extension":
                    return ("puzzlepiece.extension", .purple)
                case "kext":
                    return ("gear", .orange)
                case "service":
                    return ("gearshape", .blue)
                case "action":
                    return ("bolt", .yellow)
                case "workflow":
                    return ("flowchart", .blue)
                case "automator":
                    return ("gearshape.2", .orange)
                case "scpt", "applescript":
                    return ("doc.applescript", .orange)
                case "command":
                    return ("terminal", .green)
                case "tool":
                    return ("wrench.and.screwdriver", .gray)
                case "script":
                    return ("doc.script", .purple)
                case "template":
                    return ("doc.on.doc", .blue)
                
                // Temporary/System
                case "backup", "bak":
                    return ("arrow.clockwise", .orange)
                case "temp", "tmp":
                    return ("clock", .gray)
                case "cache":
                    return ("internaldrive", .gray)
                
                // Special folders
                case "downloads":
                    return ("arrow.down.circle", .blue)
                case "desktop":
                    return ("display", .blue)
                case "documents":
                    return ("folder", .blue)
                case "pictures":
                    return ("photo.on.rectangle", .green)
                case "music":
                    return ("music.note", .pink)
                case "movies":
                    return ("video", .red)
                case "public":
                    return ("person.2", .green)
                case "library":
                    return ("building.2", .purple)
                case "applications":
                    return ("app.badge", .green)
                case "system":
                    return ("gearshape", .gray)
                case "users":
                    return ("person.3", .blue)
                case "volumes":
                    return ("externaldrive", .orange)
                case "network":
                    return ("network", .blue)
                case "trash":
                    return ("trash", .red)
                
                default:
                    return ("doc", .gray)
                }
            }
        }
    }
} 