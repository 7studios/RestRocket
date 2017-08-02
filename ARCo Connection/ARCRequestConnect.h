
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
#import "ARCConnection.h"
#import "ARCRequestor.h"


@interface ARCRequestConnect : NSObject <ARCConnection> {
    
    NSHTTPURLResponse*  response_;
    
    NSUInteger          responseCode_;
    NSMutableData*      responseData_;
	ARCRequestor*       request_;
    NSURLConnection*    connection_;
    NSDictionary*       responseHeaders_;
    
    ARCResult*          result_;
    
}

@property (nonatomic, assign) NSUInteger    responseCode;

@property(nonatomic, strong) NSHTTPURLResponse* response;
@property (nonatomic, strong) NSMutableData*    responseData;
@property (nonatomic, strong) ARCRequestor*     request;

@property (nonatomic, strong) NSURLConnection*  connection;
@property (nonatomic, strong) NSDictionary*     responseHeaders;
@property (nonatomic, strong) ARCResult*        result;



- (BOOL)connectionVerified;

@end
