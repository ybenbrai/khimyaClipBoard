import SwiftUI

struct ConfirmClearModal: View {
    let onConfirm: () -> Void
    let onCancel: () -> Void
    @State private var hoveringCancel = false
    @State private var hoveringDelete = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Clear Clipboard History")
                .font(.system(size: 18, weight: .bold))
                .padding(.top, 12)
            Text("Are you sure you want to delete all clipboard items? This cannot be undone.")
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            HStack(spacing: 16) {
                Button(action: onCancel) {
                    Text("Cancel")
                        .frame(minWidth: 80)
                        .padding(.vertical, 6)
                        .background(Color(NSColor.windowBackgroundColor))
                        .foregroundColor(.primary)
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color(NSColor.separatorColor), lineWidth: 1)
                        )
                }
                .keyboardShortcut(.cancelAction)
                .onHover { hovering in
                    hoveringCancel = hovering
                    if hovering { NSCursor.pointingHand.push() } else { NSCursor.pop() }
                }
                .buttonStyle(PlainButtonStyle())
                Button(action: onConfirm) {
                    Text("Delete")
                        .foregroundColor(.white)
                        .frame(minWidth: 80)
                        .padding(.vertical, 6)
                        .background(Color.red)
                        .cornerRadius(6)
                }
                .keyboardShortcut(.defaultAction)
                .onHover { hovering in
                    hoveringDelete = hovering
                    if hovering { NSCursor.pointingHand.push() } else { NSCursor.pop() }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.bottom, 12)
        }
        .frame(width: 408)
        .padding()
    }
} 