
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

#import <Foundation/Foundation.h>

#import "ARCResult.h"
#import "ARCProcessor.h"
#import "ARCConnection.h"


@class ARCRouterMap;


typedef void (^ARCResultBlock) (ARCResult *result);
typedef void (^ARCParseBlock) (id object);
typedef id (^ARCFormatBlock) (id object);
typedef id (^ARCProgressBlock) (float progress);



/**
 * HTTP methods for requests
 */
typedef enum ARCRequestMethod {
    ARCRequestMethodGET = 0,
    ARCRequestMethodPOST,
    ARCRequestMethodPUT,
    ARCRequestMethodDELETE,
    ARCRequestMethodHEAD,
    ARCRequestMethodALL
} ARCRequestMethod;



@interface ARCRequestor : NSObject
{
    ARCRouterMap*           routerMap_;
        
    ARCRequestMethod        method_;
    NSString*               remotePath_;
    NSString*               remoteKey_;
    
    NSMutableDictionary*    parameters_;
    NSMutableDictionary*    headers_;
    
	NSMutableData*          body_;
    
    NSUInteger              connectionTimeout_;
    
    id<ARCConnection>       connection_;
    id<ARCProcessor>        parser_;
    
    ARCResultBlock          completionBlock_;
    ARCResultBlock          errorsBlock_;
    ARCParseBlock           parseBlock_;
    ARCProgressBlock        progressBlock_;
    
    BOOL                    completed_;
}


/**
 * The HTTP body as a NSData used for this request
 */ 
@property (strong) NSData* body;

@property (nonatomic, assign) BOOL completed;

@property (nonatomic, readwrite, strong) ARCRouterMap *routerMap;


/**
 * The HTTP verb the request is sent via
 */
@property(nonatomic, assign) ARCRequestMethod method;

@property (nonatomic, strong) NSString* remotePath;
@property (nonatomic, strong) NSString* remoteKey;

@property (nonatomic, assign) NSUInteger connectionTimeout;

@property(nonatomic, strong) NSMutableDictionary* headers;
@property(nonatomic, readwrite, strong) NSMutableDictionary* parameters;

@property (nonatomic, strong) id connection;
@property (nonatomic, strong) id parser;

@property (nonatomic, copy) ARCResultBlock completionBlock;
@property (nonatomic, copy) ARCResultBlock errorsBlock;
@property (nonatomic, copy) ARCParseBlock parseBlock;
@property (nonatomic, copy) ARCProgressBlock progressBlock;


+ (ARCRequestor*)request;
+ (ARCRequestor*)requestWithRemotePath:(NSString *)remotePath;
+ (ARCRequestor*)requestWithRemotePathAndBaseUrlKey:(NSString *)remotePath key:(NSString*)key;

+ (ARCRequestor*)requestWithMap:(ARCRouterMap *)map;
+ (ARCRequestor*)requestWithMap:(ARCRouterMap *)map withKey:(NSString*)key;

- (void)send;
- (ARCResult*)sendSyncronous;

- (NSURL*)remoteBaseForKey:(NSString*)key;
- (NSMutableURLRequest *)remoteRequest;
- (NSMutableURLRequest *)remoteRequestWithKey:(NSString*)key;

- (NSString*)methodString;

- (void)addParameters:(NSDictionary *)data;
- (void)addHeaders:(NSDictionary *)data;
- (NSString*)bodyString:(NSData*)data;



@end


