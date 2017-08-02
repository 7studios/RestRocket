//
//  ARCURLMap.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCNavigationMode.h"


@class ARCURLNavigatorPattern;
@class ARCURLGeneratorPattern;


@interface ARCURLMap : NSObject {
    
    NSMutableDictionary*    _objectMappings;
    
    NSMutableArray*         _objectPatterns;
    NSMutableArray*         _fragmentPatterns;
    NSMutableDictionary*    _stringPatterns;
    
    NSMutableDictionary*    _schemes;
    
    ARCURLNavigatorPattern*  _defaultObjectPattern;
    ARCURLNavigatorPattern*  _hashPattern;
    
    BOOL                    _invalidPatterns;
    
}

@property (nonatomic, strong) NSMutableDictionary*    objectMappings;



- (id)dispatchURL:(NSString*)URL toTarget:(id)target query:(NSDictionary*)query;



/**
 * Adds a URL pattern which will perform a selector on an object when loaded.
 */
- (void)from:(NSString*)URL toObject:(id)object;
- (void)from:(NSString*)URL toObject:(id)object selector:(SEL)selector;


/**
 * Adds a URL pattern which will create and present a view controller when loaded.
 *
 * The selector will be called on the view controller after is created, and arguments from
 * the URL will be extracted using the pattern and passed to the selector.
 *
 * target can be either a Class which is a subclass of UIViewController, or an object which
 * implements a method that returns a UIViewController instance.  If you use an object, the
 * selector will be called with arguments extracted from the URL, and the view controller that
 * you return will be the one that is presented.
 */
- (void)from:(NSString*)URL toViewController:(id)target;
- (void)from:(NSString*)URL toViewController:(id)target selector:(SEL)selector;
- (void)from:(NSString*)URL toViewController:(id)target transition:(NSInteger)transition;
- (void)from:(NSString*)URL parent:(NSString*)parentURL toViewController:(id)target selector:(SEL)selector transition:(NSInteger)transition;


/**
 * Adds a URL pattern which will create and present a share view controller when loaded.
 *
 * Controllers created with the "share" mode, meaning that it will be created once and re-used
 * until it is destroyed.
 */
- (void)from:(NSString*)URL toSharedViewController:(id)target;
- (void)from:(NSString*)URL toSharedViewController:(id)target selector:(SEL)selector;
- (void)from:(NSString*)URL parent:(NSString*)parentURL toSharedViewController:(id)target;
- (void)from:(NSString*)URL parent:(NSString*)parentURL toSharedViewController:(id)target selector:(SEL)selector;


/**
 * Adds a direct mapping from a literal URL to an object.
 *
 * The URL must not be a pattern - it must be the a literal URL. All requests to open this URL will
 * return the object bound to it, rather than going through the pattern matching process to create
 * a new object.
 *
 * Mapped objects are not retained.  You are responsible for removing the mapping when the object
 * is destroyed, or risk crashes.
 */
- (void)setObject:(id)object forURL:(NSString*)URL;

/**
 * Gets or creates the object with a pattern that matches the URL.
 *
 * Object mappings are checked first, and if no object is bound to the URL then pattern
 * matching is used to create a new object.
 */
- (id)objectForURL:(NSString*)URL;
- (id)objectForURL:(NSString*)URL query:(NSDictionary*)query;
- (id)objectForURL:(NSString*)URL query:(NSDictionary*)query pattern:(ARCURLNavigatorPattern**)pattern;

- (NSInteger)transitionForURL:(NSString*)URL;
- (BOOL)isSchemeSupported:(NSString*)scheme;
- (BOOL)isAppURL:(NSURL*)URL;



@end
