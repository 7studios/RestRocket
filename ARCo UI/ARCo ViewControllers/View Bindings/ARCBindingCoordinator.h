
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
#import "ARCBinding.h"
#import "ARCBindToCollection.h"



@interface ARCBindingCoordinator : NSObject

@property (nonatomic, strong) NSMutableSet *bindings;


+ (ARCBindingCoordinator *)sharedCoordinator;


+ (id)bind:(NSString *)dstPath of:(NSObject *)dst to:(NSString *)srcPath of:(NSObject *)src;
+ (id)bind:(NSString *)dstPath of:(NSObject *)dst to:(NSString *)srcPath of:(NSObject *)src withTransform:(TransformBlock)block;
+ (id)bind:(NSString *)dstPath of:(NSObject *)dst to:(NSString *)srcPath of:(NSObject *)src withValidation:(ValidationBlock)block;
+ (id)bind:(NSString *)dstPath of:(NSObject *)dst to:(NSString *)srcPath of:(NSObject *)src withTransform:(TransformBlock)tBlock andValidation:(ValidationBlock)vBlock;

+ (id)bindCollection:(NSString *)dstPath of:(NSObject *)dst to:(NSString *)srcPath of:(NSObject *)src withAdd:(AddBlock)aBlock andRemove:(RemoveBlock)rBlock;

@end
