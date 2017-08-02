//
//  ARCProcessXML.m
//  CoreDog
//
//  Created by GREGORY GENTLING on 8/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCProcessXML.h"

#import "XMLDictionary.h"
#import "NSStack.h"


@implementation ARCProcessXML



- (NSDictionary*)deserialize:(NSData*)object error:(NSError **)error {
        
    NSDictionary *xmlDictionary = [NSDictionary dictionaryWithXMLData:object]; 
	if ([xmlDictionary count] <= 0) {
        //if (error) *error = [[parser errorTrace] lastObject];
	}
	
	return xmlDictionary;
}

- (NSString*)serialize:(id)object error:(NSError **)error {
    /*--------------------------------------------------------------
	 * object is in dictionary format already...
	 *-------------------------------------------------------------*/
	NSString* xml = [object newXMLString];
    
	return xml;
}

@end
