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

#import "ARCFourBorderStyle.h"

// Style
#import "ARCShape.h"
#import "ARCStyleContext.h"

// Style (private)
#import "ARCStyleInternal.h"



///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ARCFourBorderStyle

@synthesize top     = _top,
            right   = _right,
            bottom  = _bottom,
            left    = _left,
            width   = _width;



- (id)initWithNext:(ARCStyle*)next {
	self = [super initWithNext:next];
  if (self) {
    _width = 1;
  }

  return self;
}



#pragma mark -
#pragma mark Class public

+ (ARCFourBorderStyle*)styleWithTop:(UIColor*)top right:(UIColor*)right bottom:(UIColor*)bottom left:(UIColor*)left width:(CGFloat)width next:(ARCStyle*)next {
  ARCFourBorderStyle* style = [[self alloc] initWithNext:next];
  style.top = top;
  style.right = right;
  style.bottom = bottom;
  style.left = left;
  style.width = width;
  return style;
}


+ (ARCFourBorderStyle*)styleWithTop:(UIColor*)top width:(CGFloat)width next:(ARCStyle*)next {
  ARCFourBorderStyle* style = [[self alloc] initWithNext:next];
  style.top = top;
  style.width = width;
  return style;
}


+ (ARCFourBorderStyle*)styleWithRight:(UIColor*)right width:(CGFloat)width next:(ARCStyle*)next {
  ARCFourBorderStyle* style = [[self alloc] initWithNext:next];
  style.right = right;
  style.width = width;
  return style;
}


+ (ARCFourBorderStyle*)styleWithBottom:(UIColor*)bottom width:(CGFloat)width next:(ARCStyle*)next {
  ARCFourBorderStyle* style = [[self alloc] initWithNext:next];
  style.bottom = bottom;
  style.width = width;
  return style;
}


+ (ARCFourBorderStyle*)styleWithLeft:(UIColor*)left width:(CGFloat)width next:(ARCStyle*)next {
  ARCFourBorderStyle* style = [[self alloc] initWithNext:next];
  style.left = left;
  style.width = width;
  return style;
}


#pragma mark -
#pragma mark TTStyle

- (void)draw:(ARCStyleContext*)context {
  CGRect rect = context.frame;
  UIEdgeInsets insets = UIEdgeInsetsMake(_top ? _width/2. : 0,
                                         _left ? _width/2 : 0,
                                         _bottom ? _width/2 : 0,
                                         _right ? _width/2 : 0);
  CGRect strokeRect = ARCRectInset(rect, insets);
  [context.shape openPath:strokeRect];

  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSetLineWidth(ctx, _width);

  [context.shape addTopEdgeToPath:strokeRect lightSource:kDefaultLightSource];
  if (_top) {
    [_top setStroke];

  } else {
    [[UIColor clearColor] setStroke];
  }
  CGContextStrokePath(ctx);

  [context.shape addRightEdgeToPath:strokeRect lightSource:kDefaultLightSource];
  if (_right) {
    [_right setStroke];

  } else {
    [[UIColor clearColor] setStroke];
  }
  CGContextStrokePath(ctx);

  [context.shape addBottomEdgeToPath:strokeRect lightSource:kDefaultLightSource];
  if (_bottom) {
    [_bottom setStroke];

  } else {
    [[UIColor clearColor] setStroke];
  }
  CGContextStrokePath(ctx);

  [context.shape addLeftEdgeToPath:strokeRect lightSource:kDefaultLightSource];
  if (_left) {
    [_left setStroke];

  } else {
    [[UIColor clearColor] setStroke];
  }
  CGContextStrokePath(ctx);

  CGContextRestoreGState(ctx);

  context.frame = CGRectMake(rect.origin.x + (_left ? _width : 0),
                             rect.origin.y + (_top ? _width : 0),
                             rect.size.width - ((_left ? _width : 0) + (_right ? _width : 0)),
                             rect.size.height - ((_top ? _width : 0) + (_bottom ? _width : 0)));
  return [self.next draw:context];
}


@end
