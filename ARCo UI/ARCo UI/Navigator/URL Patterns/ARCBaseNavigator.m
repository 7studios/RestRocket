//
//  ARCBaseNavigator.m
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCBaseNavigator.h"

#import "ARCURLMap.h"
#import "ARCURLAction.h"
#import "ARCURLNavigatorPattern.h"
#import "ARCNavigatorRootContainer.h"
#import "ARCBaseViewNavigationController.h"

#import "ARCGlobalCommon.h"
#import "UIViewController+Additions.h"
#import "UIViewController+Navigator.h"
#import "UIView+Additions.h"


@implementation ARCBaseNavigator

@synthesize URLMap = _URLMap,
            window = _window,
            URL = URL_,
            rootViewController = _rootViewController,
            rootContainer,
            opensExternalURLs = _opensExternalURLs;




+ (ARCBaseNavigator *)sharedNavigator {
    
    static dispatch_once_t predicate;
    static ARCBaseNavigator *_shared = nil;
    
    dispatch_once(&predicate, ^{
        _shared = [[self alloc] init];
    });
    
    return _shared;
}


+ (ARCBaseNavigator*)navigatorForView:(UIView*)view {

    if (![view isKindOfClass:[UIView class]]) {
        return [ARCBaseNavigator sharedNavigator];
    }
    
    id<ARCNavigatorRootContainer>  container = nil;
    UIViewController*              controller = nil;      // The iterator.
    UIViewController*              childController = nil; // The last iterated controller.
    
    for (controller = view.viewController; nil != controller; controller = controller.parentViewController) {
        
        if ([controller conformsToProtocol:@protocol(ARCNavigatorRootContainer)]) {
            container = (id<ARCNavigatorRootContainer>)controller;
            break;
        }
        
        childController = controller;
    }
    
    ARCBaseNavigator* navigator = [container getNavigatorForController:childController];
    if (nil == navigator) {
        navigator = [ARCBaseNavigator sharedNavigator];
    }
    
    return navigator;
}



- (id)init {
    if (self = [super init]) {
        _URLMap = [[ARCURLMap alloc] init];
        
        NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(applicationWillLeaveForeground:)
                       name:UIApplicationWillTerminateNotification
                     object:nil];

        if (nil != &UIApplicationDidEnterBackgroundNotification) {
            [center addObserver:self
                       selector:@selector(applicationWillLeaveForeground:)
                           name:UIApplicationDidEnterBackgroundNotification
                         object:nil];
        }
    }
    return self;
}


