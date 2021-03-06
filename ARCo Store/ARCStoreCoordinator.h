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

#import <CoreData/CoreData.h>



@interface ARCStoreCoordinator : NSObject {
    
    NSManagedObjectContext*         managedObjectContext_;
	NSManagedObjectModel*           _managedObjectModel;
	NSPersistentStoreCoordinator*   _persistentStoreCoordinator;
    
}

@property (nonatomic, readwrite, strong) NSManagedObjectContext*    managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel*                 managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator*         persistentStoreCoordinator;



+ (ARCStoreCoordinator *)sharedContext;

- (NSManagedObjectContext*)newManagedObjectContext;

#ifdef NS_BLOCKS_AVAILABLE
- (BOOL) saveWithErrorHandler:(void(^)(NSError *))errorCallback;
#endif


- (NSString *) storePath;
- (NSURL *) storeURL;
- (NSString *) persistentStoreType;
- (NSDictionary *) persistentStoreOptions;
- (NSString *) applicationDocumentsDirectory;


- (BOOL) save;

@end
