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

#import "ARCTextStyle.h"

// Style
#import "ARCStyleContext.h"
#import "ARCStyleDelegate.h"
#import "UIFont+Addition.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ARCTextStyle

@synthesize font              = _font;
@synthesize color             = _color;
@synthesize shadowColor       = _shadowColor;
@synthesize shadowOffset      = _shadowOffset;
@synthesize minimumFontSize   = _minimumFontSize;
@synthesize numberOfLines     = _numberOfLines;
@synthesize textAlignment     = _textAlignment;
@synthesize verticalAlignment = _verticalAlignment;
@synthesize lineBreakMode     = _lineBreakMode;



- (id)initWithNext:(ARCStyle*)next {
	self = [super initWithNext:next];
  if (self) {
    _shadowOffset = CGSizeZero;
    _numberOfLines = 1;
    _textAlignment = UITextAlignmentCenter;
    _verticalAlignment = UIControlContentVerticalAlignmentCenter;
    _lineBreakMode = UILineBreakModeTailTruncation;
  }

  return self;
}


#pragma mark -
#pragma mark Class public

+ (ARCTextStyle*)styleWithFont:(UIFont*)font next:(ARCStyle*)next {
  ARCTextStyle* style = [[self alloc] initWithNext:next];
  style.font = font;
  return style;
}


+ (ARCTextStyle*)styleWithColor:(UIColor*)color next:(ARCStyle*)next {
  ARCTextStyle* style = [[self alloc] initWithNext:next];
  style.color = color;
  return style;
}


+ (ARCTextStyle*)styleWithFont:(UIFont*)font color:(UIColor*)color next:(ARCStyle*)next {
  ARCTextStyle* style = [[self alloc] initWithNext:next];
  style.font = font;
  style.color = color;
  return style;
}


+ (ARCTextStyle*)styleWithFont:(UIFont*)font color:(UIColor*)color textAlignment:(UITextAlignment)textAlignment next:(ARCStyle*)next {
  ARCTextStyle* style = [[self alloc] initWithNext:next];
  style.font = font;
  style.color = color;
  style.textAlignment = textAlignment;
  return style;
}


+ (ARCTextStyle*)styleWithFont:(UIFont*)font color:(UIColor*)color
                  shadowColor:(UIColor*)shadowColor shadowOffset:(CGSize)shadowOffset
                         next:(ARCStyle*)next {
  ARCTextStyle* style = [[self alloc] initWithNext:next];
  style.font = font;
  style.color = color;
  style.shadowColor = shadowColor;
  style.shadowOffset = shadowOffset;
  return style;
}



+ (ARCTextStyle*)styleWithFont:(UIFont*)font color:(UIColor*)color
              minimumFontSize:(CGFloat)minimumFontSize
                  shadowColor:(UIColor*)shadowColor shadowOffset:(CGSize)shadowOffset
                         next:(ARCStyle*)next {
  ARCTextStyle* style = [[self alloc] initWithNext:next];
  style.font = font;
  style.color = color;
  style.minimumFontSize = minimumFontSize;
  style.shadowColor = shadowColor;
  style.shadowOffset = shadowOffset;
  return style;
}


+ (ARCTextStyle*)styleWithFont:(UIFont*)font color:(UIColor*)color
              minimumFontSize:(CGFloat)minimumFontSize
                  shadowColor:(UIColor*)shadowColor shadowOffset:(CGSize)shadowOffset
                textAlignment:(UITextAlignment)textAlignment
            verticalAlignment:(UIControlContentVerticalAlignment)verticalAlignment
                lineBreakMode:(UILineBreakMode)lineBreakMode numberOfLines:(NSInteger)numberOfLines
                         next:(ARCStyle*)next {
  ARCTextStyle* style = [[self alloc] initWithNext:next];
  style.font = font;
  style.color = color;
  style.minimumFontSize = minimumFontSize;
  style.shadowColor = shadowColor;
  style.shadowOffset = shadowOffset;
  style.textAlignment = textAlignment;
  style.verticalAlignment = verticalAlignment;
  style.lineBreakMode = lineBreakMode;
  style.numberOfLines = numberOfLines;
  return style;
}



#pragma mark -
#pragma mark Private


