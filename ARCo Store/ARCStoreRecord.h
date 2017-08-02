//
//  CKRecord.h
//  CoreKit
//
//  Created by Matt Newberry on 7/19/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

//@class CKSearch;

#import <CoreData/CoreData.h>
#import "ARCRequestor.h"


typedef enum ARCRecordOptions {
    ARCRecordOptionsSaveAutomatically,
    ARCrecordOptionsAutomaticallySyncRemotely,
    ARCRecordOptionsOverrideRelationships,
    ARCRecordOptionsConvertCamelCase
} ARCRecordOptions;



@interface ARCStoreRecord : NSManagedObject {
    
    NSDictionary *_attributes;
    
}

@property (nonatomic, readonly) NSDictionary *attributes;



/** Return the name of the model */
+ (NSString *) entityName;
/** Return the name of the model and optionally remove the class prefix (if there is one) 
 
 @param removePrefix Optionally remove the class prefix
 */
+ (NSString *) entityNameWithPrefix: (BOOL) removePrefix;

/** Return the entity description */
+ (NSEntityDescription *) entityDescription;

/** Default fetch request for entity */
+ (NSFetchRequest *) fetchRequest;



/** Save changes to object 
 
 Convience method mapped to class CKCoreData method [CKCoreData save]
 */
- (BOOL) save;

/** @name Creating, Updating, Deleting */

/** Create a blank record */
+ (id) blank;

/** Automatically create or update a resource 
 If a record exists matching the passed data parameter, update: is called. If not, create: is called.
 @param data NSDictionary or NSArray containing data to populate record with
 */
+ (id) build:(id) data;

/** Create a new record
 If an array is passed, the method will call itself for each value
 @param data NSDictionary or NSArray containing data to populate record with
 */
+ (id) create:(id) data;

/** Update an existing record
 @param data Key/values to update the record with
 */
- (id) update:(NSDictionary *) data;

/** Update all matching records with the specified data 
 @param predicate query to match records by
 @param data data to update matching records with
 */
+ (void) updateWithPredicate:(NSPredicate *) predicate withData:(NSDictionary *) data;

/** Remove an existing record
 */
- (void) remove;

/** Remove an existing record both locally and remotely */
- (void) removeLocallyAndRemotely;

/** Remove all of the entity's records
 */
+ (void) removeAll;

/** Remove all of the entity's records that match the specified predicate
 @param predicate `NSPredicate` object
 */
+ (void) removeAllWithPredicate:(NSPredicate *) predicate;


/** @name Remote Syncronization*/

/** Automatically detects whether the object should be a GET, POST, PUT, or DELETE operation */
- (void) sync;
- (void) sync:(ARCRequestor *)request parseBlock:(ARCParseBlock) parseBlock completionBlock:(ARCResultBlock) completionBlock errorBlock:(ARCResultBlock) errorBlock;

+ (void) get:(ARCParseBlock) parseBlock completionBlock:(ARCResultBlock) completionBlock errorBlock:(ARCResultBlock) errorBlock;
+ (ARCRequestor *) requestForGet;

- (void) post:(ARCParseBlock) parseBlock completionBlock:(ARCResultBlock) completionBlock errorBlock:(ARCResultBlock) errorBlock;
- (ARCRequestor *) requestForPost;

- (void) put:(ARCParseBlock) parseBlock completionBlock:(ARCResultBlock) completionBlock errorBlock:(ARCResultBlock) errorBlock;
- (ARCRequestor *) requestForPut;

- (void) get:(ARCParseBlock) parseBlock completionBlock:(ARCResultBlock) completionBlock errorBlock:(ARCResultBlock) errorBlock;
- (ARCRequestor *) requestForGet;

- (void) removeRemotely:(ARCResultBlock) completionBlock errorBlock:(ARCResultBlock) errorBlock;
- (ARCRequestor *) requestForRemoveRemotely;

- (id) serialize;


/** @name Counting */

/** Count all of an entities records */
+ (NSUInteger) count;

/** Count all of an entities records that match the specified predicate
 @param predicate `NSPredicate` object
 */
+ (NSUInteger) countWithPredicate:(NSPredicate *) predicate;

/** @name Searching */

/** Return the first record using the default sort method */
+ (id) first;
/** Return the last record using the default sort method */
+ (id) last;
/** Check to see if a record exists using it's ID
 @param itemID Primary key
 */
+ (BOOL) exists:(NSNumber *) itemID;

/** Return all records using the default sort method */
+ (NSArray *) all;
/** Return all records using the specified sort method 
 @param sortBy Sort syntax
 */
+ (NSArray *) allSortedBy:(NSString *) sortBy;

/** Return all records using a predfined class CKSearch object 
 @param search 
 */ 
// + (NSArray *) findWithPredicate:(CKSearch *) search;

/** Find all results matching the specified predicate 
 @param predicate `NSPredicate` object
 */
+ (NSArray *) findWithPredicate:(NSPredicate *) predicate;
/** Find all results matching the specified predicate with a specific sort by and limit 
 @param predicate `NSPredicate` object
 @param sortBy Sort syntax
 @param limit Maximum number of records to return
 */
+ (NSArray *) findWithPredicate:(NSPredicate *) predicate sortedBy:(NSString *) sortedBy withLimit:(NSUInteger) limit;
/** Find all results where the specified attribute is exactly the value 
 @param attribute Attribute to search by
 @param value value to match for the attribute
 */
+ (NSArray *) findWhereAttribute:(NSString *) attribute equals:(id) value;
/** Find all results where the specified attribute contains the value 
 @param attribute Attribute to search by
 @param value value to check against
 */
+ (NSArray *) findWhereAttribute:(NSString *) attribute contains:(id) value;

/** Find a record by a specified ID
 @param itemId the ID of the object
 */
+ (id) findById:(NSNumber *) itemId;

/** @name Aggregates */
/** Average the specified attribute 
 Attribute must be of NSNumber type
 @param attribute the attribute to average
 */
+ (NSNumber *) average:(NSString *) attribute;
/** Find the minimum value of the specified attribute 
 Attribute must be of NSNumber type
 @param attribute the attribute to find the minimum value of
 */
+ (NSNumber *) minimum:(NSString *) attribute;
/** Find the maximum value of the specified attribute 
 Attribute must be of NSNumber type
 @param attribute the attribute to find the maximum value of
 */
+ (NSNumber *) maximum:(NSString *) attribute;
/** Find the sum of the specified attribute 
 Attribute must be of NSNumber type
 @param attribute the attribute to sum
 */
+ (NSNumber *) sum:(NSString *) attribute;




/** @name Seeds */

+ (BOOL) seed;
+ (BOOL) seedGroup:(NSString *) groupName;

/** @name Defaults */

/** Dictionary containing keys consisting of local fields with objects representing remote fields they should be mapped to */
+ (NSDictionary *) attributeMap;

/** Primary key field name */
+ (NSString *) primaryKeyName;

@end
