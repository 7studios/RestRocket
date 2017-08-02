//
//  ARCNavigator.m
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCNavigator.h"
#import "ARCURLAction.h"


UIViewController* ARCOpenURL(NSString* URL) {
    return [[ARCNavigator navigator] openURLAction:[[ARCURLAction actionWithURLPath:URL] applyAnimated:YES]];
}


UIViewController* ARCOpenURLFromView(NSString* URL, UIView* view) {
    return [[ARCBaseNavigator navigatorForView:view] openURLAction:[[ARCURLAction actionWithURLPath:URL] applyAnimated:YES]];
}



@implementation ARCNavigator



+ (ARCNavigator*)navigator {
    return (ARCNavigator*)[ARCBaseNavigator sharedNavigator];
}


- (void)reload {
    //UIViewController* controller = self.visibleViewController;
    
    /*
    if ([controller isKindOfClass:[TTModelViewController class]]) {
        TTModelViewController* ttcontroller = (TTModelViewController*)controller;
        [ttcontroller reload];
    }
     */
}


@end
