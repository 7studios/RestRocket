//
//  ARCBaseNavigator+ARCAdditions.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCBaseViewNavigationController.h"


@interface ARCBaseViewNavigationController (ARCAdditions)

- (void)presentModalController: (UIViewController*)controller 
              parentController: (UIViewController*)parentController 
                      animated: (BOOL)animated 
                    transition: (NSInteger)transition;


@end
