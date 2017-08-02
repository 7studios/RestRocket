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

#import "ARCLinearGradientFillStyle.h"

// Style
#import "ARCShape.h"
#import "ARCStyleContext.h"

// Style (private)
#import "ARCStyleInternal.h"



///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ARCLinearGradientFillStyle

@synthesize color1 = _color1,
            color2 = _color2,
            colors = colors_;



#pragma mark -
#pragma mark Class public

+ (ARCLinearGradientFillStyle*)styleWithColor1:(UIColor*)color1 color2:(UIColor*)color2 next:(ARCStyle*)next {
    ARCLinearGradientFillStyle* style = [[self alloc] initWithNext:next];
    style.color1 = color1;
    style.color2 = color2;
    
    style.colors = [[NSArray alloc] initWithObjects:color1, color2, nil];
    return style;
}


#pragma mark -
#pragma mark TTStyle

- (void)draw:(ARCStyleContext*)context {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = context.frame;

    CGContextSaveGState(ctx);
    [context.shape addToPath:rect];
    CGContextClip(ctx);

    //UIColor* colors[] = { _color1, _color2 };

    CGGradientRef gradient = [self newGradientWithColors:self.colors count:2];
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(rect.origin.x, rect.origin.y),
                              CGPointMake(rect.origin.x, rect.origin.y+rect.size.height),
                              kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);

    CGContextRestoreGState(ctx);

    return [self.next draw:context];
}


@end
