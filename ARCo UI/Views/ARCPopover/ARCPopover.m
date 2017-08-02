
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


#import "ARCPopover.h"
#import "ARCPopover+Private.h"


@implementation ARCPopover

// private
@synthesize didShowHandler=_didShowHandler;
@synthesize didHideHandler=_didHideHandler;
// public
@synthesize popoverLayout=_popoverLayout;
@synthesize popoverView=_popoverView;
@synthesize dimmingView=_dimmingView;
@synthesize contentVC=_contentVC;
@synthesize isVisible=_isVisible;


#pragma mark - Class lifecycle

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"isVisible"];
    
    _didShowHandler = nil;
    _didHideHandler = nil;
}


- (id)init
{
    if ( !(self = [super init]) ) return nil;
    
    _dimmingView = [[ARCDimmingView alloc] initWithFrame:[[UIScreen mainScreen] bounds] dimmingColor:nil];
    
    [_dimmingView setTapBlock:^{
        [self dismissPopoverAnimated:YES];
    }];
    
    _isVisible = NO;
    
    [self addObserver:self forKeyPath:@"isVisible" options:NSKeyValueObservingOptionNew context:NULL];
    
    return self;
}

- (id)initWithContentViewController:(UIViewController *)contentViewController
              didShowHandler:(ARCPopoverDidHideHandler)didShowHandler
              didHideHandler:(ARCPopoverDidHideHandler)didHideHandler
{
    self = [self init];
    
    self.contentVC = contentViewController;
    _popoverLayout = [[ARCPopoverLayout alloc] init];
    
    //self.popoverLayout.contentSize = self.contentVC.contentSizeForViewInPopover;
    
    self.popoverLayout.contentSize = self.contentVC.view.frame.size;
    
    /*
    CGRect contentFrame = {
        0.0f,
        0.0f,
        _contentVC.view.frame.size.width,
        _contentVC.view.frame.size.height
    };
    self.contentVC.view.frame = contentFrame;
    */
    
    self.didShowHandler = didShowHandler;
    self.didHideHandler = didHideHandler;
    
    return self;
}


+ (id)popoverWithContentViewController:(UIViewController *)contentViewController
                 didShowHandler:(ARCPopoverDidHideHandler)didShowHandler
                 didHideHandler:(ARCPopoverDidHideHandler)didHideHandler
{
    id popover = [[self alloc] initWithContentViewController:contentViewController
                                       didShowHandler:didShowHandler
                                       didHideHandler:didHideHandler];
    
    return popover;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isVisible"])
    {
        if (self.isVisible)
        {
            if (self.didShowHandler)
            {
                self.didShowHandler();
            }
        }
        else
        {
            if (self.didHideHandler)
            {
                self.didHideHandler();
            }
        }
    }
}


#pragma mark - Public methods

- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)barButtonItem animated:(BOOL)animated {
    UIView *targetView = (UIView *)barButtonItem;
    CGRect targetFrame = [targetView convertRect:targetView.frame toView:nil];
    
    [self presentPopoverFromRect:targetFrame inView:targetView animated:YES];
}

- (void)presentPopoverFromRect:(CGRect)targetRect inView:(UIView *)targetView animated:(BOOL)animated {
    self.popoverLayout.targetView = targetView;
    self.popoverLayout.targetRect = targetRect;
    
    if (_popoverView == nil)
    {
        _popoverView = [[ARCPopoverView alloc] initWithPopover:self popoverLayout:self.popoverLayout];
    }
    else
    {
        [self.popoverView.contentViewContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self.popoverView.contentViewContainer addSubview:_contentVC.view];
    
    
    id appDelegate = [[UIApplication sharedApplication] delegate];
    UIWindow *appWindow = [appDelegate window];
    
    [appWindow addSubview:self.dimmingView];
    [appWindow addSubview:self.popoverView];
    
    [self.dimmingView showAnimated:NO];
    
    if (animated == NO) {
        self.isVisible = YES;
        
    } else {
        self.popoverView.alpha = 0.0f;
        
        [UIView animateWithDuration:0.1
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.popoverView.alpha = 1.0f;
                         }
                         completion:^(BOOL finished) {
                             self.isVisible = YES;
                         }];
    }
}

- (void)dismissPopoverAnimated:(BOOL)animated {
    [self.dimmingView hideAnimated:NO];
    
    if (animated == NO) {
        [self.popoverView removeFromSuperview];
        
        self.isVisible = NO;
    } else {
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.popoverView.alpha = 0.0f;
                         }
                         completion:^(BOOL finished) {
                             [self.popoverView removeFromSuperview];
                             self.isVisible = NO;
                         }];
    }
}

@end
