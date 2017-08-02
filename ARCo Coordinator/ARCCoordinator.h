
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

@class ARCManagedStore, ARCRouter;

/** 
 * ARCCoordinator serves as the main coordinator. 
 */
@interface ARCCoordinator : NSObject{
        
    Class               connectionClass_;
	//Class _serializationClass;
    //Class _fixtureSerializationClass;
    
    NSString*           _baseURL;
    
    NSString*           _httpUser;
    NSString*           _httpPassword;
    
    NSString*           _responseKeyPath;
        
    ARCManagedStore*    store_;
    
    ARCRouter*           router_;
    
    ARCBindings*        bindings_;
    
    NSDateFormatter*    dateFormatter_;
    NSString*           dateFormat_;
    
    BOOL                secureAllConnections_;

@private

    
}


/** @name Getting the Shared Manager */

/** Returns the ARCCoordinator singleton which is automatically created */
+ (ARCCoordinator*) sharedInstance;


/** @name Setting the Base URL and Authentication Credentials */

/** Convience method to easily create the property credentials 
 
 @param url the property baseURL to be used for remote connections
 @param user Username for HTTP authentication
 @param password Password for HTTP authentication
 */
- (ARCCoordinator *) setBaseURL:(NSString *) url user:(NSString *) user password:(NSString *) password;


/** @name Serialization Methods */


- (id) parse:(id) object;

- (id) serialize:(id) object;



/** @name Properties */

/** The class used to parse remote responses and also serialize native objects
 
 Must conform to protocol CKSerialization
 */
@property (nonatomic, assign) Class serializationClass;

/** The class used to parse local fixtures
 
 Must conform to protocol CKSerialization
 */
//@property (nonatomic, assign) Class fixtureSerializationClass;

/** Used for all remote connections
 
 Must conform to protocol CKConnection
 */
@property (nonatomic, assign) Class connectionClass;

/** Creates and manages changes to the CoreData stack */
//@property (nonatomic, readonly, retain) CKCoreData *coreData;

/** Creates and manages routes */
@property (nonatomic, readonly, retain) ARCRouter *router;

/** Creates and manages bindings */
@property (nonatomic, readonly, retain) ARCBindings *bindings;

/** Base URL used to append all resource paths to, ex: https://api.rackspace.com/v1.0/ */
@property (nonatomic, retain) NSString *baseURL;

/** HTTP Basic Auth user */
@property (nonatomic, retain) NSString *httpUser;

/** HTTP Basic Auth password */
@property (nonatomic, retain) NSString *httpPassword;

/** Keypath to response objects
 
 If response objects are not at the top level, you can specify the path to those objects (ex: Twitter, "results")
 */
@property (nonatomic, retain) NSString *responseKeyPath;

/** Internal connection instance */
//@property (nonatomic, readonly, retain) id <CKSerialization> serializer;
//@property (nonatomic, readonly, retain) id <CKSerialization> fixtureSerializer;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSString *dateFormat;

/** Global setting to batch all remote requests.
 
 Can also be set on a per model basis
 */
@property (nonatomic, assign) BOOL batchAllRequests;

/** Global setting to secure all remote requests.
 
 Can also be set on a per model basis
 */
@property (nonatomic, assign) BOOL secureAllConnections;


- (BOOL) loadSeedFiles:(NSArray *) files groupName:(NSString *) groupName;
- (BOOL) loadSeedFilesForGroupName:(NSString *) groupName;
- (BOOL) loadAllSeedFiles;
+ (NSArray *) seedFiles;


- (NSManagedObjectContext *) managedObjectContext;
- (NSManagedObjectModel *) managedObjectModel;

//- (void) sendRequest:(CKRequest *) request;
//- (void) sendBatchRequest:(CKRequest *) request;
//- (CKResult *) sendSyncronousRequest:(CKRequest *) request;


@end
