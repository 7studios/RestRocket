//
// Copyright 2009-2011 Facebook
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

extern const CGFloat    kTableCellSmallMargin;
extern const CGFloat    kTableCellSpacing;
extern const CGFloat    kTableCellMargin;
extern const CGFloat    kTableCellHPadding;
extern const CGFloat    kTableCellVPadding;
extern const NSInteger  kTableMessageTextLineCount;

/**
 * The base class for table cells which are single-object based.
 *
 * Subclasses should implement the object getter and setter.  The base implementations do
 * nothing, allowing you to store the object yourself using the appropriate type.
 */
@interface ARCTableCell : UITableViewCell

@property (nonatomic, retain) id object;


/**
 * Measure the height of the row with the object that will be assigned to the cell.
 */
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object;

@end