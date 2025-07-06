import SwiftUI
import AppKit

struct ClipboardItemView: View {
    let item: ClipboardItem
    let currentTime: Date
    let isSelected: Bool
    let onSelect: () -> Void
    let onPin: () -> Void
    let onCopy: () -> Void
    let onDelete: () -> Void

    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 10) {
            Button(action: onPin) {
                Image(systemName: item.pinned ? "star.fill" : "star")
                    .foregroundColor(item.pinned ? .yellow : .gray)
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 20, height: 20)

            Image(systemName: item.content.typeIcon.name)
                .foregroundColor(item.content.typeIcon.color)
                .frame(width: 20, height: 20)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.preview.trimmingCharacters(in: .whitespacesAndNewlines))
                    .font(.system(size: 12, weight: .regular))
                    .lineLimit(1)
                Spacer(minLength: 2)
                Text(timeAgoString(from: item.lastCopied))
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 2)

            Spacer(minLength: 8)

            Button(action: onCopy) {
                Image(systemName: "doc.on.doc")
                    .foregroundColor(.blue)
            }
            .buttonStyle(PlainButtonStyle())
            .help("Copy")

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle())
            .help("Delete")
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(isSelected ? Color.accentColor.opacity(0.15) : isHovered ? Color(NSColor.controlAccentColor).opacity(0.06) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 1)
        )
        .onHover { hovering in
            isHovered = hovering
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onSelect()
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
