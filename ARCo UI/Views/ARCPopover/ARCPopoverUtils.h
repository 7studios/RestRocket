


@interface ARCPopoverUtils : NSObject

+ (CGFloat)clampValue:(CGFloat)value min:(CGFloat)min max:(CGFloat)max;
+ (BOOL)rect:(CGRect)aRect canBeCenteredInRect:(CGRect)targetRect;
+ (BOOL)view:(UIView *)aView canBeCenteredInView:(UIView *)targetView;

@end
