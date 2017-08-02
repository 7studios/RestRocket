
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



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



typedef void(^ARCBlock)(void);
typedef void(^ARCIndexBlock)(NSUInteger index);

typedef void(^ARCGestureRecognizerBlock)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location);
typedef void(^ARCTouchBlock)(NSSet* set, UIEvent* event);
typedef void(^ARCViewBlock)(UIView *view);

typedef void(^ARCSenderBlock)(id sender);
typedef BOOL(^ARCValidationBlock)(id obj);
typedef id(^ARCAccumulationBlock)(id sum, id obj);
typedef id(^ARCTransformBlock)(id obj);

typedef void(^ARCInternalWrappingBlock)(BOOL cancel);


typedef enum {
    ARCPositionStatic,
    ARCPositionAbsolute,
    ARCPositionFloatLeft,
    ARCPositionFloatRight,
} ARCPosition;



/**
 * @return the current runtime version of the iPhone OS.
 */
float ARCOSVersion(void);

/**
 * @return TRUE if the keyboard is visible.
 */
BOOL ARCIsKeyboardVisible(void);

/**
 * @return TRUE if the device has phone capabilities.
 */
BOOL ARCIsPhoneSupported(void);

/**
 * @return TRUE if the device is iPad.
 */
BOOL ARCIsPad(void);

/**
 * @return the current device orientation.
 */
UIInterfaceOrientation ARCDeviceOrientation();

/**
 * @return TRUE if the current device orientation is portrait or portrait upside down.
 */
BOOL ARCDeviceOrientationIsPortrait();

/**
 * @return TRUE if the current device orientation is landscape left, or landscape right.
 */
BOOL ARCDeviceOrientationIsLandscape();

/**
 * On iPhone/iPod touch
 * Checks if the orientation is portrait, landscape left, or landscape right.
 * This helps to ignore upside down and flat orientations.
 *
 * On iPad:
 * Always returns Yes.
 */
BOOL ARCIsSupportedOrientation(UIInterfaceOrientation orientation);

/**
 * @return the rotation transform for a given orientation.
 */
CGAffineTransform ARCRotateTransformForOrientation(UIInterfaceOrientation orientation);

/**
 * @return the application frame with no offset.
 *
 * From the Apple docs:
 * Frame of application screen area in points (i.e. entire screen minus status bar if visible)
 */
CGRect ARCApplicationFrame();

/**
 * @return the toolbar height for a given orientation.
 *
 * The toolbar is slightly shorter in landscape.
 */
CGFloat ARCToolbarHeightForOrientation(UIInterfaceOrientation orientation);

/**
 * @return the height of the keyboard for a given orientation.
 */
CGFloat ARCKeyboardHeightForOrientation(UIInterfaceOrientation orientation);

/**
 * @return the space between the edge of the screen and a grouped table cell. Larger on iPad.
 */
CGFloat ARCGroupedTableCellInset();



/**
 * @return the current orientation of the visible view controller.
 */
UIInterfaceOrientation ARCInterfaceOrientation();

/**
 * @return the bounds of the screen with device orientation factored in.
 */
CGRect ARCScreenBounds();

/**
 * @return the application frame below the navigation bar.
 */
CGRect ARCNavigationFrame();

/**
 * @return the application frame below the navigation bar and above a toolbar.
 */
CGRect ARCToolbarNavigationFrame();

/**
 * @return the application frame below the navigation bar and above the keyboard.
 */
CGRect ARCKeyboardNavigationFrame();

/**
 * @return the height of the area containing the status bar and possibly the in-call status bar.
 */
CGFloat ARCStatusHeight();

/**
 * @return the height of the area containing the status bar and navigation bar.
 */
CGFloat ARCBarsHeight();

/**
 * @return the height of a toolbar considering the current orientation.
 */
CGFloat ARCToolbarHeight();

/**
 * @return the height of the keyboard considering the current orientation.
 */
CGFloat ARCKeyboardHeight();





#define ZEROLIMIT(_VALUE) (_VALUE < 0 ? 0 : (_VALUE > 1 ? 1 : _VALUE))

///////////////////////////////////////////////////////////////////////////////////////////////////
// Color helpers

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define HSVCOLOR(h,s,v) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:1]
#define HSVACOLOR(h,s,v,a) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:(a)]

#define RGBA(r,g,b,a) (r)/255.0f, (g)/255.0f, (b)/255.0f, (a)



///////////////////////////////////////////////////////////////////////////////////////////////////
// Style helpers

#define ARCSTYLE(_SELECTOR) [[ARCStyleSheet sharedStyleSheet] styleWithSelector:@#_SELECTOR]

#define ARCSTYLESTATE(_SELECTOR, _STATE) [[ARCStyleSheet sharedStyleSheet] styleWithSelector:@#_SELECTOR forState:_STATE]

#define ARCSTYLESHEET ((id)[ARCStyleSheet sharedStyleSheet])

#define ARCSTYLEVAR(_VARNAME) [ARCSTYLESHEET _VARNAME]


///////////////////////////////////////////////////////////////////////////////////////////////////
// Images

#define ARCIMAGE(_URL) [UIImage imageNamed:_URL]



///////////////////////////////////////////////////////////////////////////////////////////////////
// Dimensions of common iOS Views

/**
 * The standard height of a row in a table view controller.
 * @const 44 pixels
 */
extern const CGFloat cDefaultRowHeight;

/**
 * The standard height of a toolbar in portrait orientation.
 * @const 44 pixels
 */
extern const CGFloat cDefaultPortraitToolbarHeight;

/**
 * The standard height of a toolbar in landscape orientation.
 * @const 33 pixels
 */
extern const CGFloat cDefaultLandscapeToolbarHeight;

/**
 * The standard height of the keyboard in portrait orientation.
 * @const 216 pixels
 */
extern const CGFloat cDefaultPortraitKeyboardHeight;

/**
 * The standard height of the keyboard in landscape orientation.
 * @const 160 pixels
 */
extern const CGFloat cDefaultLandscapeKeyboardHeight;

/**
 * The space between the edge of the screen and the cell edge in grouped table views.
 * @const 10 pixels
 */
extern const CGFloat cGroupedTableCellInset;



///////////////////////////////////////////////////////////////////////////////////////////////////
// Animation

/**
 * The standard duration length for a transition.
 * @const 0.3 seconds
 */
extern const CGFloat cDefaultTransitionDuration;

/**
 * The standard duration length for a fast transition.
 * @const 0.2 seconds
 */
extern const CGFloat cDefaultFastTransitionDuration;

/**
 * The standard duration length for a flip transition.
 * @const 0.7 seconds
 */
extern const CGFloat cDefaultFlipTransitionDuration;


///////////////////////////////////////////////////////////////////////////////////////////////////
// RECTs

/**
 * @return a rectangle with dx and dy subtracted from the width and height, respectively.
 *
 * Example result: CGRectMake(x, y, w - dx, h - dy)
 */
CGRect ARCRectContract(CGRect rect, CGFloat dx, CGFloat dy);

/**
 * @return a rectangle whose origin has been offset by dx, dy, and whose size has been
 * contracted by dx, dy.
 *
 * Example result: CGRectMake(x + dx, y + dy, w - dx, h - dy)
 */
CGRect ARCRectShift(CGRect rect, CGFloat dx, CGFloat dy);

/**
 * @return a rectangle with the given insets.
 *
 * Example result: CGRectMake(x + left, y + top, w - (left + right), h - (top + bottom))
 */
CGRect ARCRectInset(CGRect rect, UIEdgeInsets insets);

