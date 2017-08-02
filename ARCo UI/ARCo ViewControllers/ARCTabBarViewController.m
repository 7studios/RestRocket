//
//  ARCTabBarViewController.m
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCTabBarViewController.h"

//
#import "ARCTabGrid.h"
#import "ARCTabView.h"
#import "ARCTabItem.h"



@interface ARCTabBarViewController ()

@end



@implementation ARCTabBarViewController

@synthesize viewControllers = viewControllers_,
            selectedViewController = selectedViewController_,
            tabBar = tabBar_,
            tabBarView = tabBarView_,
            selectedIndex;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)setSelectedViewController:(UIViewController *)vc {
	UIViewController *oldVC = self.selectedViewController;
	if (self.selectedViewController != vc) {
		self.selectedViewController = nil;
		self.selectedViewController = vc;
        
		if (visible) {
			[oldVC viewWillDisappear:NO];
			[self.selectedViewController viewWillAppear:NO];
		}
		self.tabBarView.contentView = vc.view;
		if (visible) {
			[oldVC viewDidDisappear:NO];
			[self.selectedViewController viewDidAppear:NO];
		}
		
		//[self.tabBar setSelectedTab:[self.tabBar.tabs objectAtIndex:self.selectedIndex] animated:(oldVC != nil)];
	}
}


- (void)setViewControllers:(NSArray *)array {
	if (array != viewControllers_) {
		viewControllers_ = nil;
		viewControllers_ = array;
		
		if (viewControllers_ != nil) {
			//[self loadTabs];
		}
	}
	
	self.selectedIndex = 0;
}


#pragma mark
#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect f = self.view.bounds;
    
	self.tabBarView = [[ARCTabView alloc] initWithFrame:ARCScreenBounds()];
	self.view = self.tabBarView;
    
    
    tabBar_ = [[ARCTabGrid alloc] initWithFrame:CGRectMake(75.0f, 30.0f, f.size.width-160.0f, 0.0f)];
    tabBar_.backgroundColor = [UIColor clearColor];
    tabBar_.columnCount = 5;
    tabBar_.tabItems = [NSArray arrayWithObjects:
                     [[ARCTabItem alloc] initWithTitle:@"Home"],
                     [[ARCTabItem alloc] initWithTitle:@"New Leads"],
                     [[ARCTabItem alloc] initWithTitle:@"Prospects"],
                     [[ARCTabItem alloc] initWithTitle:@"Calculators"],
                     [[ARCTabItem alloc] initWithTitle:@"Applications"],
                     nil];
    [tabBar_ sizeToFit];
    [tabBar_ setTabItemBadgeWithNumber:3 toString:@"2"];
    //[topNavView addSubview:tabBar_];
    
    self.tabBarView.tabBar = self.tabBar;

    

	//self.tabBar = [[ARCTabGrid alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
	//self.tabBar.delegate = self;
	//self.tabBarView.backgroundColor = [UIColor clearColor];
	//self.tabBarView.tabBar = self.tabBar;
	
    //[self loadTabs];
	
	UIViewController *tmp = self.selectedViewController;
	self.selectedViewController = nil;
	[self setSelectedViewController:tmp];
}


- (void)viewDidUnload {
	self.tabBar = nil;
	//self.selectedTab = nil;
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.selectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.selectedViewController viewDidAppear:animated];
	visible = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.selectedViewController viewWillDisappear:animated];	
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	[self.selectedViewController viewDidDisappear:animated];
	visible = NO;
}



- (NSUInteger)selectedIndex {
	return [self.viewControllers indexOfObject:self.selectedViewController];
}

- (void)setSelectedIndex:(NSUInteger)aSelectedIndex {
	if (self.viewControllers.count > aSelectedIndex)
		self.selectedViewController = [self.viewControllers objectAtIndex:aSelectedIndex];
}


#pragma mark
#pragma mark - InterfaceOrientation


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	//return [self.selectedViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
}

- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.selectedViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



@end
