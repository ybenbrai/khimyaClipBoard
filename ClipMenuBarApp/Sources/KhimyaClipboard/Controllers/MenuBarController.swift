import SwiftUI
import AppKit

@MainActor
class MenuBarController: NSObject, NSApplicationDelegate, NSTextViewDelegate {
    private var statusItem: NSStatusItem!
    private var window: NSWindow!
    private var clipboardManager: ClipboardManager!
    private var eventMonitor: Any?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupClipboardManager()
        setupMenuBar()
        setupWindow()
        setupEventMonitor()
    }

  private func setupMenuBar() {
    statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    if let button = statusItem.button {
        button.image = NSImage(systemSymbolName: "doc.on.clipboard.fill", accessibilityDescription: "Khimya Clipboard")
        button.imagePosition = .imageLeft
        button.target = self
        button.action = #selector(toggleWindow(_:)) // LEFT click
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }
}


    private func setupWindow() {
        window = ClipboardPanelWindow(
            contentRect: NSRect(x: 0, y: 0, width: 792, height: 480),
            styleMask: [.borderless, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        window.backgroundColor = NSColor.windowBackgroundColor
        window.contentView = NSHostingView(rootView: ClipboardHistoryView(
            clipboardManager: clipboardManager
        ))
        window.isReleasedWhenClosed = false
        window.level = .floating
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.ignoresMouseEvents = false
        window.delegate = self
        window.center()
        window.makeKeyAndOrderFront(nil)
    }

    private func setupEventMonitor() {
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            guard let self = self, self.window.isVisible else { return }

            let clickLocation = event.locationInWindow
            let windowFrame = self.window.frame

            if !windowFrame.contains(clickLocation) {
                DispatchQueue.main.async {
                    self.window.orderOut(nil)
                }
            }
        }
    }

    private func setupClipboardManager() {
        clipboardManager = ClipboardManager()
    }

    @objc private func toggleWindow(_ sender: Any?) {
    let event = NSApp.currentEvent
    if event?.type == .rightMouseUp {
        showLeftClickMenu(nil) // RIGHT click
    } else {
        if window.isVisible {
            window.orderOut(nil)
        } else {
            centerWindow()
            window.makeKeyAndOrderFront(nil)
            window.orderFrontRegardless()
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}


    private func centerWindow() {
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            let windowFrame = window.frame
            let newOrigin = NSPoint(
                x: screenFrame.midX - windowFrame.width / 2,
                y: screenFrame.midY - windowFrame.height / 2
            )
            window.setFrameOrigin(newOrigin)
        }
    }

    @objc private func showAbout(_ sender: AnyObject?) {
        // Dismiss the clipboard window first
        if window.isVisible {
            window.orderOut(nil)
        }
        
        let alert = NSAlert()
        alert.messageText = "Khimya Clipboard"
        alert.informativeText = "\n\nVersion 2.0.0\n\nA beautiful clipboard manager for macOS\n\nMade with love for the amazing imedia24 team ❤️\n\nDeveloped by Khimya\n\n🌐 https://imedia24.de\n💻 https://github.com/ybenbrai\n\n© 2025 Khimya"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Back to App")
        
        // Make links clickable
        let attributedString = NSMutableAttributedString(string: alert.informativeText)
        let fullText = alert.informativeText
        
        // Set default text color to system text color
        let fullRange = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttribute(.foregroundColor, value: NSColor.labelColor, range: fullRange)
        
        // Find and make imedia24.de clickable
        if let range = fullText.range(of: "https://imedia24.de") {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.link, value: "https://imedia24.de", range: nsRange)
            attributedString.addAttribute(.foregroundColor, value: NSColor.linkColor, range: nsRange)
        }
        
        // Find and make GitHub link clickable
        if let range = fullText.range(of: "https://github.com/ybenbrai") {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.link, value: "https://github.com/ybenbrai", range: nsRange)
            attributedString.addAttribute(.foregroundColor, value: NSColor.linkColor, range: nsRange)
        }
        
        alert.informativeText = ""
        alert.accessoryView = NSTextView()
        if let textView = alert.accessoryView as? NSTextView {
            textView.isEditable = false
            textView.isSelectable = true
            textView.backgroundColor = NSColor.clear
            textView.textStorage?.setAttributedString(attributedString)
            textView.frame = NSRect(x: 0, y: 0, width: 300, height: 120)
            textView.delegate = self
        }
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            // Reopen and bring the clipboard window to the front
            centerWindow()
            window.makeKeyAndOrderFront(nil)
            window.orderFrontRegardless()
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    @objc private func quitApp(_ sender: AnyObject?) {
        NSApplication.shared.terminate(nil)
    }

    @objc private func showLeftClickMenu(_ sender: AnyObject?) {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "About Khimya Clipboard", action: #selector(showAbout(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp(_:)), keyEquivalent: "q"))

        if let button = statusItem.button {
            menu.popUp(positioning: nil, at: NSPoint(x: 0, y: button.bounds.height), in: button)
        }
    }

    // 🔁 SWAPPED: Left click opens window
    @objc private func handleLeftClick(_ sender: NSClickGestureRecognizer) {
        toggleWindow(nil)
    }

    // 🔁 SWAPPED: Right click shows menu
    @objc private func handleRightClick(_ sender: NSClickGestureRecognizer) {
        showLeftClickMenu(nil)
    }

    func applicationWillTerminate(_ notification: Notification) {
        clipboardManager?.stopMonitoring()
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
        }
    }
    
    // MARK: - NSTextViewDelegate
    func textView(_ textView: NSTextView, clickedOnLink link: Any, at charIndex: Int) -> Bool {
        if let urlString = link as? String, let url = URL(string: urlString) {
            NSWorkspace.shared.open(url)
        }
        return true
    }
}

extension MenuBarController: NSWindowDelegate {
    func windowDidResignKey(_ notification: Notification) {
        if let window = notification.object as? NSWindow, window.attachedSheet != nil {
            return
        }
        window.orderOut(nil)
    }

    func windowDidResignMain(_ notification: Notification) {
        if let window = notification.object as? NSWindow, window.attachedSheet != nil {
            return
        }
        window.orderOut(nil)
    }
}
