//
//  ARCURLNavigatorPattern+ARCURLNavigatorPattern_Additions.m
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCURLNavigatorPattern+Additions.h"

@implementation ARCURLNavigatorPattern (Additions)

- (void)setSelectorWithNames:(NSArray*)names {
    NSString* selectorName = [[names componentsJoinedByString:@":"] stringByAppendingString:@":"];
    SEL selector = NSSelectorFromString(selectorName);
    [self setSelectorIfPossible:selector];
}


@end
