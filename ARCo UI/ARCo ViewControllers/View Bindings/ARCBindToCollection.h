
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

typedef void(^AddBlock)(NSObject *, NSObject *, NSString *);
typedef void(^RemoveBlock)(NSObject *, NSObject *, NSString *);


@interface ARCBindToCollection : NSObject {
    
}

@property (nonatomic, strong) NSObject *srcObj;
@property (nonatomic, strong) NSString *srcKeyPath;

@property (nonatomic, strong) NSObject *dstObj;
@property (nonatomic, strong) NSString *dstKeyPath;

@property (nonatomic, assign) AddBlock addBlock;
@property (nonatomic, assign) RemoveBlock removeBlock;



- (id)initWithSrc:(NSObject *)src srcKeyPath:(NSString *)srcPath dst:(NSObject *)dst andDstKeyPath:(NSString *)dstPath withAdd:(AddBlock)aBlock andRemove:(RemoveBlock)rBlock;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

- (void)remove;

@end
