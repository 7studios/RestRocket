//
//  ARCBaseViewNavigationController.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARCBaseViewNavigationController : UINavigationController {
    
}


- (void)pushAnimationDidStop;

- (void)pushViewController:(UIViewController*)controller animatedWithTransition:(UIViewAnimationTransition)transition;

//** BLOCKS
- (void)pushViewControllerWithBlocks:(UIViewController*)controller duration:(NSTimeInterval)duration animatedWithOptions:(UIViewAnimationOptions)options;

/**
 * Pops a view controller with a transition other than the standard sliding animation.
 */
- (UIViewController*)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition;



@end
