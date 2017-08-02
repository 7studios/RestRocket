
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

/*
 * Usage:   id<ARCProcessor> processor = [[ARCRegistryProcessor sharedInstance] processorForMIMEType:response.MIMEType];
 *          id result = [processor objectFromString:[NSString bodyAsString:data] error:&error];
 */


#import "ARCRegistryProcessor.h"


/**
 MIME Type Default Constants
 */
NSString* const ARCMIMETypeJSON = @"application/json";
NSString* const ARCMIMETypeFormURLEncoded = @"application/x-www-form-urlencoded";
NSString* const ARCMIMETypeXML = @"application/xml";
NSString* const ARCMIMETypeHTML = @"text/html";


@implementation ARCRegistryProcessor


+ (ARCRegistryProcessor *) sharedProcessor {

    static dispatch_once_t predicate_reg;
    static ARCRegistryProcessor *_shared = nil;
    
    dispatch_once(&predicate_reg, ^{
        _shared = [[self alloc] initProcessor];
    });
    
    return _shared;
}



- (id)initProcessor {
    if (self = [super init]) {        
        MIMETypeToProcess_ = [[NSMutableDictionary alloc] init];
        
        [self autoRegister];
    }
    
    return self;
}



- (Class<ARCProcessor>)processorClassForMIMEType:(NSString*)MIMEType {
    return [MIMETypeToProcess_ objectForKey:MIMEType];
}


- (id<ARCProcessor>)processorForMIMEType:(NSString*)MIMEType {
    Class processorClass = [self processorClassForMIMEType:MIMEType];
    if (processorClass) {
        return [[processorClass alloc] init];
    }
    
    return nil;
}


- (void)setProcessorClass:(Class<ARCProcessor>)processorClass forMIMEType:(NSString*)MIMEType {
    [MIMETypeToProcess_ setObject:processorClass forKey:MIMEType];
}


- (void)autoRegister {
    Class processorClass = nil;
    
    // XML
    processorClass = NSClassFromString(@"ARCProcessXML");
    if (processorClass) {
        [self setProcessorClass:processorClass forMIMEType:ARCMIMETypeXML];
    }
    
    // JSON
    processorClass = NSClassFromString(@"ARCProcessSBJSON");
    if (processorClass) {
        [self setProcessorClass:processorClass forMIMEType:ARCMIMETypeJSON];
    }
    
    // TEXT/HTML -> error out html resource page
    processorClass = NSClassFromString(@"ARCProcessHTML");
    if (processorClass) {
        [self setProcessorClass:processorClass forMIMEType:ARCMIMETypeHTML];
    }
}


@end
