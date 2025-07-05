# Release Notes

## Version 1.1.0 - Professional macOS App Bundle

### 🎉 Major Improvements

#### ✅ **Proper macOS Application**

- **App Bundle**: Now distributed as `KhimyaClipboard.app` instead of command-line executable
- **Code Signed**: Properly signed and trusted by macOS
- **No Security Warnings**: Runs without "unidentified developer" alerts
- **Native Integration**: Looks and behaves like any other macOS application

#### 🔐 **Security & Trust**

- **Code Signing**: App is signed with developer certificate
- **Entitlements**: Proper permissions for clipboard access
- **Sandbox**: Configured for clipboard functionality
- **Apple Events**: Allowed for system integration

#### 📦 **Distribution**

- **Professional Package**: `KhimyaClipboard-App.zip` (657KB)
- **Easy Installation**: Drag to Applications folder
- **Proper Metadata**: Bundle ID, version, and app information
- **Documentation**: Updated installation guides

### 🚀 **For Users**

1. Download `KhimyaClipboard-App.zip`
2. Extract and drag `KhimyaClipboard.app` to Applications
3. Launch from Applications folder
4. No security warnings or additional steps required!

### 🔧 **Technical Changes**

- Added `Info.plist` with proper app metadata
- Added `entitlements.plist` for permissions
- Updated `Package.swift` with product definition
- Code signed with `codesign` tool
- Created proper `.app` bundle structure

### 📋 **Features (Unchanged)**

- ✅ Clipboard history with real-time monitoring
- ✅ Image and SVG preview support (native SwiftDraw rendering)
- ✅ File and folder support
- ✅ One-click copy from history
- ✅ Beautiful, modern SwiftUI interface
- ✅ Smart deduplication
- ✅ Persistent storage

---

## Version 1.0.0 - Initial Release

### ✨ **Features**

- Clipboard history management
- Image and SVG preview support
- File and folder handling
- Real-time clipboard monitoring
- Modern SwiftUI interface
- Menu bar integration

### 🔧 **Technical**

- Built with SwiftUI and AppKit
- Native SVG rendering with SwiftDraw
- macOS 13.0+ support
- Command-line executable distribution
