
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


#import "ARCStoreCoordinator.h"
#import "NIDebuggingTools.h"
#import "ARCRequestor.h"

@implementation ARCStoreCoordinator

@synthesize managedObjectContext = managedObjectContext_,
            managedObjectModel = _managedObjectModel,
            persistentStoreCoordinator = _persistentStoreCoordinator;


#define arcCoreDataApplicationStorageType		 NSSQLiteStoreType
#define arcCoreDataTestingStorageType            NSInMemoryStoreType
#define arcCoreDataStoreFileName                 @"ARCStore.sqlite"
#define arcCoreDataThreadKey                     @"arcCoreDataThreadKey"



+ (ARCStoreCoordinator *)sharedContext {
    
    static dispatch_once_t predicate;
    static ARCStoreCoordinator *_shared = nil;
    
    dispatch_once(&predicate, ^{
        _shared = [[self alloc] init];
    });
    
    return _shared;
}


- (id)init{
    if (self = [super init]){
        self.managedObjectModel = [self managedObjectModel];
		self.persistentStoreCoordinator = [self persistentStoreCoordinator];
		managedObjectContext_ = [self newManagedObjectContext];
    }
    
    return self;
}

- (NSManagedObjectContext *)managedObjectContext{
    
    if ([NSThread isMainThread]) {
		return managedObjectContext_;
    } else {
		
		NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
		NSManagedObjectContext *backgroundThreadContext = [threadDictionary objectForKey:arcCoreDataThreadKey];
		
		if (!backgroundThreadContext) {
			
			backgroundThreadContext = [self newManagedObjectContext];					
			[threadDictionary setObject:backgroundThreadContext forKey:arcCoreDataThreadKey];			
		}
        
		return backgroundThreadContext;
	}
}

- (NSManagedObjectContext*)newManagedObjectContext {
	
	NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
	[moc setPersistentStoreCoordinator:self.persistentStoreCoordinator];
	[moc setUndoManager:nil];
	[moc setMergePolicy:NSOverwriteMergePolicy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mergeChanges:) name:NSManagedObjectContextDidSaveNotification object:moc];
    
	return moc;
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if( _managedObjectModel != nil)
		return _managedObjectModel;
    
    self.managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:[NSBundle bundleForClass:[self class]]]]; 
    
	return _managedObjectModel;
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator {
    
	if( _persistentStoreCoordinator != nil)
		return _persistentStoreCoordinator;
	
	NSString* storePath = [self storePath];    
    NSURL *storeURL = [self storeURL];
    
    NSError* error;
	
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
	
	NSDictionary* options = [self persistentStoreOptions];
    NSString *storageType = [self persistentStoreType];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:storageType configuration:nil URL:storeURL options:options error:&error]){
                
		[[NSFileManager defaultManager] removeItemAtPath:storePath error:nil];
		
		if (![_persistentStoreCoordinator addPersistentStoreWithType:storageType configuration:nil URL:storeURL options:options error:&error]){
            
            NSLog(@"%@", error);
            abort();
        }
	}
	
	return _persistentStoreCoordinator;
}

- (NSString *) persistentStoreType{
    
    return [[UIApplication sharedApplication] delegate] == nil ? arcCoreDataTestingStorageType : arcCoreDataApplicationStorageType;
}

- (NSDictionary *) persistentStoreOptions{
    
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,nil];
}

- (void) managedObjectContextDidSave:(NSNotification *)notification{

	[self.managedObjectContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
												withObject:notification
											 waitUntilDone:YES];
}

- (void) mergeChanges:(NSNotification *)notification {
    
	[self performSelectorOnMainThread:@selector(managedObjectContextDidSave:) withObject:notification waitUntilDone:YES];
}

- (NSString *) storePath{
    
    return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:arcCoreDataStoreFileName];
}

- (NSURL *) storeURL{
    
    return [NSURL fileURLWithPath:[self storePath]];
}

- (NSString *) applicationDocumentsDirectory {	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


- (void) mergeChangesFromNotification:(NSNotification *)notification
{    
	[self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
}

- (void) mergeChangesOnMainThread:(NSNotification *)notification
{
	if ([NSThread isMainThread])
	{
		[self mergeChangesFromNotification:notification];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(mergeChangesFromNotification:) withObject:notification waitUntilDone:YES];
	}
}

- (BOOL)save
{
	return [self saveWithErrorHandler:nil];
}

#ifdef NS_BLOCKS_AVAILABLE
- (BOOL) saveWithErrorHandler:(void(^)(NSError *))errorCallback
{
	NSError *error = nil;
	BOOL saved = NO;
	
    int insertedObjectsCount = [[self.managedObjectContext insertedObjects] count];
	int updatedObjectsCount = [[self.managedObjectContext updatedObjects] count];
	int deletedObjectsCount = [[self.managedObjectContext deletedObjects] count];
    
	NSDate *startTime = [NSDate date];

	@try
	{        
		saved = [self.managedObjectContext save:&error];
	}
	@catch (NSException *exception)
	{
		NIDERROR(@"Problem saving: %@", (id)[exception userInfo] ?: (id)[exception reason]);	
	}
	@finally 
    {
        if (!saved)
        {
            if (errorCallback)
            {
                errorCallback(error);
            }
            else if (error)
            {
                NIDERROR(@"******** CORE DATA FAILURE: Failed to save to data store: %@", [error localizedDescription]);
                NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
                if(detailedErrors != nil && [detailedErrors count] > 0) {
                    for(NSError* detailedError in detailedErrors) {
                        NIDERROR(@"  DetailedError: %@", [detailedError userInfo]);
                    }
                }
                else {
                    NIDERROR(@"******** CORE DATA FAILURE: %@", [error userInfo]);
                }

            }
        }
    }
    NIDINFO(@"Created: %i, Updated: %i, Deleted: %i, Time: %f seconds", insertedObjectsCount, updatedObjectsCount, deletedObjectsCount, ([startTime timeIntervalSinceNow] *-1));
    
	return saved && error == nil;
}
#endif

- (void) saveWrapper
{
#if __IPHONE_5_0
    @autoreleasepool
    {
        [self save];
    }
#else
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self save];
    [pool drain];
#endif
}

- (BOOL) saveOnBackgroundThread
{
	[self performSelectorInBackground:@selector(saveWrapper) withObject:nil];
    
	return YES;
}

- (BOOL) saveOnMainThread
{
	@synchronized(self)
	{
		[self performSelectorOnMainThread:@selector(saveWrapper) withObject:nil waitUntilDone:YES];
	}
    
	return YES;
}



@end
