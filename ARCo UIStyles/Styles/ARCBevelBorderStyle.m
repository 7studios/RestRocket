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

#import "ARCBevelBorderStyle.h"

// Style
#import "ARCShape.h"
#import "ARCStyleContext.h"
#import "UIColor+Additions.h"

// Style (private)
#import "ARCStyleInternal.h"




///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ARCBevelBorderStyle

@synthesize highlight = _highlight,
            shadow = _shadow,
            width = _width,
            lightSource = _lightSource;



- (id)initWithNext:(ARCStyle*)next {
    self = [super initWithNext:next];
    if (self) {
        _width = 1;
        _lightSource = kDefaultLightSource;
    }

    return self;
}


#pragma mark -
#pragma mark Class public


+ (ARCBevelBorderStyle*)styleWithColor:(UIColor*)color width:(CGFloat)width next:(ARCStyle*)next {
  return [self styleWithHighlight:[color highlight] shadow:[color shadow] width:width
                      lightSource:kDefaultLightSource next:next];
}



+ (ARCBevelBorderStyle*)styleWithHighlight:(UIColor*)highlight
                                   shadow:(UIColor*)shadowColor
                                    width:(CGFloat)width
                              lightSource:(NSInteger)lightSource
                                     next:(ARCStyle*)next {
    
  ARCBevelBorderStyle* style = [[ARCBevelBorderStyle alloc] initWithNext:next];
  style.highlight = highlight;
  style.shadow = shadowColor;
  style.width = width;
  style.lightSource = lightSource;
  return style;
}



#pragma mark -
#pragma mark ARCStyle


- (void)draw:(ARCStyleContext*)context {
  CGRect strokeRect = CGRectInset(context.frame, _width/2, _width/2);
  [context.shape openPath:strokeRect];

  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSetLineWidth(ctx, _width);

  UIColor* topColor = _lightSource >= 0 && _lightSource <= 180 ? _highlight : _shadow;
  UIColor* leftColor = _lightSource >= 90 && _lightSource <= 270 ? _highlight : _shadow;
  UIColor* bottomColor = (_lightSource >= 180 && _lightSource <= 360) || _lightSource == 0 ? _highlight : _shadow;
  UIColor* rightColor = (_lightSource >= 270 && _lightSource <= 360) || (_lightSource >= 0 && _lightSource <= 90) ? _highlight : _shadow;

  CGRect rect = context.frame;

  [context.shape addTopEdgeToPath:strokeRect lightSource:_lightSource];
  if (topColor) {
    [topColor setStroke];

    rect.origin.y += _width;
    rect.size.height -= _width;

  } else {
    [[UIColor clearColor] setStroke];
  }
  CGContextStrokePath(ctx);

  [context.shape addRightEdgeToPath:strokeRect lightSource:_lightSource];
  if (rightColor) {
    [rightColor setStroke];

    rect.size.width -= _width;

  } else {
    [[UIColor clearColor] setStroke];
  }
  CGContextStrokePath(ctx);

  [context.shape addBottomEdgeToPath:strokeRect lightSource:_lightSource];
  if (bottomColor) {
    [bottomColor setStroke];

    rect.size.height -= _width;

  } else {
    [[UIColor clearColor] setStroke];
  }
  CGContextStrokePath(ctx);

  [context.shape addLeftEdgeToPath:strokeRect lightSource:_lightSource];
  if (leftColor) {
    [leftColor setStroke];

    rect.origin.x += _width;
    rect.size.width -= _width;

  } else {
    [[UIColor clearColor] setStroke];
  }
  CGContextStrokePath(ctx);

  CGContextRestoreGState(ctx);

  context.frame = rect;
  return [self.next draw:context];
}


@end
