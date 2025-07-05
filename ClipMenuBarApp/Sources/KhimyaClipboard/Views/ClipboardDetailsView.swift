import SwiftUI
import AppKit
import WebKit
import SwiftDraw

struct ClipboardDetailsView: View {
    let item: ClipboardItem
    let currentTime: Date

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                previewSection
                Divider()
                infoSection
                Divider()
                actionSection
            }
            .padding(16)
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
        }
        .buttonStyle(LinkButtonStyle())
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
            pasteboard.setString(url.absoluteString, forType: .fileURL)
            pasteboard.setPropertyList([url.path], forType: NSPasteboard.PasteboardType("NSFilenamesPboardType"))
            pasteboard.writeObjects([url as NSURL])
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