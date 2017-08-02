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
#import "ARCStoreRecord.h"
#import "ARCConnectCoordinator.h"


@implementation ARCRouterMap

@synthesize model = model_,
            object = object_,
            isInstanceMap = isInstanceMap_,
            remotePath = _remotePath,
            localAttribute = _localAttribute,
            remoteAttribute = _remoteAttribute,
            responseKeyPath = responseKeyPath_,
            requestMethod = _requestMethod;



+ (ARCRouterMap *)map {
    
    return [self mapWithRemotePath:nil];
}

+ (ARCRouterMap *)mapWithRemotePath:(NSString *)remotePath {
    
    return [[ARCRouterMap alloc] initWithRemotePath:remotePath];
}


- (id)initWithRemotePath:(NSString *)remotePath {
    if (self = [super init]) {
        self.remotePath = remotePath;
        
        self.responseKeyPath = [ARCConnectCoordinator sharedCoordinator].responseKeyPath;
    }
    
    return self;
}


- (NSString *)remotePath {
    
    NSMutableString *path = [NSMutableString stringWithString:_remotePath];
    
    if(object_ != nil){
     
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\((.*?)\\)" options:0 error:nil];
        
        [regex enumerateMatchesInString:path options:0 range:NSMakeRange(0, [path length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop){

            NSString *keyPath = [_remotePath substringWithRange:[result rangeAtIndex:1]];
                        
            id value = [object_ valueForKeyPath:keyPath];
            
            if(value != nil){
                
                if(![value isKindOfClass:[NSString class]])
                    value = [value stringValue];
                
                [path replaceCharactersInRange:[path rangeOfString:[_remotePath substringWithRange:result.range]] withString:value];
            }
        }];
    }
    
    return [path lowercaseString];
}

- (BOOL)isAttributeMap {
    
    return ([_localAttribute length] > 0 && [_remoteAttribute length] > 0);
}

- (BOOL)isRelationshipMap {
    
    NSEntityDescription *entity = [model_ entityDescription];
    
    if(entity){
        
        return [[[entity relationshipsByName] allKeys] containsObject:_localAttribute];
    }
    
    return NO;
}

- (BOOL)isRemotePathMap {
    
    return [_remotePath length] > 0;
}

@end
