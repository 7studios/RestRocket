//
//  ARCBaseNavigator.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ARCNavigatorRootContainer;

@class ARCURLMap;
@class ARCURLAction;
@class ARCURLNavigatorPattern;


@interface ARCBaseNavigator : NSObject<UIPopoverControllerDelegate> {

    ARCURLMap*                      _URLMap;
    UIWindow*                       _window;
    UIViewController*               _rootViewController;
    UIPopoverController*            _popoverController;

    NSString*                       URL_;
    
    BOOL                            _opensExternalURLs;
    
    id<ARCNavigatorRootContainer>  _rootContainer;
}

/**
 * The URL map used to translate between URLs and view controllers.
 *
 * @see TTURLMap
 */
@property (nonatomic, strong) ARCURLMap* URLMap;

/**
 * The window that contains the view controller hierarchy.
 *
 * By default retrieves the keyWindow. If there is no keyWindow, creates a new
 * TTNavigatorWindow.
 */
@property (nonatomic, strong) UIWindow* window;

@property (nonatomic, strong) UIViewController* rootViewController;
@property (nonatomic, strong) UIViewController* visibleViewController;

/**
 * Allows URLs to be opened externally if they don't match any patterns.
 *
 * @default NO
 */
@property (nonatomic) BOOL opensExternalURLs;

/**
 * The URL of the currently visible view controller;
 *
 * Setting this property will open a new URL.
 */
@property (nonatomic, strong) NSString* URL;
@property (nonatomic, strong) UIViewController* topViewController;

/**
 * A container that holds the root view controller.
 *
 * If nil, the window is treated as the root container.
 *
 * @default nil
 */
@property (nonatomic, assign) id<ARCNavigatorRootContainer> rootContainer;



+ (ARCBaseNavigator *)sharedNavigator;

+ (ARCBaseNavigator*)navigatorForView:(UIView*)view;


/**
 * Load and display the view controller with a pattern that matches the URL.
 *
 * This method replaces all other openURL methods by using the chainable TTURLAction object.
 *
 * If there is not yet a rootViewController, the view controller loaded with this URL
 * will be assigned as the rootViewController and inserted into the keyWindow. If there is not
 * a keyWindow, a UIWindow will be created and displayed.
 *
 * Example TTURLAction initialization:
 * [[TTURLAction actionWithURLPath:@"tt://some/path"]
 *                   applyAnimated:YES]
 *
 * Each apply* method on the TTURLAction object returns self, allowing you to chain methods
 * when initializing the object. This allows for a flexible method that requires a shifting set
 * of parameters that have specific defaults. The old openURL* methods are being phased out, so
 * please start using openURLAction instead.
 */
- (UIViewController*)openURLAction:(ARCURLAction*)URLAction;


/**
 * Gets a view controller for the URL without opening it.
 *
 * @return The view controller mapped to URL.
 */
- (UIViewController*)viewControllerForURL:(NSString*)URL;

/**
 * Gets a view controller for the URL without opening it.
 *
 * @return The view controller mapped to URL.
 */
- (UIViewController*)viewControllerForURL:(NSString*)URL query:(NSDictionary*)query;

/**
 * Gets a view controller for the URL without opening it.
 *
 * @return The view controller mapped to URL.
 */
- (UIViewController*)viewControllerForURL:(NSString*)URL query:(NSDictionary*)query pattern:(ARCURLNavigatorPattern**)pattern;


/**
 * Removes all view controllers from the window and releases them.
 */
- (void)removeAllViewControllers;


@end
