//
//  CKRecordPrivate.h
//  CoreKit
//
//  Created by Matt Newberry on 7/21/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "ARCStoreRecord.h"



@interface ARCStoreRecord (StorePrivate)

- (ARCStoreRecord *) threadedSafeSelf;

+ (NSManagedObjectContext *) managedObjectContext;
+ (NSNumber *) aggregateForKeyPath:(NSString *) keyPath;

- (NSPropertyDescription *) propertyDescriptionForKey:(NSString *) key;
- (void) setProperty:(NSString *) property value:(id) value attributeType:(NSAttributeType) attributeType;
- (void) setRelationship:(NSString *) key value:(id) value relationshipDescription:(NSRelationshipDescription *) relationshipDescription;


@end
