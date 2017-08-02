
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


#import "ARCPopoverView.h"
#import "ARCPopoverView+Private.h"
#import "ARCPopover.h"
#import "ARCPopoverLayout.h"
#import "ARCStatusBarStatus.h"


@implementation ARCPopoverView

// private
@synthesize statusBarStatus=_statusBarStatus;
@synthesize arrowOrigin=_arrowOrigin;
// public
@synthesize popover=_popover;
@synthesize popoverLayout=_popoverLayout;
@synthesize contentViewContainer=_contentViewContainer;


#pragma mark - Class lifecycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _popover = nil;
    _popoverLayout = nil;
}


- (id)initWithPopover:(ARCPopover *)popover popoverLayout:(ARCPopoverLayout *)popoverLayout
{
    if (!(self = [super initWithFrame:popoverLayout.popoverFrame]) ) return nil;
    
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    
    _statusBarStatus = [[ARCStatusBarStatus alloc] initWithStateHandler:^(ARCStatusBarState state) {
        
        if (state == ARCStatusBarStateNormal) {
            CGRect newFrame = self.frame;
            newFrame.origin.y -= 40;
            newFrame.origin.y += 20;
            
            [self updateFrameWithFrame:newFrame animated:YES];
            
        } else if (state == ARCStatusBarStateExpanded) {
            CGRect newFrame = self.frame;
            newFrame.origin.y -= 20;
            newFrame.origin.y += 40;
            
            [self updateFrameWithFrame:newFrame animated:YES];
        }
    }];
    
    _popover = popover;
    _popoverLayout = popoverLayout;
    
    [self setupContentView];
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self updateArrowOrigin];
    
    CGRect contentFrame = self.contentViewContainer.frame;
    contentFrame.origin = self.popoverLayout.popoverContentOffset;
    self.contentViewContainer.frame = contentFrame;
    
    
    UIBezierPath *popoverPath = [self popoverPath];
    
    [[UIColor colorWithWhite:1.0f alpha:0.8f] setFill];
    [[UIColor colorWithWhite:1.0f alpha:0.2f] setStroke];
    
    [popoverPath addClip];
    [popoverPath fill];
    [popoverPath setLineJoinStyle:kCGLineJoinRound];
    [popoverPath setLineWidth:3.0f];
    [popoverPath stroke];
    
    
    // top shine
    UIBezierPath *shinePath = [self popoverShinePath];
    
    [[UIColor colorWithWhite:1.0f alpha:0.10f] setFill];
    [shinePath fill];
    
    
    // popover shadow
    self.layer.shadowPath = [popoverPath CGPath];
    self.layer.shadowOffset = CGSizeMake(0.0f, 4.0f);
    self.layer.shadowOpacity = 0.7f;
    self.layer.shadowRadius = 18.0f;
}


#pragma mark - Private methods

- (void)setupContentView
{
    CGRect containerViewFrame = { 0.0f, 0.0f, self.popoverLayout.contentSize.width, self.popoverLayout.contentSize.height };
    
    _contentViewContainer = [[UIView alloc] initWithFrame:containerViewFrame];
    
    self.contentViewContainer.clipsToBounds = YES;
    self.contentViewContainer.layer.cornerRadius = 6.0f;
    self.contentViewContainer.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.contentViewContainer.layer.borderWidth = 1.0f;
    
    [self addSubview:_contentViewContainer];
}


#pragma mark - Public methods

- (void)updateFrameWithFrame:(CGRect)newFrame animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.frame = newFrame;
        }];
    } else {
        self.frame = newFrame;
    }
    
    [self setNeedsDisplay];
}

@end
