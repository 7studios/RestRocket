


@class ARCPopover;
@class ARCPopoverLayout;


@interface ARCPopoverView : UIView

@property (nonatomic, assign, readonly) ARCPopover *popover;
@property (nonatomic, assign, readonly) ARCPopoverLayout *popoverLayout;
@property (nonatomic, retain, readonly) UIView *contentViewContainer;

- (id)initWithPopover:(ARCPopover *)popover popoverLayout:(ARCPopoverLayout *)popoverLayout;

@end
