


#import "ARCPopoverLayout.h"
#import "ARCPopoverLayout+Private.h"
#import "ARCPopoverUtils.h"


@implementation ARCPopoverLayout

// private
@synthesize screenMatrix=_screenMatrix;
// public
@synthesize arrowDirection=_arrowDirection;
@synthesize arrowSize=_arrowSize;
@synthesize cornerRadius=_cornerRadius;
@synthesize contentInsets=_contentInsets;
@synthesize contentSize=_contentSize;
@synthesize popoverContentOffset=_popoverContentOffset;
@synthesize popoverFrame=_popoverFrame;
@synthesize popoverFrameInsets=_popoverFrameInsets;
@synthesize popoverMaxSize=_popoverMaxSize;
@synthesize popoverMinSize=_popoverMinSize;
@synthesize targetOffset=_targetOffset;
@synthesize targetRect=_targetRect;
@synthesize targetView=_targetView;


#pragma mark - Class lifecycle

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"targetRect"];
    
    _targetView = nil;
}

- (id)init
{
    if ( !(self = [super init]) ) return nil;
    
    self.arrowSize = CGSizeMake(32.0f, 26.0f);
    self.cornerRadius = 8.0f;
    self.contentInsets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
    self.contentSize = CGSizeMake(100.0f, 80.0f);
    self.popoverFrameInsets = UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f);
    
    self.popoverMaxSize = CGSizeMake(300.0f, 420.0f);
    self.popoverMinSize = CGSizeMake(120.0f, 70.0f);
    
    self.targetOffset = 5.0f;
    self.targetRect = CGRectZero;
    
    [self addObserver:self forKeyPath:@"targetRect" options:NSKeyValueObservingOptionNew context:NULL];
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ARCPopoverLayout *copy = [[ARCPopoverLayout allocWithZone:zone] init];
    
    copy.arrowSize = self.arrowSize;
    copy.cornerRadius = self.cornerRadius;
    copy.contentSize = self.contentSize;
    copy.contentInsets = self.contentInsets;
    copy.popoverFrameInsets = self.popoverFrameInsets;
    copy.targetOffset = self.targetOffset;
    copy.targetRect = self.targetRect;
    copy.targetView = self.targetView;
    
    return copy;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"targetRect"])
    {
        [self updateArrowDirection];
        [self updatePopoverFrame];
    }
}


#pragma mark - Getters / Setters

- (CGPoint)popoverContentOffset
{
    CGPoint offset = { self.contentInsets.left, self.contentInsets.top };
    
    switch (self.arrowDirection)
    {
        case ARCPopoverArrowDirectionUp:
            offset.y += self.arrowSize.height;
            break;
            
        case ARCPopoverArrowDirectionDown:
            break;
            
        case ARCPopoverArrowDirectionUnknown:
            break;
    }
    
    return offset;
}


#pragma mark - Public methods

- (void)updateArrowDirection
{
    ARCPopoverArrowDirection arrowDirection = ARCPopoverArrowDirectionUnknown;
    
    CGRect convertedTargetRect = [self.targetView convertRect:self.targetRect toView:nil];
    
    self.screenMatrix = [self calculateScreenMatrix];
    
    if (CGRectIntersectsRect(self.screenMatrix.topLeft, convertedTargetRect) ||
        CGRectIntersectsRect(self.screenMatrix.topCenter, convertedTargetRect) ||
        CGRectIntersectsRect(self.screenMatrix.topRight, convertedTargetRect))
    {
        arrowDirection = ARCPopoverArrowDirectionUp;
    }
    else if (CGRectIntersectsRect(self.screenMatrix.centerLeft, convertedTargetRect) ||
             CGRectIntersectsRect(self.screenMatrix.center, convertedTargetRect) ||
             CGRectIntersectsRect(self.screenMatrix.centerRight, convertedTargetRect))
    {
        arrowDirection = ARCPopoverArrowDirectionDown;
    }
    else if (CGRectIntersectsRect(self.screenMatrix.bottomLeft, convertedTargetRect) ||
             CGRectIntersectsRect(self.screenMatrix.bottomCenter, convertedTargetRect) ||
             CGRectIntersectsRect(self.screenMatrix.bottomRight, convertedTargetRect))
    {
        arrowDirection = ARCPopoverArrowDirectionDown;
    }
    
    _arrowDirection = arrowDirection;
}

- (void)updatePopoverFrame
{
    CGRect frame = CGRectZero;
    
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect convertedTargetRect = [appWindow convertRect:self.targetRect fromView:self.targetView];
    
    // calculate the frame
    frame.size.width = self.contentSize.width + self.contentInsets.left + self.contentInsets.right;
    frame.size.width = [ARCPopoverUtils clampValue:frame.size.width min:self.popoverMinSize.width max:self.popoverMaxSize.width];
    
    frame.size.height = self.contentSize.height + self.contentInsets.top + self.contentInsets.bottom + self.arrowSize.height;
    frame.size.height = [ARCPopoverUtils clampValue:frame.size.height min:self.popoverMinSize.height max:self.popoverMaxSize.height];
    
    frame.origin.y = 0.0f;
    frame.origin.x = CGRectGetMidX(convertedTargetRect) - (frame.size.width / 2);
    
    switch (self.arrowDirection)
    {
        case ARCPopoverArrowDirectionUp:
            frame.origin.y += CGRectGetMaxY(convertedTargetRect) + self.targetOffset;
            break;
            
        case ARCPopoverArrowDirectionDown:
            frame.origin.y += CGRectGetMinY(convertedTargetRect) - frame.size.height - self.targetOffset;
            break;
            
        case ARCPopoverArrowDirectionUnknown:
            break;
    }
    
    // move the frame based on targetRect and the window bounds
    CGRect windowBounds = appWindow.bounds;
    
    if (CGRectContainsRect(windowBounds, frame) == NO)
    {
        CGFloat screenMaxX = CGRectGetMaxX(windowBounds);
        CGFloat frameMaxX = CGRectGetMaxX(frame);
        
        CGFloat diff = frameMaxX - screenMaxX;
        
        if (diff < 0)
        {
            frame.origin.x = self.popoverFrameInsets.left;
        }
        else
        {
            frame.origin.x -= diff + self.popoverFrameInsets.right;
        }
    }
    
    _popoverFrame = frame;
}

@end