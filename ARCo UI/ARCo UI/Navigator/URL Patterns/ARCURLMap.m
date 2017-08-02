//
//  ARCURLMap.m
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCURLMap.h"
#import "ARCURLNavigatorPattern.h"
#import "ARCURLGeneratorPattern.h"

#import <objc/runtime.h>
#import <objc/message.h>



@implementation ARCURLMap

@synthesize objectMappings = _objectMappings;



#pragma mark -
#pragma mark Private

/**
 * @return a unique key for a class with a given name.
 * @private
 */
- (NSString*)keyForClass:(Class)cls withName:(NSString*)name {
    const char* className = class_getName(cls);
    return [NSString stringWithFormat:@"%s_%@", className, (nil != name) ? name : @""];
}


- (void)dealloc {
    NSLog(@"root controller dealloc");
}


- (void)registerScheme:(NSString*)scheme {
    if (nil != scheme) {
        if (nil == _schemes) {
            _schemes = [[NSMutableDictionary alloc] init];
        }
        [_schemes setObject:[NSNull null] forKey:scheme];
    }
}


- (void)addObjectPattern:(ARCURLNavigatorPattern*)pattern forURL:(NSString*)URL {
    pattern.URL = URL;
    [pattern compile];
    [self registerScheme:pattern.scheme];
    
    if (pattern.isUniversal) {
        _defaultObjectPattern = pattern;
        
    } else if (pattern.isFragment) {
        if (!_fragmentPatterns) {
            _fragmentPatterns = [[NSMutableArray alloc] init];
        }
        [_fragmentPatterns addObject:pattern];
        
    } else {
        _invalidPatterns = YES;
        
        if (!_objectPatterns) {
            _objectPatterns = [[NSMutableArray alloc] init];
        }
        
        [_objectPatterns addObject:pattern];
    }
}


- (void)addStringPattern:(ARCURLGeneratorPattern*)pattern forURL:(NSString*)URL withName:(NSString*)name {
    pattern.URL = URL;
    [pattern compile];
    [self registerScheme:pattern.scheme];
    
    if (!_stringPatterns) {
        _stringPatterns = [[NSMutableDictionary alloc] init];
    }
    
    NSString* key = [self keyForClass:pattern.targetClass withName:name];
    [_stringPatterns setObject:pattern forKey:key];
}


- (ARCURLNavigatorPattern*)matchObjectPattern:(NSURL*)URL {
    if (_invalidPatterns) {
        [_objectPatterns sortUsingSelector:@selector(compareSpecificity:)];
        _invalidPatterns = NO;
    }
    
    for (ARCURLNavigatorPattern* pattern in _objectPatterns) {
        if ([pattern matchURL:URL]) {
            return pattern;
        }
    }
    
    return _defaultObjectPattern;
}


- (BOOL)isWebURL:(NSURL*)URL {
    return [URL.scheme caseInsensitiveCompare:@"http"] == NSOrderedSame
    || [URL.scheme caseInsensitiveCompare:@"https"] == NSOrderedSame
    || [URL.scheme caseInsensitiveCompare:@"ftp"] == NSOrderedSame
    || [URL.scheme caseInsensitiveCompare:@"ftps"] == NSOrderedSame
    || [URL.scheme caseInsensitiveCompare:@"data"] == NSOrderedSame
    || [URL.scheme caseInsensitiveCompare:@"file"] == NSOrderedSame;
}


- (BOOL)isExternalURL:(NSURL*)URL {
    if ([URL.host isEqualToString:@"maps.google.com"]
        || [URL.host isEqualToString:@"itunes.apple.com"]
        || [URL.host isEqualToString:@"phobos.apple.com"]) {
        return YES;
        
    } else {
        return NO;
    }
}



#pragma mark Mapping
///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)from:(NSString*)URL toObject:(id)target {
    ARCURLNavigatorPattern* pattern = [[ARCURLNavigatorPattern alloc] initWithTarget:target];
    [self addObjectPattern:pattern forURL:URL];
}


- (void)from:(NSString*)URL toObject:(id)target selector:(SEL)selector {
    ARCURLNavigatorPattern* pattern = [[ARCURLNavigatorPattern alloc] initWithTarget:target];
    pattern.selector = selector;
    [self addObjectPattern:pattern forURL:URL];
}


- (void)from:(NSString*)URL toViewController:(id)target {
    ARCURLNavigatorPattern* pattern = [[ARCURLNavigatorPattern alloc] initWithTarget:target mode:ARCNavigationModeCreate];
    [self addObjectPattern:pattern forURL:URL];
}

