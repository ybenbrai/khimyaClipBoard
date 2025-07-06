# Release Notes

## Version 2.1.0 - Multi-File Grouping & Smarter Clipboard

### ✨ New Features

- **Multi-File Grouping**: When you copy multiple files or folders, they are grouped into a single entry with a count and detailed preview.
- **No Duplicate Text Entries**: The app now prevents adding a separate text entry for the names of files/folders when copying multiple files/folders.

### 🎨 UI Improvements

- Grouped entries show a purple package icon and a count badge.
- Details panel lists all files/folders in the group with icons and colors.

### 🛠️ Technical Improvements

- Improved clipboard detection logic for multi-file and single-file scenarios.
- Smarter deduplication for multi-file entries using exact path comparison.
- Prevents duplicate entries and infinite loops in clipboard history.

### 🧹 General

- Code cleanup and improved reliability for clipboard monitoring.

## Version 2.0.0 - Sticky Copy Button & UI Polish

### ✨ New Features

- **Sticky Copy Button**: Always-accessible copy button in the details panel
- **Enhanced UI**: Improved button styling and positioning
- **Better Documentation**: Updated README and installation guides

### 🎨 UI Improvements

- Copy button now sticks to the bottom of the details panel
- Smaller, more compact button design
- Left-aligned positioning for better UX
- Added visual feedback and hover effects
- Improved spacing and margins

### 🔧 Technical Improvements

- Removed sound feedback functionality (as requested)
- Cleaner codebase with better organization
- Updated Swift Package Manager configuration
- Improved error handling and stability

### 📚 Documentation

- Comprehensive README with feature details
- Updated installation guide with troubleshooting
- Better project structure documentation
- Clear usage instructions

## Version 1.5.0

### ✨ New Features

- **Auto-Start Integration**: Launch automatically on system startup
- **Modern About Page**: Beautiful borderless About panel
- **Enhanced File Support**: 150+ file extensions with semantic colors

### 🎨 UI Improvements

- Redesigned About page with modern SwiftUI modal
- Improved file type icons and colors
- Better visual hierarchy and spacing
- Enhanced hover effects and interactions

### 🔧 Technical Improvements

- Updated to modern SMAppService API for auto-start
- Improved clipboard monitoring efficiency
- Better memory management
- Enhanced error handling

## Version 1.0.0 - Initial Release

### ✨ Core Features

- **Clipboard History**: Automatic tracking of copied content
- **Multi-format Support**: Text, images, files, and URLs
- **Smart Deduplication**: Prevents duplicate entries
- **Visual Type Icons**: File type detection with colored icons
- **Pin Items**: Star important clipboard entries
- **Search & Filter**: Find items quickly
- **Clear History**: Easy cleanup options

### 🎨 User Interface

- **Modern SwiftUI**: Clean, responsive design
- **Menu Bar Integration**: Easy access from anywhere
- **Sidebar Layout**: Organized content with details panel
- **Hover Effects**: Interactive elements with visual feedback

### 🔧 Technical Features

- **Native macOS App**: Built with SwiftUI and AppKit
- **Combine Integration**: Reactive data flow
- **SVG Support**: Via SwiftDraw for image previews
- **Proper Permissions**: Clipboard access and auto-start

---

**Khimya Clipboard** - A modern clipboard manager for macOS
