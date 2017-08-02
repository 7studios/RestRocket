//
//  UIViewController+Navigator.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Navigator)

/**
 * The current URL that this view controller represents.
 */
@property (nonatomic, readonly) NSString* navigatorURL;

/**
 * The URL that was used to load this controller through TTNavigator.
 *
 * Do not ever change the value of this property.  TTNavigator will assign this
 * when creating your view controller, and it expects it to remain constant throughout
 * the view controller's life.  You can override navigatorURL if you want to specify
 * a different URL for your view controller to use when persisting and restoring it.
 */
@property (nonatomic, copy) NSString* originalNavigatorURL;



/**
 * The default initializer sent to view controllers opened through TTNavigator.
 */
- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query;




@end
