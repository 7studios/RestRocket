//
//  ARCProcessSBJSON.m
//  CoreDog
//
//  Created by GREGORY GENTLING on 8/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCProcessSBJSON.h"

#import "SBJsonParser.h"
#import "SBJsonWriter.h"



@implementation ARCProcessSBJSON


- (NSDictionary*)deserialize:(NSData*)object error:(NSError **)error {
	SBJsonParser* parser = [[SBJsonParser alloc] init];
    
    NSString* string = [[NSString alloc] initWithData:object encoding:NSASCIIStringEncoding];
    
	id result = [parser objectWithString:string];
	if (nil == result) {
        if (error) *error = [[parser errorTrace] lastObject];
	}
	
	return result;
}


- (NSString*)serialize:(id)object error:(NSError **)error {
    SBJsonWriter *jsonWriter = [SBJsonWriter new];    
    NSString *json = [jsonWriter stringWithObject:object];
    if (!json) {
        if (error) *error = [[jsonWriter errorTrace] lastObject];
    }
    
    return json;
}



@end
