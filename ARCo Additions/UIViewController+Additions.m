//
//  UIViewController+ARCUIViewController.m
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+Additions.h"

const CGFloat kDefaultTransitionDuration      = 0.3;



@implementation UIViewController (ARCAdditions)



#pragma mark -
#pragma mark Public


+ (void)AddCommonController:(UIViewController*)controller {
    
    
}


- (BOOL)canContainControllers {
    return NO;
}


- (BOOL)canBeTopViewController {
    return YES;
}


- (UIViewController*)topSubcontroller {
    return nil;
}


- (void)showBars:(BOOL)show animated:(BOOL)animated {
    
    BOOL statusBarHidden = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIStatusBarHidden"] boolValue];
    
    if (!statusBarHidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:!show withAnimation:animated];
    }
    
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kDefaultTransitionDuration];
    }
    self.navigationController.navigationBar.alpha = show ? 1 : 0;
    if (animated) {
        [UIView commitAnimations];
    }
}


- (UIViewController*)popupViewController {
    //NSString* key = [NSString stringWithFormat:@"%d", self.hash];
    return nil; // [gPopupViewControllers objectForKey:key];
}


- (void)addSubcontroller:(UIViewController*)controller animated:(BOOL)animated transition:(UIViewAnimationTransition)transition {
    if (self.navigationController) {
        [self.navigationController addSubcontroller:controller animated:animated transition:transition];
    }
}


- (void)bringControllerToFront:(UIViewController*)controller animated:(BOOL)animated {
}


- (UIViewController*)superController {
    UIViewController* parent = self.parentViewController;
    if (nil != parent) {
        return parent;
    } else {
        //NSString* key = [NSString stringWithFormat:@"%d", self.hash];
        return nil; // [gSuperControllers objectForKey:key];
    }
}


- (void)setSuperController:(UIViewController*)viewController {
    if (nil != viewController) {
    }
}



@end
