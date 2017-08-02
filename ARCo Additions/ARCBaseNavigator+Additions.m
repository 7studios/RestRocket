//
//  ARCBaseNavigator+ARCAdditions.m
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCBaseNavigator+Additions.h"

@implementation ARCBaseViewNavigationController (ARCAdditions)


- (void)presentModalController: (UIViewController*)controller 
              parentController: (UIViewController*)parentController 
                      animated: (BOOL)animated 
                    transition: (NSInteger)transition  
{ 
    controller.modalTransitionStyle = transition; 
	
    if ([controller isKindOfClass:[UINavigationController class]]) 
	{ 
        [parentController presentModalViewController: controller animated: animated]; 
		
    } else { 
		UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:controller];
		
        [navController setModalPresentationStyle:UIModalPresentationFormSheet]; // set the presentation preference 
        [navController setModalTransitionStyle:[controller modalTransitionStyle]]; // set the transition preference 
		
        [parentController presentModalViewController:navController animated:animated]; 
    } 
} 


@end
