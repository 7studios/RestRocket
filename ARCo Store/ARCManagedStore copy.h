
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

#import "CoreData+MagicalRecord.h"
#import "ARCManagedStoreProtocol.h"



@interface ARCManagedStore : MagicalRecordHelpers<ARCManagedStoreProtocol> {

	NSString*          storeFilename_;

    errorBlock_d       errorBlock_;
    storeStatusBlock_d storeStatusBlock_;
}


// The filename of the database backing this object store
@property (nonatomic, readonly) NSString* storeFilename;

// The full path to the database backing this object store
@property (nonatomic, readonly) NSString* pathToStoreFile;


/**
 * Initialize a new managed object store backed by a SQLite database with the specified filename.
 * If a seed database name is provided and no existing database is found, initialize the store by
 * copying the seed database from the main bundle. If the managed object model provided is nil,
 * all models will be merged from the main bundle for you.
 */
+ (id)initStoreWithStoreNamed:(NSString *)storeName storeStatusBlock:(storeStatusBlock_d)storeStatusBlock errorBlock:(errorBlock_d)errorBlock;
+ (id)initStoreWithStoreNamed:(NSString *)storeName usingSeedDatabaseName:(NSString *)nilOrNameOfSeedDatabaseInMainBundle storeStatusBlock:(storeStatusBlock_d)storeStatusBlock errorBlock:(errorBlock_d)errorBlock;


/**
 * This deletes and recreates the managed object context and 
 * persistant store, effectively clearing all data
 */
- (void)deleteStoreUsingSeedDatabaseName:(NSString *)seedFile errorBlock:(errorBlock_d)errorBlock;
- (void)deleteStore:(errorBlock_d)errorBlock;

- (void)createStoreCoordinator;
- (void)createStoreIfNecessaryUsingSeedDatabase:(NSString*)seedDatabase storeStatusBlock:(storeStatusBlock_d)storeStatusBlock errorBlock:(errorBlock_d)errorBlock;

- (id)initStoreWithStoreNamed:(NSString *)storeName usingSeedDatabaseName:(NSString *)nilOrNameOfSeedDatabaseInMainBundle storeStatusBlock:(storeStatusBlock_d)storeStatusBlock errorBlock:(errorBlock_d)errorBlock;

@end