- (CGSize)sizeOfText:(NSString*)text withFont:(UIFont*)font size:(CGSize)size {
  if (_numberOfLines == 1) {
    return [text sizeWithFont:font];

  } else {
    CGSize maxSize = CGSizeMake(size.width, CGFLOAT_MAX);
    CGSize textSize = [text sizeWithFont:font constrainedToSize:maxSize
                           lineBreakMode:_lineBreakMode];
    if (_numberOfLines) {
      CGFloat maxHeight = font.ARCLineHeight * _numberOfLines;
      if (textSize.height > maxHeight) {
        textSize.height = maxHeight;
      }
    }
    return textSize;
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)rectForText:(NSString*)text forSize:(CGSize)size withFont:(UIFont*)font {
  CGRect rect = CGRectZero;
  if (_textAlignment == UITextAlignmentLeft
      && _verticalAlignment == UIControlContentVerticalAlignmentTop) {
    rect.size = size;

  } else {
    CGSize textSize = [self sizeOfText:text withFont:font size:size];

    if (size.width < textSize.width) {
      size.width = textSize.width;
    }

    rect.size = textSize;

    if (_textAlignment == UITextAlignmentCenter) {
      rect.origin.x = round(size.width/2 - textSize.width/2);

    } else if (_textAlignment == UITextAlignmentRight) {
      rect.origin.x = size.width - textSize.width;
    }

    if (_verticalAlignment == UIControlContentVerticalAlignmentCenter) {
      rect.origin.y = round(size.height/2 - textSize.height/2);

    } else if (_verticalAlignment == UIControlContentVerticalAlignmentBottom) {
      rect.origin.y = size.height - textSize.height;
    }
  }
  return rect;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawText:(NSString*)text context:(ARCStyleContext*)context {
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSaveGState(ctx);

  UIFont* font = _font ? _font : context.font;

  if (nil == font) {
    font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
  }

  if (_shadowColor) {
    // Due to a bug in OS versions 3.2 and 4.0, the shadow appears upside-down. It pains me to
    // write this, but a lot of research has failed to turn up a way to detect the flipped shadow
    // programmatically
    float shadowYOffset = -_shadowOffset.height;
    //NSString *osVersion = [UIDevice currentDevice].systemVersion;
    //if ([osVersion versionStringCompare:@"3.2"] != NSOrderedAscending) {
    //  shadowYOffset = _shadowOffset.height;
    //}

    CGSize offset = CGSizeMake(_shadowOffset.width, shadowYOffset);
    CGContextSetShadowWithColor(ctx, offset, 0, _shadowColor.CGColor);
  }

  if (_color) {
    [_color setFill];
  }

  CGRect rect = context.contentFrame;

  if (_numberOfLines == 1) {
    CGRect titleRect = [self rectForText:text forSize:rect.size withFont:font];
    titleRect.size = [text drawAtPoint:
                      CGPointMake(titleRect.origin.x+rect.origin.x,
                                  titleRect.origin.y+rect.origin.y)
                              forWidth:rect.size.width withFont:font
                           minFontSize:_minimumFontSize ? _minimumFontSize : font.pointSize
                        actualFontSize:nil lineBreakMode:_lineBreakMode
                    baselineAdjustment:UIBaselineAdjustmentAlignCenters];
    context.contentFrame = titleRect;

  } else {
    CGRect titleRect = [self rectForText:text forSize:rect.size withFont:font];
    titleRect = CGRectOffset(titleRect, rect.origin.x, rect.origin.y);
    rect.size = [text drawInRect:titleRect withFont:font lineBreakMode:_lineBreakMode
                       alignment:_textAlignment];
    context.contentFrame = rect;
  }

  CGContextRestoreGState(ctx);
}


#pragma mark -
#pragma mark ARCStyle

- (void)draw:(ARCStyleContext*)context {
  if ([context.delegate respondsToSelector:@selector(textForLayerWithStyle:)]) {
    NSString* text = [context.delegate textForLayerWithStyle:self];
    if (text) {
      context.didDrawContent = YES;
      [self drawText:text context:context];
    }
  }

  if (!context.didDrawContent
      && [context.delegate respondsToSelector:@selector(drawLayer:withStyle:)]) {
    [context.delegate drawLayer:context withStyle:self];
    context.didDrawContent = YES;
  }

  [self.next draw:context];
}



- (CGSize)addToSize:(CGSize)size context:(ARCStyleContext*)context {
  if ([context.delegate respondsToSelector:@selector(textForLayerWithStyle:)]) {
    NSString* text = [context.delegate textForLayerWithStyle:self];
    UIFont* font = _font ? _font : context.font;

    CGFloat maxWidth = context.contentFrame.size.width;
    if (!maxWidth) {
      maxWidth = CGFLOAT_MAX;
    }
    CGFloat maxHeight = _numberOfLines ? _numberOfLines * font.ARCLineHeight : CGFLOAT_MAX;
    CGSize maxSize = CGSizeMake(maxWidth, maxHeight);
    CGSize textSize = [self sizeOfText:text withFont:font size:maxSize];

    size.width += textSize.width;
    size.height += textSize.height;
  }

  if (_next) {
    return [self.next addToSize:size context:context];

  } else {
    return size;
  }
}


@end