#pragma mark -
#pragma mark NSNotifications

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationWillLeaveForeground:(void *)ignored {
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * @protected
 */
- (Class)windowClass {
    return [UIWindow class];
}


- (UIViewController*)getVisibleChildController:(UIViewController*)controller {
    return controller.topSubcontroller;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)navigationControllerClass {
    return [ARCBaseViewNavigationController class];
}


- (void)setRootViewController:(UIViewController*)controller {
    if (controller != _rootViewController) {
        _rootViewController = controller;
        
        //[self.window addSubview:_rootViewController.view];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Prepare the given controller's parent controller and return it. Ensures that the parent
 * controller exists in the navigation hierarchy. If it doesn't exist, and the given controller
 * isn't a container, then a UINavigationController will be made the root controller.
 *
 * @private
 */
- (UIViewController*)parentForController:(UIViewController*)controller isContainer:(BOOL)isContainer parentURLPath:(NSString*)parentURLPath {
    
    if (controller == _rootViewController) {
        return nil;
        
    } else {
        // If this is the first controller, and it is not a "container", forcibly put
        // a navigation controller at the root of the controller hierarchy.
        if (nil == _rootViewController && !isContainer) {
            [self setRootViewController:[[[self navigationControllerClass] alloc] init]];
        }
        
        if (nil != parentURLPath) {
            return [self openURLAction:[ARCURLAction actionWithURLPath:parentURLPath]];
            
        } else {
            UIViewController* parent = self.topViewController;
            if (parent != controller) {
                return parent;
                
            } else {
                return nil;
            }
        }
    }
}


- (void)presentModalController: (UIViewController*)controller 
              parentController: (UIViewController*)parentController 
                      animated: (BOOL)animated 
                    transition: (NSInteger)transition  
                    modalStyle: (UIModalPresentationStyle)modalStyle
{ 
    controller.modalTransitionStyle = transition; 
	
    if ([controller isKindOfClass:[UINavigationController class]]) 
	{ 
        [parentController presentModalViewController: controller animated: animated]; 
		
    } else { 
		UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:controller];
		
        [navController setModalPresentationStyle:modalStyle]; // set the presentation preference 
        [navController setModalTransitionStyle:[controller modalTransitionStyle]]; // set the transition preference 
		
        [parentController presentModalViewController:navController animated:animated]; 
    } 
} 


- (void)presentModalController: (UIViewController*)controller
              parentController: (UIViewController*)parentController
                      animated: (BOOL)animated
                    transition: (NSInteger)transition {
    
    controller.modalTransitionStyle = transition;
    
    if ([controller isKindOfClass:[UINavigationController class]]) {
        
        [parentController presentModalViewController:controller animated:animated];
        
    } else {
        UINavigationController* navController = [[[self navigationControllerClass] alloc] init];
        
        navController.modalTransitionStyle = transition;
        navController.modalPresentationStyle = controller.modalPresentationStyle;
        [navController pushViewController:controller animated: NO];
        [parentController presentModalViewController:navController animated:animated];
    }
}


- (void)presentPopoverController: (UIViewController*)controller
                    sourceButton: (UIBarButtonItem*)sourceButton
                      sourceView: (UIView*)sourceView
                      sourceRect: (CGRect)sourceRect
                        animated: (BOOL)animated {
    
    //TTDASSERT(nil != sourceButton || nil != sourceView);
    
    if (nil == sourceButton && nil == sourceView) {
        return;
    }
    
    if (nil != _popoverController) {
        [_popoverController dismissPopoverAnimated:animated];
    }
    
    _popoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
    _popoverController.delegate = self;
    if (nil != sourceButton) {
        [_popoverController presentPopoverFromBarButtonItem: sourceButton
                                   permittedArrowDirections: UIPopoverArrowDirectionAny
                                                   animated: animated];
        
    } else {
        [_popoverController presentPopoverFromRect: sourceRect
                                            inView: sourceView
                          permittedArrowDirections: UIPopoverArrowDirectionAny
                                          animated: animated];
    }
}


/**
 * Present a view controller that strictly depends on the existence of the parent controller.
 */
- (void)presentDependantController: (UIViewController*)controller
                  parentController: (UIViewController*)parentController
                              mode: (ARCNavigationMode)mode
                            action: (ARCURLAction*)action {
    
    if (mode == ARCNavigationModeModal) {
        [self presentModalController: controller
                    parentController: parentController
                            animated: action.animated
                          transition: action.transition];
        
    } else if (mode == ARCNavigationModePopover) {
        [self presentPopoverController: controller
                          sourceButton: action.sourceButton
                            sourceView: action.sourceView
                            sourceRect: action.sourceRect
                              animated: action.animated];
        
    } else {
        [parentController addSubcontroller: controller
                                  animated: action.animated
                                transition: action.transition];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * @return NO if the controller already has a super controller and is simply made visible.
 *         YES if the controller is the new root or if it did not have a super controller.
 *
 * @private
 */
- (BOOL)presentController:(UIViewController*)controller parentController:(UIViewController*)parentController mode:(ARCNavigationMode)mode action:(ARCURLAction*)action {
    
    BOOL didPresentNewController = YES;
    
    if (nil == _rootViewController) {
        
        [self setRootViewController:controller];
        
    } else {
        UIViewController* previousSuper = controller.superController;
        
        if (nil != previousSuper) {
            if (previousSuper != parentController) {
                // The controller already exists, so we just need to make it visible
                for (UIViewController* superController = previousSuper; controller; ) {
                    UIViewController* nextSuper = superController.superController;
                    
                    [superController bringControllerToFront:controller animated:!nextSuper];
                    
                    controller = superController;
                    superController = nextSuper;
                }
            }
            didPresentNewController = NO;
            
        } else if (nil != parentController) {
            [self presentDependantController: controller
                            parentController: parentController
                                        mode: mode
                                      action: action];
        }
    }
    
    return didPresentNewController;
}


- (BOOL)presentController:(UIViewController*)controller parentURLPath:(NSString*)parentURLPath withPattern:(ARCURLNavigatorPattern*)pattern action:(ARCURLAction*)action {
    BOOL didPresentNewController = NO;
    
    if (nil != controller) {
        UIViewController* topViewController = self.topViewController;
        
        if (controller != topViewController) {
            UIViewController* parentController = [self parentForController: controller isContainer:[controller canContainControllers] parentURLPath: parentURLPath ? parentURLPath : pattern.parentURL];
            
            if (nil != parentController && parentController != topViewController) {
                [self presentController: parentController
                       parentController: nil
                                   mode: ARCNavigationModeNone
                                 action: [ARCURLAction actionWithURLPath:nil]];
            }
            //** NEW RootView
            didPresentNewController = [self presentController:controller parentController:parentController mode:pattern.navigationMode action:action];
        }
    }
    return didPresentNewController;
}



#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIWindow*)window {
    if (nil == _window) {
        UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
        if (nil != keyWindow) {
            _window = keyWindow;
            
        } else {
            _window = [[[self windowClass] alloc] initWithFrame:ARCScreenBounds()];
            [_window makeKeyAndVisible];
        }
    }
    return _window;
}


- (UIViewController*)visibleViewController {
    UIViewController* controller = _rootViewController;
    
    while (nil != controller) {
        UIViewController* child = controller.modalViewController;
        
        if (nil == child) {
            child = [self getVisibleChildController:controller];
        }
        
        if (nil != child) {
            controller = child;
            
        } else {
            return controller;
        }
    }
    return nil;
}


- (UIViewController*)topViewController {
    
    UIViewController* controller = _rootViewController;
    
    while (controller) {
        UIViewController* child = controller.popupViewController;
        if (!child || ![child canBeTopViewController]) {
            child = controller.modalViewController;
        }
        if (!child) {
            child = controller.topSubcontroller;
        }
        if (child) {
            if (child == _rootViewController) {
                return child;
                
            } else {
                controller = child;
            }
            
        } else {
            return controller;
        }
    }
    return nil;
}



- (NSString*)URL {
    return self.topViewController.navigatorURL;
}


- (void)setURL:(NSString*)URLPath {
    [self openURLAction:[[ARCURLAction actionWithURLPath:URLPath] applyAnimated:YES]];
}



- (UIViewController*)viewControllerForURL:(NSString*)URL {
    return [self viewControllerForURL:URL query:nil pattern:nil];
}

- (UIViewController*)viewControllerForURL:(NSString*)URL query:(NSDictionary*)query {
    return [self viewControllerForURL:URL query:query pattern:nil];
}


- (UIViewController*)viewControllerForURL:(NSString*)URL query:(NSDictionary*)query pattern:(ARCURLNavigatorPattern**)pattern {
    
    NSRange fragmentRange = [URL rangeOfString:@"#" options:NSBackwardsSearch];
    
    if (fragmentRange.location != NSNotFound) {
        NSString* baseURL = [URL substringToIndex:fragmentRange.location];
        
        if ([self.URL isEqualToString:baseURL]) {
            UIViewController* controller = self.visibleViewController;
            
            id result = [_URLMap dispatchURL:URL toTarget:controller query:query];
            if ([result isKindOfClass:[UIViewController class]]) {
                return result;
                
            } else {
                return controller;
            }
            
        } else {
            
            id object = [_URLMap objectForURL:baseURL query:nil pattern:pattern];
            if (object) {
                id result = [_URLMap dispatchURL:URL toTarget:object query:query];
                if ([result isKindOfClass:[UIViewController class]]) {
                    return result;
                    
                } else {
                    return object;
                }
                
            } else {
                return nil;
            }
        }
    }
    
    id object = [_URLMap objectForURL:URL query:query pattern:pattern];
    if (object) {
        UIViewController* controller = object;        
        return controller;        
    } else {
        return nil;
    }
}


- (UIViewController*)openURLAction:(ARCURLAction*)action {
    if (nil == action || nil == action.urlPath) {
        return nil;
    }
    
    // We may need to modify the urlPath, so let's create a local copy.
    NSString* urlPath = action.urlPath;
    
    NSURL* theURL = [NSURL URLWithString:urlPath];
    if ([_URLMap isAppURL:theURL]) {
        [[UIApplication sharedApplication] openURL:theURL];
        return nil;
    }
    
    if (nil == theURL.scheme) {
        if (nil != theURL.fragment) {
            urlPath = [self.URL stringByAppendingString:urlPath];
            
        } else {
            urlPath = [@"http://" stringByAppendingString:urlPath];
        }
        theURL = [NSURL URLWithString:urlPath];
    }
        
    ARCURLNavigatorPattern* pattern = nil;
    UIViewController* controller = [self viewControllerForURL:urlPath query:action.query pattern:&pattern];
    if (nil != controller) {
        
        action.transition = action.transition ? action.transition : pattern.transition;
        BOOL wasNew = [self presentController:controller 
                                parentURLPath:action.parentURLPath 
                                  withPattern:pattern 
                                       action:action];
        
        /*
        BOOL wasNew = [self presentController:controller
								parentURLPath:action.parentURLPath
								  withPattern:pattern
									 animated:action.animated
								   transition:(action.transition ? action.transition : pattern.transition)
							presentationStyle:(action.modalPresentationStyle ? action.modalPresentationStyle : pattern.modalPresentationStyle)];
        */
        
    } else if (_opensExternalURLs) {
        [[UIApplication sharedApplication] openURL:theURL];
    }
    
    return controller;
}


- (void)removeAllViewControllers {
    //[_URLMap removeAllObjects];
}




@end
