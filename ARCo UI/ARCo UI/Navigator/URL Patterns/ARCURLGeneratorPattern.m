//
//  ARCURLGeneratorPattern.m
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCURLGeneratorPattern.h"
#import "ARCPatternTEXT.h"
#import "ARCURLWildcard.h"


@implementation ARCURLGeneratorPattern

@synthesize targetClass;



-(id) init {
	return [self initWithTargetClass:nil];
}

-(id) initWithTargetClass:(id)aTargetClass {
    if (self = [super init]) {
	    targetClass = aTargetClass;
    }
    
	return self;
}


#pragma mark NKURLNavigationPattern

-(Class) classForInvocation {
	return targetClass;
}


#pragma mark API

-(void) compile {
	[self compileURL];
    
	for (id <ARCPatternTEXT> pattern in _path) {
		if ([pattern isKindOfClass:[ARCURLWildcard class]]) {
			ARCURLWildcard *wildcard = (ARCURLWildcard *)pattern;
			[wildcard deduceSelectorForClass:targetClass];
		}
	}
	
	for (id <ARCPatternTEXT> pattern in [_query objectEnumerator]) {
		if ([pattern isKindOfClass:[ARCURLWildcard class]]) {
			ARCURLWildcard *wildcard = (ARCURLWildcard *)pattern;
			[wildcard deduceSelectorForClass:targetClass];
		}
	}
}

- (NSString *)generateURLFromObject:(id)object {
	NSMutableArray *paths = [NSMutableArray array];
	NSMutableArray *queries = nil;
    
	[paths addObject:[NSString stringWithFormat:@"%@:/", _scheme]];
	
	for (id<ARCPatternTEXT> patternText in _path) {
		NSString *value = [patternText convertPropertyOfObject:object];
		[paths addObject:value];
	}
	
	for (NSString *name in [_query keyEnumerator]) {
		id<ARCPatternTEXT> patternText	= [_query objectForKey:name];
		NSString *value = [patternText convertPropertyOfObject:object];
		NSString *pair = [NSString stringWithFormat:@"%@=%@", name, value];
		if (!queries) {
			queries = [NSMutableArray array];
		}
		[queries addObject:pair];
	}
	
	NSString *generatedPath = [paths componentsJoinedByString:@"/"];
	if (queries) {
		NSString *queryString = [queries componentsJoinedByString:@"&"];
		return [generatedPath stringByAppendingFormat:@"?%@", queryString];
	}
	else {
		return generatedPath;
	}
}


@end
