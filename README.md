# Khimya Clipboard

A beautiful, modern clipboard manager for macOS that keeps track of your clipboard history with a clean, intuitive interface.

## ✨ Features

- **Clipboard History**: Automatically saves all copied text, images, and files
- **Smart Deduplication**: Prevents duplicate entries from cluttering your history
- **File Support**: Handles text, images, and file URLs with appropriate previews
- **Type Icons**: Visual indicators for different file types with semantic colors (150+ extensions supported)
- **Auto-Start**: Option to launch automatically on system startup
- **Clean UI**: Modern, minimal interface that doesn't interfere with your workflow
- **Pin Items**: Star important items to keep them at the top
- **Search**: Quickly find items in your clipboard history
- **Clear History**: Easy way to clear all clipboard items
- **Sticky Copy Button**: Always-accessible copy button in the details panel

## 🚀 Installation

### Option 1: Download Pre-built App

1. Download the latest release from [Releases](https://github.com/ybenbrai/khimyaClipBoard/releases)
2. Extract the ZIP file
3. Drag `KhimyaClipboard.app` to your Applications folder
4. Launch the app from Applications

### Option 2: Build from Source

```bash
git clone https://github.com/ybenbrai/khimyaClipBoard.git
cd khimyaClipBoard/ClipMenuBarApp
swift build -c release
```

## 🎯 Usage

1. **Launch the app** - It will appear as a menu bar icon
2. **Click the menu bar icon** to open the clipboard history
3. **Copy items** from any application to add them to your history
4. **Click on any item** to view details and copy it back to clipboard
5. **Use the star button** to pin important items
6. **Use the copy button** in the details panel for quick access

## 🎨 Features in Detail

### Clipboard Monitoring

- Automatically detects new clipboard content
- Supports text, images, and file URLs
- Smart deduplication prevents clutter
- Configurable monitoring on/off

### Visual File Type Support

- 150+ file extensions with semantic colors
- Icons for different content types (text, image, file, folder)
- Preview support for images and SVG files

### User Interface

- Clean, modern SwiftUI interface
- Sidebar layout with details panel
- Sticky copy button always accessible
- Hover effects and smooth animations
- Responsive design that adapts to content

### Auto-Start Integration

- Modern SMAppService API for startup integration
- User-friendly toggle in the app
- Proper macOS integration

## 🔧 Technical Details

- **Platform**: macOS 13.0+
- **Language**: Swift 5.9+
- **Framework**: SwiftUI + AppKit
- **Architecture**: MVVM with Combine
- **Dependencies**: SwiftDraw (for SVG support)

## 📝 Development

### Building

```bash
cd ClipMenuBarApp
swift build
swift run
```

### Project Structure

```
ClipMenuBarApp/
├── Sources/KhimyaClipboard/
│   ├── Controllers/     # App controllers
│   ├── Models/          # Data models
│   ├── Views/           # SwiftUI views
│   └── Utils/           # Utilities and constants
├── Package.swift        # Swift Package Manager config
└── Info.plist          # App configuration
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with SwiftUI and modern macOS APIs
- Icons from SF Symbols
- SVG support via SwiftDraw

---

**Made with ❤️ by [Khimya](https://imedia24.de)**
