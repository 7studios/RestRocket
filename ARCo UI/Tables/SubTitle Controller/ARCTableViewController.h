
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
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


#import "ARCBaseViewController.h"
#import "ARCTableModelEventListener.h"
#import "ARCTableModelCellProvider.h"


@class ARCTableModelBase;


@interface ARCTableViewController : UIViewController <UITableViewDelegate, ARCTableModelEventListener, ARCTableModelCellProvider> {
    
    UITableView*              tableView_;
    ARCTableModelBase*        tableModel_;
    
    UITableViewStyle          tableViewStyle_;
    
    
    id<UITableViewDelegate>   tableDelegate_;
}


@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic, strong, readonly) ARCTableModelBase *tableModel;
@property (nonatomic) UITableViewStyle tableViewStyle;



/**
 * Initializes and returns a controller having the given style.
 */
- (id)initWithStyle:(UITableViewStyle)style;


/**
 * Creates an delegate for the table view.
 *
 * Subclasses can override this to provide their own table delegate implementation.
 */
- (id<UITableViewDelegate>)createDelegate;


@end
