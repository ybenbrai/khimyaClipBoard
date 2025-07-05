import SwiftUI

struct AboutModal: View {
    let onClose: () -> Void
    @State private var hoveringClose = false
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                Image(systemName: "doc.on.clipboard.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.accentColor)
                
                Text("Khimya Clipboard")
                    .font(.system(size: 24, weight: .bold))
                
                Text("Version 1.0.0")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 12) {
                Text("A beautiful and efficient clipboard manager for macOS")
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                
                Text("Features:")
                    .font(.system(size: 14, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 6) {
                    FeatureRow(icon: "doc.text", text: "Text clipboard history")
                    FeatureRow(icon: "photo", text: "Image and SVG preview")
                    FeatureRow(icon: "folder", text: "File and folder support")
                    FeatureRow(icon: "clock", text: "Real-time monitoring")
                    FeatureRow(icon: "doc.on.doc", text: "One-click copy")
                }
            }
            
            VStack(spacing: 8) {
                Text("Developed with ❤️ by")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                
                Text("Khimya")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("https://github.com/ybenbrai")
                    .font(.system(size: 12))
                    .foregroundColor(.blue)
                    .onTapGesture {
                        if let url = URL(string: "https://github.com/ybenbrai") {
                            NSWorkspace.shared.open(url)
                        }
                    }
                    .onHover { hovering in
                        if hovering { NSCursor.pointingHand.push() } else { NSCursor.pop() }
                    }
            }
            
            Button(action: onClose) {
                Text("Close")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .frame(minWidth: 100)
                    .padding(.vertical, 8)
                    .background(Color.accentColor)
                    .cornerRadius(8)
            }
            .keyboardShortcut(.defaultAction)
            .onHover { hovering in
                hoveringClose = hovering
                if hovering { NSCursor.pointingHand.push() } else { NSCursor.pop() }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .frame(width: 400)
        .padding(32)
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(.accentColor)
                .frame(width: 16)
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(.primary)
            Spacer()
        }
    }
} 