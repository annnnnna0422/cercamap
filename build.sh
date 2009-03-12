#!/bin/sh
#
# [pzion 20090312] Adapted from dmg.sh from json-framework
#

# Determine the project name and version
PROJ=$(ls -d *.xcodeproj | sed s/.xcodeproj//)
VERS=$(agvtool vers -terse)

# Derived names
DIST=${PROJ}-${VERS}
DMG=$DIST.dmg

# Remove old targets
rm -f $DMG
rm -rf build/
mkdir -p build/$DIST

xcodebuild -target CercaMap -configuration Release -sdk iphoneos2.0 install \
    ARCHS=armv6 \
    DSTROOT=build/$DIST/SDKs/CercaMap/iphoneos.sdk || exit 1
cp rsrc/SDKSettings-iphoneos.plist build/$DIST/SDKs/CercaMap/iphoneos.sdk/SDKSettings.plist || exit 1

# Create the iPhone Simulator SDK
xcodebuild -target CercaMap -configuration Release -sdk iphonesimulator2.0 install \
    ARCHS=i386 \
    DSTROOT=build/$DIST/SDKs/CercaMap/iphonesimulator.sdk || exit 1
cp rsrc/SDKSettings-iphonesimulator.plist build/$DIST/SDKs/CercaMap/iphonesimulator.sdk/SDKSettings.plist || exit 1

# Copy the demo project
rm -rf DemoProject/build
cp -R DemoProject build/$DIST/

# Copy documentation
cp -p README.txt build/$DIST

hdiutil create -fs HFS+ -volname "$PROJ $VERS" -srcfolder build/$DIST build/$DMG
