
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

#import "ARCRequestConnect.h"
#import "ARCResult.h"
#import "ARCRequestor.h"

#import "ARCReachability.h"
#import "ARCProcessor.h"
#import "ARCRegistryProcessor.h"

//* Cateogries
#import "NSString+Additions.h"
#import "NSDictionary+Additions.h"


@implementation ARCRequestConnect


@synthesize responseCode = responseCode_,
            responseData = responseData_,
            request = request_,
            connection = connection_,
            responseHeaders = responseHeaders_,
            response = response_,
            result = result_;


- (id)init {
    if (self = [super init]) {
        responseData_ = [[NSMutableData alloc] init];
    }
    
    return self;
}


- (BOOL)connectionVerified { 
    return [[ARCReachability reachabilityForInternetConnection] networkStatus] != ARCReachabilityNotReachable;
}


- (void)send:(ARCRequestor*)request {
    self.request = request;
    
    if(![self connectionVerified]) {
		return;
    }
    
    NSURLRequest* r = [request remoteRequest];    
    connection_ = [[NSURLConnection	alloc] initWithRequest:r delegate:self];
    self.request.connection = connection_;
    
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:request.connectionTimeout]];
    } while ((self.request != nil) && !self.request.completed);

}


- (ARCResult *)sendSyncronously:(ARCRequestor *)request {
	
    NSHTTPURLResponse *httpResponse = nil;
	NSError *error = nil;
    self.request = request;
    
	if(![self connectionVerified]) {
		return [ARCResult resultWithRequest:request andResponse:nil];	
    }
    
	NSData *response = [NSURLConnection sendSynchronousRequest:[request_ remoteRequest] returningResponse:&httpResponse error:&error];
    
	responseCode_ = [httpResponse statusCode];
    self.responseHeaders = [httpResponse allHeaderFields];
    
	return [[ARCResult alloc] initWithRequest:request_ response:response httpResponse:httpResponse error:&error];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
	
	responseCode_ = [response statusCode];
    response_ = response;
    
    [responseData_ setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
	[responseData_ appendData:data];
    
    if (request_.progressBlock != nil) {
        if (response_ != nil && [response_ expectedContentLength] != NSURLResponseUnknownLength) {            
            request_.progressBlock([data length]/[response_ expectedContentLength]);
        }
    }
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    request_.completed = YES;
    
    result_ = [ARCResult resultWithRequest:request_ response:responseData_ httpResponse:response_];
    
	if (request_.completionBlock != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            request_.completionBlock(result_);	
        });
    }
}


- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    request_.progressBlock(totalBytesWritten/totalBytesExpectedToWrite);
}


- (void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    //[[challenge sender] useCredential:[_request credentials] forAuthenticationChallenge:challenge];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	request_.completed = YES;
	
    result_ = [ARCResult resultWithRequest:request_ andError:&error];
    
	if(request_.errorsBlock != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            request_.errorsBlock(result_);
        });
    }
}


@end
