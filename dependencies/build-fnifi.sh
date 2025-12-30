#!/bin/sh

rm -rf fnifi.xcframework
rm -rf libsmb2-macos.a
rm -rf libsmb2-ios.a

mkdir build-fnifi
cd build-fnifi

git clone --recurse-submodules -j$(sysctl -n hw.ncpu)                         \
    https://github.com/abadiet/FNIFI
sed -i "" "s/-Wall -Wextra -Werror//" FNIFI/CMakeLists.txt
sed -i "" "s/#ifdef FNIFI_DEBUG/#define FNIFI_DEBUG\n#ifdef FNIFI_DEBUG/"     \
    FNIFI/include/fnifi/utils/utils.hpp
curl https://raw.githubusercontent.com/leetal/ios-cmake/refs/heads/master/ios.toolchain.cmake \
    -o ios.toolchain.cmake

# MACOS
mkdir macos
cd macos
cmake ../FNIFI -DBUILD_EXAMPLES=OFF -DFNIFI_DEBUG=ON -DENABLE_LIBSMB2=ON      \
    -DBUILD_SHARED_LIBS=OFF
make -j$(sysctl -n hw.ncpu)
cd ..

# IOS
mkdir ios
cd ios
cmake ../FNIFI -DBUILD_EXAMPLES=OFF -DFNIFI_DEBUG=ON -DENABLE_OPENCV=OFF      \
    -DENABLE_LIBSMB2=ON -DENABLE_EXIV2=OFF -DBUILD_SHARED_LIBS=OFF            \
    -DCMAKE_TOOLCHAIN_FILE=../ios.toolchain.cmake -DPLATFORM=OS64
make -j$(sysctl -n hw.ncpu)
cd ..

# IOS Simulator
mkdir ios-sim
cd ios-sim
cmake ../FNIFI -DBUILD_EXAMPLES=OFF -DFNIFI_DEBUG=ON -DENABLE_OPENCV=OFF      \
    -DENABLE_LIBSMB2=ON -DENABLE_EXIV2=OFF -DBUILD_SHARED_LIBS=OFF            \
    -DCMAKE_TOOLCHAIN_FILE=../ios.toolchain.cmake -DPLATFORM=SIMULATORARM64
make -j$(sysctl -n hw.ncpu)
cd ..

# Combine everything
mkdir include
echo """module FNIFIModule {
    umbrella \".\"
    export *
}""" > include/module.modulemap
cp -r FNIFI/include/* include
cp -r FNIFI/dependencies/SXEval/include/* include
xcodebuild -create-xcframework                                                \
    -library macos/libfnifi.a -headers include                                \
    -library ios/libfnifi.a -headers include                                  \
    -library ios-sim/libfnifi.a -headers include                              \
    -output ../fnifi.xcframework

mv macos/dependencies/libsmb2/lib/libsmb2.a ../libsmb2-macos.a
mv ios/dependencies/libsmb2/lib/libsmb2.a ../libsmb2-ios.a
mv ios-sim/dependencies/libsmb2/lib/libsmb2.a ../libsmb2-ios-sim.a

cd ..
rm -rf build-fnifi
