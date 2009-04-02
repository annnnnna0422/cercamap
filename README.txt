HOW TO BUILD THE CERCAMAP LIBRARY

1. Run ./build.sh from the root directory of the source tree.  This will
   create the file build/CercaMap-Release-1.0.dmg

HOW TO INSTALL CERCAMAP LIBRARY

1. Mount the build/CercaMap-Release-1.0.dmg disk image created in the build
   steps above by opening it in the Finder.

2. Create the directory ~/Library/SDKs if it doesn't already exist.

3. Copy the SDKs/CercaMap folder from the mounted disk image to ~/Library/SDKs.

HOW TO TEST YOUR INSTALLATION

1. Open the "CercaMapDemo" project from the "DemoProject" folder of the mounted
   disk image.

2. Build and run!  The map should show you a city view of San Francisco which you
   can navigate by touch.

HOW TO USE THE CERCAMAP LIBRARY IN A PROJECT

1. Select your target application in the Targets folder of the Groups & Files pane
   and click the Info button or hit command-i.

2. Click the Build tab.

3. Ensure that "All Configuations" is selected in the "Configuration:" pop-up menu.

4. Add the following line exactly as-is to the "Additional SDKs" setting in the
   "Architectures" setttings group:

   $(HOME)/Library/SDKs/CercaMap/$(PLATFORM_NAME).sdk

5. Add the following two lines exactly as-is, in order, to the "Other Linker Flags"
   setting in the "Linking" settings group:

   -ObjC
   -lCercaMap

6. Refer to the manual and sample project for details on how to use the libarary from
   within your code.

NOTES

- It may be necessary to get tell Interface Builder about the CercaMapView class before you can
  create instances of it and connect to them.  To do so, click "File > Read Class Files..."
  and navigate to the ~/Library/SDKs/Cerca/iphoneos.sdk/usr/local/include/CercaMapView.h
  and click "Open".
