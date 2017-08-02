//
//  ARCBaseViewNavigationController.m
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCBaseViewNavigationController.h"

#import "ARCBaseNavigator.h"
#import "ARCURLMap.h"

#import "UIViewController+Additions.h"
#import "UIViewController+Navigator.h"




@implementation ARCBaseViewNavigationController


- (UIViewAnimationTransition)invertTransition:(UIViewAnimationTransition)transition {
    switch (transition) {
        case UIViewAnimationTransitionCurlUp:
            return UIViewAnimationTransitionCurlDown;
        case UIViewAnimationTransitionCurlDown:
            return UIViewAnimationTransitionCurlUp;
        case UIViewAnimationTransitionFlipFromLeft:
            return UIViewAnimationTransitionFlipFromRight;
        case UIViewAnimationTransitionFlipFromRight:
            return UIViewAnimationTransitionFlipFromLeft;
        default:
            return UIViewAnimationTransitionNone;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)pushAnimationDidStop {
}


#pragma mark -
#pragma mark UINavigationController

- (void)dealloc {
    NSLog(@"NavigationController dealloc");
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)popViewControllerAnimated:(BOOL)animated {
    if (animated) {
        NSString* URL = self.topViewController.originalNavigatorURL;
        UIViewAnimationTransition transition = URL ? [[ARCBaseNavigator sharedNavigator].URLMap transitionForURL:URL] : UIViewAnimationTransitionNone;
        if (transition) {
            UIViewAnimationTransition inverseTransition = [self invertTransition:transition];
            return [self popViewControllerAnimatedWithTransition:inverseTransition];
        }
    }
    
    return [super popViewControllerAnimated:animated];
}


#pragma mark -
#pragma mark Public

- (void)pushViewControllerWithBlocks:(UIViewController*)controller duration:(NSTimeInterval)duration animatedWithOptions:(UIViewAnimationOptions)options {
    [self pushViewController:controller animated:NO];
    
    [UIView transitionWithView:self.view duration:duration
                       options:options
                    animations:^ { [self.view addSubview:controller.view]; }
                    completion:nil];
}


- (void)pushViewController:(UIViewController*)controller animatedWithTransition:(UIViewAnimationTransition)transition {
    [self pushViewController:controller animated:NO];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];
}


- (UIViewController*)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition {
    
    UIViewController* poppedController = [self popViewControllerAnimated:NO];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
    [UIView setAnimationTransition:transition forView:self.view cache:NO];
    [UIView commitAnimations];
    
    return poppedController;
}




@end
