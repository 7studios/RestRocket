//
//  ARCProcessNJSON.m
//  CoreDog
//
//  Created by GREGORY GENTLING on 8/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCProcessNJSON.h"
#import "NSString+Additions.h"


@implementation ARCProcessNJSON


- (NSDictionary*)deserialize:(NSData*)object error:(NSError **)error {
    
    NSError *err = nil;
    
    id value = [NSJSONSerialization JSONObjectWithData:object options:NSJSONReadingAllowFragments error:&err];
    if(err)
        NSLog(@"%@", [err localizedFailureReason]);
    
    return value;
}


- (NSString*)serialize:(id)object error:(NSError **)error {
    NSData *value = nil;
    
    if([NSJSONSerialization isValidJSONObject:object]){
        
        NSError *error = nil;
        value = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
        
        if(error)
            NSLog(@"%@", [error localizedFailureReason]);
    }
    
    return [NSString bodyAsString:value];
}



@end
