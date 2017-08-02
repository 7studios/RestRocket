
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


#import "ARCProcessor.h"

/**
 MIME Type Constants
 */
extern NSString* const ARCMIMETypeJSON;
extern NSString* const ARCMIMETypeFormURLEncoded;
extern NSString* const ARCMIMETypeXML;
extern NSString* const ARCMIMETypeHTML;



@interface ARCRegistryProcessor : NSObject {

    NSMutableDictionary*    MIMETypeToProcess_;
    
}

/** Returns the ARCRegistryProcessor singleton which is automatically created */
+ (ARCRegistryProcessor*) sharedProcessor;

- (id)initProcessor;


/**
 Instantiate and return a ARCProcessor for the given MIME Type
 */
- (id<ARCProcessor>)processorForMIMEType:(NSString*)MIMEType;


/**
 Return the class registered for handling parser/encoder operations
 for a given MIME Type
 */
- (Class<ARCProcessor>)processorClassForMIMEType:(NSString*)MIMEType;


/**
 Registers an ARCProcessor conformant class as the handler for the specified MIME Type
 */
- (void)setProcessorClass:(Class<ARCProcessor>)processorClass forMIMEType:(NSString*)MIMEType;


- (void)autoRegister;

@end
