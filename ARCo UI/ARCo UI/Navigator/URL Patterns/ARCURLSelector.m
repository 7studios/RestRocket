//
//  ARCURLSelector.m
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCURLSelector.h"
#import "ARCURLArguments.h"




@implementation ARCURLSelector

@synthesize name, next;



#pragma mark -

- (id)initWithName:(NSString *)aName {
    if (self = [super init]) {
        name = [aName copy];
        selector = NSSelectorFromString(name);
        next = nil;
    }
    
    return self;
}


#pragma mark -

- (NSString *)perform:(id)anObject returnType:(ARCURLArgumentType)aReturnType {
    if (next) {
        id value = [anObject performSelector:selector];
        return [next perform:value returnType:aReturnType];
    }
    else {
        NSMethodSignature *sig = [anObject methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        
        [invocation setTarget:anObject];
        [invocation setSelector:selector];
        [invocation invoke];
        
        if (!aReturnType) {
            aReturnType = URLArgumentTypeForProperty([anObject class], name);
        }
        
        switch (aReturnType) {
            case ARCURLArgumentTypeNone: {
                return @"";
            }
            case ARCURLArgumentTypeInteger: {
                int val = 0;
                [invocation getReturnValue:&val];
                return [NSString stringWithFormat:@"%d", val];
            }
            case ARCURLArgumentTypeLongLong: {
                long long val = 0;
                [invocation getReturnValue:&val];
                return [NSString stringWithFormat:@"%lld", val];
            }
            case ARCURLArgumentTypeFloat: {
                float val = 0.0;
                [invocation getReturnValue:&val];
                return [NSString stringWithFormat:@"%f", val];
            }
            case ARCURLArgumentTypeDouble: {
                double val = 0.0;
                [invocation getReturnValue:&val];
                return [NSString stringWithFormat:@"%f", val];
            }
            case ARCURLArgumentTypeBool: {
                BOOL val = FALSE;
                [invocation getReturnValue:&val];
                return [NSString stringWithFormat:@"%d", val];
            }
            default: {
                id val = nil;
                [invocation getReturnValue:&val];
                return [NSString stringWithFormat:@"%@", val];
            }
        }
        return @"";
    }
}



@end
