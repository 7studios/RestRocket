//
//  UIView+BlocksKit.m
//  BlocksKit
//

#import "UIView+BlocksKit.h"
#import "NSObject+AssociatedObjects.h"
#import "UIGestureRecognizer+BlocksKit.h"
#import "NSArray+BlocksKit.h"

static char *kViewTouchDownBlockKey = "UIViewTouchDownBlock";
static char *kViewTouchMoveBlockKey = "UIViewTouchMoveBlock";
static char *kViewTouchUpBlockKey = "UIViewTouchUpBlock";



@implementation UIView (BlocksKit)

- (void)whenTouches:(NSUInteger)numberOfTouches tapped:(NSUInteger)numberOfTaps handler:(ARCBlock)block {
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *gesture = [UITapGestureRecognizer recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        block();
    }];
    
    [[self.gestureRecognizers select:^BOOL(id obj) {
        if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
            BOOL rightTouches = ([(UITapGestureRecognizer *)obj numberOfTouchesRequired] == numberOfTouches);
            BOOL rightTaps = ([(UITapGestureRecognizer *)obj numberOfTapsRequired] == numberOfTaps);
            return (rightTouches && rightTaps);
        }
        return NO;
    }] each:^(id obj) {
        [gesture requireGestureRecognizerToFail:(UITapGestureRecognizer *)obj];
    }];

    [gesture setNumberOfTouchesRequired:numberOfTouches];
    [gesture setNumberOfTapsRequired:numberOfTaps];
    
    [self addGestureRecognizer:gesture];
}

- (void)whenTapped:(ARCBlock)block {
    [self whenTouches:1 tapped:1 handler:block];
}

- (void)whenDoubleTapped:(ARCBlock)block {
    [self whenTouches:2 tapped:1 handler:block];
}

- (void)whenTouchedDown:(ARCTouchBlock)block {
    self.userInteractionEnabled = YES;
    [self associateCopyOfValue:block withKey:kViewTouchDownBlockKey];
}

- (void)whenTouchMove:(ARCTouchBlock)block {
	self.userInteractionEnabled = YES;
    [self associateCopyOfValue:block withKey:kViewTouchMoveBlockKey];
}	

- (void)whenTouchedUp:(ARCTouchBlock)block {
    self.userInteractionEnabled = YES;
    [self associateCopyOfValue:block withKey:kViewTouchUpBlockKey];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    ARCTouchBlock block = [self associatedValueForKey:kViewTouchDownBlockKey];
    if (block)
        block(touches, event);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    ARCTouchBlock block = [self associatedValueForKey:kViewTouchMoveBlockKey];
    if (block)
        block(touches, event);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    ARCTouchBlock block = [self associatedValueForKey:kViewTouchUpBlockKey];
    if (block)
        block(touches, event);
}

- (void)eachSubview:(ARCViewBlock)block {
    [self.subviews each:(ARCSenderBlock)block];
}

@end
