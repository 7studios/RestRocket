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

#import "ARCBindingMap.h"
#import "ARCStoreCoordinator.h"


@implementation ARCBindingMap

@synthesize objectID = _objectID,
            entityClass = _entityClass,
            control = _control,
            target = _target,
            changeType = _changeType,
            block = _block,
            selector = _selector,
            keyPath = _keyPath;



+ (ARCBindingMap *)map {
    return [[ARCBindingMap alloc] init];
}


- (void) setObjectID:(NSManagedObjectID *)objectID {
    self.entityClass = NSClassFromString([[objectID entity] managedObjectClassName]); 
    _objectID = objectID;
}

- (NSManagedObject *)object {
    return [[ARCStoreCoordinator sharedContext].managedObjectContext objectWithID:_objectID];
}


- (void)fire:(NSManagedObject *) object{
    
    if(_control != nil && _keyPath != nil)
        [self updateControl:object];    
    
    if(_selector != nil && _target != nil)
        [_target performSelector:_selector withObject:self];
    
    if(_block != nil)
        _block(self);
}

- (void) updateControl: (NSManagedObject *) object{
    
    id value = [object valueForKeyPath:_keyPath];
        
    if(value == nil)
        return;
    
    if([value isKindOfClass:[NSString class]]){
     
        if([_control respondsToSelector:@selector(setText:)])
            [_control performSelectorOnMainThread:@selector(setText:) withObject:value waitUntilDone:YES];
    }
    else if([value isKindOfClass:[NSNumber class]]){
                
        if([_control isKindOfClass:[UIProgressView class]]){
            
            float progress = [value floatValue];
            progress = progress > 1 ? progress / 100 : progress;
            
            [_control setProgress:progress animated:NO];
        }
        else if([_control isKindOfClass:[UISlider class]] || [_control isKindOfClass:NSClassFromString(@"UIStepper")]){
            
            [(UISlider *) _control setValue:[value floatValue]];
        }
        else if([_control isKindOfClass:[UISwitch class]]){
            
            [_control setOn:[value boolValue] animated:NO];
        }
    }
}



@end
