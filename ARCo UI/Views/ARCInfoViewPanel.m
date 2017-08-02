//
//  MKInfoPanel.m
//  HorizontalMenu
//
//  Created by Mugunth on 25/04/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above
//  Read my blog post at http://mk.sg/8e on how to use this code

//  As a side note on using this code, you might consider giving some credit to me by
//	1) linking my website from your app's website 
//	2) or crediting me inside the app's credits page 
//	3) or a tweet mentioning @mugunthkumar
//	4) A paypal donation to mugunth.kumar@gmail.com
//
//  A note on redistribution
//	While I'm ok with modifications to this source code, 
//	if you are re-publishing after editing, please retain the above copyright notices

#import "ARCInfoViewPanel.h"

// animation
#import "UIView+FTAnimation.h"


#import <QuartzCore/QuartzCore.h>
#import <objc/message.h>



@interface ARCInfoViewPanel ()
    @property (nonatomic, assign) ARCInfoPanelType type;
    + (ARCInfoViewPanel*) infoPanel;
@end



@implementation ARCInfoViewPanel

@synthesize titleLabel = _titleLabel,
            detailLabel = _detailLabel,
            thumbImage = _thumbImage,
            backgroundGradient = _backgroundGradient,
            type = type_;



#pragma mark -
#pragma mark Lifecycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}


#pragma mark -
#pragma mark Setter/Getter

-(void)setType:(ARCInfoPanelType)type {
    if(type == ARCInfoPanelTypeError) {
        self.backgroundGradient.image = [[UIImage imageNamed:@"Red.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:5];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.detailLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
        self.thumbImage.image = [UIImage imageNamed:@"Warning.png"];
        self.detailLabel.textColor = [UIColor colorWithRed:1.f green:0.651f blue:0.651f alpha:1.f];
    }
    
    else if(type == ARCInfoPanelTypeInfo) {
        self.backgroundGradient.image = [[UIImage imageNamed:@"Blue.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:5];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        self.thumbImage.image = [UIImage imageNamed:@"Tick.png"];   
        self.detailLabel.textColor = RGBACOLOR(210, 210, 235, 1.0);
    }
}


+ (ARCInfoViewPanel *)infoPanel {
    ARCInfoViewPanel *panel = (ARCInfoViewPanel*)[[[UINib nibWithNibName:@"InfoPanel" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    panel.hidden = YES;
    
    return panel;
}


+ (ARCInfoViewPanel *)showPanelInView:(UIView *)view type:(ARCInfoPanelType)type title:(NSString *)title subtitle:(NSString *)subtitle {
    return [self showPanelInView:view type:type title:title subtitle:subtitle hideAfter:-1];
}

+ (ARCInfoViewPanel *)showPanelInView:(UIView *)view type:(ARCInfoPanelType)type title:(NSString *)title subtitle:(NSString *)subtitle hideAfter:(NSTimeInterval)interval {    
    
    ARCInfoViewPanel *panel = [ARCInfoViewPanel infoPanel];
    CGFloat panelHeight = 50;
    
    panel.type = type;
    panel.titleLabel.text = title;
    
    if(subtitle) {
        panel.detailLabel.text = subtitle;
        [panel.detailLabel sizeToFit];
        
        panelHeight = MAX(CGRectGetMaxY(panel.thumbImage.frame), CGRectGetMaxY(panel.detailLabel.frame));
        panelHeight += 10.f;    // padding at bottom
    } else {
        panel.detailLabel.hidden = YES;
        panel.thumbImage.frame = CGRectMake(15, 5, 35, 35);
        panel.titleLabel.frame = CGRectMake(57, 12, 240, 21);
    }
    
    // update frame of panel
    panel.frame = CGRectMake(0, view.frame.size.height-panelHeight, view.bounds.size.width, panelHeight);
    [view addSubview:panel];
    
    [panel backInFrom:kFTAnimationBottom inView:view withFade:NO duration:0.6 delegate:nil startSelector:nil stopSelector:nil];
    
    if (interval > 0) {
        [panel performSelector:@selector(hidePanel) withObject:view afterDelay:interval]; 
    }
    
    return panel;
}


- (void)hidePanel {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self backOutTo:kFTAnimationBottom inView:self.superview withFade:NO duration:0.5 delegate:nil startSelector:nil stopSelector:nil];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2.00];
}


#pragma mark -
#pragma mark Touch Recognition

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}



@end
