
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

#import "ARCSearchTableViewController.h"

#import "ARCGlobalCommon.h"

// Models
#import "ARCSearchTableModel.h"

// Cell Objects
#import "ARCTableCellObject.h"

// Cell
#import "ARCTableCell.h"

// Views
#import "ARCTableView.h"

// Style sheets
#import "MStyleSheet.h"


#import "GithubRepositories.h"



@implementation ARCSearchTableViewController

@synthesize searchBar = searchBar_;



///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {    
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
}


#pragma mark -
#pragma mark Public


- (UITableView*)tableView {
    [super tableView];
    
    if (nil == searchBar_) {
        CGRect f = self.view.bounds;
        
        //** Move it down some...
        [tableView_ setFrame:CGRectMake(0, cDefaultRowHeight, f.size.width, f.size.height-cDefaultRowHeight)];
        
        // Add search bar to top of screen.
        searchBar_ = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, tableView_.frame.size.width-50, cDefaultRowHeight)];
        searchBar_.delegate = self;
        searchBar_.placeholder = @"Search for a lead...";
        [self.view addSubview:searchBar_];
    }
    
    return tableView_;
}


- (ARCSearchTableModel *)tableModel {
    if (tableModel_ == nil) {
        tableModel_ = [[ARCSearchTableModel alloc] initWithCellProvider:self];
        [tableModel_ addTableModelListener:self];
    }
    return (ARCSearchTableModel *)tableModel_;
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


- (void)tableModelChanged:(ARCTableModelEvent *)changeEvent
{
    [self.tableView reloadData];
}



/////////////////////////////////////////////////////////////////////////////////////
#pragma mark UISearchBarDelegate Private


-(void)handleSearchForTerm:(NSString *)searchTerm {    
    [[self tableModel] filterObjectsWithPrefix:searchTerm];
}


- (void)resetSearch {
    if ([[self tableModel] isKindOfClass:[ARCSearchTableModel class]]) {
        [[self tableModel] clearSearchFilter];
    }
}



#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	NSString *searchTerm = [searchBar text];
        
    [self handleSearchForTerm:searchTerm];	
	//[searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	int length = [[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length];
	
	if (length < 3) {	 
		[self resetSearch];
	} else {
        [self handleSearchForTerm:searchText];
    }
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[self resetSearch];
	
	[searchBar resignFirstResponder];
}



@end
