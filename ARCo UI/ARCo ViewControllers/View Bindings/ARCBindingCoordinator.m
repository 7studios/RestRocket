
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


#import "ARCBindingCoordinator.h"



@implementation ARCBindingCoordinator

@synthesize bindings;



+ (ARCBindingCoordinator *)sharedCoordinator {
    
    static dispatch_once_t predicate;
    static ARCBindingCoordinator *_shared = nil;
    
    dispatch_once(&predicate, ^{
        _shared = [[self alloc] init];
    });
    
    return _shared;
}



- (id)init
{
    self = [super init];
    if (self) {
        self.bindings = [[NSMutableSet alloc] init];
    }
    
    return self;
}


+ (id)bind:(NSString *)dstPath of:(NSObject *)dst to:(NSString *)srcPath of:(NSObject *)src{
    return [ARCBindingCoordinator bind:dstPath of:dst to:srcPath of:src withTransform:nil andValidation:nil];
}

+ (id)bind:(NSString *)dstPath of:(NSObject *)dst to:(NSString *)srcPath of:(NSObject *)src withTransform:(TransformBlock)block{
    return [ARCBindingCoordinator bind:dstPath of:dst to:srcPath of:src withTransform:block andValidation:nil];
}

+ (id)bind:(NSString *)dstPath of:(NSObject *)dst to:(NSString *)srcPath of:(NSObject *)src withValidation:(ValidationBlock)block{
    return [ARCBindingCoordinator bind:dstPath of:dst to:srcPath of:src withTransform:nil andValidation:block];
}

+ (id)bind:(NSString *)dstPath of:(NSObject *)dst to:(NSString *)srcPath of:(NSObject *)src withTransform:(TransformBlock)tBlock andValidation:(ValidationBlock)vBlock{
    
    ARCBinding *bind = [[ARCBinding alloc]initWithSrc:src srcKeyPath:srcPath dst:dst andDstKeyPath:dstPath withTransform:tBlock andValidation:vBlock];
    
    [[ARCBindingCoordinator sharedCoordinator].bindings addObject:bind];
    
    return bind;
}


+ (id)bindCollection:(NSString *)dstPath of:(NSObject *)dst to:(NSString *)srcPath of:(NSObject *)src withAdd:(AddBlock)aBlock andRemove:(RemoveBlock)rBlock{
    
    ARCBindToCollection *bind = [[ARCBindToCollection alloc]initWithSrc:src srcKeyPath:srcPath dst:dst andDstKeyPath:dstPath withAdd:aBlock andRemove:rBlock];
    
    [[ARCBindingCoordinator sharedCoordinator].bindings addObject:bind];
    
    return bind;
}

@end
