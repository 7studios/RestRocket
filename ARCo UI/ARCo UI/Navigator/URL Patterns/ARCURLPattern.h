//
//  ARCURLPattern.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ARCPatternTEXT;


@interface ARCURLPattern : NSObject {
 
    NSString*               _URL;
    NSString*               _scheme;
    NSMutableArray*         _path;
    NSMutableDictionary*    _query;
    id<ARCPatternTEXT>      _fragment;
    NSInteger               _specificity;
    SEL                     _selector;
    
}

@property (nonatomic, copy)     NSString* URL;
@property (nonatomic, readonly) NSString* scheme;
@property (nonatomic, readonly) NSInteger specificity;
@property (nonatomic, readonly) Class     classForInvocation;
@property (nonatomic)           SEL       selector;
@property (nonatomic, strong) id<ARCPatternTEXT>    fragment;


- (void)setSelectorIfPossible:(SEL)selector;

- (void)compileURL;


@end
