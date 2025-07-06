import SwiftUI
import AppKit
import ServiceManagement

@MainActor
class MenuBarController: NSObject, NSApplicationDelegate, NSTextViewDelegate {
    private var statusItem: NSStatusItem!
    private var window: NSWindow!
    private var clipboardManager: ClipboardManager!
    private var eventMonitor: Any?
    private var aboutPanel: NSPanel?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupClipboardManager()
        setupMenuBar()
        setupWindow()
        setupEventMonitor()
    }

    private func setupClipboardManager() {
        clipboardManager = ClipboardManager()
    }

    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "doc.on.clipboard.fill", accessibilityDescription: "Khimya Clipboard")
            button.imagePosition = .imageLeft
            button.target = self
            button.action = #selector(toggleWindow(_:))
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

    @objc private func toggleWindow(_ sender: Any?) {
        let event = NSApp.currentEvent
        if event?.type == .rightMouseUp {
            showLeftClickMenu(nil)
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
        // Close any existing About panel first
        aboutPanel?.close()

        let hostingController = NSHostingController(rootView: AboutView(
            onBack: { [weak self] in
                self?.aboutPanel?.close()
                self?.centerWindow()
                self?.window.makeKeyAndOrderFront(nil)
                self?.window.orderFrontRegardless()
                NSApp.activate(ignoringOtherApps: true)
            },
            onClose: { [weak self] in
                self?.aboutPanel?.close()
            }
        ))

        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 420, height: 360),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        panel.isMovableByWindowBackground = true
        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true
        panel.backgroundColor = NSColor.windowBackgroundColor
        panel.title = "About Khimya Clipboard"
        panel.isFloatingPanel = true
        panel.hidesOnDeactivate = false
        panel.contentView = hostingController.view
        panel.center()
        panel.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        aboutPanel = panel
    }

    @objc private func quitApp(_ sender: AnyObject?) {
        NSApplication.shared.terminate(nil)
    }

    @objc private func showLeftClickMenu(_ sender: AnyObject?) {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "About Khimya Clipboard", action: #selector(showAbout(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        
        // Startup options
        let startupItem = NSMenuItem(title: isLaunchAtStartupEnabled() ? "Disable Launch at Startup" : "Enable Launch at Startup", 
                                   action: #selector(toggleLaunchAtStartup(_:)), 
                                   keyEquivalent: "")
        menu.addItem(startupItem)
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp(_:)), keyEquivalent: "q"))

        if let button = statusItem.button {
            menu.popUp(positioning: nil, at: NSPoint(x: 0, y: button.bounds.height), in: button)
        }
    }
    
    @objc private func toggleLaunchAtStartup(_ sender: AnyObject?) {
        if isLaunchAtStartupEnabled() {
            disableLaunchAtStartup()
        } else {
            enableLaunchAtStartup()
        }
    }
    
    private func isLaunchAtStartupEnabled() -> Bool {
        let appService = SMAppService.mainApp
        return appService.status == .enabled
    }
    
    private func enableLaunchAtStartup() {
        let appService = SMAppService.mainApp
        
        do {
            try appService.register()
            print("Launch at startup enabled")
        } catch {
            print("Failed to enable launch at startup: \(error)")
        }
    }
    
    private func disableLaunchAtStartup() {
        let appService = SMAppService.mainApp
        
        do {
            try appService.unregister()
            print("Launch at startup disabled")
        } catch {
            print("Failed to disable launch at startup: \(error)")
        }
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
