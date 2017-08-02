//
//  CKRecord.m
//  CoreKit
//
//  Created by Matt Newberry on 7/19/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "ARCStoreRecord.h"
#import "ARCStoreCoordinator.h"
#import "ARCResult.h"

#import "ARCStoreRecordPrivate.h"
#import "ARCStoreRecord+Router.h"


/*
#import "CKManager.h"
#import "NIPaths.h"
#import "CKRecordPrivate.h"
#import "CKRecord+CKRouter.h"
*/


@implementation ARCStoreRecord

@synthesize attributes = _attributes;



- (id) initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context{
    
    if (self = [super initWithEntity:entity insertIntoManagedObjectContext:context]){
        
        _attributes = [[[self class] entityDescription] propertiesByName];
    }
    
    return self;
}


#pragma mark -
#pragma mark Entity Methods

+ (NSString *) entityName {
	
	return [self entityNameWithPrefix:YES];
}

+ (NSString *) entityNameWithPrefix:(BOOL) removePrefix{
    
    NSMutableString *name = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@", self]];

    //if([arcCoreDataClassPrefix length] > 0 && removePrefix)
    //    [name replaceOccurrencesOfString:arcCoreDataClassPrefix withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [arcCoreDataClassPrefix length])];
	
	return name;
}

+ (NSEntityDescription *) entityDescription{
	return nil;
	//return [NSEntityDescription entityForName:[self entityNameWithPrefix:NO] inManagedObjectContext:[self managedObjectContext]];
}

+ (NSFetchRequest *) fetchRequest{
	
	NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
	[fetch setEntity:[self entityDescription]];
	return fetch;
}


#pragma mark -
#pragma mark Saving
+ (BOOL) save{
    return NO;
    //return [[[CKManager sharedManager] coreData] save];
}

- (BOOL) save{
    
    return [[self class] save];
}

#pragma mark -
#pragma mark Creating, Updating, Deleting

+ (id) blank{
    return nil;
    //return [[self alloc] initWithEntity:[self entityDescription] insertIntoManagedObjectContext:[self managedObjectContext]];
}

+ (id) build:(id) data{
    
    __block id returnValue = nil;
    
    if ([data isKindOfClass:[NSArray class]]) {
        
        returnValue = [NSMutableArray arrayWithCapacity:[data count]];
        
        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
           
            id object = [self build:obj];
            
            if(object != nil)
                [returnValue addObject:object];
        }];
    }
    
    else if ([data isKindOfClass:[NSDictionary class]]) {
        
        id resourceId = [data objectForKey:[self primaryKeyName]];
        
		if (resourceId != nil){
			
			id resource = [self findById:[NSNumber numberWithInt:[resourceId intValue]]];
            
            returnValue = resource == nil ? [self create:data] : [[resource threadedSafeSelf] update:data];
		}
		else
			returnValue = [self create:data];
    }
        
    return returnValue;
}

+ (id) create:(id) data{
    
    __block id returnValue = nil;
    
    if([data isKindOfClass:[NSDictionary class]])
        returnValue = [[self blank] update:data];
    else if([data isKindOfClass:[NSArray class]]){
        
        returnValue = [NSMutableArray array];
        
        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            
            id newValue = [self create:obj];

            if(newValue != nil)
                [returnValue addObject:newValue]; 
        }];
    }
    
    return returnValue;
}

- (id) update:(NSDictionary *) data{
    id safe = nil;
    /*
    CKRecord *safe = [self threadedSafeSelf];
    
    [data enumerateKeysAndObjectsWithOptions:0 usingBlock:^(id key, id obj, BOOL *stop){
        
        NSDictionary *propertyMap = [[safe class] attributeMap];
        NSString *localKey = [[propertyMap allKeys] containsObject:key] ? [propertyMap objectForKey:key] : key;  
        
        NSPropertyDescription *propertyDescription = [safe propertyDescriptionForKey:localKey];
        
        if(propertyDescription != nil){
            
            if([propertyDescription isKindOfClass:[NSRelationshipDescription class]])
                [safe setRelationship:localKey value:obj relationshipDescription:(NSRelationshipDescription *) propertyDescription];
            else if([propertyDescription isKindOfClass:[NSAttributeDescription class]]){
                
                NSAttributeDescription *attributeDescription = (NSAttributeDescription *) propertyDescription;
                [safe setProperty:localKey value:obj attributeType:[attributeDescription attributeType]];
            }
        }
    }];
    
    
    NSError *error = nil;
    if(![safe validateForUpdate:&error]){
        NSLog(@"%@", error);
    }
    */
    
    return safe;
}

