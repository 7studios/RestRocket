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

#import "ARCRequestor.h"


@interface ARCRouterMap : NSObject{
    
    Class               model_;
    id                  object_;
    
    BOOL                isInstanceMap_;
    NSString*           responseKeyPath_;
    
    NSString*           _remotePath;
    NSString*           _localAttribute;
    NSString*           _remoteAttribute;
    ARCRequestMethod   _requestMethod;

}

@property (nonatomic, assign) Class model;
@property (strong) id object;
@property (nonatomic, assign) BOOL isInstanceMap;
@property (nonatomic, copy) NSString *remotePath;
@property (nonatomic, copy) NSString *localAttribute;
@property (nonatomic, copy) NSString *remoteAttribute;
@property (nonatomic, copy) NSString *responseKeyPath;
@property (nonatomic, assign) ARCRequestMethod requestMethod;


+ (ARCRouterMap *) map;
+ (ARCRouterMap *) mapWithRemotePath:(NSString *)remotePath;

- (id)initWithRemotePath:(NSString *)remotePath;


- (BOOL) isAttributeMap;
- (BOOL) isRelationshipMap;
- (BOOL) isRemotePathMap;


@end
