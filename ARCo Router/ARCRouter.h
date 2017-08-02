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

#import "ARCRouterMap.h"
#import "ARCRequestor.h"


@interface ARCRouter : NSObject{
    
    NSMutableDictionary*    routes_;
}


/** Routing dictionary for classes 
 @param routes Keys represent class names, values represent their route
 */
@property (nonatomic, readonly) NSMutableDictionary *routes;


+ (ARCRouter *) sharedRouter;

- (void) addMap:(ARCRouterMap *) map;

- (void) mapModel:(Class) model toRemotePath:(NSString *) path forRequestMethod:(ARCRequestMethod) method;
- (void) mapInstancesOfModel:(Class) model toRemotePath:(NSString *) path forRequestMethod:(ARCRequestMethod) method;

- (void) mapRelationship:(NSString *) relationship forModel:(Class) model toRemotePath:(NSString *) path forRequestMethod:(ARCRequestMethod) method;

- (void) mapLocalAttribute:(NSString *) localAttribute toRemoteKey:(NSString *) remoteKey forModel:(Class) model;
- (void) mapKeyPathsToAttributes:(Class) model sourceKeyPath:(NSString*)sourceKeyPath, ... NS_REQUIRES_NIL_TERMINATION;

- (ARCRouterMap *) mapForModel:(Class) model forRequestMethod:(ARCRequestMethod) method;
- (ARCRouterMap *) mapForInstancesOfModel:(Class) model forRequestMethod:(ARCRequestMethod) method;
- (ARCRouterMap *) mapForRelationship:(NSString *) relationship forModel:(Class) model andRequestMethod:(ARCRequestMethod) method; 

- (NSDictionary *) attributeMapForModel:(Class) model;
- (NSArray *) mapsForModel:(Class) model;

- (NSString *) localAttributeForRemoteKey:(NSString *) remoteKey forModel:(Class) model;
- (NSString *) remoteKeyForLocalAttribute:(NSString *) localAttribute forModel:(Class) model;

- (NSMutableDictionary *) setupCache;

@end
