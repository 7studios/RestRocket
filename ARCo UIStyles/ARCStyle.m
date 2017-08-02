//
// Copyright 2009-2011 Facebook
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

#import "ARCStyle.h"
#import "ARCPartStyle.h"





@implementation ARCStyle

@synthesize next = _next;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNext:(ARCStyle*)next {
	self = [super init];
  if (self) {
    _next = next;
  }

  return self;
}



- (id)init {
	self = [self initWithNext:nil];
  if (self) {
  }

  return self;
}




#pragma mark -
#pragma mark Public


- (ARCStyle*)next:(ARCStyle*)next {
  self.next = next;
  return self;
}


- (void)draw:(ARCStyleContext*)context {
  [self.next draw:context];
}


- (UIEdgeInsets)addToInsets:(UIEdgeInsets)insets forSize:(CGSize)size {
  if (self.next) {
    return [self.next addToInsets:insets forSize:size];

  } else {
    return insets;
  }
}


- (CGSize)addToSize:(CGSize)size context:(ARCStyleContext*)context {
  if (_next) {
    return [self.next addToSize:size context:context];

  } else {
    return size;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addStyle:(ARCStyle*)style {
  if (_next) {
    [_next addStyle:style];

  } else {
    _next = style;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)firstStyleOfClass:(Class)cls {
  if ([self isKindOfClass:cls]) {
    return self;

  } else {
    return [self.next firstStyleOfClass:cls];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)styleForPart:(NSString*)name {
  ARCStyle* style = self;
  while (style) {
    if ([style isKindOfClass:[ARCPartStyle class]]) {
      ARCPartStyle* partStyle = (ARCPartStyle*)style;
      if ([partStyle.name isEqualToString:name]) {
        return partStyle;
      }
    }
    style = style.next;
  }
  return nil;
}


@end
