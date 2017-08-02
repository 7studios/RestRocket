
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

typedef void(^ARCDimmingViewDisplayedBlock)(BOOL isDisplayed);
typedef void(^ARCDimmingViewTapBlock)(void);


/** ARCDimmingView it's a view that works like the UIPopover or UIActionSheet background */
@interface ARCDimmingView : UIView {
    
}

@property (nonatomic, copy) ARCDimmingViewDisplayedBlock displayedBlock;
@property (nonatomic, copy) ARCDimmingViewTapBlock tapBlock;

/** YES if the view is visible */
@property (nonatomic, assign, readonly) BOOL isDisplayed;



+ (id)dimmingViewWithFrame:(CGRect)frame
              dimmingColor:(UIColor *)dimmingColor;

+ (id)dimmingViewWithFrame:(CGRect)frame
              dimmingColor:(UIColor *)dimmingColor
                 displayed:(ARCDimmingViewDisplayedBlock)displayedBlock
                       tap:(ARCDimmingViewTapBlock)tapBlock;


/** Initializer for a basic view 
 @param frame the frame of the view
 @param dimmingColor the custom background color of the view
 */
- (id)initWithFrame:(CGRect)frame dimmingColor:(UIColor *)dimmingColor;


/** Initializes the view with custom blocks
 
 @param frame the frame of the view
 @param dimmingColor the custom background color of the view
 @param displayedBlock an obj-c block, called when the view will become visible
 @param tapBlock an obj-c block, called when the user taps the view
 */
- (id)initWithFrame:(CGRect)frame
       dimmingColor:(UIColor *)dimmingColor
     displayed:(ARCDimmingViewDisplayedBlock)displayedBlock
           tap:(ARCDimmingViewTapBlock)tapBlock;



/** shows the view, animated or not */
- (void)showAnimated:(BOOL)animated;

/** hides the view, animated or not */
- (void)hideAnimated:(BOOL)animated;

@end


