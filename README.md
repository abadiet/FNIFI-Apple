# FNIFI-Apple - MacOS/iOS/VisionOS/TVOS
Apple's Photos application but with added connectivity, filtering and sorting algorithms.
    
> [!INFORMATION]
> Still in development...

## Building

To build the application, you need to change several XCode settings, link with [VLCLib](https://github.com/videolan/vlckit) and build the [FNIFI](https://github.com/abadiet/FNIFI) library.
Unfortunately, mixing a C++ library with Swift/Objective-C++ code is not easy, but the funniest is when you add cross-compilation... I wish you good luck.
[Here](https://github.com/abadiet/FNIFI-Apple/blob/main/dependencies/build-fnifi.sh) is how I did (still not sure this was the proper way) for **compiling the application for MacOS arm64 and IOS arm64 architectures**.
Let's detailed the process a bit.

### XCode settings to change
- Swift Compiler - Language > C++ and Objective-C interop. = C++/Objective-C++
- Signing - App Sandbox & Hardened Runtime > Disable Library Validation = YES
- Signing - App Sandbox & Hardened Runtime > Outgoing Connections (Client) = YES
- Search Paths > Header Search Paths
- Search Paths > Library Search Paths
- Linking General > Other Linker Flags

### Link with VLCLib
Follow [VLCLib](https://github.com/videolan/vlckit)'s instructions (using either Cocoapods or Carthage).
If you don't mind using these, you can still compile it from source:
```bash
git clone https://github.com/videolan/vlckit
cd vlckit
./compileAndBuildVLCKit.sh -r -x -a aarch64  # MacOS arm64
./compileAndBuildVLCKit.sh -r -a aarch64  # IOS arm64
```
This will produce some VLCKit.xcframework that should be added to the XCode project.

### Single architecture without cross-compilation
*Assuming you have OpenCV, Exiv2, CMake and XCode installed*
```bash
git clone --recurse-submodules -j$(sysctl -n hw.ncpu) https://github.com/abadiet/FNIFI
mkdir build
cd build
cmake .. -DBUILD_EXAMPLES=OFF -DENABLE_LIBSMB2=ON -DBUILD_SHARED_LIBS=OFF
make -j$(sysctl -n hw.ncpu)
mkdir include
echo """module FNIFIModule {
    umbrella \".\"
    export *
}""" > include/module.modulemap
cp -r ../include/* include
cp -r ../dependencies/SXEval/include/* include
xcodebuild -create-xcframework -library libfnifi.a -headers include -output fnifi.xcframework
mv dependencies/libsmb2/lib/libsmb2.a libsmb2.a
```
This will produce fnifi.xcframework (needed for using the FNIFI C++ library with Swift/Objective-C++ environement) and libsmb2.a (dependency needed by FNIFI, the others ones, namely OpenCV and Exiv2 are considered installed and accessible by FNIFI).
You should then be able to build the application through XCode.

### Single architecture with cross-compilation
*Without OpenCV and Exiv2 libraries*
```bash
git clone --recurse-submodules -j$(sysctl -n hw.ncpu) https://github.com/abadiet/FNIFI
mkdir build
cd build
curl https://raw.githubusercontent.com/leetal/ios-cmake/refs/heads/master/ios.toolchain.cmake -o ios.toolchain.cmake
cmake .. -DBUILD_EXAMPLES=OFF -DENABLE_LIBSMB2=ON -DBUILD_SHARED_LIBS=OFF -DENABLE_OPENCV=OFF -DENABLE_EXIV2=OFF -DCMAKE_TOOLCHAIN_FILE=ios.toolchain.cmake -DPLATFORM=<your-target-platform>
make -j$(sysctl -n hw.ncpu)
mkdir include
echo """module FNIFIModule {
    umbrella \".\"
    export *
}""" > include/module.modulemap
cp -r ../include/* include
cp -r ../dependencies/SXEval/include/* include
xcodebuild -create-xcframework -library libfnifi.a -headers include -output fnifi.xcframework
mv dependencies/libsmb2/lib/libsmb2.a libsmb2.a
```
For choosing the target platform, check out [ios-cmake](https://github.com/leetal/ios-cmake/).
Once again, this will produce fnifi.xcframework (needed for using the FNIFI C++ library with Swift/Objective-C++ environement) and libsmb2.a (dependency needed by FNIFI).
You should then be able to build the application through XCode.

### Multiple architectures
Check [my personal script](https://github.com/abadiet/FNIFI-Apple/blob/main/dependencies/build-fnifi.sh)  for compiling for both MacOS arm64 and IOS arm64 architectures at the same time.
