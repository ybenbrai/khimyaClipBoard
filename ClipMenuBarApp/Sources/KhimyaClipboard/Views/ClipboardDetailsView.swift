import SwiftUI
import AppKit
import WebKit

struct ClipboardDetailsView: View {
    let item: ClipboardItem
    let currentTime: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Preview
            Group {
                if case .image(let image) = item.content {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 120)
                        .cornerRadius(8)
                        .padding(.top, 16)
                        .padding(.horizontal, 16)
                } else if case .file(let url) = item.content {
                    let ext = url.pathExtension.lowercased()
                    if ext == "svg" {
                        SVGView(url: url)
                            .frame(maxHeight: 120)
                            .padding(.top, 16)
                            .padding(.horizontal, 16)
                    } else if item.content.isDirectory {
                        HStack(spacing: 8) {
                            Image(systemName: "folder")
                                .font(.system(size: 32))
                                .foregroundColor(.yellow)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(url.lastPathComponent.trimmingCharacters(in: .whitespacesAndNewlines))
                                    .font(.system(size: 15, weight: .medium))
                                    .lineLimit(1)
                                Text(url.path.trimmingCharacters(in: .whitespacesAndNewlines))
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                        }
                        .padding(.top, 16)
                        .padding(.horizontal, 16)
                    } else if let nsImage = NSImage(contentsOf: url) {
                        Image(nsImage: nsImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 120)
                            .cornerRadius(8)
                            .padding(.top, 16)
                            .padding(.horizontal, 16)
                    } else {
                        HStack(spacing: 8) {
                            Image(systemName: "doc")
                                .font(.system(size: 32))
                                .foregroundColor(.orange)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(url.lastPathComponent.trimmingCharacters(in: .whitespacesAndNewlines))
                                    .font(.system(size: 15, weight: .medium))
                                    .lineLimit(1)
                                Text(url.path.trimmingCharacters(in: .whitespacesAndNewlines))
                                    .font(.system(size: 11))
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                        }
                        .padding(.top, 16)
                        .padding(.horizontal, 16)
                    }
                } else if case .text(let text) = item.content {
                    ScrollView {
                        Text(text.trimmingCharacters(in: .whitespacesAndNewlines))
                            .font(.system(size: 15, weight: .regular, design: .monospaced))
                            .padding(.top, 16)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxHeight: 120)
                }
            }
            Divider().padding(.vertical, 12)
            // Details
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Application")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Cursor")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.primary)
                }
                HStack {
                    Text("Types")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(item.content.type)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.primary)
                }
                HStack {
                    Text("Number of copies")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(item.copyCount)")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.primary)
                }
                HStack {
                    Text("First copy time")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(dateString(item.firstCopied))
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.primary)
                }
                HStack {
                    Text("Last copy time")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(dateString(item.lastCopied))
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            Spacer()
            // Actions
            HStack {
                Button(action: { copyToClipboard(item) }) {
                    Text("Copy")
                        .font(.system(size: 13, weight: .medium))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 16)
                        .background(Color.accentColor.opacity(0.15))
                        .cornerRadius(6)
                }
                .onHover { hovering in
                    if hovering { NSCursor.pointingHand.push() } else { NSCursor.pop() }
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
    }
    
    private func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
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
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        webView.setValue(false, forKey: "drawsBackground")
        return webView
    }
    func updateNSView(_ nsView: WKWebView, context: Context) {}
} 