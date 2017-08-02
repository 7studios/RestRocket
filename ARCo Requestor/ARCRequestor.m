
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

#import "ARCRequestor.h"
#import "ARCRouterMap.h"
#import "ARCReachability.h"
#import "ARCRequestConnect.h"
#import "ARCConnectCoordinator.h"

//* Cateogries
#import "NSDate+Helper.h"
#import "NSString+Additions.h"
#import "NSDictionary+Additions.h"
#import "NSDictionary+ARCBlocks.h"



@interface ARCRequestor (Private)
- (BOOL)shouldSendParams;
- (id)connection;
@end


@implementation ARCRequestor

@synthesize routerMap = routerMap_,
            method = method_,
            parameters = parameters_,
            remotePath = remotePath_,
            remoteKey = remoteKey_,
            headers = headers_,
            body = body_,
            connectionTimeout = connectionTimeout_,

            connection = connection_,
            parser = parser_,
            completionBlock = completionBlock_,
            errorsBlock = errorsBlock_,
            parseBlock = parseBlock_,
            progressBlock = progressBlock_,
            completed = completed_;



- (id) initWithRouterMap:(ARCRouterMap *)map {
    
    if (self = [super init]) {
        headers_ = [[NSMutableDictionary alloc] init];
        parameters_ = [[NSMutableDictionary alloc] init];
                
        connectionTimeout_ = 60;
        routerMap_ = map;
    }
    
    return self;
}


- (id)initWithRouterMapAndBaseUrlKey:(ARCRouterMap *)map withKey:(NSString*)key {
    
    if (self = [self initWithRouterMap:map]) {
        remoteKey_  = key;
    }
    return self;
}



+ (ARCRequestor*)request {
    return [self requestWithMap:nil withKey:nil];
}

+ (ARCRequestor*)requestWithRemotePath:(NSString *)remotePath {
    ARCRouterMap *map = [ARCRouterMap mapWithRemotePath:remotePath];
    return [self requestWithMap:map withKey:nil];
}

+ (ARCRequestor*)requestWithRemotePathAndBaseUrlKey:(NSString *)remotePath key:(NSString*)key {
    ARCRouterMap *map = [ARCRouterMap mapWithRemotePath:remotePath];
    return [self requestWithMap:map withKey:key];
}

+ (ARCRequestor*)requestWithMap:(ARCRouterMap *)map {
    return [[self alloc] initWithRouterMap:map];
}

+ (ARCRequestor*)requestWithMap:(ARCRouterMap *)map withKey:(NSString*)key {
    return [[self alloc] initWithRouterMapAndBaseUrlKey:map withKey:key];
}


- (id)connection {
    return connection_ == nil ? (connection_ = [[ARCRequestConnect alloc] init]) : connection_;
}


- (void)send {
    if ([self connection] != nil) {
        [[ARCConnectCoordinator sharedCoordinator] sendRequest:self];
    }
}


- (ARCResult*)sendSyncronous {
    if ([self connection] != nil) {
        return [connection_ sendSyncronously:self];
    }
    return nil;
}


- (void) addHeaders:(NSDictionary *)data {
    [headers_ addEntriesFromDictionary:data];
}

- (void) addParameters:(NSDictionary *)data {
    [parameters_ addEntriesFromDictionary:data];
}

- (void)setRouterMap:(ARCRouterMap *)routerMap {
    
    routerMap_ = routerMap;
    
    self.remotePath = routerMap_.remotePath;
    self.method = routerMap_.requestMethod;
}



- (NSURL*)remoteBaseForKey:(NSString*)key {
    NSString* baseUrl = [[ARCConnectCoordinator sharedCoordinator] baseURLForKey:key];
    
    if ([parameters_ count] > 0 && ![baseUrl isEmpty]) {        
        [baseUrl AppendQueryParams:baseUrl queryParams:parameters_];
        
        NSMutableString *output = [NSMutableString stringWithString:baseUrl];
        [output appendString:[@"" stringByAddingQueryDictionary:parameters_]]; 
        
        return [NSURL URLWithString:output];
    }
    
    return [NSURL URLWithString:baseUrl];
}


- (NSMutableURLRequest *)remoteRequest {
    return [self remoteRequestWithKey:remoteKey_];
}


