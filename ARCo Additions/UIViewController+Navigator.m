//
//  UIViewController+Navigator.m
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+Navigator.h"



static NSMutableDictionary* sNavigatorURLs          = nil;


@implementation UIViewController (Navigator)




- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
    }
    
    return self;
}



- (NSString*)navigatorURL {
    return self.originalNavigatorURL;
}


- (NSString*)originalNavigatorURL {
    NSString* key = [NSString stringWithFormat:@"%d", self.hash];
    return [sNavigatorURLs objectForKey:key];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOriginalNavigatorURL:(NSString*)URL {
    NSString* key = [NSString stringWithFormat:@"%d", self.hash];
    if (nil != URL) {
        if (nil == sNavigatorURLs) {
            sNavigatorURLs = [[NSMutableDictionary alloc] init];
        }
        [sNavigatorURLs setObject:URL forKey:key];
        
        //[UIViewController AddNavigatorController:self];
        
    } else {
        [sNavigatorURLs removeObjectForKey:key];
    }
}





@end
