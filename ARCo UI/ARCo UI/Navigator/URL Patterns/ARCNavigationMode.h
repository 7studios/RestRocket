//
//  Header.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

typedef enum {
    ARCNavigationModeNone,
    ARCNavigationModeCreate,            // a new view controller is created each time
    ARCNavigationModeShare,             // a new view controller is created, cached and re-used
    ARCNavigationModeModal,             // a new view controller is created and presented modally
    ARCNavigationModePopover,           // a new view controller is created and presented in a popover
    ARCNavigationModeExternal,          // an external app will be opened
} ARCNavigationMode;

