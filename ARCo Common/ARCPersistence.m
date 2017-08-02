
//
// Copyright 2011 Greg Gentling 7Studios
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "ARCPersistence.h"

@implementation ARCPersistence

// Usage [PersistentUtil removePersistentKey:persistentKeyLastOpendLabelPk];
// if ([PersistentUtil getPersistentBoolValue:persistentKeyShowUpdatedArticles]) {
// count = feed.unReadCount;
// }

+(void)setPersistentValue:(NSString *)value forKey:(NSString *)key
{
	NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
	[persistentDefaults setObject:value forKey:key];
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString *)getPersistentValue:(NSString *)key
{
	NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
	return [persistentDefaults objectForKey:key];
}


+(BOOL)getPersistentBoolValue:(NSString *)key
{
	NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
	return [persistentDefaults boolForKey:key];
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setPersistentBoolValue:(BOOL)value forKey:(NSString *)key
{
	NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
	[persistentDefaults setBool:value forKey:key];
}


+(void)setPersistentIntValue:(int) value forKey:(NSString *)key
{
	NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
	[persistentDefaults setInteger:value forKey:key];
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}
+(int)getPersistentIntValue:(NSString *)key
{
	NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
	return [persistentDefaults integerForKey:key];
}


+(void)setPersistentDoubleValue:(double) value forKey:(NSString *)key
{
	NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
	[persistentDefaults setDouble:value forKey:key];
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}
+(double)getPersistentDoubleValue:(NSString *)key
{
	NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
	return [persistentDefaults doubleForKey:key];
}


+(void)setPersistentCGPointValue:(CGPoint)value forKey:(NSString *)key
{
	NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
	[persistentDefaults setObject:NSStringFromCGPoint(value) forKey:key];
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}
+(CGPoint)getPersistentCGPointValue:(NSString *)key
{
	NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
	return CGPointFromString([persistentDefaults objectForKey:key]);
}


//** New
+(void)setPersistentDateValue:(NSDate *)value forKey:(NSString *)key
{
	NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
	[persistentDefaults setObject:value forKey:key];
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSDate *)getPersistentDateValue:(NSString *)key
{
	NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
	return (NSDate *)[persistentDefaults objectForKey:key];
}


+(void)setPersistentObjectValue:(id)value forKey:(NSString *)key
{
	NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
	[persistentDefaults setObject:value forKey:key];
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}
+(id)getPersistentObjectValue:(NSString *)key
{
	NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
	return [persistentDefaults objectForKey:key];
}


+(void)removePersistentKey:(NSString *)key
{
	NSUserDefaults *persistentDefaults = [NSUserDefaults standardUserDefaults];
	[persistentDefaults removeObjectForKey:key];
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
