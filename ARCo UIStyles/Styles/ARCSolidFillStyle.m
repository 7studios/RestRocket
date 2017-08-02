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

#import "ARCSolidFillStyle.h"

// Style
#import "ARCShape.h"
#import "ARCStyleContext.h"




///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ARCSolidFillStyle

@synthesize color = _color;


#pragma mark -
#pragma mark Class public

+ (ARCSolidFillStyle*)styleWithColor:(UIColor*)color next:(ARCStyle*)next {
  ARCSolidFillStyle* style = [[self alloc] initWithNext:next];
  style.color = color;
  return style;
}


#pragma mark -
#pragma mark TTStyle

- (void)draw:(ARCStyleContext*)context {
  CGContextRef ctx = UIGraphicsGetCurrentContext();

  CGContextSaveGState(ctx);
  [context.shape addToPath:context.frame];

  [_color setFill];
  CGContextFillPath(ctx);
  CGContextRestoreGState(ctx);

  return [self.next draw:context];
}


@end
