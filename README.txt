HOW TO INSTALL CERCAMAP LIBRARY

1. Create the directory ~/Library/SDKs if it doesn't already exist.

2. Copy the SDKs/CercaMap folder from the provided disk image to ~/Library/SDKs.

HOW TO TEST YOUR INSTALLATION

1. Open the "CercaMapDemo" project from the "DemoProject" folder.

2. Edit the "config.h" file: change VIRTUAL_EARTH_KIT_USERNAME and
   VIRTUAL_EARTH_KIT_PASSWORD to match the username and pasword issued
   to you by Microsoft.

HOW TO USE CERCAMAP IN A PROJECT

1. Select your target application in the Targets folder of the Groups & Files pane
   and click the Info button or hit command-i.

2. Click the Build tab.

3. Ensure that "All Configuations" is selected in the "Configuration:" pop-up menu.

4. Add the following line exactly as-is to the "Additional SDKs" setting in the
   "Architectures" setttings group:

   $(HOME)/Library/SDKs/CercaMIap/$(PLATFORM_NAME).sdk

5. Add the following two lines exactly as-is, in order, to the "Other Linker Flags"
   setting in the "Linking" settings group:

   -ObjC
   -lCercaMap

6. Right click on the "Frameworks" group of the Groups & Files pane and select
   "Add > Existing Frameworks...". Navigate to the library

   /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS2.0.sdk/usr/lib/libxml2.2.dylib

   and click "Add" then "Add" in the following dialog.

7. Refer to the manual and sample project for details on how to use the libarary from
   within your code.

NOTES

- It may be necessary to get tell Interface Builder about the CercaMapView class before you can
  create instances of it and connect to them.  To do so, click "File > Read Class Files..."
  and navigate to the ~/Library/SDKs/Cerca/iphoneos.sdk/usr/local/include/CercaMapView.h
  and click "Open".