+ (void) updateWithPredicate:(NSPredicate *)predicate withData:(NSDictionary *)data{
 
    [[self findWithPredicate:predicate] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
       
        [obj update:data];
    }];
}

+ (void) removeAll{
    
	[self removeAllWithPredicate:nil];
}

+ (void) removeAllWithPredicate:(NSPredicate *) predicate{
	
	NSFetchRequest *request = [self fetchRequest];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [[ARCStoreCoordinator sharedContext].managedObjectContext executeFetchRequest:request error:&error];
    
    [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){       
        [obj remove];
    }];
}

- (void) remove{
	
	[[self managedObjectContext] deleteObject:self];
}

- (void) removeLocallyAndRemotely{
    
    [self remove];
    [self removeRemotely:nil errorBlock:nil];
}

#pragma mark -
#pragma mark Remote Syncronization

+ (void)get:(ARCParseBlock) parseBlock completionBlock:(ARCResultBlock) completionBlock errorBlock:(ARCResultBlock) errorBlock{
    
    ARCRequestor *request = [self requestForGet];
    request.parseBlock = parseBlock;
    request.completionBlock = completionBlock;
    request.errorsBlock = errorBlock;
    
    //[[CKManager sharedManager] sendRequest:request];    
}

+ (ARCRequestor *) requestForGet{
    return [ARCRequestor requestWithMap:[self mapForRequestMethod:ARCRequestMethodGET]];
}

- (void) post:(ARCParseBlock) parseBlock completionBlock:(ARCResultBlock) completionBlock errorBlock:(ARCResultBlock) errorBlock{
    
    [self sync:[self requestForPost] parseBlock:parseBlock completionBlock:completionBlock errorBlock:errorBlock];
}

- (ARCRequestor *) requestForPost{
    
    ARCRequestor *request = [ARCRequestor requestWithMap:[ARCStoreRecord mapForRequestMethod:ARCRequestMethodPOST]];
    request.body = [self serialize];
    
    return request;    
}

- (void) put:(ARCParseBlock) parseBlock completionBlock:(ARCResultBlock) completionBlock errorBlock:(ARCResultBlock) errorBlock{
        
    [self sync:[self requestForPut] parseBlock:parseBlock completionBlock:completionBlock errorBlock:errorBlock];
}

- (ARCRequestor *) requestForPut{
    
    ARCRequestor *request = [ARCRequestor requestWithMap:[ARCStoreRecord mapForRequestMethod:ARCRequestMethodPUT]];
    request.body = [self serialize];
    
    return request;
}

- (void) get:(ARCParseBlock) parseBlock completionBlock:(ARCResultBlock) completionBlock errorBlock:(ARCResultBlock) errorBlock{
        
    [self sync:[self requestForGet] parseBlock:parseBlock completionBlock:completionBlock errorBlock:errorBlock];
}

- (ARCRequestor *) requestForGet{
    
    return [ARCRequestor requestWithMap:[ARCStoreRecord mapForRequestMethod:ARCRequestMethodGET]];
}

- (void) removeRemotely:(ARCResultBlock) completionBlock errorBlock:(ARCResultBlock) errorBlock{
    
   [self sync:[self requestForRemoveRemotely] parseBlock:nil completionBlock:completionBlock errorBlock:errorBlock];
}

- (ARCRequestor *) requestForRemoveRemotely{
    
    return [ARCRequestor requestWithMap:[ARCStoreRecord mapForRequestMethod:ARCRequestMethodDELETE]];
}

- (void) sync{
    
    if(![self isInserted])
        [self put:nil completionBlock:nil errorBlock:nil];
    
    else if([self isUpdated])
        [self post:nil completionBlock:nil errorBlock:nil];
    
    else if([self isDeleted])
        [self removeRemotely:nil errorBlock:nil];
    
    else
        [self get:nil completionBlock:nil errorBlock:nil];
}

