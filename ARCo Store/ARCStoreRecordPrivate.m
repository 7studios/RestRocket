//
//  CKRecordPrivate.m
//  CoreKit
//
//  Created by Matt Newberry on 7/21/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "ARCStoreRecord.h"
#import "ARCStoreCoordinator.h"

#import "NSDate+Helper.h"



@implementation ARCStoreRecord (CKRecordPrivate)


- (ARCStoreRecord *)threadedSafeSelf {
    NSError * error = nil;
    return  (ARCStoreRecord*)[[ARCStoreCoordinator sharedContext].managedObjectContext existingObjectWithID:[self objectID] error:&error];
}

+ (NSManagedObjectContext *) managedObjectContext {
    return [ARCStoreCoordinator sharedContext].managedObjectContext;
}


- (NSPropertyDescription *) propertyDescriptionForKey:(NSString *) key{
    
    return [[_attributes allKeys] containsObject:key] ? [_attributes objectForKey:key] : nil;
}


- (void) setProperty:(NSString *) property value:(id) value attributeType:(NSAttributeType) attributeType{
        
    if(value != nil){
        
        switch (attributeType) {
                
            case NSDateAttributeType:
                if(![value isKindOfClass:[NSDate class]] && [value isKindOfClass:[NSString class]]){
                    value = [NSDate dateFromString:value];
                }
                
                break;
                
            case NSStringAttributeType:
                if(![value isKindOfClass:[NSString class]])
                    value = [value respondsToSelector:@selector(stringValue)] ? [value stringValue] : [NSNull null];
                break;
                
            case NSInteger16AttributeType:
            case NSInteger32AttributeType:
            case NSInteger64AttributeType:
                value = [NSNumber numberWithInt:[value intValue]];
                break;
                
            case NSFloatAttributeType:
            case NSDecimalAttributeType:
                value = [NSNumber numberWithFloat:[value floatValue]];
                break;
                
            case NSDoubleAttributeType:
                value = [NSNumber numberWithDouble:[value doubleValue]];
                break;
                
            case NSBooleanAttributeType:
                value = [NSNumber numberWithBool:[value boolValue]];
                break;
        }
    }
    else
        value = [NSNull null];
     
    NSError *error = nil;
    if(![self validateValue:&value forKey:property error:&error]){
        NSLog(@"ERROR - %@", error);
    }
    else
        [self setValue:value forKey:property];
}

- (void) setRelationship:(NSString *) key value:(id) value relationshipDescription:(NSRelationshipDescription *) relationshipDescription {
    
    id existingValue = [self valueForKey:key];
    
    Class relationshipClass = NSClassFromString([[relationshipDescription destinationEntity] managedObjectClassName]);
    id newValue = nil;
    
    if([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])        
        newValue = [relationshipClass findById:[NSNumber numberWithInt:[value intValue]]];
    else{
        
        newValue = [relationshipClass build:value];

        if([relationshipDescription isToMany])
            newValue = [newValue isKindOfClass:[NSArray class]] ? [NSSet setWithArray:newValue] : [NSSet setWithArray:[NSArray arrayWithObject:newValue]];
        else{
            
            if([value isKindOfClass:[NSDictionary class]])
                newValue = value;
            else if ([value isKindOfClass:[NSArray class]] && [[value objectAtIndex:0] isKindOfClass:[NSDictionary class]])
                newValue = [value objectAtIndex:0];
        }
    }
    
    if(![existingValue isEqual:newValue])
        [self setValue:newValue forKey:key];
}

+ (NSNumber *) aggregateForKeyPath:(NSString *) keyPath{
    
    NSArray *results = [[self class] all];
    
    return [results valueForKeyPath:keyPath];
}

@end
