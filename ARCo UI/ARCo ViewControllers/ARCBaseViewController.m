
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



#import "ARCBaseViewController.h"

#import "UIViewController+Additions.h"



@interface ARCBaseViewController ()
@property (nonatomic, assign, readwrite) BOOL isViewAppearing;
@property (nonatomic, assign, readwrite) BOOL hasViewAppeared;

- (void)createNavigationBar;

- (void)resizeForKeyboard:(NSNotification *)notification appearing:(BOOL)appearing;

@end



#pragma mark -

@implementation ARCBaseViewController

@synthesize navigationBarStyle,navigationBarTintColor,statusBarStyle,isViewAppearing,hasViewAppeared,autoresizesForKeyboard;


#pragma mark <NSObject>

- (id)init {
	self = [self initWithNibName:nil bundle:nil];
	if (!self) {
		return nil;
	}
    
	self.navigationBarStyle = UIBarStyleDefault;
	self.navigationBarTintColor	= nil;
	self.statusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
	self.hasViewAppeared = FALSE;
	self.isViewAppearing = FALSE;
	self.autoresizesForKeyboard	= FALSE;
    
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (!self) {
		return nil;
	}
	self.navigationBarStyle = UIBarStyleDefault;
	self.statusBarStyle = UIStatusBarStyleDefault;
	return self;
}


#pragma mark @UIViewController

- (void)createNavigationBar {
    if (!self.popupViewController) {
		UINavigationBar *bar = self.navigationController.navigationBar;
		bar.tintColor = self.navigationBarTintColor;
		bar.barStyle = self.navigationBarStyle;
		[[UIApplication sharedApplication] setStatusBarStyle:self.statusBarStyle animated:YES];
	}
}


- (void)loadView {
	[super loadView];
	self.view.autoresizesSubviews = TRUE;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
	self.isViewAppearing = TRUE;
	self.hasViewAppeared = TRUE;
    
    [self createNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.isViewAppearing = FALSE;
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if (ARCIsPad()) {
		return TRUE;
	}
	else {
		UIViewController *popup = [self popupViewController];
		if (popup) {
			return [popup shouldAutorotateToInterfaceOrientation:interfaceOrientation];
		}
	}
	return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}


-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
	UIViewController *popup = [self popupViewController];
	if (popup) {
		return [popup willAnimateRotationToInterfaceOrientation:fromInterfaceOrientation duration:duration];
	}
	else {
		return [super willAnimateRotationToInterfaceOrientation:fromInterfaceOrientation duration:duration];
	}
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	UIViewController *popup = [self popupViewController];
	if (popup) {
		return [popup didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	}
	else {
		return [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	}
}


#pragma mark -

-(UIView *) rotatingHeaderView {
	UIViewController *popup = [self popupViewController];
	if (popup) {
		return [popup rotatingHeaderView];
	}
	else {
		return [super rotatingHeaderView];
	}
}

-(UIView *) rotatingFooterView {
	UIViewController *popup = [self popupViewController];
	if (popup) {
		return [popup rotatingFooterView];
	}
	else {
		return [super rotatingFooterView];
	}
}


#pragma mark [UIKeyboardNotifications]

-(void) resizeForKeyboard:(NSNotification *)notification appearing:(BOOL)appearing {
	NSDictionary *userInfo = [notification userInfo];
	CGRect keyboardFrame;
	BOOL animated;
	
	// Get the ending frame rect
	NSValue *frameEndValue	= [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardRect		= [frameEndValue CGRectValue];
	
	// Convert to window coordinates
	keyboardFrame			= [self.view convertRect:keyboardRect fromView:nil];
	
	NSNumber *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	animated = ([animationDurationValue doubleValue] > 0.0) ? TRUE : FALSE; 

	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:[animationDurationValue doubleValue]];
	}
	
	if (appearing) {
		[self keyboardWillAppear:animated withBounds:keyboardFrame];
		[self keyboardWillAppear:animated withBounds:keyboardFrame animationDuration:[animationDurationValue doubleValue]];
	}
	else {
		[self keyboardDidDisappear:animated withBounds:keyboardFrame];
	}
	
	if (animated) {
		[UIView commitAnimations];
	}
}

-(void) keyboardWillShow:(NSNotification *)notification {
	if (self.isViewAppearing) {
		[self resizeForKeyboard:notification appearing:YES];
	}
}

-(void) keyboardDidShow:(NSNotification *)notification {
	CGRect keyboardBounds;
	CGRect frameStart;
	[[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&frameStart];
	keyboardBounds = CGRectMake(0, 0, frameStart.size.width, frameStart.size.height);
	[self keyboardDidAppear:YES withBounds:keyboardBounds];
}

-(void) keyboardDidHide:(NSNotification *)notification {
	if (self.isViewAppearing) {
		[self resizeForKeyboard:notification appearing:NO];
	}
}

-(void) keyboardWillHide:(NSNotification *)notification {
	CGRect keyboardBounds;
	CGRect frameEnd;
	[[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&frameEnd];
	keyboardBounds = CGRectMake(0, 0, frameEnd.size.width, frameEnd.size.height);
	NSTimeInterval animationDuration;
	NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	[animationDurationValue getValue:&animationDuration];
	[self keyboardWillDisappear:TRUE withBounds:keyboardBounds];
	[self keyboardWillDisappear:TRUE withBounds:keyboardBounds animationDuration:animationDuration];
}


#pragma mark API

-(void) setAutoresizesForKeyboard:(BOOL)flag {
	if (flag != autoresizesForKeyboard) {
		autoresizesForKeyboard = flag;
		if (autoresizesForKeyboard) {
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)  name:UIKeyboardDidShowNotification  object:nil];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:)  name:UIKeyboardDidHideNotification  object:nil];
		}
		else {
			[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
			[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
			[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification  object:nil];
			[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification  object:nil];
		}
	}
}

-(void) keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds {

}

-(void) keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds animationDuration:(NSTimeInterval)aDuration {

}

-(void) keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds {

}

-(void) keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds animationDuration:(NSTimeInterval)aDuration {

}

-(void) keyboardDidAppear:(BOOL)animated withBounds:(CGRect)bounds {

}

-(void) keyboardDidDisappear:(BOOL)animated withBounds:(CGRect)bounds {

}


#pragma mark -

-(void) viewDidUnload {
	[super viewDidUnload];
}

-(void) didReceiveMemoryWarning {
	if (hasViewAppeared && !isViewAppearing) {
		[super didReceiveMemoryWarning];
		hasViewAppeared = NO;
	}
	else {
		[super didReceiveMemoryWarning];
	}
}

-(void)  dealloc {
	self.autoresizesForKeyboard = FALSE;
	self.navigationBarTintColor = nil;
}

@end
