
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


#import "ARCDimmingView.h"


@interface ARCDimmingView ()
@end


@implementation ARCDimmingView

// private
@synthesize displayedBlock = _displayedBlock;
@synthesize tapBlock = _tapBlock;
//public
@synthesize isDisplayed=_isDisplayed;


#pragma mark - Class lifecycle


- (id)initWithFrame:(CGRect)frame {
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = [[UIScreen mainScreen] applicationFrame];
    }
    
    if ( !(self = [super initWithFrame:frame]) ) return nil;
    
    self.alpha = 0.0f;
    self.userInteractionEnabled = YES;
    
    _isDisplayed = NO;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture addTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
    
    return self;
}


- (id)initWithFrame:(CGRect)frame dimmingColor:(UIColor *)dimmingColor {
    self = [self initWithFrame:frame
                  dimmingColor:dimmingColor
                     displayed:nil
                           tap:nil];
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
       dimmingColor:(UIColor *)dimmingColor
          displayed:(ARCDimmingViewDisplayedBlock)displayedBlock
                tap:(ARCDimmingViewTapBlock)tapBlock {
    self = [self initWithFrame:frame];
    
    if (dimmingColor) {
        self.backgroundColor = [dimmingColor colorWithAlphaComponent:0.85f];
    }
    
    self.displayedBlock = displayedBlock;
    self.tapBlock = tapBlock;
    
    return self;
}


+ (id)dimmingViewWithFrame:(CGRect)frame dimmingColor:(UIColor *)dimmingColor {
    id view = [[self class] dimmingViewWithFrame:frame
                                    dimmingColor:dimmingColor
                                       displayed:nil
                                             tap:nil];
    
    return view;
}

+ (id)dimmingViewWithFrame:(CGRect)frame
              dimmingColor:(UIColor *)dimmingColor
                 displayed:(ARCDimmingViewDisplayedBlock)displayedBlock
                       tap:(ARCDimmingViewTapBlock)tapBlock {
    id view = [[self alloc] initWithFrame:frame
                             dimmingColor:dimmingColor
                                displayed:displayedBlock
                                      tap:tapBlock];
    
    return view;
}


#pragma mark - Private methods

- (void)handleTap:(UITapGestureRecognizer *)gestur {
    if (self.tapBlock) {
        self.tapBlock();
    }
}


#pragma mark - Public methods

- (void)showAnimated:(BOOL)animated {
    self.hidden = NO;
    
    if (animated == NO) {
        _isDisplayed = YES;
        self.alpha = 1.0f;
        
        if (self.displayedBlock) {
            self.displayedBlock(self.isDisplayed);
        }
    } else {
        [UIView animateWithDuration:0.1
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             self.alpha = 1.0f;
                             
                         } completion:^(BOOL finished) {
                             
                             _isDisplayed = YES;
                             
                             if (self.displayedBlock) {
                                 self.displayedBlock(self.isDisplayed);
                             }
                         }
        ];
    }
}

- (void)hideAnimated:(BOOL)animated {
    if (animated == NO) {
        _isDisplayed = NO;
        self.alpha = 0.0f;
        self.hidden = YES;
        
        if (self.displayedBlock) {
            self.displayedBlock(self.isDisplayed);
        }
    } else {
        [UIView animateWithDuration:0.1
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             self.alpha = 0.0f;
                             
                         } completion:^(BOOL finished) {
                             
                             _isDisplayed = NO;
                             self.hidden = YES;
                             
                             if (self.displayedBlock) {
                                 self.displayedBlock(self.isDisplayed);
                             }
                         }
        ];
    }
}

@end
