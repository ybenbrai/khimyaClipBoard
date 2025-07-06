#!/bin/bash

set -e

echo "🔨 Building KhimyaClipboard..."

# Clean previous build
echo "🧹 Cleaning previous build..."
swift package clean

# Build in release mode
echo "⚡ Building in release mode..."
swift build -c release

# Create dist directory if it doesn't exist
mkdir -p dist

# Remove old app bundle
echo "🗑️ Removing old app bundle..."
rm -rf dist/KhimyaClipboard.app

# Create new app bundle structure
echo "📦 Creating app bundle..."
mkdir -p dist/KhimyaClipboard.app/Contents/MacOS
mkdir -p dist/KhimyaClipboard.app/Contents/Resources

# Copy the built executable
echo "📋 Copying executable..."
cp .build/release/KhimyaClipboard dist/KhimyaClipboard.app/Contents/MacOS/

# Copy Info.plist
echo "📄 Copying Info.plist..."
cp Info.plist dist/KhimyaClipboard.app/Contents/

# Copy entitlements
echo "🔐 Copying entitlements..."
cp entitlements.plist dist/KhimyaClipboard.app/Contents/

# Make executable
chmod +x dist/KhimyaClipboard.app/Contents/MacOS/KhimyaClipboard

# Create DMG
echo "💾 Creating DMG..."
rm -f dist/KhimyaClipboard.dmg

# Create temporary directory for DMG
mkdir -p /tmp/KhimyaClipboard_dmg

# Copy app to temp directory
cp -R dist/KhimyaClipboard.app /tmp/KhimyaClipboard_dmg/

# Create DMG
hdiutil create -volname "KhimyaClipboard" -srcfolder /tmp/KhimyaClipboard_dmg -ov -format UDZO dist/KhimyaClipboard.dmg

# Clean up temp directory
rm -rf /tmp/KhimyaClipboard_dmg

echo "✅ Build complete!"
echo "📱 App bundle: dist/KhimyaClipboard.app"
echo "💿 DMG: dist/KhimyaClipboard.dmg" 