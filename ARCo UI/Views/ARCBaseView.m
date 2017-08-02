
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

#import "ARCBaseView.h"


// Style
#import "ARCStyleContext.h"
#import "ARCStyle.h"
#import "ARCLayout.h"



///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ARCBaseView

@synthesize style   = _style,
            layout  = _layout;



- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeRedraw;
    }

    return self;
}


#pragma mark -
#pragma mark UIView


- (void)drawRect:(CGRect)rect {
  ARCStyle* style = self.style;
  if (nil != style) {
    ARCStyleContext* context = [[ARCStyleContext alloc] init];
    context.frame = self.bounds;
    context.contentFrame = context.frame;

    [style draw:context];
    if (!context.didDrawContent) {
      [self drawContent:self.bounds];
    }

  } else {
    [self drawContent:self.bounds];
  }
}


- (void)layoutSubviews {
    ARCLayout* layout = self.layout;
    if (nil != layout) {
        [layout layoutSubviews:self.subviews forView:self];
    }
}


- (CGSize)sizeThatFits:(CGSize)size {
    ARCStyleContext* context = [[ARCStyleContext alloc] init];
    context.font = nil;
    
    return [_style addToSize:CGSizeZero context:context];
}


- (void)setStyle:(ARCStyle*)style {
    if (style != _style) {
        _style = style;

        [self setNeedsDisplay];
    }
}



- (void)drawContent:(CGRect)rect {
}


@end
