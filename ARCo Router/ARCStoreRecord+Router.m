//
//  ARCRouter+ARCRouter_Store.m
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCStoreRecord+Router.h"

/** Set a class prefix such as RS, RAX, etc.. Will be parsed out when necessary for remote operations and local file mapping */
#define ARCCoreDataClassPrefix @""


@implementation ARCStoreRecord (Router)



+ (NSString *)entityNameWithPrefix:(BOOL)removePrefix {
    
    NSMutableString *name = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@", self]];
    
    if([ARCCoreDataClassPrefix length] > 0 && removePrefix)
        [name replaceOccurrencesOfString:ARCCoreDataClassPrefix withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [ARCCoreDataClassPrefix length])];
	
	return name;
}


+ (ARCRouterMap*)mapForRequestMethod:(ARCRequestMethod)method {
    
    ARCRouterMap *map = [[ARCRouter sharedRouter] mapForModel:[self class] forRequestMethod:method];
    
    if(map == nil) {
        
        map = [ARCRouterMap map];
        map.model = [self class];
        map.requestMethod = method;
        
        NSString *resourceName = [self entityNameWithPrefix:NO];
        map.remotePath = resourceName;
    }
    
    return map;
}





@end
