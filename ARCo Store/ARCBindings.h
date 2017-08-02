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

#import "ARCStoreRecord.h"

@class ARCBindingMap;


typedef enum ARCBindingChangeType{
    ARCBindingChangeTypeInserted,
    ARCBindingChangeTypeUpdated,
    ARCBindingChangeTypeDeleted,
    ARCBindingChangeTypeAll
} ARCBindingChangeType;


typedef void (^ARCBindingChangeBlock) (ARCBindingMap *map);


@interface ARCBindings : NSObject {
    
    NSMutableDictionary*    bindings_;
    
@private
    NSMutableSet*       _firedMaps;
}

@property (nonatomic, strong) NSMutableDictionary *bindings;
@property (nonatomic, strong) NSMutableSet *firedMaps;


+ (ARCBindings *) sharedBindings;

- (ARCBindingMap *) bindModel:(NSManagedObject *) model toControl:(id) control inTarget:(id) target forKeyPath:(NSString *) keypath;

- (ARCBindingMap *) bindModel:(NSManagedObject *) model toSelector:(SEL) selector inTarget:(id) target forChangeType:(ARCBindingChangeType) changeType;

- (ARCBindingMap *) bindModel:(NSManagedObject *) model toBlock:(ARCBindingChangeBlock) block forChangeType:(ARCBindingChangeType) changeType;

- (ARCBindingMap *) bindEntity:(Class) entity toSelector:(SEL) selector inTarget:(id) target forChangeType:(ARCBindingChangeType) changeType;

- (ARCBindingMap *) bindEntity:(Class) entity toBlock:(ARCBindingChangeBlock) block forChangeType:(ARCBindingChangeType) changeType;

- (NSArray *) bindingsForTarget:(id) target forChangeType:(ARCBindingChangeType) changeType;
- (NSArray *) bindingsForModel:(NSManagedObject *) model forChangeType:(ARCBindingChangeType) changeType;
- (NSArray *) bindingsForEntity:(Class) entity forChangeType:(ARCBindingChangeType) changeType;
- (NSArray *) bindingsForChangeType:(ARCBindingChangeType) changeType;

- (void) addMap: (ARCBindingMap *) map;
- (void) handleChangesForObjects:(NSSet *) objects ofChangeType:(ARCBindingChangeType) changeType;

@end
