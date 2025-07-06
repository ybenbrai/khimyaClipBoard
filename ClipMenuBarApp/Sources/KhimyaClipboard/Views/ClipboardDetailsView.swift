import SwiftUI
import AppKit
import WebKit
import SwiftDraw

struct ClipboardDetailsView: View {
    let item: ClipboardItem
    let currentTime: Date

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    previewSection
                    Divider()
                    infoSection
                    Divider()
                    Spacer(minLength: 60)
                }
                .padding(16)
            }
            HStack {
                Button(action: {
                    copyToClipboard(item)
                }) {
                    Label("Copy", systemImage: "doc.on.doc")
                        .foregroundColor(.white)
                        .font(.system(size: 11, weight: .medium))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(Color.accentColor)
                        .cornerRadius(6)
                        .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 1)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 4)
                .padding(.leading, 24)
                .padding(.trailing, 24)
                .padding(.top, 8)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(VisualEffectView(material: .sidebar, blendingMode: .withinWindow).edgesIgnoringSafeArea(.bottom))
        }
    }

    private var previewSection: some View {
        Group {
            if case .image(let image) = item.content {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(6)
            } else if case .file(let url) = item.content {
                filePreview(url: url)
            } else if case .multiFile(let urls) = item.content {
                multiFilePreview(urls: urls)
            } else if case .text(let text) = item.content {
                ScrollView(.vertical) {
                    Text(text)
                        .font(.system(size: 13, weight: .regular, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    private func filePreview(url: URL) -> some View {
        let ext = url.pathExtension.lowercased()
        if ext == "svg" {
            return AnyView(
                SVGView(url: url)
                    .frame(maxHeight: 150)
                    .background(Color.clear)
            )
        } else if ["png", "jpg", "jpeg", "gif", "bmp", "tiff", "heic", "webp"].contains(ext), let nsImage = NSImage(contentsOf: url) {
            return AnyView(
                Image(nsImage: nsImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(6)
            )
        } else if item.content.isDirectory {
            return AnyView(
                Label(url.lastPathComponent, systemImage: "folder")
                    .font(.system(size: 14))
            )
        } else {
            return AnyView(
                Label(url.lastPathComponent, systemImage: "doc")
                    .font(.system(size: 14))
            )
        }
    }

    private func multiFilePreview(urls: [URL]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "shippingbox.fill")
                    .foregroundColor(.purple)
                Text("\(urls.count) Files & Folders")
                    .font(.system(size: 14, weight: .medium))
                Spacer()
            }
            .padding(.bottom, 4)
            
            LazyVStack(alignment: .leading, spacing: 6) {
                ForEach(urls, id: \.path) { url in
                    HStack(spacing: 8) {
                        Image(systemName: getFileIcon(for: url))
                            .foregroundColor(getFileColor(for: url))
                            .frame(width: 16, height: 16)
                        Text(url.lastPathComponent)
                            .font(.system(size: 12))
                            .lineLimit(1)
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(4)
                }
            }
        }
    }
    
    private func getFileIcon(for url: URL) -> String {
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir) && isDir.boolValue {
            return "folder"
        }
        
        let ext = url.pathExtension.lowercased()
        switch ext {
        case "pdf": return "doc.richtext"
        case "doc", "docx": return "doc.text"
        case "xls", "xlsx": return "chart.bar.doc.horizontal"
        case "ppt", "pptx": return "chart.bar"
        case "png", "jpg", "jpeg", "gif", "bmp", "tiff", "heic", "webp": return "photo"
        case "svg": return "photo.artframe"
        case "mp3", "wav", "aac", "flac", "m4a", "ogg": return "music.note"
        case "mp4", "avi", "mov", "mkv", "wmv", "flv", "webm": return "video"
        case "zip", "rar", "7z", "tar", "gz", "bz2", "xz": return "doc.zipper"
        case "py", "swift", "java", "cpp", "c", "h", "rb", "go", "rs", "sql": return "doc.text"
        case "html", "htm", "css", "js", "json", "xml", "php": return "doc.text"
        case "app", "exe", "dmg", "pkg": return "app.badge"
        default: return "doc"
        }
    }
    
    private func getFileColor(for url: URL) -> Color {
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir) && isDir.boolValue {
            return .orange
        }
        
        let ext = url.pathExtension.lowercased()
        switch ext {
        case "pdf": return .red
        case "doc", "docx": return .blue
        case "xls", "xlsx": return .green
        case "ppt", "pptx": return .orange
        case "png", "jpg", "jpeg", "gif", "bmp", "tiff", "heic", "webp": return .green
        case "svg": return .purple
        case "mp3", "wav", "aac", "flac", "m4a", "ogg": return .pink
        case "mp4", "avi", "mov", "mkv", "wmv", "flv", "webm": return .red
        case "zip", "rar", "7z", "tar", "gz", "bz2", "xz": return .purple
        case "py": return .blue
        case "swift": return .orange
        case "java": return .red
        case "app", "exe", "dmg", "pkg": return .green
        default: return .gray
        }
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            infoRow("Type", item.content.type)
            infoRow("Copies", "\(item.copyCount)")
            infoRow("First Copied", dateString(item.firstCopied))
            infoRow("Last Copied", dateString(item.lastCopied))
        }
    }

    private func infoRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title).font(.system(size: 11)).foregroundColor(.secondary)
            Spacer()
            Text(value).font(.system(size: 11))
        }
    }

    private var actionSection: some View {
        Button(action: {
            copyToClipboard(item)
        }) {
            Label("Copy to Clipboard", systemImage: "doc.on.doc")
                .foregroundColor(.blue)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func copyToClipboard(_ item: ClipboardItem) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        switch item.content {
        case .text(let text):
            pasteboard.setString(text, forType: .string)
        case .image(let image):
            pasteboard.writeObjects([image])
        case .file(let url):
            pasteboard.writeObjects([url as NSURL])
        case .multiFile(let urls):
            pasteboard.writeObjects(urls.map { $0 as NSURL })
        }
    }
}

struct SVGView: NSViewRepresentable {
    let url: URL
    func makeNSView(context: Context) -> NSView {
        guard let svg = SVG(fileURL: url) else {
            return NSView()
        }
        let svgView = SwiftDraw.SVGView(svg: svg)
        let hostingView = NSHostingView(rootView: svgView)
        hostingView.frame = CGRect(origin: .zero, size: svg.size)
        hostingView.wantsLayer = true
        hostingView.layer?.backgroundColor = CGColor.clear
        return hostingView
    }
    func updateNSView(_ nsView: NSView, context: Context) {}
}

struct VisualEffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}