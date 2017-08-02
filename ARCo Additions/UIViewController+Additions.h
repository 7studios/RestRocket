//
//  UIViewController+ARCUIViewController.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ARCAdditions)

/**
 * The view controller that contains this view controller.
 *
 * This is just like parentViewController, except that it is not readonly.  This property offers
 * custom UIViewController subclasses the chance to tell TTNavigator how to follow the hierarchy
 * of view controllers.
 */
@property (nonatomic, strong) UIViewController* superController;

/**
 * A popup view controller that is presented on top of this view controller.
 */
@property (nonatomic, strong) UIViewController* popupViewController;


/**
 * Determines whether a controller is primarily a container of other controllers.
 *
 * @default NO
 */
@property (nonatomic, readonly) BOOL canContainControllers;



+ (void)AddCommonController:(UIViewController*)controller;


/**
 * Shows or hides the navigation and status bars.
 */
- (void)showBars:(BOOL)show animated:(BOOL)animated;


- (UIViewController*)topSubcontroller;
- (BOOL)canBeTopViewController;

- (void)addSubcontroller:(UIViewController*)controller animated:(BOOL)animated transition:(UIViewAnimationTransition)transition;

- (void)bringControllerToFront:(UIViewController*)controller animated:(BOOL)animated;

@end
