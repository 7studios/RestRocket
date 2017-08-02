//
//  CKResult.h
//  CoreKit
//
//  Created by Matt Newberry on 7/18/11.
//  Copyright 2011 MNDCreative, LLC. All rights reserved.
//


@class ARCRequestor;


/** Standard interface to handle HTTP responses and local CoreData fetch requests */

@interface ARCResult : NSObject {
    
    NSDictionary*       _objects;
	NSError*            _error;
	NSHTTPURLResponse*  _httpResponse;
    
    id                  response_;
    ARCRequestor*       request_;
    
}

@property (nonatomic, strong) NSDictionary *objects;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSHTTPURLResponse *httpResponse;

@property (nonatomic, strong) ARCRequestor *request;
@property (nonatomic, strong) id response;


+ (ARCResult *)resultWithRequest:(ARCRequestor *)request andResponse:(id)response;

+ (ARCResult *)resultWithRequest:(ARCRequestor *)request response:(id)response httpResponse:(NSHTTPURLResponse *)httpResponse;
+ (ARCResult *)resultWithRequest:(ARCRequestor *)request andError:(NSError **) error;


- (id) initWithRequest:(ARCRequestor *)request response:(id)response httpResponse:(NSHTTPURLResponse *)httpResponse error:(NSError **) error; 
- (id) initWithObjects:(NSArray *) objects; 
- (id) object;


/**
 * Returns the value of 'Content-Type' HTTP header
 */
- (NSString*)contentType;

/**
 * Returns the value of the 'Content-Length' HTTP header
 */
- (NSString*)contentLength;

/**
 * True when the server turned an HTML response (MIME type is text/html)
 */
- (BOOL)isHTML;

/**
 * True when the server turned an XHTML response (MIME type is application/xhtml+xml)
 */
- (BOOL)isXHTML;

/**
 * True when the server turned an XML response (MIME type is application/xml)
 */
- (BOOL)isXML;

/**
 * True when the server turned an JSON response (MIME type is application/json)
 */
- (BOOL)isJSON;


@end
