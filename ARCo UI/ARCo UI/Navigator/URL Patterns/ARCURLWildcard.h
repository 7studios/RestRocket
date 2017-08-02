//
//  ARCURLWildcard.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCPatternTEXT.h"


@class ARCURLSelector;


@interface ARCURLWildcard : NSObject <ARCPatternTEXT> {
    
    NSString*               name;
	NSInteger               argIndex;
	ARCURLArgumentType      argType;
	ARCURLSelector*         selector;

}


@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger argIndex;
@property (nonatomic, assign) ARCURLArgumentType argType;
@property (nonatomic, strong) ARCURLSelector *selector;



#pragma mark -

- (void)deduceSelectorForClass:(Class)cls;



@end
