
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



#import "ARCGlobalCommon.h"
#import "ARCBaseNavigator.h"


#import "UIWindow+Additions.h"




const CGFloat cDefaultRowHeight = 44;

const CGFloat cDefaultPortraitToolbarHeight   = 44;
const CGFloat cDefaultLandscapeToolbarHeight  = 33;

const CGFloat cDefaultPortraitKeyboardHeight      = 216;
const CGFloat cDefaultLandscapeKeyboardHeight     = 160;
const CGFloat cDefaultPadPortraitKeyboardHeight   = 264;
const CGFloat cDefaultPadLandscapeKeyboardHeight  = 352;

const CGFloat cGroupedTableCellInset = 9;
const CGFloat cGroupedPadTableCellInset = 42;

const CGFloat cDefaultTransitionDuration      = 0.3;
const CGFloat cDefaultFastTransitionDuration  = 0.2;
const CGFloat cDefaultFlipTransitionDuration  = 0.7;



float ARCOSVersion() {
  return [[[UIDevice currentDevice] systemVersion] floatValue];
}


BOOL ARCIsKeyboardVisible() {
  // Operates on the assumption that the keyboard is visible if and only if there is a first
  // responder; i.e. a control responding to key events
  UIWindow* window = [UIApplication sharedApplication].keyWindow;
  return !![window findFirstResponder];
}


BOOL ARCIsPhoneSupported() {
  NSString* deviceType = [UIDevice currentDevice].model;
  return [deviceType isEqualToString:@"iPhone"];
}


BOOL ARCIsPad() {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}


UIInterfaceOrientation ARCDeviceOrientation() {
    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
  
    return orient;
}


BOOL ARCDeviceOrientationIsPortrait() {
  UIInterfaceOrientation orient = ARCDeviceOrientation();

  switch (orient) {
    case UIInterfaceOrientationPortrait:
    case UIInterfaceOrientationPortraitUpsideDown:
      return YES;
    default:
      return NO;
  }
}


BOOL ARCDeviceOrientationIsLandscape() {
  UIInterfaceOrientation orient = ARCDeviceOrientation();

  switch (orient) {
    case UIInterfaceOrientationLandscapeLeft:
    case UIInterfaceOrientationLandscapeRight:
      return YES;
    default:
      return NO;
  }
}


BOOL ARCIsSupportedOrientation(UIInterfaceOrientation orientation) {
  if (ARCIsPad()) {
    return YES;

  } else {
    switch (orientation) {
      case UIInterfaceOrientationPortrait:
      case UIInterfaceOrientationLandscapeLeft:
      case UIInterfaceOrientationLandscapeRight:
        return YES;
      default:
        return NO;
    }
  }
}


CGAffineTransform ARCRotateTransformForOrientation(UIInterfaceOrientation orientation) {
  if (orientation == UIInterfaceOrientationLandscapeLeft) {
    return CGAffineTransformMakeRotation(M_PI*1.5);

  } else if (orientation == UIInterfaceOrientationLandscapeRight) {
    return CGAffineTransformMakeRotation(M_PI/2);

  } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
    return CGAffineTransformMakeRotation(-M_PI);

  } else {
    return CGAffineTransformIdentity;
  }
}


CGRect ARCApplicationFrame() {
  CGRect frame = [UIScreen mainScreen].applicationFrame;
  return CGRectMake(0, 0, frame.size.width, frame.size.height);
}


CGFloat ARCToolbarHeightForOrientation(UIInterfaceOrientation orientation) {
  if (UIInterfaceOrientationIsPortrait(orientation) || ARCIsPad()) {
    return cDefaultRowHeight;

  } else {
    return cDefaultLandscapeToolbarHeight;
  }
}


CGFloat ARCKeyboardHeightForOrientation(UIInterfaceOrientation orientation) {
  if (ARCIsPad()) {
    return UIInterfaceOrientationIsPortrait(orientation) ? cDefaultPadPortraitKeyboardHeight
                                                         : cDefaultPadLandscapeKeyboardHeight;

  } else {
    return UIInterfaceOrientationIsPortrait(orientation) ? cDefaultPortraitKeyboardHeight
                                                         : cDefaultLandscapeKeyboardHeight;
  }
}

CGFloat ARCGroupedTableCellInset() {
  return ARCIsPad() ? cGroupedPadTableCellInset : cGroupedTableCellInset;
}



///////////////////////////////////////////////////////////////////////////////////////////////////

UIInterfaceOrientation ARCInterfaceOrientation() {
    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
    if (UIDeviceOrientationUnknown == orient) {
        return [ARCBaseNavigator sharedNavigator].visibleViewController.interfaceOrientation;
        
    } else {
        return orient;
    }
}


CGRect ARCScreenBounds() {
    CGRect bounds = [UIScreen mainScreen].bounds;
    if (UIInterfaceOrientationIsLandscape(ARCInterfaceOrientation())) {
        CGFloat width = bounds.size.width;
        bounds.size.width = bounds.size.height;
        bounds.size.height = width;
    }
    return bounds;
}


CGRect ARCNavigationFrame() {
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    return CGRectMake(0, 0, frame.size.width, frame.size.height - ARCToolbarHeight());
}


CGRect ARCToolbarNavigationFrame() {
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    return CGRectMake(0, 0, frame.size.width, frame.size.height - ARCToolbarHeight()*2);
}


CGRect ARCKeyboardNavigationFrame() {
    return ARCRectContract(ARCNavigationFrame(), 0, ARCKeyboardHeight());
}


CGFloat ARCStatusHeight() {
    UIInterfaceOrientation orientation = ARCInterfaceOrientation();
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return [UIScreen mainScreen].applicationFrame.origin.x;
        
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return -[UIScreen mainScreen].applicationFrame.origin.x;
        
    } else {
        return [UIScreen mainScreen].applicationFrame.origin.y;
    }
}


CGFloat ARCBarsHeight() {
    CGRect frame = [UIApplication sharedApplication].statusBarFrame;
    if (UIInterfaceOrientationIsPortrait(ARCInterfaceOrientation())) {
        return frame.size.height + cDefaultRowHeight;
        
    } else {
        return frame.size.width + (ARCIsPad() ? cDefaultRowHeight : cDefaultLandscapeToolbarHeight);
    }
}


CGFloat ARCToolbarHeight() {
    return ARCToolbarHeightForOrientation(ARCInterfaceOrientation());
}


CGFloat ARCKeyboardHeight() {
    return ARCKeyboardHeightForOrientation(ARCInterfaceOrientation());
}


///////////////////////////////////////////////////////////////////////////////////////////////////
CGRect ARCRectContract(CGRect rect, CGFloat dx, CGFloat dy) {
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - dx, rect.size.height - dy);
}

CGRect ARCRectShift(CGRect rect, CGFloat dx, CGFloat dy) {
    return CGRectOffset(ARCRectContract(rect, dx, dy), dx, dy);
}

CGRect ARCRectInset(CGRect rect, UIEdgeInsets insets) {
    return CGRectMake(rect.origin.x + insets.left, rect.origin.y + insets.top,
                      rect.size.width - (insets.left + insets.right),
                      rect.size.height - (insets.top + insets.bottom));
}



