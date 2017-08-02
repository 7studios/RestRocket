//
//  ARCNavigator.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCBaseNavigator.h"


/**
 * Shortcut for calling [[ARCNavigator navigator] openURL:]
 */
UIViewController* ARCOpenURL(NSString* URL);


/**
 * Shortcut for calling [[ARCBaseNavigator navigatorForView:view] openURL:]
 */
UIViewController* ARCOpenURLFromView(NSString* URL, UIView* view);


@interface ARCNavigator : ARCBaseNavigator {
    
}


+ (ARCNavigator*)navigator;

/**
 * Reloads the content in the visible view controller.
 */
- (void)reload;


@end
