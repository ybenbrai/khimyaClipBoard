import SwiftUI
import AppKit

@main
struct KhimyaClipboardApp: App {
    @NSApplicationDelegateAdaptor(MenuBarController.self) var menuBarController
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
} 