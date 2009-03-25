#!/bin/sh

PROJ=$(ls -d *.xcodeproj | sed s/.xcodeproj//)
VERS=$(agvtool vers -terse)

rm -rf build/

for TYPE in "Release"
do
    DIST=${PROJ}-${TYPE}-${VERS}
    DMG=$DIST.dmg

    # Build iPhone hardware SDK
    xcodebuild -target CercaMap -configuration "$TYPE" -sdk iphoneos2.0 install \
	ARCHS=armv6 \
	DSTROOT=build/$DIST/SDKs/CercaMap/iphoneos.sdk || exit 1
    cp rsrc/SDKSettings-iphoneos.plist build/$DIST/SDKs/CercaMap/iphoneos.sdk/SDKSettings.plist || exit 1

    # Build iPhone simulator SDK
    xcodebuild -target CercaMap -configuration "$TYPE" -sdk iphonesimulator2.0 install \
	ARCHS=i386 \
	DSTROOT=build/$DIST/SDKs/CercaMap/iphonesimulator.sdk || exit 1
    cp rsrc/SDKSettings-iphonesimulator.plist build/$DIST/SDKs/CercaMap/iphonesimulator.sdk/SDKSettings.plist || exit 1

    # Copy the demo project
    rm -rf DemoProject/build
    cp -R DemoProject build/$DIST/

    # Copy documentation
    cp -p README.txt build/$DIST

    # Build disk image
    hdiutil create -fs HFS+ -volname "$PROJ $VERS" -srcfolder build/$DIST build/$DMG
done
