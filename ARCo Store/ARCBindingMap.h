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


@interface ARCBindingMap : NSObject {
    
    NSManagedObjectID*  _objectID;
    
    Class               _entityClass;
    id                  _control;
    id                  _target;
    
    ARCBindingChangeType _changeType;
    ARCBindingChangeBlock _block;
    
    SEL                 _selector;
    NSString*           _keyPath;
}


@property (nonatomic, readwrite, strong) NSManagedObjectID *objectID;
@property (nonatomic, assign) Class entityClass;
@property (nonatomic, strong) id control;
@property (nonatomic, strong) id target;

@property (nonatomic, assign) ARCBindingChangeType changeType;
@property (nonatomic, copy) ARCBindingChangeBlock block;

@property (nonatomic, assign) SEL selector;
@property (nonatomic, copy) NSString *keyPath;


+ (ARCBindingMap *)map;

- (void) fire: (NSManagedObject *) object;
- (void) updateControl: (NSManagedObject *) object;
- (NSManagedObject *) object;

@end
