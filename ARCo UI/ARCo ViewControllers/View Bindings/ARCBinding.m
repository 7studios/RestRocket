
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


#import "ARCBinding.h"



@implementation ARCBinding

@synthesize srcObj,srcKeyPath,dstObj,dstKeyPath,transform,validation;



- (id)initWithSrc:(NSObject *)src srcKeyPath:(NSString *)srcPath dst:(NSObject *)dst andDstKeyPath:(NSString *)dstPath withTransform:(TransformBlock)tBlock andValidation:(ValidationBlock)vBlock{
    
    self = [super init];
    if (self) {
        // Store both the source object and source key path (We'll probably use this in the future)
        self.srcObj = src;
        self.srcKeyPath = srcPath;
        
        // Store the destination object and destination key path
        self.dstObj = dst;
        self.dstKeyPath = dstPath;
        
        // Store the transformation and validation blocks
        self.transform = tBlock;
        self.validation = vBlock;
        
        // Add an observer to the source object for the key path watching for new values
        [src addObserver:self forKeyPath:srcPath options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    /*[change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSLog(@"key: %@ - value: %@", key, obj);
    }];*/
    
    NSNumber *kind = [change valueForKey:NSKeyValueChangeKindKey];
    if ([kind intValue] == NSKeyValueChangeSetting){
        // Extract the new value from the change dictionary
        NSObject *value = [change valueForKey:NSKeyValueChangeNewKey];

        // Test to see if this ObserverLink has a validation block
        if (self.validation != nil){
            // If there is a validation block then test the value
            if (!self.validation(value)){
                // If the value fails the validation block then return
                return;
            }
        }
        
        // Test to see if this ObserverLink has a transform block
        if (self.transform != nil){
            // If there is a transform block then apply it to the value
            value = self.transform(value);
        }
        
        // Set the value of the destination object at the given key path
        [self.dstObj setValue:value forKeyPath:self.dstKeyPath];    
    }
}

- (void)remove{
    [self.srcObj removeObserver:self forKeyPath:self.srcKeyPath];
}

@end
