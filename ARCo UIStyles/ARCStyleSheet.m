
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


#import "ARCStyleSheet.h"

// Style
#import "ARCDefaultStyleSheet.h"

#import <objc/message.h>



///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ARCStyleSheet


#pragma mark -
#pragma mark Class public

+ (ARCStyleSheet *) sharedStyleSheet {
    return [ARCStyleSheet sharedStyleSheet:nil];
}


+ (ARCStyleSheet *) sharedStyleSheet:(ARCStyleSheet*)styleSheet {
    
    static dispatch_once_t predicate;
    static ARCStyleSheet *_shared = nil;
    
    dispatch_once(&predicate, ^{
        if (styleSheet != nil) {
            _shared = styleSheet;
        } else {
            _shared = [[ARCDefaultStyleSheet alloc] init];
        }
        
    });
    
    return _shared;
}



- (id)init {
	self = [super init];
  if (self) {
    [[NSNotificationCenter defaultCenter]
     addObserver: self
        selector: @selector(didReceiveMemoryWarning:)
            name: UIApplicationDidReceiveMemoryWarningNotification
          object: nil];
  }

  return self;
}



- (void)dealloc {
  [[NSNotificationCenter defaultCenter]
   removeObserver: self
             name: UIApplicationDidReceiveMemoryWarningNotification
           object: nil];
}


#pragma mark -
#pragma mark NSNotifications

- (void)didReceiveMemoryWarning:(void*)object {
  [self freeMemory];
}


#pragma mark -
#pragma mark Public

- (ARCStyle*)styleWithSelector:(NSString*)selector {
  return [self styleWithSelector:selector forState:UIControlStateNormal];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (ARCStyle*)styleWithSelector:(NSString*)selector forState:(UIControlState)state {
  
    NSString* key = state == UIControlStateNormal ? selector : [NSString stringWithFormat:@"%@%d", selector, state];
    
    ARCStyle* style = [styles_ objectForKey:key];
    if (!style) {
        SEL sel = NSSelectorFromString(selector);
        if ([self respondsToSelector:sel]) {
            //style = [self performSelector:sel withObject:state];
            
            style = objc_msgSend(self, sel, state);
            
            if (style) {
                if (!styles_) {
                    styles_ = [[NSMutableDictionary alloc] init];
                }
                [styles_ setObject:style forKey:key];
            }
        }
    }
    return style;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)freeMemory {
}


@end
