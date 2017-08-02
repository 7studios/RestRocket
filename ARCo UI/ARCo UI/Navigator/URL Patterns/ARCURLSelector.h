//
//  ARCURLSelector.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCPatternTEXT.h"



@interface ARCURLSelector : NSObject {
    
    NSString*           name;
	SEL                 selector;
	ARCURLSelector*     next;
    
}

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, strong) ARCURLSelector *next;


#pragma mark -

- (id)initWithName:(NSString *)aName;

- (NSString *)perform:(id)anObject returnType:(ARCURLArgumentType)aTeturnType;

@end
