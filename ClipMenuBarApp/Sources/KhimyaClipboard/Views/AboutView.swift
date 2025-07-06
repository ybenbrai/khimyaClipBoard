import SwiftUI

struct AboutView: View {
    let onBack: () -> Void
    let onClose: () -> Void
    
    @State private var hoveringBack = false
    @State private var hoveringClose = false
    @State private var hoveringLink1 = false
    @State private var hoveringLink2 = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 12) {
                Image(systemName: "doc.on.clipboard.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.accentColor)
                    .padding(.top, 32)
                
                Text("Khimya Clipboard")
                    .font(.system(size: 28, weight: .bold))
                
                Text("Version 2.0.0")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }

            Divider()
                .padding(.vertical, 20)

            // Info text
            VStack(alignment: .center, spacing: 12) {
                Text("A beautiful clipboard manager for macOS")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 15))
                    .padding(.horizontal, 24)
                
                HStack(spacing: 20) {
                    Link("🌐 imedia24.de", destination: URL(string: "https://imedia24.de")!)
                        .underline(hoveringLink1, color: .accentColor)
                        .onHover { hovering in
                            hoveringLink1 = hovering
                            updateCursor(hovering)
                        }

                    Link("💻 GitHub", destination: URL(string: "https://github.com/ybenbrai")!)
                        .underline(hoveringLink2, color: .accentColor)
                        .onHover { hovering in
                            hoveringLink2 = hovering
                            updateCursor(hovering)
                        }
                }
                .font(.system(size: 13))
                .padding(.bottom, 20)
            }

            Divider()
                .padding(.vertical, 20)

            // Buttons
            HStack(spacing: 16) {
                Button(action: onBack) {
                    Text("Back to App")
                        .font(.system(size: 15, weight: .medium))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 24)
                        .background(hoveringBack ? Color.accentColor.opacity(0.2) : Color.accentColor.opacity(0.1))
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                .onHover { hovering in
                    hoveringBack = hovering
                    updateCursor(hovering)
                }

                Button(action: onClose) {
                    Text("Close")
                        .font(.system(size: 15, weight: .medium))
                        .padding(.vertical, 10)
                        .padding(.horizontal, 24)
                        .background(hoveringClose ? Color.accentColor.opacity(0.9) : Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
                .onHover { hovering in
                    hoveringClose = hovering
                    updateCursor(hovering)
                }
            }
            .padding(.bottom, 32)
        }
        .frame(width: 420)
    }

    private func updateCursor(_ hovering: Bool) {
        if hovering {
            NSCursor.pointingHand.push()
        } else {
            NSCursor.pop()
        }
    }
}
