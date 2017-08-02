//
//  ARCURLGeneratorPattern.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCURLPattern.h"


@interface ARCURLGeneratorPattern : ARCURLPattern {
    
    Class targetClass;
    
}

@property (nonatomic, assign) Class targetClass;

#pragma mark -

-(id) initWithTargetClass:(Class)aTargetClass;

#pragma mark -

-(void) compile;
-(NSString *) generateURLFromObject:(id)object;


@end
