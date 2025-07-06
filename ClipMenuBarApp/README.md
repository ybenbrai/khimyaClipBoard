# Khimya Clipboard

A beautiful and efficient clipboard manager for macOS built with SwiftUI.

## 🚀 Quick Start

### For Your Friends (Easy Installation)

1. **Download**: Get the `KhimyaClipboard` executable from the `dist` folder
2. **Run**: Double-click the `KhimyaClipboard` file to start the app
3. **Use**: The app will appear in your menu bar with a clipboard icon

### System Requirements

- macOS 13.0 or later
- No additional installation required

## ✨ Features

- **📋 Clipboard History**: Keep track of your last clipboard items
- **🖼️ Image & SVG Preview**: Visual preview of images and SVG files
- **📁 File & Folder Support**: Handle files and directories
- **⚡ Real-time Monitoring**: Instant clipboard detection
- **🖱️ One-click Copy**: Quick copy with a single click
- **🎨 Beautiful UI**: Modern, clean interface with hover effects
- **🔍 Smart Deduplication**: Avoid duplicate entries
- **💾 Persistent Storage**: Your clipboard history stays safe

## 🎯 Usage

1. **Launch**: The app runs in the menu bar with a clipboard icon
2. **Access**: Click the menu bar icon to open the clipboard history
3. **Copy**: Click any item to copy it back to your clipboard
4. **Delete**: Hover over items to see delete buttons
5. **Clear All**: Use the trash button to clear all history
6. **About**: Click the info button to learn more about the app
7. **Quit**: Use the power button to exit the application

## 🔧 For Developers

### Build from Source

1. Clone the repository:

```bash
git clone https://github.com/ybenbrai/khimyaClipBoard.git
cd khimyaClipBoard/ClipMenuBarApp
```

2. Build and package the app and DMG:

```bash
./build.sh
```

- This will build the latest version, update the .app bundle, and create a DMG in the `dist/` folder.
- The app version is now **1.0.1**.

### Project Structure

```
ClipMenuBarApp/
├── Sources/
│   └── KhimyaClipboard/
│       ├── Controllers/
│       ├── Models/
│       ├── Views/
│       └── Utils/
├── Package.swift
└── README.md
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
- **Dependencies**: SwiftDraw for SVG rendering
- **Platform**: macOS 13.0+

## 📝 License

This project is licensed under the MIT License.

## 👨‍💻 Developer

**Khimya** - [GitHub](https://github.com/ybenbrai)

Developed with ❤️ for the macOS community.
