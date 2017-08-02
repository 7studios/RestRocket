//
//  ARCURLNavigatorPattern.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCPatternTEXT.h"
#import "ARCURLPattern.h"

@interface ARCURLNavigatorPattern : ARCURLPattern {
    
    Class                       _targetClass;
    id                          _targetObject;
    ARCURLArgumentType          _navigationMode;
    NSString*                   _parentURL;
    NSInteger                   _transition;
    NSInteger                   _argumentCount;
    UIModalPresentationStyle    _modalPresentationStyle;
    
}

@property (nonatomic, assign)   Class               targetClass;
@property (nonatomic, strong)   id                  targetObject;
@property (nonatomic, readonly) ARCURLArgumentType  navigationMode;
@property (nonatomic, copy)     NSString*           parentURL;
@property (nonatomic, assign)   NSInteger           transition;
@property (nonatomic, assign)   NSInteger           argumentCount;

@property (nonatomic, readonly) BOOL                isUniversal;
@property (nonatomic, readonly) BOOL                isFragment;
@property (nonatomic, assign) UIModalPresentationStyle modalPresentationStyle;

- (id)initWithTarget:(id)target;
- (id)initWithTarget:(id)target mode:(ARCURLArgumentType)navigationMode;

- (void)compile;

- (BOOL)matchURL:(NSURL*)URL;

- (id)invoke:(id)target withURL:(NSURL*)URL query:(NSDictionary*)query;

/**
 * either instantiates an object or delegates object creation
 * depending on current configuration
 * @return the newly created object or nil if something went wrong
 */
- (id)createObjectFromURL:(NSURL*)URL query:(NSDictionary*)query;

@end
