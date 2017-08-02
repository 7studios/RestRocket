//
//  ARCURLArguments.m
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCURLArguments.h"
#import <objc/runtime.h>


///////////////////////////////////////////////////////////////////////////////////////////////////
ARCURLArgumentType ConvertArgumentType(char argType) {
    if (argType == 'c'
        || argType == 'i'
        || argType == 's'
        || argType == 'l'
        || argType == 'C'
        || argType == 'I'
        || argType == 'S'
        || argType == 'L') {
        return ARCURLArgumentTypeInteger;
        
    } else if (argType == 'q' || argType == 'Q') {
        return ARCURLArgumentTypeLongLong;
        
    } else if (argType == 'f') {
        return ARCURLArgumentTypeFloat;
        
    } else if (argType == 'd') {
        return ARCURLArgumentTypeDouble;
        
    } else if (argType == 'B') {
        return ARCURLArgumentTypeBool;
        
    } else {
        return ARCURLArgumentTypePointer;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
ARCURLArgumentType URLArgumentTypeForProperty(Class cls, NSString* propertyName) {
    objc_property_t prop = class_getProperty(cls, propertyName.UTF8String);
    if (prop) {
        const char* type = property_getAttributes(prop);
        return ConvertArgumentType(type[1]);
        
    } else {
        return ARCURLArgumentTypeNone;
    }
}

