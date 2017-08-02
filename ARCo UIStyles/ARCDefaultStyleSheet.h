
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

// Style
#import "ARCStyle.h"
#import "ARCStyleSheet.h"
#import "ARCShapeStyle.h"
#import "ARCShadowStyle.h"
#import "ARCLinearGradientFillStyle.h"
#import "ARCHorizontalGradientFillStyle.h"
#import "ARCSolidBorderStyle.h"
#import "ARCSolidFillStyle.h"
#import "ARCPartStyle.h"
#import "ARCFourBorderStyle.h"
#import "ARCBoxStyle.h"
#import "ARCTextStyle.h"
#import "ARCInsetStyle.h"
#import "ARCReflectiveFillStyle.h"
#import "ARCInnerShadowStyle.h"
#import "ARCBevelBorderStyle.h"
#import "ARCImageStyle.h"
#import "ARCBlendStyle.h"


// Shapes
#import "ARCRoundedRectangleShape.h"
#import "ARCRectangleShape.h"

#import "UIColor+Additions.h"



@class ARCShape;

@interface ARCDefaultStyleSheet : ARCStyleSheet

// Common styles
@property (nonatomic, readonly) UIColor*  textColor;
@property (nonatomic, readonly) UIColor*  highlightedTextColor;
@property (nonatomic, readonly) UIColor*  backgroundTextColor;
@property (nonatomic, readonly) UIFont*   font;
@property (nonatomic, readonly) UIColor*  backgroundColor;
@property (nonatomic, readonly) UIColor*  navigationBarTintColor;
@property (nonatomic, readonly) UIColor*  toolbarTintColor;
@property (nonatomic, readonly) UIColor*  searchBarTintColor;

@property (nonatomic, readonly) UIFont* buttonFont;
@property (nonatomic, readonly) UIFont* tableFont;
@property (nonatomic, readonly) UIFont* tableSmallFont;
@property (nonatomic, readonly) UIFont* tableTitleFont;
@property (nonatomic, readonly) UIFont* tableTimestampFont;
@property (nonatomic, readonly) UIFont* tableButtonFont;
@property (nonatomic, readonly) UIFont* tableSummaryFont;
@property (nonatomic, readonly) UIFont* tableHeaderPlainFont;
@property (nonatomic, readonly) UIFont* tableHeaderGroupedFont;

@property (nonatomic, readonly) UIColor* tabTintColor;
@property (nonatomic, readonly) UIColor* tabBarTintColor;

@property (nonatomic, readonly) UIColor*  timestampTextColor;
@property (nonatomic, readonly) UIColor*  linkTextColor;
@property (nonatomic, readonly) UIColor*  moreLinkTextColor;


// Tables
@property (nonatomic, readonly) UIColor*  tablePlainBackgroundColor;
@property (nonatomic, readonly) UIColor*  tablePlainCellSeparatorColor;
@property (nonatomic, readonly) UITableViewCellSeparatorStyle tablePlainCellSeparatorStyle;
@property (nonatomic, readonly) UIColor*  tableGroupedBackgroundColor;
@property (nonatomic, readonly) UIColor*  tableGroupedCellSeparatorColor;
@property (nonatomic, readonly) UITableViewCellSeparatorStyle tableGroupedCellSeparatorStyle;
@property (nonatomic, readonly) UIColor*  searchTableBackgroundColor;
@property (nonatomic, readonly) UIColor*  searchTableSeparatorColor;


- (ARCStyle*)selectionFillStyle:(ARCStyle*)next;


@end
