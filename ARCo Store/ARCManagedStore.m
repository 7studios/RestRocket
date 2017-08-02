
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


#import "ARCManagedStore.h"
#import "NSPersistentStoreCoordinator+MagicalRecord.h"
#import "NSString+Additions.h"



@implementation ARCManagedStore

@synthesize storeFilename = storeFilename_;



+ (id)initStoreWithStoreNamed:(NSString *)storeName storeStatusBlock:(storeStatusBlock_d)storeStatusBlock errorBlock:(errorBlock_d)errorBlock {
    return [[self alloc] initStoreWithStoreNamed:storeName usingSeedDatabaseName:nil storeStatusBlock:storeStatusBlock errorBlock:errorBlock];    
}

+ (id)initStoreWithStoreNamed:(NSString *)storeName usingSeedDatabaseName:(NSString *)nilOrNameOfSeedDatabaseInMainBundle storeStatusBlock:(storeStatusBlock_d)storeStatusBlock errorBlock:(errorBlock_d)errorBlock {
    return [[self alloc] initStoreWithStoreNamed:storeName usingSeedDatabaseName:nilOrNameOfSeedDatabaseInMainBundle storeStatusBlock:storeStatusBlock errorBlock:errorBlock];
}

- (id)initStoreWithStoreNamed:(NSString *)storeName usingSeedDatabaseName:(NSString *)nilOrNameOfSeedDatabaseInMainBundle storeStatusBlock:(storeStatusBlock_d)storeStatusBlock errorBlock:(errorBlock_d)errorBlock {
    if ((self = [super init])) {
        storeFilename_ = storeName;
        
        storeStatusBlock_ = [storeStatusBlock copy];
        errorBlock_ = [errorBlock copy];
        
        [self createStoreIfNecessaryUsingSeedDatabase:nilOrNameOfSeedDatabaseInMainBundle storeStatusBlock:^(NSString* status) {

            [self createStoreCoordinator];
         
         } errorBlock:^(NSError* error) {
             errorBlock_(error);
        }];
    }
    return self;
}


- (void)createStoreIfNecessaryUsingSeedDatabase:(NSString*)seedDatabase storeStatusBlock:(storeStatusBlock_d)storeStatusBlock errorBlock:(errorBlock_d)errorBlock {
    
    if (YES == [[NSFileManager defaultManager] fileExistsAtPath:self.pathToStoreFile]) {
        if (seedDatabase != nil) {
            NSString* seedDatabasePath = [[NSBundle mainBundle] pathForResource:seedDatabase ofType:nil];
            
            NSError* error;
            if (![[NSFileManager defaultManager] copyItemAtPath:seedDatabasePath toPath:self.pathToStoreFile error:&error]) {
                errorBlock_(error);
            }
        }
    }
}


- (NSString*)pathToStoreFile {
    NSURL *urlForStore = [NSPersistentStore MR_urlForStoreName:storeFilename_];
    NSURL *pathToStore = [urlForStore URLByDeletingLastPathComponent];

    return [pathToStore path];
}


- (void)createStoreCoordinator {
    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreNamed:storeFilename_];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
    
    NSManagedObjectContext *context = [NSManagedObjectContext contextWithStoreCoordinator:coordinator];
    [NSManagedObjectContext setDefaultContext:context];
}


- (void)deleteStoreUsingSeedDatabaseName:(NSString *)seedFile errorBlock:(errorBlock_d)errorBlock {
    NSURL* storeUrl = [NSURL fileURLWithPath:self.pathToStoreFile];
    errorBlock_ = [errorBlock copy];
    
    NSError* error;
	if (![[NSFileManager defaultManager] removeItemAtPath:storeUrl.path error:&error]) {
        errorBlock_(error);
    }
    
    if (![seedFile isBlank]) {
        [self createStoreIfNecessaryUsingSeedDatabase:seedFile storeStatusBlock:^(NSString* status) {
            
        } errorBlock:^(NSError *error) {
            errorBlock_(error);
        }];
    }
    
    [self createStoreCoordinator];
}


- (void)deleteStore:(errorBlock_d)errorBlock {
    [self deleteStoreUsingSeedDatabaseName:nil errorBlock:errorBlock];
}


@end
