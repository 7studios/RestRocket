//
//  UIFont+Addition.m
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIFont+Addition.h"

@implementation UIFont (Addition)

- (CGFloat)ARCLineHeight {
    return (self.ascender - self.descender) + 1;
}

@end
