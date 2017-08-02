//
//  ARCURLWildcard.m
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCURLWildcard.h"
#import "ARCURLSelector.h"
#import "ARCURLArguments.h"



@implementation ARCURLWildcard

@synthesize name,argIndex,argType,selector;



#pragma mark -

-(id) init {
    if (self = [super init]) {
        name = nil;
        argIndex = NSNotFound;
        argType = ARCURLArgumentTypeNone;
        selector = nil;
    }
    
    return self;
}


#pragma mark API

- (BOOL)match:(NSString *)aTextString {
    return TRUE;
}

- (NSString *)convertPropertyOfObject:(id)anObject {
    if (selector) {
        return [selector perform:anObject returnType:argType];
    }
    else {
        return @"";
    }
}

- (void)deduceSelectorForClass:(Class)aClass {
    NSArray *names = [name componentsSeparatedByString:@"."];
    
    if (names.count > 1) {
        ARCURLSelector *urlSelector = nil;
        
        for (NSString *selectorName in names) {
            ARCURLSelector *newSelector = [[ARCURLSelector alloc] initWithName:selectorName];
            
            if (urlSelector) {
                urlSelector.next = newSelector;
            }
            else {
                self.selector = newSelector;
            }
            urlSelector = newSelector;
        }
    }
    else {
        self.argType = URLArgumentTypeForProperty(aClass, name);
        self.selector = [[ARCURLSelector alloc] initWithName:name];
    }
}



@end
