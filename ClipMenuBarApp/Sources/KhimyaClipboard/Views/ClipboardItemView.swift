import SwiftUI
import AppKit

struct ClipboardItemView: View {
    let item: ClipboardItem
    let currentTime: Date
    let isSelected: Bool
    let onSelect: () -> Void
    let onCopy: () -> Void
    let onDelete: () -> Void
    
    @State private var isHovered = false
    @State private var hoveringCopy = false
    @State private var hoveringDelete = false
    
    var body: some View {
        HStack(spacing: 10) {
            contentIcon
                .frame(width: 22, height: 22)
            VStack(alignment: .leading, spacing: 2) {
                Text(item.preview)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                Text(timeAgoString(from: item.lastCopied))
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.secondary)
            }
            Spacer()
            if isHovered || isSelected {
                Button(action: onCopy) {
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())
                .onHover { hovering in
                    hoveringCopy = hovering
                    if hovering { NSCursor.pointingHand.push() } else { NSCursor.pop() }
                }
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.red)
                }
                .buttonStyle(PlainButtonStyle())
                .onHover { hovering in
                    hoveringDelete = hovering
                    if hovering { NSCursor.pointingHand.push() } else { NSCursor.pop() }
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            ZStack {
                if isSelected {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.accentColor.opacity(0.15))
                } else if isHovered {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(NSColor.controlAccentColor).opacity(0.07))
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 1.5)
        )
        .onHover { hovering in
            isHovered = hovering
            if hovering { NSCursor.pointingHand.push() } else { NSCursor.pop() }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onSelect()
        }
    }
    
    @ViewBuilder
    private var contentIcon: some View {
        switch item.content {
        case .text:
            Image(systemName: "doc.text")
                .foregroundColor(.blue)
        case .image:
            Image(systemName: "photo")
                .foregroundColor(.green)
        case .file(let url):
            if item.content.isDirectory {
                Image(systemName: "folder")
                    .foregroundColor(.yellow)
            } else if url.pathExtension.lowercased() == "png" || url.pathExtension.lowercased() == "jpg" || url.pathExtension.lowercased() == "jpeg" || url.pathExtension.lowercased() == "gif" {
                Image(systemName: "photo")
                    .foregroundColor(.green)
            } else {
                Image(systemName: "doc")
                    .foregroundColor(.orange)
            }
        }
    }
    
    private func timeAgoString(from date: Date) -> String {
        let interval = currentTime.timeIntervalSince(date)
        if interval < 60 { return "Just now" }
        else if interval < 3600 { return "\(Int(interval / 60))m ago" }
        else if interval < 86400 { return "\(Int(interval / 3600))h ago" }
        else if interval < 604800 { return "\(Int(interval / 86400))d ago" }
        else {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
    }
} 