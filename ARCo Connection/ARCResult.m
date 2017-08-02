//
//  CKResult.m
//  CoreKit
//
//  Created by Matt Newberry on 7/18/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//

#import "ARCResult.h"
#import "ARCStoreRecord.h"

#import "ARCRouterMap.h"
#import "ARCRegistryProcessor.h"
#import "NSDictionary+Additions.h"



@implementation ARCResult

@synthesize objects = _objects,
            error = _error,
            httpResponse = _httpResponse,
            request = request_,
            response = response_;



+ (ARCResult *)resultWithRequest:(ARCRequestor *)request andResponse:(id)response {

    return [[self alloc] initWithRequest:request response:response httpResponse:nil error:nil];
}

+ (ARCResult *)resultWithRequest:(ARCRequestor *)request response:(id)response httpResponse:(NSHTTPURLResponse *)httpResponse {
    
    return [[self alloc] initWithRequest:request response:response httpResponse:httpResponse error:nil];
}

+ (ARCResult *)resultWithRequest:(ARCRequestor *)request andError:(NSError **) error {
 
    return [[self alloc] initWithRequest:request response:nil httpResponse:nil error:error];
}

- (id)initWithRequest:(ARCRequestor *)request response:(id)response httpResponse:(NSHTTPURLResponse *)httpResponse error:(NSError **) error {
    
    if(self = [super init]) {
        
        //** Order is significant...
        self.request = request;
        self.httpResponse = httpResponse;
        self.response = response;
        
        if(error != nil) {
            self.error = *error;
        }
        
        if ([response isKindOfClass:[NSData class]] && [response length] == 0) {
            self.objects = [NSArray array];
        } else if (response != nil && [response isKindOfClass:[NSArray class]] && [[response objectAtIndex:0] isKindOfClass:[NSManagedObject class]]) {
            self.objects = response;
        } else {
            
            //NSDictionary *dictionary = [httpResponse allHeaderFields];
            //NSLog([dictionary description]);
            
            NSError* error = nil;                
            id<ARCProcessor> processor = [[ARCRegistryProcessor sharedProcessor] processorForMIMEType:httpResponse.MIMEType];
            
            if (processor != nil) {
                id parsed = [processor deserialize:response error:&error];
                
                if([request_.routerMap.responseKeyPath length] > 0 && [parsed isKindOfClass:[NSDictionary class]])        
                    parsed = [parsed objectForKeyPath:request_.routerMap.responseKeyPath];
                
                //Class model = request_.routerMap.model;
                
                self.objects = parsed;
                
            } else {
                //** error couldn't match mime to parser... 
            }
           
        }
    }
    
    return self;
}

- (id) initWithObjects:(NSArray *) objects {
    return [self initWithRequest:nil response:objects httpResponse:nil error:nil];
}

- (id) object {
	return _objects != nil && [_objects count] > 0 ? _objects : nil;
}


- (NSString*)contentType {
	return ([[response_ allHeaderFields] objectForKey:@"Content-Type"]);
}

- (NSString*)contentLength {
	return ([[response_ allHeaderFields] objectForKey:@"Content-Length"]);
}

- (BOOL)isHTML {
	NSString* contentType = [self contentType];
	return (contentType && ([contentType rangeOfString:@"text/html"
											   options:NSCaseInsensitiveSearch|NSAnchoredSearch].length > 0 ||
                            [self isXHTML]));
}

- (BOOL)isXHTML {
	NSString* contentType = [self contentType];
	return (contentType &&
			[contentType rangeOfString:@"application/xhtml+xml"
							   options:NSCaseInsensitiveSearch|NSAnchoredSearch].length > 0);
}

- (BOOL)isXML {
	NSString* contentType = [self contentType];
	return (contentType &&
			[contentType rangeOfString:@"application/xml"
							   options:NSCaseInsensitiveSearch|NSAnchoredSearch].length > 0);
}

- (BOOL)isJSON {
	NSString* contentType = [self contentType];
	return (contentType &&
			[contentType rangeOfString:@"application/json"
							   options:NSCaseInsensitiveSearch|NSAnchoredSearch].length > 0);
}


@end
