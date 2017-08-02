//
//  ARCTabView.m
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCTabView.h"
#import "ARCTabGrid.h"
#import "ARCBaseView.h"




@implementation ARCTabView

@synthesize contentView = contentView_,
            tabBar = tabBar_;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setTabBar:(ARCTabGrid *)tabGrid {
	[tabBar_ removeFromSuperview];
	tabBar_ = tabGrid;
    
	[self addSubview:tabBar_];
}


- (void)setContentView:(UIView *)content {
	[self.contentView removeFromSuperview];
    
	contentView_ = content;
	contentView_.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - self.tabBar.bounds.size.height);
    
	[self addSubview:contentView_];
	[self sendSubviewToBack:contentView_];
}


- (void)layoutSubviews {
	[super layoutSubviews];
    
	CGRect f = self.contentView.frame;
	f.size.height = self.bounds.size.height - self.tabBar.bounds.size.height;
    
	self.contentView.frame = f;
	[self.contentView layoutSubviews];
}


- (void)drawContent:(CGRect)rect {
    /*
	CGContextRef c = UIGraphicsGetCurrentContext();
	[RGBCOLOR(230, 230, 230) set];
	CGContextFillRect(c, self.bounds);
     */
}



@end
