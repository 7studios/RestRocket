
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


#import "ARCBaseViewNavigationController.h"



@interface ARCBaseViewController : ARCBaseViewNavigationController


/*!
@abstract The style of the navigation bar when this view 
controller is pushed onto a navigation controller.
*/
@property (nonatomic, assign) UIBarStyle navigationBarStyle;

/*!
@abstract The color of the navigation bar when this view 
controller is pushed onto a navigation controller.
*/
@property (nonatomic, retain) UIColor *navigationBarTintColor;

/*!
@abstract The style of the status bar when this view controller is appearing.
*/
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;	

/*!
@abstract The view has appeared at least once.
*/
@property (nonatomic, assign, readonly) BOOL hasViewAppeared;

/*!
@abstract The view is currently visible.
*/
@property (nonatomic, assign, readonly) BOOL isViewAppearing;

/*!
@abstract Determines if the view will be resized automatically to fit the keyboard.
*/
@property (nonatomic, assign) BOOL autoresizesForKeyboard;


#pragma mark -

/*!
@abstract Sent to the controller before the keyboard slides in.
*/
-(void) keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds;
-(void) keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds animationDuration:(NSTimeInterval)aDuration;

/*!
@abstract Sent to the controller before the keyboard slides out.
*/
-(void) keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds;
-(void) keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds animationDuration:(NSTimeInterval)aDuration;

/*!
@abstract Sent to the controller after the keyboard has slid in.
*/
-(void) keyboardDidAppear:(BOOL)animated withBounds:(CGRect)bounds;

/*!
@abstract Sent to the controller after the keyboard has slid out.
*/
-(void) keyboardDidDisappear:(BOOL)animated withBounds:(CGRect)bounds;

@end
