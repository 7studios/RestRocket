//
//  NSDictionary+Additions.m
//  iRep
//
//  Created by GREGORY GENTLING on 7/19/11.
//  Copyright 2011 7Studios LLC. All rights reserved.
//


#import "NSDictionary+Additions.h"
#import "NSDictionary+ARCBlocks.h"
#import "NSString+Additions.h"
#import "NSDate+Helper.h"



@implementation NSDictionary (KeyAdditions)


/*
 Usage:
 NSString *stringObject = [jsonDictionary objectForKeyNotNull:@"SomeString"];
 NSArray *arrayObject = [jsonDictionary objectForKeyNotNull:@"SomeArray"];
 */

- (id)objectForKeyNotNull:(NSString *)key {
	id object = [self objectForKey:key];
	if ((NSNull *)object == [NSNull null] || (__bridge CFNullRef)object == kCFNull)
		return nil;
	
	return object;
}


- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    return [self objectForKey:key] == [NSNull null] ? defaultValue : [[self objectForKey:key] boolValue];
}

- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue {
	return [self objectForKey:key] == [NSNull null] ? defaultValue : [[self objectForKey:key] intValue];
}

- (long long)getLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue {
	return [self objectForKey:key] == [NSNull null] ? defaultValue : [[self objectForKey:key] longLongValue];
}

- (NSNumber *)getNumberValueForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue {
	return [self objectForKey:key] == [NSNull null] ? defaultValue : [self objectForKey:key];
}

- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue {	
	return [self objectForKeyNotNull:key] == nil ? defaultValue : [self objectForKey:key];
}


- (NSDate *)getDateValueForKey:(NSString *)key defaultValue:(NSDate *)defaultValue {
	
	if ([self objectForKey:key] == [NSNull null]) {
		return defaultValue;
	}
	
	id value = [self objectForKey:key];
	
	if ([value isKindOfClass:[NSDate class]]) {
		return (NSDate*)value;
		
	} else if ([value isKindOfClass:[NSString class]]) {
		return [NSDate dateFromString:value];
	}
	
	return defaultValue;
}

@end


@implementation NSDictionary (Additions)


- (id)objectForKeyPath:(NSString *)keyPath {
    
	NSArray *components = [keyPath componentsSeparatedByString:@"."];
    __block id object = self;
    
    [components enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop){
        
        if([object isKindOfClass:[NSDictionary class]] && [[object allKeys] containsObject:key])
            object = [self valueForKey:key];
        
    }];
    
    return object;
}


/*
 * Example: NSDictionary* mappableData = [NSDictionary dictionaryWithKeysAndObjects:@"name", @"Blake", @"favoriteCatID", [NSNumber numberWithInt:31337], @"cats", catsData, nil];
 *          NSDictionary* dictionary2 = [NSDictionary dictionaryWithKeysAndObjects:@"key", @"value", @"key2", @"value2", nil];
 */
+ (id)dictionaryWithKeysAndObjects:(id)firstKey, ... {
	va_list args;
    va_start(args, firstKey);
	
    NSMutableArray* keys = [NSMutableArray array];
	NSMutableArray* values = [NSMutableArray array];
    
    for (id key = firstKey; key != nil; key = va_arg(args, id)) {
		id value = va_arg(args, id);
        [keys addObject:key];
		[values addObject:value];		
    }
    va_end(args);
    
    return [self dictionaryWithObjects:values forKeys:keys];
}



/**
 * private helper function to convert any object to its string representation
 * @private
 */
static NSString *toString(id object) {
	return [NSString stringWithFormat: @"%@", object];
}

static NSString *urlEncode(id object) {
	NSString *string = toString(object);

	return [string URLEncodedString];
}


- (void)URLEncodePart:(NSMutableArray*)parts path:(NSString*)path value:(id)value {
    [parts addObject:[NSString stringWithFormat: @"%@=%@", path, urlEncode(value)]];
}


- (void)URLEncodeParts:(NSMutableArray*)parts path:(NSString*)inPath {
    
    [self each:^(id key, id value) {
        //[self enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        
        NSLog(@"root key: %@ root value: %@", key, value);
        
        NSString* path = (NO == [inPath isEmpty]) ? [inPath stringByAppendingFormat:@"[%@]", urlEncode(key)] : urlEncode(key);
        if( [value isKindOfClass:[NSArray class]] )
        {
            for( id item in value )
            {
                [self URLEncodePart:parts path:[path stringByAppendingString:@"[]"] value:item];
            }
        }
        else if([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSMutableDictionary class]])
        {
            [value URLEncodeParts:parts path:path];
        }
        else
        {
            [self URLEncodePart:parts path:path value:value];
        }
    }];
}


- (NSString*)URLEncodedStringFromDict {
    if ([self count] <= 0) return [NSString newEmpty];
    
    NSMutableArray* parts = [NSMutableArray array];
    [self URLEncodeParts:parts path:nil];
    return [parts componentsJoinedByString:@"&"];
}


@end
