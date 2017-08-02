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

//  S7GraphView.h
//  S7Touch
//
//  Created by Aleks Nesterow on 9/27/09.
//  aleks.nesterow@gmail.com
//  
//  Thanks to http://snobit.habrahabr.ru/ for releasing sources for his
//  Cocoa component named GraphView.
//  

#import <UIKit/UIKit.h>


@class ARCGraphView;

@protocol ARCGraphViewDataSource<NSObject>

@required

/** 
  * Returns the number of plots your want to be rendered in the view.
  * 
  * @params
  * graphView Component that is asking for the number of plots.
  * 
  * @return Number of plots your want to be rendered in the view.
  */
- (NSUInteger)graphViewNumberOfPlots:(ARCGraphView *)graphView;

/** 
  * Returns an array with objects of any type you can provide a formatter for via xValueFormatter property
  * or stay happy with default formatting.
  * 
  * @params
  * graphView Component that is asking for the values.
  * 
  * @return Array with objects of any type you can provide a formatter for via xValueFormatter property
  * or stay happy with default formatting.
  */
- (NSArray *)graphViewXValues:(ARCGraphView *)graphView;

/** 
  * Returns an array with objects of type NSNumber.
  * 
  * @params
  * graphView Component that is asking for the values.
  * plotIndex Index of the plot that you should provide an array of values for.
  * 
  * @return Array with objects of type NSNumber.
  */
- (NSArray *)graphView:(ARCGraphView *)graphView yValuesForPlot:(NSUInteger)plotIndex;

@optional

/** 
  * Returns the value indicating whether the component should render the plot with the specified index as filled.
  *
  * @param
  * graphView Component that is asking whether the plot should be filled.
  * plotIndex Index of the plot that you should decide whether it is filled or not.
  * 
  * @return YES if the plot should be rendered as filled; otherwise, NO.
  */
- (BOOL)graphView:(ARCGraphView *)graphView shouldFillPlot:(NSUInteger)plotIndex;

@end

@interface ARCGraphView : UIView {
	
@private
	
	id<ARCGraphViewDataSource> _dataSource;
	
	NSFormatter *_xValuesFormatter;
	NSFormatter *_yValuesFormatter;
	
	BOOL _drawAxisX;
	BOOL _drawAxisY;
	BOOL _drawGridX;
	BOOL _drawGridY;
	
	UIColor *_xValuesColor;
	UIColor *_yValuesColor;
	
	UIColor *_gridXColor;
	UIColor *_gridYColor;
	
	BOOL _drawInfo;
	NSString *_info;
	UIColor *_infoColor;
}

/** Returns a different color for the first 10 plots. */
+ (UIColor *)colorByIndex:(NSInteger)index;

@property (nonatomic, strong) IBOutlet id<ARCGraphViewDataSource> dataSource;

@property (nonatomic, strong) IBOutlet NSFormatter *xValuesFormatter;
@property (nonatomic, strong) IBOutlet NSFormatter *yValuesFormatter;

@property (nonatomic, assign) BOOL drawAxisX;
@property (nonatomic, assign) BOOL drawAxisY;
@property (nonatomic, assign) BOOL drawGridX;
@property (nonatomic, assign) BOOL drawGridY;

@property (nonatomic, strong) UIColor *xValuesColor;
@property (nonatomic, strong) UIColor *yValuesColor;

@property (nonatomic, strong) UIColor *gridXColor;
@property (nonatomic, strong) UIColor *gridYColor;

@property (nonatomic, assign) BOOL drawInfo;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, strong) UIColor *infoColor;

- (void)reloadData;

@end
