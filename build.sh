#!/bin/sh
#
# [pzion 20090312] Adapted from dmg.sh from json-framework
#

# Determine the project name and version
PROJ=$(ls -d *.xcodeproj | sed s/.xcodeproj//)
VERS=$(agvtool vers -terse)

# Derived names
DIST=${PROJ}_${VERS}
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

if false; then
    # Create the documentation
    xcodebuild -target Documentation -configuration Release install DSTROOT=build/$DIST || exit 1
    rm -rf build/$DIST/Documentation/html/org.brautaset.${PROJ}.docset

    cat <<HTML > build/$DIST/API.html
    <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
    <html><head><meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <script type="text/javascript">
    <!--
    window.location = "Documentation/html/index.html"
    //-->
    </script>
    </head>
    <body>
    <p>Aw, shucks! I tried to redirect you to the <a
    href="Documentaton/html/index.html">api documentation</a> but obviously
    failed. Please find it yourself. </p>
    </body>
    </html>
HTML

    cp -p CREDITS build/$DIST
    cp -p README build/$DIST
    cp -p INSTALL build/$DIST
fi

hdiutil create -fs HFS+ -volname build/$DIST -srcfolder build/$DIST build/$DMG
