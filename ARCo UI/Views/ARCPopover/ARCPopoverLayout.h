


typedef enum
{
    ARCPopoverArrowDirectionUnknown,
    ARCPopoverArrowDirectionUp,
    ARCPopoverArrowDirectionDown
} ARCPopoverArrowDirection;


/** ARCPopoverLayout is the model object used to construct to the popover */
@interface ARCPopoverLayout : NSObject <NSCopying>

/** direction of the arrow */
@property (nonatomic, assign, readonly) ARCPopoverArrowDirection arrowDirection;

/** size of the arrow */
@property (nonatomic, assign) CGSize arrowSize;

/** corner radius of the popover shape */
@property (nonatomic, assign) CGFloat cornerRadius;

/** insets of the view controller container */
@property (nonatomic, assign) UIEdgeInsets contentInsets;

/** size of the view controller container */
@property (nonatomic, assign) CGSize contentSize;

/** offset of the view controller container, calculated using contentInsets */
@property (nonatomic, assign, readonly) CGPoint popoverContentOffset;

/** calculated frame for the popover view */
@property (nonatomic, assign, readonly) CGRect popoverFrame;

/** insets of the popover shape */
@property (nonatomic, assign) UIEdgeInsets popoverFrameInsets;

/** popover shape maximum size */
@property (nonatomic, assign) CGSize popoverMaxSize;

/** popover shape minimum size */
@property (nonatomic, assign) CGSize popoverMinSize;

/** offset from the target view */
@property (nonatomic, assign) CGFloat targetOffset;

/** the rect from where present the popover */
@property (nonatomic, assign) CGRect targetRect;

/** the target that contains targetRect */
@property (nonatomic, assign) UIView *targetView;

- (void)updateArrowDirection;
- (void)updatePopoverFrame;

@end
