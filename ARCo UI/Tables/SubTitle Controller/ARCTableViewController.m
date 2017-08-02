
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

#import "ARCTableViewController.h"
#import "MStyleSheet.h"
#import "ARCTableView.h"

// Models
#import "ARCTableModelBase.h"

// Cell Objects
#import "ARCTableCellObject.h"

// Cell
#import "ARCTableCell.h"


#import "GithubRepositories.h"



@implementation ARCTableViewController

@synthesize tableView = tableView_,
            tableModel = tableModel_,
            tableViewStyle = tableViewStyle_;



///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        tableViewStyle_ = UITableViewStylePlain;
                
        self.wantsFullScreenLayout = YES;
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}


- (id)initWithStyle:(UITableViewStyle)style {
	self = [self initWithNibName:nil bundle:nil];
    if (self) {
        tableViewStyle_ = style;
    }
    
    return self;
}



#pragma mark -
#pragma mark UIViewController

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *objects = [NSMutableArray array];
    [[GithubRepositories exampleRepositories] enumerateObjectsUsingBlock:^(id repository, NSUInteger idx, BOOL *stop) {
        ARCTableCellObject *object = [[ARCTableCellObject alloc] initWithTitle:[repository objectForKey:@"name"] description:[repository objectForKey:@"description"]];
        [objects addObject:object];
    }];

    [[self tableModel] setObjects:objects];
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}


- (void)addButtonTapped:(id)sender {
    ARCTableCellObject *object = [[ARCTableCellObject alloc] initWithTitle:@"A new object" description:[NSString stringWithFormat:@"This was created at %@", [NSDate date]]];
    [self.tableModel insertObject:object atIndex:0];
}


- (void)sortOrderControlChanged:(UISegmentedControl *)control {
    [self.tableModel setSortOrder:control.selectedSegmentIndex];
}


#pragma mark -
#pragma mark Public


- (ARCTableModelBase *)tableModel {
    if (tableModel_ == nil) {
        tableModel_ = [[ARCTableModelBase alloc] initWithCellProvider:self];
        [tableModel_ addTableModelListener:self];
    }
    return tableModel_;
}


- (UITableView*)tableView {
    if (nil == tableView_) {	

        tableView_ = [[ARCTableView alloc] initWithFrame:self.view.bounds style:tableViewStyle_];
        tableView_.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        tableView_.layer.cornerRadius = 8;
        [tableView_ setDelegate:self];
		[tableView_ setDataSource:[self tableModel]];
        [tableView_ setRowHeight:65.0f];

        
        UIColor* separatorColor = tableViewStyle_ == UITableViewStyleGrouped ? ARCSTYLEVAR(tableGroupedCellSeparatorColor) : ARCSTYLEVAR(tablePlainCellSeparatorColor);
        if (separatorColor) {
            tableView_.separatorColor = separatorColor;
        }
        
        tableView_.separatorStyle = tableViewStyle_ == UITableViewStyleGrouped ? ARCSTYLEVAR(tableGroupedCellSeparatorStyle) : ARCSTYLEVAR(tablePlainCellSeparatorStyle);
        
        UIColor* backgroundColor = tableViewStyle_ == UITableViewStyleGrouped ? ARCSTYLEVAR(tableGroupedBackgroundColor) : ARCSTYLEVAR(tablePlainBackgroundColor);
        if (backgroundColor) {
            tableView_.backgroundColor = backgroundColor;
            self.view.backgroundColor = backgroundColor;
        }
        
        [self.view addSubview:tableView_];
    }
    
    return tableView_;
}


- (id<UITableViewDelegate>)createDelegate {
    return nil;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	/*
	 To conform to the Human Interface Guidelines, selections should not be persistent --
	 deselect the row after it has been selected.
	 */
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark ARCTableModelCellProvider methods

- (UITableViewCell *)cellForObjectAtIndexPath:(NSIndexPath *)indexPath reuseIdentifier:(NSString *)reuseIdentifier {
    return [[ARCTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}


- (void)configureCell:(UITableViewCell *)cell forObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    
    ARCTableCellObject *subTitleObj = object;

    cell.detailTextLabel.numberOfLines = 2;
    cell.textLabel.text = subTitleObj.title;
    cell.detailTextLabel.text = subTitleObj.description;
}



#pragma mark -
#pragma mark ARCTableModelEventListener methods

- (void)tableModelChanged:(ARCTableModelEvent *)changeEvent {
    
    switch (changeEvent.type) {
            
        case ARCTableModelRefreshDataEvent:
            [self.tableView reloadData];
            break;
            
        case ARCTableModelInsertRowEvent:
            [self.tableView insertRowsAtIndexPaths:changeEvent.indexPaths withRowAnimation:UITableViewRowAnimationTop];
            break;
            
        default:
            [self.tableView reloadData];
            break;
    }
}



@end
