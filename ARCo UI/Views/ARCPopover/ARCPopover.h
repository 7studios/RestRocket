
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


#import "ARCDimmingView.h"
#import "ARCPopoverLayout.h"
#import "ARCPopoverView.h"


typedef void(^ARCPopoverDidShowHandler)();
typedef void(^ARCPopoverDidHideHandler)();


/** Popover is a component that mimic the iPad popover on the iPhone.
 It works just like UIPopover: create an instance passing a content view controller and present it from a rect or UIBarButtonItem.
 */
@interface ARCPopover : NSObject


/** The view controller that will be visible inside the popover */
@property (nonatomic, retain) UIViewController *contentVC;


/** The model object for the popover
 You can modify it's properties to change various aspects of the popover creation
 */
@property (nonatomic, retain, readonly) ARCPopoverLayout *popoverLayout;

/** If the popover is presented this will return YES */
@property (nonatomic, assign, readonly) BOOL isVisible;


- (id)initWithContentViewController:(UIViewController *)contentViewController
              didShowHandler:(ARCPopoverDidHideHandler)didShowHandler
              didHideHandler:(ARCPopoverDidHideHandler)didHideHandler;


+ (id)popoverWithContentViewController:(UIViewController *)contentViewController
                 didShowHandler:(ARCPopoverDidHideHandler)didShowHandler
                 didHideHandler:(ARCPopoverDidHideHandler)didHideHandler;


/** display the popover from a UIBarButtonItem 
 @param barButtonItem a UIBarButtonItem object to prenset the popover from
 @param animated set to YES to fade-in the popover
 */
- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)barButtonItem
                               animated:(BOOL)animated;

/** display the popover from a given rect
 @param targetRect present the popover from the given rect
 @param targetView the view that contains the given targetRect
 @param animated set to YES to fade-in the popover
 */
- (void)presentPopoverFromRect:(CGRect)targetRect
                        inView:(UIView *)targetView
                      animated:(BOOL)animated;

/** dismiss the popover with a fade-out animation, if enabled
 @param animated set to YES to fade-out the popover
 */
- (void)dismissPopoverAnimated:(BOOL)animated;

@end
