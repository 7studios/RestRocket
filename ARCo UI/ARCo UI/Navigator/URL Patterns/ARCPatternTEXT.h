//
//  ARCPatternTEXT.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString* const ARCUniversalURLPattern;

typedef NSUInteger ARCURLArgumentType;
enum {
	ARCURLArgumentTypeNone,
	ARCURLArgumentTypePointer,
	ARCURLArgumentTypeBool,
	ARCURLArgumentTypeInteger,
	ARCURLArgumentTypeLongLong,
	ARCURLArgumentTypeFloat,
	ARCURLArgumentTypeDouble
};


@protocol ARCPatternTEXT <NSObject>

-(BOOL)match:(NSString *)aTextString;
-(NSString *)convertPropertyOfObject:(id)anObject;

@end

