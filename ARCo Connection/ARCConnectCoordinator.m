//
//  ARCConnectCoordinator.m
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCConnectCoordinator.h"

#import "ARCRequestor.h"
#import "NSDictionary+ARCBlocks.h"
#import "NSString+Additions.h"


@implementation ARCConnectCoordinator

@synthesize baseURLs = baseURLs_,
            username = username_,
            password = password_,
            responseKeyPath = responseKeyPath_,
            dateFormatter = dateFormatter_,
            dateFormat = dateFormat_;


#pragma mark -
# pragma mark Initializations

+ (ARCConnectCoordinator *)sharedCoordinator {
    
    static dispatch_once_t predicate;
    static ARCConnectCoordinator *_shared = nil;
    
    dispatch_once(&predicate, ^{
        _shared = [[self alloc] init];
    });
    
    return _shared;
}



- (id)init {
    
    if (self = [super init]) {
        
        dateFormatter_ = [[NSDateFormatter alloc] init];
        baseURLs_ = [[NSMutableDictionary alloc] init];
        
        //** Defaults
        responseKeyPath_ = @"results";
    }
    
    return self;
}



- (void)sendRequest:(ARCRequestor *)request {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [request.connection send:request];
    });
}


- (void)sendSynchronousRequest:(ARCRequestor *)request {
    [request.connection sendSynchronousRequest:request];
}



- (void)addToBaseURLs:(NSString *)url  key:(NSString*)key {
    return [self addToBaseURLs:url key:key user:nil password:nil];
}


- (void)addToBaseURLs:(NSString *)url key:(NSString*)key user:(NSString *)user password:(NSString *)password {
    
    [baseURLs_ setObject:url forKey:key];
    
    self.username = user;
    self.password = password;
}


- (NSString *)baseURLForKey:(NSString *)keypath {
    __block NSString *base = nil;
    
    [baseURLs_ eachWithStop:^(id key, id object, BOOL *stop) {
        if ([keypath isEqualToString:(NSString*)keypath]) {
            *stop = YES;
            base = [NSString stringWithFormat: @"%@", object];
        }
    }];
    
    //** if nothing is found grab the first object
    if (nil == base && [baseURLs_ count] > 0) {
        id key = [[baseURLs_ allKeys] objectAtIndex:0];
        base = [NSString stringWithFormat: @"%@", [baseURLs_ objectForKey:key]];
    }
    
    return base;
}


@end
