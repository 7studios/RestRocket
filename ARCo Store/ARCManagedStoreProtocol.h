//
//  ARCSManagedStoreProtocol.h
//  CoreDog
//
//  Created by GREGORY GENTLING on 9/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


#import "ARCRequestor.h"

@class ARCRouterMap;


typedef void (^errorBlock_d)(NSError *error);
typedef void (^storeStatusBlock_d)(NSString *status);


/** 
 * ARCSManagedStoreProtocol defines conforming methods for third-party HTTP CoreData Store libraries 
 */
@protocol ARCManagedStoreProtocol <NSObject>

@required 

//+ (void) initStoreWithStoreNamed;



@optional

/**
 Send a batched, asyncronous request.
 */
//- (void) sendBatchRequest:(CKRequest *) request;

@end