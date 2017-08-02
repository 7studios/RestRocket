//
//  NSObject+ARCField_Validation.m
//  CoreDog
//
//  Created by GREGORY GENTLING on 9/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCControl+Validation.h"

@implementation UIControl (Validation)


- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:email];
}

- (NSMutableArray*)validateEmailWith:(NSString*)emails
{
    NSMutableArray *validEmails = [[NSMutableArray alloc] init];
    NSArray *emailArray = [emails componentsSeparatedByString:@","];
    for (NSString *email in emailArray)
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
        if ([emailTest evaluateWithObject:email])
            [validEmails addObject:email];
    }
    return validEmails;
}


@end
