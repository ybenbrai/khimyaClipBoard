# Khimya Clipboard - Installation Guide

## 🚀 Quick Installation

### For End Users

1. **Download the App**

   - Go to [GitHub Releases](https://github.com/ybenbrai/khimyaClipBoard/releases)
   - Download the latest `KhimyaClipboard-App.zip`

2. **Install**

   - Extract the ZIP file
   - Drag `KhimyaClipboard.app` to your Applications folder
   - Launch from Applications

3. **First Launch**
   - The app will appear in your menu bar
   - Click the clipboard icon to open
   - Grant clipboard access if prompted

### For Developers

1. **Clone the Repository**

   ```bash
   git clone https://github.com/ybenbrai/khimyaClipBoard.git
   cd khimyaClipBoard/ClipMenuBarApp
   ```

2. **Build and Package**
   ```bash
   ./build.sh
   ```
   - This will build the latest version, update the .app bundle, and create a DMG in the `dist/` folder.
   - The app version is now **1.0.1**.

## 🔧 System Requirements

- **macOS**: 13.0 or later
- **Architecture**: Apple Silicon (M1/M2) or Intel
- **Memory**: 50MB RAM
- **Storage**: 10MB disk space

## 🎯 Features

### Core Functionality

- **Clipboard History**: Automatic tracking of copied content
- **Multi-File Grouping**: Copying multiple files/folders creates a single grouped entry with a count and preview, not separate text entries for names
- **Multi-format Support**: Text, images, files, and URLs
- **Smart Deduplication**: Prevents duplicate entries
- **Visual Type Icons**: 150+ file extensions with semantic colors

### User Interface

- **Modern SwiftUI**: Clean, responsive design
- **Menu Bar Integration**: Easy access from anywhere
- **Sticky Copy Button**: Always-accessible copy functionality
- **Hover Effects**: Interactive elements with visual feedback

### Advanced Features

- **Pin Items**: Star important clipboard entries
- **Auto-Start**: Launch automatically on system startup
- **Search & Filter**: Find items quickly
- **Clear History**: Easy cleanup options

## 🔒 Security & Permissions

The app requires the following permissions:

- **Clipboard Access**: To monitor and copy content
- **Auto-Start**: To launch at system startup (optional)

All permissions are handled through standard macOS security dialogs.

## 🐛 Troubleshooting

### App Won't Launch

1. Check macOS version (requires 13.0+)
2. Verify the app is in Applications folder
3. Check Gatekeeper settings in System Preferences

### Clipboard Not Working

1. Grant clipboard access when prompted
2. Check System Preferences > Security & Privacy > Privacy > Accessibility
3. Restart the app if needed

### Auto-Start Issues

1. Enable auto-start in the app's About panel
2. Check System Preferences > Users & Groups > Login Items
3. Restart your Mac to test

## 📝 Development Notes

### Project Structure

```
ClipMenuBarApp/
├── Sources/KhimyaClipboard/
│   ├── Controllers/     # App lifecycle and window management
│   ├── Models/          # Data models and clipboard management
│   ├── Views/           # SwiftUI user interface components
│   └── Utils/           # Constants and utilities
├── Package.swift        # Swift Package Manager configuration
└── Info.plist          # App metadata and permissions
```

### Key Technologies

- **SwiftUI**: Modern declarative UI framework
- **AppKit**: Native macOS integration
- **Combine**: Reactive programming for data flow
- **SwiftDraw**: SVG rendering support

### Building for Distribution

```bash
./build.sh
# The built app will be in dist/KhimyaClipboard.app and DMG in dist/KhimyaClipboard.dmg
```

## 🤝 Support

- **GitHub Issues**: Report bugs or request features
- **Documentation**: Check the main README.md
- **Developer**: [Khimya](https://imedia24.de)

---

**Khimya Clipboard** - A modern clipboard manager for macOS
