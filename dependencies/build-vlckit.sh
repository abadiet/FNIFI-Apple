#!/bin/sh

rm -rf fnifi.xcframework
rm -rf libsmb2-macos.a
rm -rf libsmb2-ios.a

mkdir build-vlckit
cd build-vlckit

git clone -j$(sysctl -n hw.ncpu) https://code.videolan.org/videolan/VLCKit    \
    --branch 4.0.0a18
cd VLCKit

# MACOS
./compileAndBuildVLCKit.sh -r -x -a aarch64

# IOS
./compileAndBuildVLCKit.sh -r -a aarch64

# Combine everything
cp -r build/iOS/VLCKit.xcframework ..
cp -r build/macOS/VLCKit.xcframework/macos-arm64 ../../VLCKit.xcframework
rm ../../VLCKit.xcframework/Info.plist
echo """<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
        <key>AvailableLibraries</key>
        <array>
                <dict>
                        <key>BinaryPath</key>
                        <string>VLCKit.framework/Versions/A/VLCKit</string>
                        <key>DebugSymbolsPath</key>
                        <string>dSYMs</string>
                        <key>LibraryIdentifier</key>
                        <string>ios-arm64</string>
                        <key>LibraryPath</key>
                        <string>VLCKit.framework</string>
                        <key>SupportedArchitectures</key>
                        <array>
                                <string>arm64</string>
                        </array>
                        <key>SupportedPlatform</key>
                        <string>ios</string>
                </dict>
                <dict>
                        <key>BinaryPath</key>
                        <string>VLCKit.framework/Versions/A/VLCKit</string>
                        <key>DebugSymbolsPath</key>
                        <string>dSYMs</string>
                        <key>LibraryIdentifier</key>
                        <string>macos-arm64</string>
                        <key>LibraryPath</key>
                        <string>VLCKit.framework</string>
                        <key>SupportedArchitectures</key>
                        <array>
                                <string>arm64</string>
                        </array>
                        <key>SupportedPlatform</key>
                        <string>macos</string>
                </dict>
        </array>
        <key>CFBundlePackageType</key>
        <string>XFWK</string>
        <key>XCFrameworkFormatVersion</key>
        <string>1.0</string>
</dict>
</plist>""" > ../../VLCKit.xcframework/Info.plist

cd ../..
rm -rf build-vlckit
