//
//  UIView+Additions.m
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UIView+Additions.h"
#import "ARCGlobalCommon.h"


@implementation UIView (ARCAdditions)


- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}



- (CGFloat)left {
    return self.frame.origin.x;
}


- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}


- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


- (CGFloat)centerX {
    return self.center.x;
}


- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


- (CGFloat)centerY {
    return self.center.y;
}


- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


- (CGFloat)width {
    return self.frame.size.width;
}


- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


- (CGFloat)height {
    return self.frame.size.height;
}


- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


- (CGFloat)ttScreenX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}


- (CGFloat)ttScreenY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}


- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}


- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}


- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}


- (CGPoint)origin {
    return self.frame.origin;
}


- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


- (CGSize)size {
    return self.frame.size;
}


- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


- (CGFloat)orientationWidth {
    return UIInterfaceOrientationIsLandscape(ARCInterfaceOrientation()) ? self.height : self.width;
}


- (CGFloat)orientationHeight {
    return UIInterfaceOrientationIsLandscape(ARCInterfaceOrientation())
    ? self.width : self.height;
}


- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}


- (UIView*)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
        
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
        
    } else {
        return nil;
    }
}


- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}


- (CGPoint)offsetFromView:(UIView*)otherView {
    CGFloat x = 0, y = 0;
    for (UIView* view = self; view && view != otherView; view = view.superview) {
        x += view.left;
        y += view.top;
    }
    return CGPointMake(x, y);
}


- (CGRect)frameWithKeyboardSubtracted:(CGFloat)plusHeight {
    CGRect frame = self.frame;
    if (ARCIsKeyboardVisible()) {
        CGRect screenFrame = ARCScreenBounds();
        CGFloat keyboardTop = (screenFrame.size.height - (ARCKeyboardHeight() + plusHeight));
        CGFloat screenBottom = self.ttScreenY + frame.size.height;
        CGFloat diff = screenBottom - keyboardTop;
        if (diff > 0) {
            frame.size.height -= diff;
        }
    }
    return frame;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDictionary *)userInfoForKeyboardNotification {
    CGRect screenFrame = ARCScreenBounds();
    CGRect bounds = CGRectMake(0, 0, screenFrame.size.width, self.height);
    CGPoint centerBegin = CGPointMake(floor(screenFrame.size.width/2 - self.width/2),
                                      screenFrame.size.height + floor(self.height/2));
    CGPoint centerEnd = CGPointMake(floor(screenFrame.size.width/2 - self.width/2),
                                    screenFrame.size.height - floor(self.height/2));
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSValue valueWithCGRect:bounds], UIKeyboardBoundsUserInfoKey,
            [NSValue valueWithCGPoint:centerBegin], UIKeyboardCenterBeginUserInfoKey,
            [NSValue valueWithCGPoint:centerEnd], UIKeyboardCenterEndUserInfoKey,
            nil];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)presentAsKeyboardAnimationDidStop {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidShowNotification
                                                        object:self
                                                      userInfo:[self userInfoForKeyboardNotification]];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dismissAsKeyboardAnimationDidStop {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidHideNotification
                                                        object:self
                                                      userInfo:[self userInfoForKeyboardNotification]];
    [self removeFromSuperview];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)presentAsKeyboardInView:(UIView*)containingView {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillShowNotification
                                                        object:self
                                                      userInfo:[self userInfoForKeyboardNotification]];
    
    self.top = containingView.height;
    [containingView addSubview:self];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(presentAsKeyboardAnimationDidStop)];
    self.top -= self.height;
    [UIView commitAnimations];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dismissAsKeyboard:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification
                                                        object:self
                                                      userInfo:[self userInfoForKeyboardNotification]];
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(dismissAsKeyboardAnimationDidStop)];
    }
    
    self.top += self.height;
    
    if (animated) {
        [UIView commitAnimations];
        
    } else {
        [self dismissAsKeyboardAnimationDidStop];
    }
}


@end
