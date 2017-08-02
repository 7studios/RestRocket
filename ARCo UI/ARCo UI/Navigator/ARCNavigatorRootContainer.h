//
//  Header.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>

@class ARCBaseNavigator;

@protocol ARCNavigatorRootContainer

@required

- (void)navigator:(ARCBaseNavigator*)navigator setRootViewController:(UIViewController*)controller;

- (ARCBaseNavigator*)getNavigatorForController:(UIViewController*)controller;

@end