//
//  ARCURLPattern.m
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCURLPattern.h"

#import "ARCPatternTEXT.h"
#import "ARCURLWildcard.h"
#import "ARCURLLiteral.h"

#import "NSString+Additions.h"



@implementation ARCURLPattern

@synthesize URL         = _URL,
            scheme      = _scheme,
            specificity = _specificity,
            selector    = _selector,
            fragment    = _fragment;


- (id)init {
    if (self = [super init]) {
        _path = [[NSMutableArray alloc] init];
    }
    
    return self;
}


#pragma mark -
#pragma mark Private


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<ARCPatternTEXT>)parseText:(NSString*)text {
    NSInteger len = text.length;
    
    if (len >= 2 && [text characterAtIndex:0] == '(' && [text characterAtIndex:len - 1] == ')') {
        
        NSInteger endRange = len > 3 && [text characterAtIndex:len - 2] == ':' ? len - 3 : len - 2;
        NSString* name = len > 2 ? [text substringWithRange:NSMakeRange(1, endRange)] : nil;
        
        ARCURLWildcard* wildcard = [[ARCURLWildcard alloc] init];
        wildcard.name = name;
        
        ++_specificity;
        
        return wildcard;
        
    } else {
        ARCURLLiteral* literal = [[ARCURLLiteral alloc] init];
        
        literal.name = text;
        _specificity += 2;
        return literal;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parsePathComponent:(NSString*)value {
    id<ARCPatternTEXT> component = [self parseText:value];
    [_path addObject:component];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)parseParameter:(NSString*)name value:(NSString*)value {
    if (nil == _query) {
        _query = [[NSMutableDictionary alloc] init];
    }
    
    id<ARCPatternTEXT> component = [self parseText:value];
    [_query setObject:component forKey:name];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)classForInvocation {
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSelectorIfPossible:(SEL)selector {
    Class cls = [self classForInvocation];
    if (nil == cls
        || class_respondsToSelector(cls, selector)
        || class_getClassMethod(cls, selector)) {
        _selector = selector;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)compileURL {
    NSURL* URL = [NSURL URLWithString:_URL];
    _scheme = [URL.scheme copy];
    
    if (URL.host) {
        [self parsePathComponent:URL.host];
        
        if (URL.path) {
            for (NSString* name in URL.path.pathComponents) {
                if (![name isEqualToString:@"/"]) {
                    [self parsePathComponent:name];
                }
            }
        }
    }
    
    if (URL.query) {
        NSDictionary* query = [URL.query queryContentsUsingEncoding:NSUTF8StringEncoding];
        
        for (NSString* name in [query keyEnumerator]) {
            NSString* value = [[query objectForKey:name] objectAtIndex:0];
            [self parseParameter:name value:value];
        }
    }
    
    if (URL.fragment) {
        _fragment = [self parseText:URL.fragment];
    }
}

@end
