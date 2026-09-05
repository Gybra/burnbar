#!/bin/bash
# Assemble BurnBar.app from the SwiftPM release build.
#
#   scripts/bundle.sh [marketing-version] [build-number]
#
# The Swift executable is still named TokenBar (Package.swift target). The
# bundle name and identifier are BurnBar.
set -euo pipefail

VERSION="${1:-0.1.0}"
BUILD_NUMBER="${2:-1}"
BUNDLE_ID="${BUNDLE_ID:-com.gybra.burnbar}"
APP_NAME="${APP_DISPLAY:-BurnBar}"
OUT_DIR="${OUT_DIR:-dist}"
APP="$OUT_DIR/$APP_NAME.app"

echo "==> building release binaries"
cargo build --release
swift build -c release

echo "==> assembling $APP ($VERSION, build $BUILD_NUMBER, $BUNDLE_ID)"
rm -rf "$APP"
mkdir -p "$OUT_DIR"
touch "$OUT_DIR/.metadata_never_index"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

cp .build/release/TokenBar "$APP/Contents/MacOS/TokenBar"
cp -R .build/release/TokenBar_TokenBar.bundle "$APP/Contents/Resources/"
cp -R Sources/TokenBar/Resources/Localizations/*.lproj "$APP/Contents/Resources/"
if [ -f assets/icon.icns ]; then
  cp assets/icon.icns "$APP/Contents/Resources/icon.icns"
fi

cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>TokenBar</string>
    <key>CFBundleIdentifier</key>
    <string>$BUNDLE_ID</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundleDisplayName</key>
    <string>$APP_NAME</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>$VERSION</string>
    <key>CFBundleVersion</key>
    <string>$BUILD_NUMBER</string>
    <key>CFBundleIconFile</key>
    <string>icon</string>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleLocalizations</key>
    <array>
        <string>en</string>
        <string>zh-Hant</string>
    </array>
    <key>LSMinimumSystemVersion</key>
    <string>14.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>MIT License</string>
</dict>
</plist>
PLIST

echo "==> ad-hoc codesign"
codesign --force --deep --sign - "$APP"

echo "==> done: $APP"
