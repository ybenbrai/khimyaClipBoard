# Khimya Clipboard

A beautiful and efficient clipboard manager for macOS built with SwiftUI.

![Khimya Clipboard](https://img.shields.io/badge/macOS-13.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.1-orange.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## ✨ Features

- **📋 Clipboard History**: Keep track of your last clipboard items
- **🖼️ Image & SVG Preview**: Visual preview of images and SVG files
- **📁 File & Folder Support**: Handle files and directories
- **⚡ Real-time Monitoring**: Instant clipboard detection
- **🖱️ One-click Copy**: Quick copy with a single click
- **🎨 Beautiful UI**: Modern, clean interface with hover effects
- **🔍 Smart Deduplication**: Avoid duplicate entries
- **💾 Persistent Storage**: Your clipboard history stays safe

## 🚀 Installation

### Prerequisites

- macOS 13.0 or later
- Xcode 15.0 or later (for development)

### Build from Source

1. Clone the repository:

```bash
git clone https://github.com/ybenbrai/khimyaClipBoard.git
cd khimyaClipBoard
```

2. Build the project:

```bash
cd ClipMenuBarApp
swift build
```

3. Run the application:

```bash
swift run
```

## 🎯 Usage

1. **Launch**: The app runs in the menu bar with a clipboard icon
2. **Access**: Click the menu bar icon to open the clipboard history
3. **Copy**: Click any item to copy it back to your clipboard
4. **Delete**: Hover over items to see delete buttons
5. **Clear All**: Use the trash button to clear all history
6. **About**: Click the info button to learn more about the app
7. **Quit**: Use the power button to exit the application

## 🛠️ Development

### Project Structure

```
ClipMenuBarApp/
├── Sources/
│   └── KhimyaClipboard/
│       ├── Controllers/
│       │   ├── MenuBarController.swift
│       │   └── ClipboardPanelWindow.swift
│       ├── Models/
│       │   ├── ClipboardManager.swift
│       │   └── ClipboardItem.swift
│       ├── Views/
│       │   ├── ClipboardHistoryView.swift
│       │   ├── ClipboardDetailsView.swift
│       │   ├── ClipboardItemView.swift
│       │   ├── AboutModal.swift
│       │   └── ConfirmClearModal.swift
│       └── Utils/
│           └── Constants.swift
├── Package.swift
└── README.md
```

### Key Components

- **ClipboardManager**: Handles clipboard monitoring and item management
- **MenuBarController**: Manages the menu bar integration and window
- **ClipboardHistoryView**: Main UI with split view (list + details)
- **ClipboardDetailsView**: Shows item preview and metadata
- **SVGView**: Custom WebKit wrapper for SVG rendering

### Building

```bash
# Build for development
swift build

# Build for release
swift build -c release

# Run tests (if any)
swift test
```

## 🎨 UI/UX Features

- **Responsive Design**: Adapts to different screen sizes
- **Hover Effects**: Interactive elements with cursor changes
- **Modern Icons**: SF Symbols for consistent design
- **Smooth Animations**: Polished user experience
- **Accessibility**: Built with accessibility in mind

## 🔧 Technical Details

- **Language**: Swift 6.1
- **Framework**: SwiftUI + AppKit
- **Architecture**: MVVM with ObservableObject
- **Dependencies**: None (pure Swift)
- **Platform**: macOS 13.0+

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Developer

**Khimya** - [GitHub](https://github.com/ybenbrai)

Developed with ❤️ for the macOS community.

## 🙏 Acknowledgments

- Apple for SwiftUI and AppKit
- The macOS development community
- All contributors and users

---

⭐ If you find this project helpful, please give it a star!
