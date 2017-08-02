//
//  NSDictionary+Additions.h
//  iRep
//
//  Created by GREGORY GENTLING on 7/19/11.
//  Copyright 2011 7Studios LLC. All rights reserved.
//



@interface NSDictionary (KeyAdditions)

- (id)objectForKeyNotNull:(id)key;

- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue;

- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue;
- (long long)getLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue;
- (NSNumber *)getNumberValueForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue;

- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
- (NSDate *)getDateValueForKey:(NSString *)key defaultValue:(NSDate *)defaultValue;

@end



@interface NSDictionary (Additions)


/**
 * Creates and initializes a dictionary with key value pairs, with the keys specified
 * first instead of the objects.
 */
+ (id)dictionaryWithKeysAndObjects:(id)firstKey, ... NS_REQUIRES_NIL_TERMINATION;



/**
 * Returns a representation of the dictionary as a URLEncoded string
 *
 * @returns A UTF-8 encoded string representation of the keys/values in the dictionary
 */
- (NSString*)URLEncodedStringFromDict;


- (id)objectForKeyPath:(NSString *) keyPath;


@end