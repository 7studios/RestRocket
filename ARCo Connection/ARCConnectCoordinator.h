//
//  ARCConnectCoordinator.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCProcessor.h"

@class ARCRequestor;
@class ARCResult;

@interface ARCConnectCoordinator : NSObject {

    NSMutableDictionary*    baseURLs_;
    NSString*               username_;
    NSString*               password_;
    
    NSString*               responseKeyPath_;

    NSDateFormatter*        dateFormatter_;
    NSString*               dateFormat_;
    
@private
    ARCRequestor*           requestor_;    
}

@property (nonatomic, readwrite, strong) NSMutableDictionary *baseURLs;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString* responseKeyPath;
@property (nonatomic, readwrite, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, readwrite, strong) NSString *dateFormat;


+ (ARCConnectCoordinator *)sharedCoordinator;

- (void)sendRequest:(ARCRequestor *)request;
- (void)sendSynchronousRequest:(ARCRequestor *)request;


- (void)addToBaseURLs:(NSString *)url key:(NSString*)key;
- (void)addToBaseURLs:(NSString *)url key:(NSString*)key user:(NSString *)user password:(NSString *)password;

//** Find
- (NSString *)baseURLForKey:(NSString *)keypath;

@end
