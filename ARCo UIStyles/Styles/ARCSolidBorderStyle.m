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

#import "ARCSolidBorderStyle.h"

// Style
#import "ARCStyleContext.h"
#import "ARCShape.h"




///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ARCSolidBorderStyle

@synthesize color = _color,
            width = _width;



- (id)initWithNext:(ARCStyle*)next {
	self = [super initWithNext:next];
  if (self) {
    _width = 1;
  }

  return self;
}



#pragma mark -
#pragma mark Class public



+ (ARCSolidBorderStyle*)styleWithColor:(UIColor*)color width:(CGFloat)width next:(ARCStyle*)next {
    ARCSolidBorderStyle* style = [[self alloc] initWithNext:next];
    style.color = color;
    style.width = width;

    return style;
}


#pragma mark -
#pragma mark TTStyle

- (void)draw:(ARCStyleContext*)context {
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSaveGState(ctx);

  CGRect strokeRect = CGRectInset(context.frame, _width/2, _width/2);
  [context.shape addToPath:strokeRect];

  [_color setStroke];
  CGContextSetLineWidth(ctx, _width);
  CGContextStrokePath(ctx);

  CGContextRestoreGState(ctx);

  context.frame = CGRectInset(context.frame, _width, _width);
  return [self.next draw:context];
}


@end
