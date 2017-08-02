//
//  ARCPatternLiteral.m
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCURLLiteral.h"


@implementation ARCURLLiteral

@synthesize name;

#pragma mark -

-(id) init {
    if (self = [super init]) {
        name = nil;
    }
    
    return self;
}



#pragma mark API

-(BOOL) match:(NSString *)aTextString {
    return [aTextString isEqualToString:name];
}

-(NSString *) convertPropertyOfObject:(id)anObject {
    return name;
}



@end
