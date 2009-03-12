/*
 *  config.h
 *  CercaMapDemo
 *
 *  Created by Peter Zion on 12/03/09.
 *  Copyright 2009 Peter Zion. All rights reserved.
 *
 */

//#define VIRTUAL_EARTH_KIT_USERNAME "changeMe"
//#define VIRTUAL_EARTH_KIT_PASSWORD "changeMeToo"

#if !defined(VIRTUAL_EARTH_KIT_USERNAME) || !defined(VIRTUAL_EARTH_KIT_PASSWORD)
# error You must define both VIRTUAL_EARTH_KIT_USERNAME and VIRTUAL_EARTH_KIT_PASSWORD in config.h to build this demo.
#endif
