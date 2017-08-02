//
//  ARCPatternLiteral.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCPatternTEXT.h"


@interface ARCURLLiteral : NSObject <ARCPatternTEXT> {
    
    NSString*   name;
    
}

@property (nonatomic, copy) NSString *name;

@end
