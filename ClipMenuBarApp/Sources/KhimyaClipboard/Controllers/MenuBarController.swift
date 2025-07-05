import SwiftUI
import AppKit

@MainActor
class MenuBarController: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var window: NSWindow!
    private var clipboardManager: ClipboardManager!
    private var eventMonitor: Any?
    private var isModalPresented = false

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
            clipboardManager: clipboardManager,
            isModalPresented: Binding(
                get: { [weak self] in self?.isModalPresented ?? false },
                set: { [weak self] v in self?.isModalPresented = v }
            )
        ))
        window.isReleasedWhenClosed = false
        window.level = .normal
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
        let alert = NSAlert()
        alert.messageText = "Khimya Clipboard"
        alert.informativeText = "Version 1.0.0\n\nA beautiful and efficient clipboard manager for macOS\n\nDeveloped with ❤️ by Khimya\nhttps://github.com/ybenbrai"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Close")
        alert.runModal()
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
}

extension MenuBarController: NSWindowDelegate {
    func windowDidResignKey(_ notification: Notification) {
        if isModalPresented { return }
        if let window = notification.object as? NSWindow, window.attachedSheet != nil {
            return
        }
        window.orderOut(nil)
    }

    func windowDidResignMain(_ notification: Notification) {
        if isModalPresented { return }
        if let window = notification.object as? NSWindow, window.attachedSheet != nil {
            return
        }
        window.orderOut(nil)
    }
}
