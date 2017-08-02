
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

#import <Foundation/Foundation.h>


@interface ARCPersistence : NSObject 


+(void)setPersistentValue:(NSString *)value forKey:(NSString *)key;
+(NSString *)getPersistentValue:(NSString *)key;

+(void)removePersistentKey:(NSString *)key;

+(BOOL)getPersistentBoolValue:(NSString *)key;
+(void)setPersistentBoolValue:(BOOL)value forKey:(NSString *)key;


+(void)setPersistentIntValue:(int) value forKey:(NSString *)key;
+(int)getPersistentIntValue:(NSString *)key;

+(void)setPersistentDoubleValue:(double) value forKey:(NSString *)key;
+(double)getPersistentDoubleValue:(NSString *)key;

+(void)setPersistentCGPointValue:(CGPoint)value forKey:(NSString *)key;
+(CGPoint)getPersistentCGPointValue:(NSString *)key;

//** Date
+(void)setPersistentDateValue:(NSDate *)value forKey:(NSString *)key;
+(NSDate *)getPersistentDateValue:(NSString *)key;

//** Object
+(void)setPersistentObjectValue:(id)value forKey:(NSString *)key;
+(id)getPersistentObjectValue:(NSString *)key;


@end
