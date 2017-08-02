//
//  ARCTabBarViewController.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARCBaseViewController.h"


@class ARCTabGrid, ARCTabView;


@interface ARCTabBarViewController : ARCBaseViewController {
    
    NSArray*                viewControllers_;
    UIViewController*       selectedViewController_;
    
    ARCTabGrid*             tabBar_;
    ARCTabView*             tabBarView_;
    
    BOOL                    visible;

    
}


@property (nonatomic, strong) NSArray* viewControllers;
@property (nonatomic, strong) UIViewController* selectedViewController;

@property (nonatomic, strong) ARCTabGrid* tabBar;
@property (nonatomic, strong) ARCTabView* tabBarView;
@property (nonatomic) NSUInteger selectedIndex;



@end
