//
//  ARCURLArguments.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCPatternTEXT.h"

ARCURLArgumentType ConvertArgumentType(char argType);
ARCURLArgumentType URLArgumentTypeForProperty(Class cls, NSString* propertyName);

