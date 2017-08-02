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

#import "ARCBindings.h"
#import "ARCBindingMap.h"



@implementation ARCBindings

@synthesize bindings = _bindings;
@synthesize firedMaps = _firedMaps;


- (id) init{
    
    if (self = [super init]) {
        
        bindings_ = [[NSMutableDictionary alloc] init];
        _firedMaps = [[NSMutableSet alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleChangeNotification:) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
    }
    
    return self;
}

+ (ARCBindings *) sharedBindings{
    
    //return [CKManager sharedManager].bindings;
    return nil;
}

- (ARCBindingMap *) bindModel:(NSManagedObject *) model toControl:(id) control inTarget:(id) target forKeyPath:(NSString *) keypath{
    
    ARCBindingMap *map = [ARCBindingMap map];
    map.objectID = [model objectID];
    map.control = control;
    map.target = target;
    map.keyPath = keypath;
    map.changeType = ARCBindingChangeTypeUpdated;
    
    [self addMap:map];
    
    return map;
}

- (ARCBindingMap *) bindModel:(NSManagedObject *)model toBlock:(ARCBindingChangeBlock)block forChangeType:(ARCBindingChangeType)changeType{
    
    ARCBindingMap *map = [ARCBindingMap map];
    map.block = block;
    map.objectID = [model objectID];
    map.changeType = changeType;
    
    [self addMap:map];
    
    return map;
}

- (ARCBindingMap *) bindModel:(NSManagedObject *) model toSelector:(SEL) selector inTarget:(id) target forChangeType:(ARCBindingChangeType) changeType{
    
    ARCBindingMap *map = [ARCBindingMap map];
    map.objectID = [model objectID];
    map.target = target;
    map.selector = selector;
    map.changeType = changeType;
    
    [self addMap:map];
    
    return map;
}

- (ARCBindingMap *) bindEntity:(Class) entity toSelector:(SEL) selector inTarget:(id) target forChangeType:(ARCBindingChangeType) changeType{
    
    ARCBindingMap *map = [ARCBindingMap map];
    map.entityClass = entity;
    map.selector = selector;
    map.target = target;
    map.changeType = changeType;
    
    [self addMap:map];
    
    return map;
}

- (ARCBindingMap *)bindEntity:(Class) entity toBlock:(ARCBindingChangeBlock) block forChangeType:(ARCBindingChangeType) changeType{
    
    ARCBindingMap *map = [ARCBindingMap map];
    map.entityClass = entity;
    map.block = block;
    map.changeType = changeType;
    
    [self addMap:map];
    
    return map;
}

- (void)addMap:(ARCBindingMap *)map {
    
    if(map.entityClass == nil)
        return;
    
    NSString *className = [map.entityClass description];
    
    if([[_bindings allKeys] containsObject:className]){
        
        NSMutableArray *maps = [[_bindings objectForKey:className] mutableCopy];
        
        [maps addObject:map];
        [_bindings setObject:maps forKey:className];
    } else {
        [_bindings setObject:[NSArray arrayWithObject:map] forKey:className];
    }
}

- (NSArray *) bindingsForTarget:(id) target forChangeType:(ARCBindingChangeType) changeType{
    
    __block NSMutableArray *targetBindings = [NSMutableArray array];
    
    [[_bindings allValues] enumerateObjectsUsingBlock:^(NSArray *maps, NSUInteger idx, BOOL *stop){
       
        [maps enumerateObjectsUsingBlock:^(ARCBindingMap *map, NSUInteger idx, BOOL *stop){
            
            if((target == nil || [map.target isEqual:target]) && (changeType == ARCBindingChangeTypeAll || changeType == map.changeType)){
                [targetBindings addObject:map];   
            }
        }];
    }];
    
    return targetBindings;
}

- (NSArray *) bindingsForModel:(NSManagedObject *)model forChangeType:(ARCBindingChangeType) changeType{
    
    __block NSMutableArray *modelBindings = [_bindings objectForKey:[[model class] description]];
    
     if(modelBindings != nil){
         
         [modelBindings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
             
             ARCBindingMap *map = (ARCBindingMap *) obj;
             if([map.objectID isEqual:[model objectID]] && (changeType == ARCBindingChangeTypeAll || changeType == map.changeType)){
                [modelBindings addObject:map];
             }
        }];
     }
     else {
         modelBindings = [NSArray array];
     }
           
    return modelBindings;
}

- (NSArray *) bindingsForEntity:(Class) entity forChangeType:(ARCBindingChangeType) changeType{
    
    __block NSMutableArray *entityBindings = [_bindings objectForKey:[entity description]];
    
    if(entityBindings != nil){
        
        [entityBindings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            
            ARCBindingMap *map = (ARCBindingMap *) obj;
            if([map.entityClass isEqual:entity] && (changeType == ARCBindingChangeTypeAll || changeType == map.changeType)){
                [entityBindings addObject:map];
            }
        }];
    }
    else {
        entityBindings = [NSArray array];
    }
    
    return entityBindings;
}

- (NSArray *) bindingsForChangeType:(ARCBindingChangeType)changeType{
    
    return [self bindingsForTarget:nil forChangeType:changeType];
}

- (void) handleChangeNotification:(NSNotification *) notification{
    
    [self handleChangesForObjects:[[notification userInfo] objectForKey:NSInsertedObjectsKey] ofChangeType:ARCBindingChangeTypeInserted];
    [self handleChangesForObjects:[[notification userInfo] objectForKey:NSUpdatedObjectsKey] ofChangeType:ARCBindingChangeTypeUpdated];
    [self handleChangesForObjects:[[notification userInfo] objectForKey:NSDeletedObjectsKey] ofChangeType:ARCBindingChangeTypeDeleted];
    
    [_firedMaps removeAllObjects];
}

- (void) handleChangesForObjects:(NSSet *) objects ofChangeType:(ARCBindingChangeType) changeType{

    if(objects != nil && [objects count] > 0){
        
        NSArray *changeTypeBindings = [self bindingsForChangeType:changeType];
        
        NSMutableSet *remainingObjects = [NSMutableSet setWithSet:objects];
        [remainingObjects minusSet:_firedMaps];
        
        [changeTypeBindings enumerateObjectsWithOptions:0 usingBlock:^(ARCBindingMap *map, NSUInteger idx, BOOL *stop){
            
            [remainingObjects enumerateObjectsUsingBlock:^(NSManagedObject *object, BOOL *stop){
                
                if([[object.entity managedObjectClassName] isEqualToString:NSStringFromClass(map.entityClass)]){
                    
                    [map fire:object];
                    [_firedMaps addObject:map];
                }
            }];
        }];
    }
}



@end