- (NSMutableURLRequest *)remoteRequestWithKey:(NSString*)key {
     
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[self remoteBaseForKey:key]];
    [urlRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	
	[urlRequest setHTTPMethod:[self methodString]];
	[urlRequest setAllHTTPHeaderFields:headers_];

    [self setBody:body_];
    
    if ([self shouldSendParams]) {
         NSString *postLength = [NSString stringWithFormat:@"%d", [[self body] length]];
        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    } else {
        [urlRequest setValue:@"0" forHTTPHeaderField:@"Content-Length"];
    }
    //[urlRequest setHTTPBody:[self body]];
    //[urlRequest setValue:@"User-Agent" forHTTPHeaderField:@"ARCo Request"]; //*** Causes text/html to come back from server...
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    return urlRequest;
}


- (NSString*)methodString {
    
	switch (method_) {
            
		case ARCRequestMethodPOST:
			return @"POST";
			break;
		case ARCRequestMethodPUT:
			return @"PUT";
			break;
		case ARCRequestMethodDELETE:
			return @"DELETE";
			break;
        case ARCRequestMethodHEAD:
			return @"HEAD";
			break;
            
        case ARCRequestMethodGET:
		default:
			return @"GET";
			break;
	}
}


- (BOOL)shouldSendParams {
    return ([parameters_ count] && (method_ != ARCRequestMethodGET && method_ != ARCRequestMethodHEAD));
}


- (NSString*)bodyString:(NSData*)data {
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}




/*
+ (id)request:(NSString *)requestUrl requestMethod:(ARCRequestMethod)method 
  queryparams:(NSMutableDictionary*)params 
     postdata:(NSData*)data
completeBlock:(completeBlock_t)completeBlock
responseBlock:(responseBlock_t)responseBlock
progressBlock:(progressBlock_t)progressBlock
   errorBlock:(errorBlock_t)errorBlock
{    
    return[[self alloc] initWithRequest:requestUrl requestMethod:method queryparams:params postdata:data completeBlock:completeBlock responseBlock:responseBlock progressBlock:progressBlock errorBlock:errorBlock];
}

- (id)initWithRequest:(NSString *)requestUrl requestMethod:(ARCRequestMethod)method 
          queryparams:(NSMutableDictionary*)params
             postdata:(NSData*)data 
        completeBlock:(completeBlock_t)completeBlock
        responseBlock:(responseBlock_t)responseBlock
        progressBlock:(progressBlock_t)progressBlock
           errorBlock:(errorBlock_t)errorBlock
{    
    parameters_ = params;
    method_ = method;
    
	NSURL *url = [NSURL URLWithString:requestUrl];
    
    if ([self shouldSendParams]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", requestUrl, [parameters_ URLEncodedStringFromDict]]];
        [self setBody:data];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [[self body] length]];
                
        [URLRequest_ setHTTPMethod:[self methodString]];
        [URLRequest_ setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [URLRequest_ setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [URLRequest_ setHTTPBody:[self body]];
    }
    
    [URLRequest_ setValue:@"User-Agent" forHTTPHeaderField:@"ARCo Request"];
    URLRequest_ = [NSMutableURLRequest requestWithURL:url];
    
	if ((self = [super initWithRequest:URLRequest_ delegate:self startImmediately:NO])) {
		body_ = [[NSMutableData alloc] init];
        
        completeBlock_ = [completeBlock copy];
		responseBlock_ = [responseBlock copy];
        errorBlock_ = [errorBlock copy];
		progressBlock_ = [progressBlock copy];
        
		[self start];
	}
    
	return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    responseBlock_(URLResponse_ = response);

	[body_ setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[body_ appendData:data];
    
    if (URLResponse_ != nil && [URLResponse_ expectedContentLength] != NSURLResponseUnknownLength) {
        progressBlock_((float)[body_ length]/(float)[URLResponse_ expectedContentLength]);
    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    progressBlock_(totalBytesWritten/totalBytesExpectedToWrite);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	completeBlock_(body_, URLResponse_);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	errorBlock_(error);
}


- (BOOL)shouldSendParams {
    return ([parameters_ count] && (method_ != ARCRequestMethodGET && method_ != ARCRequestMethodHEAD));
}

*/






@end