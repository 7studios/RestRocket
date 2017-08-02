


#import "ARCPopoverView.h"
#import "ARCPopoverLayout.h"

@class ARCStatusBarStatus;


@interface ARCPopoverView ()
@property (nonatomic, retain) ARCStatusBarStatus *statusBarStatus;
@property (nonatomic, assign) CGPoint arrowOrigin;

- (void)setupContentView;
- (void)updateFrameWithFrame:(CGRect)newFrame animated:(BOOL)animated;
@end


@interface ARCPopoverView (Private)

- (void)updateArrowOrigin;
- (UIBezierPath *)popoverPath;
- (UIBezierPath *)popoverShinePath;

@end