- (void) sync:(ARCRequestor *) request parseBlock:(ARCParseBlock) parseBlock completionBlock:(ARCResultBlock) completionBlock errorBlock:(ARCResultBlock) errorBlock{
    
    if(request.parseBlock == nil)
        request.parseBlock = parseBlock;
    
    if(request.completionBlock == nil)
        request.completionBlock = completionBlock;
    
    if(request.errorsBlock == nil)
        request.errorsBlock = errorBlock;    
}


- (id) serialize{
    return nil; // [[CKManager sharedManager] serialize:self];
}



#pragma mark -
#pragma mark Counting

+ (NSUInteger) count{
	
	return [self countWithPredicate:nil];
}

+ (NSUInteger) countWithPredicate:(NSPredicate *) predicate{
	
	NSFetchRequest *fetch = [self fetchRequest];
	[fetch setPredicate:predicate];
	
    return [[ARCStoreCoordinator sharedContext].managedObjectContext countForFetchRequest:fetch error:nil];
}


#pragma mark -
#pragma mark Searching

+ (id) first{
    
    NSArray *results = [self findWithPredicate:nil sortedBy:nil withLimit:1];
    
    return [results count] == 1 ? [results objectAtIndex:0] : nil;
}

+ (id) last{
    
    NSArray *results = [self all];
    
    return [results count] > 0 ? [results lastObject] : nil;
}

+ (BOOL) exists:(NSNumber *)itemID{
    
    id result = [self findById:itemID];
    
    return result == nil;
}

+ (NSArray *) all{
    
    return [self allSortedBy:nil];
}

+ (NSArray *) allSortedBy:(NSString *)sortBy{
    
    return [self findWithPredicate:nil sortedBy:sortBy withLimit:0];
}

+ (NSArray *) findWithPredicate:(NSPredicate *)predicate{
    
    return [self findWithPredicate:predicate sortedBy:nil withLimit:0];
}

+ (NSArray *) findWithPredicate:(NSPredicate *)predicate sortedBy:(NSString *)sortedBy withLimit:(NSUInteger)limit{
    
    NSFetchRequest *request = [self fetchRequest];
    [request setPredicate:predicate];
    
    if([sortedBy length] > 0) {
        //[request setSortDescriptors:CK_SORT(sortedBy)];
    }
    
    if(limit > 0)
        [request setFetchLimit:limit];
    
    return [[ARCStoreCoordinator sharedContext].managedObjectContext executeFetchRequest:request error:nil];
}

+ (NSArray *) findWhereAttribute:(NSString *)attribute contains:(id)value{
    
    return [self findWithPredicate:[NSPredicate predicateWithFormat:@"%K CONTAINS %@", attribute, value]];
}

+ (NSArray *) findWhereAttribute:(NSString *)attribute equals:(id)value{
    
    return [self findWithPredicate:[NSPredicate predicateWithFormat:@"%K == %@", attribute, value]];
}

+ (id) findById:(NSNumber *) itemId{
        
    NSArray *results = [self findWithPredicate:[NSPredicate predicateWithFormat:@"%K == %i", [self primaryKeyName], [itemId intValue]] sortedBy:nil withLimit:1];
    
    return [results count] > 0 ? [results objectAtIndex:0] : nil;
}


#pragma mark -
#pragma mark Aggregates

+ (NSNumber *) average:(NSString *)attribute{
    
    return [self aggregateForKeyPath:[NSString stringWithFormat:@"@avg.%@", attribute]];
}

+ (NSNumber *) minimum:(NSString *)attribute{
    
    return [self aggregateForKeyPath:[NSString stringWithFormat:@"min.%@", attribute]];
}

+ (NSNumber *) maximum:(NSString *)attribute{
    
    return [self aggregateForKeyPath:[NSString stringWithFormat:@"max.%@", attribute]];
}

+ (NSNumber *) sum:(NSString *)attribute{
    
    return [self aggregateForKeyPath:[NSString stringWithFormat:@"@sum.%@", attribute]];
}


#pragma mark -
#pragma mark Seeds

+ (BOOL) seed{
    
    return [self seedGroup:nil];
}

+ (BOOL) seedGroup:(NSString *) groupName{
    return nil;
}


#pragma mark -
#pragma mark Defaults


+ (NSDictionary *) attributeMap{
    
    return [NSDictionary dictionary];
}

+ (NSString *) primaryKeyName{
    
    return @"id";
}


@end
