
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


#import "ARCRouter.h"
#import "ARCStoreRecord+Router.h"
#import "ARCRequestor.h"

//** Store
#import "NSManagedObject+MagicalRecord.h"
#import "NSManagedObjectModel+MagicalRecord.h"

//* Categories
#import "NSDate+Helper.h"
#import "NSString+Additions.h"
#import "NSDictionary+Additions.h"
#import "NSDictionary+ARCBlocks.h"


#define ckRouterCacheFile [[NSBundle bundleForClass:[self class]] pathForResource:@"ARCRouterCacheFile" ofType:@"plist"]


@implementation ARCRouter

@synthesize routes = routes_;


+ (ARCRouter *) sharedRouter {
        
    static dispatch_once_t predicate;
    static ARCRouter *_shared = nil;
    
    dispatch_once(&predicate, ^{
        _shared = [[self alloc] init];
    });
    
    return _shared;
}


- (id) init{
    
    if(self = [super init]){
        routes_ = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void) dealloc{
}

- (void) mapModel:(Class) model toRemotePath:(NSString *) path forRequestMethod:(ARCRequestMethod) method {
    
    ARCRouterMap *map = [ARCRouterMap map];
    map.model = model;
    map.remotePath = path;
    map.requestMethod = method;
    
    [self addMap:map];
}

- (void) mapInstancesOfModel:(Class) model toRemotePath:(NSString *) path forRequestMethod:(ARCRequestMethod) method{
    
    ARCRouterMap *map = [ARCRouterMap map];
    map.model = model;
    map.remotePath = path;
    map.requestMethod = method;
    map.isInstanceMap = YES;
    
    [self addMap:map];
}

- (void) mapRelationship:(NSString *) relationship forModel:(Class) model toRemotePath:(NSString *) path forRequestMethod:(ARCRequestMethod) method{
    
    ARCRouterMap *map = [ARCRouterMap map];
    map.localAttribute = relationship;
    map.remotePath = path;
    map.model = model;
    map.requestMethod = method;
    
    [self addMap:map];
}

- (void) mapLocalAttribute:(NSString *) localAttribute toRemoteKey:(NSString *) remoteKey forModel:(Class) model{
    
    ARCRouterMap *map = [ARCRouterMap map];
    map.localAttribute = localAttribute;
    map.remoteAttribute = remoteKey;
    map.model = model;
    
    [self addMap:map];
}

- (ARCRouterMap *) mapForModel:(Class) model forRequestMethod:(ARCRequestMethod)method {
    return [self mapForRelationship:nil forModel:model andRequestMethod:method];
}

- (ARCRouterMap *) mapForInstancesOfModel:(Class) model forRequestMethod:(ARCRequestMethod)method {
    
    NSArray *maps = [self mapsForModel:model];
    __block ARCRouterMap *instanceMap = nil;
    
    [maps enumerateObjectsUsingBlock:^(ARCRouterMap *map, NSUInteger index, BOOL *stop){
        
        if(map.isInstanceMap == YES && (map.requestMethod == method || map.requestMethod == ARCRequestMethodALL)) {
            
            instanceMap = map;
            *stop = YES;
        }
    }];
    
    return instanceMap;
}

- (ARCRouterMap *) mapForRelationship:(NSString *) relationship forModel:(Class) model andRequestMethod:(ARCRequestMethod) method{
    
    NSArray *routes = [self mapsForModel:model];
    ARCRouterMap *map = nil;

    if([routes count] > 0){
        
        NSUInteger index = [routes indexOfObjectPassingTest:^BOOL(ARCRouterMap *map, NSUInteger idx, BOOL *stop) {
            
            if(relationship != nil){
                
                if([map.localAttribute isEqualToString:relationship])
                    return map.requestMethod == method;
                else
                    return NO;
            }
            else if(method)
                return (map.requestMethod == method || map.requestMethod == ARCRequestMethodALL);
            else
                return [relationship isEqualToString:map.localAttribute];
        }];
                
        if(index != NSNotFound)
            map = [routes objectAtIndex:index];
    }
        
    return map;
}
    
- (NSArray *) mapsForModel:(Class) model{
    
    return [routes_ objectForKey:[model description]];
}

- (NSDictionary *) attributeMapForModel:(Class) model{
    
    __block NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    NSArray *maps = [self mapsForModel:model];
    
    [maps enumerateObjectsUsingBlock:^(ARCRouterMap *map, NSUInteger idx, BOOL *stop){
        
        if([map isAttributeMap])
            [attributes setObject:map.remoteAttribute forKey:map.localAttribute];
    }];
    
    return attributes;
}

- (void) addMap:(ARCRouterMap *) map{
    
    NSString *className = [map.model description];
    
    if([[routes_ allKeys] containsObject:className]){
        
        NSMutableArray *maps = [[routes_ objectForKey:className] mutableCopy];
        
        [maps addObject:map];
        [routes_ setObject:maps forKey:className];
    }
    else{
        
        [routes_ setObject:[NSArray arrayWithObject:map] forKey:className];
    }
}

- (NSString *) localAttributeForRemoteKey:(NSString *) remoteAttribute forModel:(Class) model{
    
    NSArray *maps = [self mapsForModel:model];
    __block NSString *attribute = nil;
    
    [maps enumerateObjectsUsingBlock:^(ARCRouterMap *map, NSUInteger idx, BOOL *stop){
        
        if([map.remoteAttribute isEqualToString:remoteAttribute])
            attribute = map.localAttribute;
    }];
    
    return attribute;
}

- (void) mapKeyPathsToAttributes:(Class) model sourceKeyPath:(NSString*)sourceKeyPath, ... {
    
    va_list args;
    va_start(args, sourceKeyPath);
    
    for (NSString* keyPath = sourceKeyPath; keyPath != nil; keyPath = va_arg(args, NSString*)) {
        
		NSString* attributeKeyPath = va_arg(args, NSString*);
        [self mapLocalAttribute:attributeKeyPath toRemoteKey:keyPath forModel:model];
    }
    
    va_end(args);
}

- (NSString *) remoteKeyForLocalAttribute:(NSString *) localAttribute forModel:(Class) model{
    
    NSArray *maps = [self mapsForModel:model];
    __block NSString *attribute = nil;
    
    [maps enumerateObjectsUsingBlock:^(ARCRouterMap *map, NSUInteger idx, BOOL *stop){
        
        if([map.localAttribute isEqualToString:localAttribute])
            attribute = map.remoteAttribute;
    }];
    
    return attribute;
}


- (NSMutableDictionary *) routes{
    
    return routes_ == nil ? [self setupCache] : routes_;
}

- (NSMutableDictionary *) setupCache{
    
    routes_ = [[NSMutableDictionary alloc] init];
    
    NSManagedObjectModel *model = [NSManagedObjectModel MR_defaultManagedObjectModel];
    NSDictionary *entities = [model entitiesByName];
    
    [entities enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSEntityDescription *description, BOOL *stop){
        
        NSMutableArray *maps = [NSMutableArray array];
        Class model = NSClassFromString([description managedObjectClassName]);
        
        for(int x = ARCRequestMethodGET; x <= ARCRequestMethodHEAD; x++){
                        
            [maps addObject:[model mapForRequestMethod:(ARCRequestMethod) x]];
        }
        
        [routes_ setObject:maps forKey:key];
    }];    
    
    return routes_;
}

@end