- (void)from:(NSString*)URL toViewController:(id)target selector:(SEL)selector {
    ARCURLNavigatorPattern* pattern = [[ARCURLNavigatorPattern alloc] initWithTarget:target mode:ARCNavigationModeCreate];
    pattern.selector = selector;
    [self addObjectPattern:pattern forURL:URL];
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)from:(NSString*)URL toViewController:(id)target transition:(NSInteger)transition {
    ARCURLNavigatorPattern* pattern = [[ARCURLNavigatorPattern alloc] initWithTarget:target mode:ARCNavigationModeCreate];
    pattern.transition = transition;
    [self addObjectPattern:pattern forURL:URL];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)from:(NSString*)URL parent:(NSString*)parentURL toViewController:(id)target selector:(SEL)selector transition:(NSInteger)transition {
    ARCURLNavigatorPattern* pattern = [[ARCURLNavigatorPattern alloc] initWithTarget:target mode:ARCNavigationModeCreate];
    pattern.parentURL = parentURL;
    pattern.selector = selector;
    pattern.transition = transition;
    [self addObjectPattern:pattern forURL:URL];
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)from:(NSString*)URL toSharedViewController:(id)target {
    ARCURLNavigatorPattern* pattern = [[ARCURLNavigatorPattern alloc] initWithTarget:target mode:ARCNavigationModeShare];
    [self addObjectPattern:pattern forURL:URL];
}


- (void)from:(NSString*)URL toSharedViewController:(id)target selector:(SEL)selector {
    ARCURLNavigatorPattern* pattern = [[ARCURLNavigatorPattern alloc] initWithTarget:target mode:ARCNavigationModeShare];
    pattern.selector = selector;
    [self addObjectPattern:pattern forURL:URL];
}


- (void)from:(NSString*)URL parent:(NSString*)parentURL toSharedViewController:(id)target {
    ARCURLNavigatorPattern* pattern = [[ARCURLNavigatorPattern alloc] initWithTarget:target mode:ARCNavigationModeShare];
    pattern.parentURL = parentURL;
    [self addObjectPattern:pattern forURL:URL];
}


- (void)from:(NSString*)URL parent:(NSString*)parentURL toSharedViewController:(id)target selector:(SEL)selector {
    ARCURLNavigatorPattern* pattern = [[ARCURLNavigatorPattern alloc] initWithTarget:target mode:ARCNavigationModeShare];
    pattern.parentURL = parentURL;
    pattern.selector = selector;
    [self addObjectPattern:pattern forURL:URL];
}



#pragma mark -
#pragma mark Public

- (void)setObject:(id)object forURL:(NSString*)URL {
    if (nil == _objectMappings) {
        _objectMappings = [[NSMutableDictionary alloc] init];
    }

    [_objectMappings setObject:object forKey:URL];
    
    if ([object isKindOfClass:[UIViewController class]]) {
        //[UIViewController ttAddNavigatorController:object];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectForURL:(NSString*)URL {
    return [self objectForURL:URL query:nil pattern:nil];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectForURL:(NSString*)URL query:(NSDictionary*)query {
    return [self objectForURL:URL query:query pattern:nil];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectForURL:(NSString*)URL query:(NSDictionary*)query pattern:(ARCURLNavigatorPattern**)outPattern {
    id object = nil;
    
    if (_objectMappings) {
        object = [_objectMappings objectForKey:URL];
        if (object && !outPattern) {
            return object;
        }
    }
    
    NSURL* theURL = [NSURL URLWithString:URL];
    ARCURLNavigatorPattern* pattern  = [self matchObjectPattern:theURL];
    if (pattern) {
        if (!object) {
            object = [pattern createObjectFromURL:theURL query:query];
        }
        if (pattern.navigationMode == ARCNavigationModeShare && object) {
            [self setObject:object forURL:URL];
        }
        if (outPattern) {
            *outPattern = pattern;
        }
        return object;
        
    } else {
        return nil;
    }
}


- (NSInteger)transitionForURL:(NSString*)URL {
    ARCURLNavigatorPattern* pattern = [self matchObjectPattern:[NSURL URLWithString:URL]];
    return pattern.transition;
}


- (BOOL)isSchemeSupported:(NSString*)scheme {
    return nil != scheme && !![_schemes objectForKey:scheme];
}

- (BOOL)isAppURL:(NSURL*)URL {
    return [self isExternalURL:URL]
    || ([[UIApplication sharedApplication] canOpenURL:URL]
        && ![self isSchemeSupported:URL.scheme]
        && ![self isWebURL:URL]);
}


- (id)dispatchURL:(NSString*)URL toTarget:(id)target query:(NSDictionary*)query {
    NSURL* theURL = [NSURL URLWithString:URL];
    for (ARCURLNavigatorPattern* pattern in _fragmentPatterns) {
        if ([pattern matchURL:theURL]) {
            return [pattern invoke:target withURL:theURL query:query];
        }
    }
    
    // If there is no match, check if the fragment points to a method on the target
    if (theURL.fragment) {
        SEL selector = NSSelectorFromString(theURL.fragment);
        if (selector && [target respondsToSelector:selector]) {
            
            objc_msgSend(target, NSSelectorFromString(theURL.fragment));
            
            //[target performSelector:selector];
            
        }
    }
    
    return nil;
}



@end
