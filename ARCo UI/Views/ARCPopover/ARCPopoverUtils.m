


#import "ARCPopoverUtils.h"


@implementation ARCPopoverUtils

+ (CGFloat)clampValue:(CGFloat)value min:(CGFloat)min max:(CGFloat)max
{
    if (value < min) return min;
    if (value > max) return max;
    
    return value;
}

+ (BOOL)rect:(CGRect)aRect canBeCenteredInRect:(CGRect)targetRect
{
    aRect.origin.x = (targetRect.size.width / 2) - (aRect.size.width / 2);
    aRect.origin.y = (targetRect.size.height / 2) - (aRect.size.height / 2);
    
    if (CGRectContainsRect(targetRect, aRect))
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)view:(UIView *)aView canBeCenteredInView:(UIView *)targetView
{
    CGRect targetFrame = targetView.frame;
    CGRect viewFrame = aView.frame;
    
    return [self rect:viewFrame canBeCenteredInRect:targetFrame];
}

@end
