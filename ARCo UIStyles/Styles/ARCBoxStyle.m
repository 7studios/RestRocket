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

#import "ARCBoxStyle.h"

// Style
#import "ARCStyleContext.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ARCBoxStyle

@synthesize margin    = _margin;
@synthesize padding   = _padding;
@synthesize minSize   = _minSize;
@synthesize position  = _position;



- (id)initWithNext:(ARCStyle*)next {
	self = [super initWithNext:next];
  if (self) {
    _margin = UIEdgeInsetsZero;
    _padding = UIEdgeInsetsZero;
    _minSize = CGSizeZero;
    _position = ARCPositionStatic;
  }

  return self;
}



#pragma mark -
#pragma mark Class public

+ (ARCBoxStyle*)styleWithMargin:(UIEdgeInsets)margin next:(ARCStyle*)next {
  ARCBoxStyle* style = [[self alloc] initWithNext:next];
  style.margin = margin;
  return style;
}


+ (ARCBoxStyle*)styleWithPadding:(UIEdgeInsets)padding next:(ARCStyle*)next {
  ARCBoxStyle* style = [[self alloc] initWithNext:next];
  style.padding = padding;
  return style;
}


+ (ARCBoxStyle*)styleWithFloats:(ARCPosition)position next:(ARCStyle*)next {
  ARCBoxStyle* style = [[self alloc] initWithNext:next];
  style.position = position;
  return style;
}



+ (ARCBoxStyle*)styleWithMargin:(UIEdgeInsets)margin padding:(UIEdgeInsets)padding next:(ARCStyle*)next {
  ARCBoxStyle* style = [[self alloc] initWithNext:next];
  style.margin = margin;
  style.padding = padding;
  return style;
}



+ (ARCBoxStyle*)styleWithMargin:(UIEdgeInsets)margin padding:(UIEdgeInsets)padding
                       minSize:(CGSize)minSize position:(ARCPosition)position next:(ARCStyle*)next {
    
  ARCBoxStyle* style = [[self alloc] initWithNext:next];
  style.margin = margin;
  style.padding = padding;
  style.minSize = minSize;
  style.position = position;
  return style;
}


#pragma mark -
#pragma mark TTStyle


- (void)draw:(ARCStyleContext*)context {
  context.contentFrame = ARCRectInset(context.contentFrame, _padding);
  [self.next draw:context];
}



- (CGSize)addToSize:(CGSize)size context:(ARCStyleContext*)context {
  size.width += _padding.left + _padding.right;
  size.height += _padding.top + _padding.bottom;

  if (_next) {
    return [self.next addToSize:size context:context];

  } else {
    return size;
  }
}


@end
