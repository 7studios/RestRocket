
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

#import "ARCDefaultStyleSheet.h"
#import "UIImage+CacheAdditions.h"



///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ARCDefaultStyleSheet


#pragma mark -
#pragma mark Common styles


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)textColor {
  return [UIColor blackColor];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)highlightedTextColor {
  return [UIColor whiteColor];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)backgroundTextColor {
	return [UIColor whiteColor];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)font {
  return [UIFont systemFontOfSize:14];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)backgroundColor {
  return [UIColor whiteColor];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)navigationBarTintColor {
  return RGBCOLOR(119, 140, 168);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)toolbarTintColor {
  return RGBCOLOR(109, 132, 162);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)searchBarTintColor {
  return RGBCOLOR(200, 200, 200);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// public fonts


- (UIFont*)buttonFont {
  return [UIFont boldSystemFontOfSize:14];
}


- (UIFont*)tableFont {
  return [UIFont boldSystemFontOfSize:17];
}


- (UIFont*)tableSmallFont {
  return [UIFont boldSystemFontOfSize:15];
}


- (UIFont*)tableTitleFont {
  return [UIFont boldSystemFontOfSize:13];
}


- (UIFont*)tableTimestampFont {
  return [UIFont systemFontOfSize:13];
}


- (UIFont*)tableButtonFont {
  return [UIFont boldSystemFontOfSize:13];
}


- (UIFont*)tableSummaryFont {
  return [UIFont systemFontOfSize:17];
}


- (UIFont*)tableHeaderPlainFont {
  return [UIFont boldSystemFontOfSize:16];
}


- (UIFont*)tableHeaderGroupedFont {
  return [UIFont boldSystemFontOfSize:18];
}


- (CGFloat) tableBannerViewHeight {
  return 22;
}


- (UIFont*)photoCaptionFont {
  return [UIFont boldSystemFontOfSize:12];
}


- (UIFont*)messageFont {
  return [UIFont systemFontOfSize:15];
}


- (UIFont*)errorTitleFont {
  return [UIFont boldSystemFontOfSize:18];
}


- (UIFont*)errorSubtitleFont {
  return [UIFont boldSystemFontOfSize:12];
}


- (UIFont*)activityLabelFont {
  return [UIFont systemFontOfSize:17];
}


- (UIFont*)activityBannerFont {
  return [UIFont boldSystemFontOfSize:11];
}


- (UITableViewCellSelectionStyle)tableSelectionStyle {
  return UITableViewCellSelectionStyleBlue;
}


- (ARCStyle*)selectionFillStyle:(ARCStyle*)next {
    return [ARCLinearGradientFillStyle styleWithColor1:RGBCOLOR(5,140,245)
                                                color2:RGBCOLOR(1,93,230) next:next];
}


- (UIColor*)linkTextColor {
    return RGBCOLOR(87, 107, 149);
}

- (UIColor*)timestampTextColor {
    return RGBCOLOR(36, 112, 216);
}


- (UIColor*)moreLinkTextColor {
    return RGBCOLOR(36, 112, 216);
}


#pragma mark -
#pragma mark UIColor Tables

- (UIColor*)tablePlainBackgroundColor {
    return nil;
}


- (UIColor*)tablePlainCellSeparatorColor {
	return nil;
}


- (UITableViewCellSeparatorStyle)tablePlainCellSeparatorStyle {
	return UITableViewCellSeparatorStyleSingleLine;
}


- (UIColor*)tableGroupedBackgroundColor {
    return [UIColor groupTableViewBackgroundColor];
}


- (UIColor*)tableGroupedCellSeparatorColor {
	return nil;
}


- (UITableViewCellSeparatorStyle)tableGroupedCellSeparatorStyle {
	return [self tablePlainCellSeparatorStyle];
}


- (UIColor*)searchTableBackgroundColor {
    return RGBCOLOR(235, 235, 235);
}


- (UIColor*)searchTableSeparatorColor {
    return [UIColor colorWithWhite:0.85 alpha:1];
}


#pragma mark -
#pragma mark UIColor Tabs

- (UIColor*)tabBarTintColor {
    return RGBCOLOR(119, 140, 168);
}

- (UIColor*)tabTintColor {
    return RGBCOLOR(228, 230, 235);
}



// Badges...
///////////////////////////////////////////////////////////////////////////////////////////////////

- (ARCStyle*)blueBadgeWithFontSize:(CGFloat)fontSize {
    return
    [ARCShapeStyle styleWithShape:[ARCRoundedRectangleShape shapeWithRadius:10] next:
     [ARCInsetStyle styleWithInset:UIEdgeInsetsMake(1, 1, 1, 1) next:
      [ARCShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.6) blur:4 offset:CGSizeMake(2, 4) next:
       [ARCReflectiveFillStyle styleWithColor:RGBCOLOR(25, 25, 112) next:
        [ARCInsetStyle styleWithInset:UIEdgeInsetsMake(-1, -1, -1, -1) next:
         [ARCSolidBorderStyle styleWithColor:[UIColor whiteColor] width:2 next:
          [ARCBoxStyle styleWithPadding:UIEdgeInsetsMake(1, 7, 2, 7) next:
           [ARCTextStyle styleWithFont:[UIFont boldSystemFontOfSize:fontSize]
                                 color:[UIColor whiteColor] next:nil]]]]]]]];
}


- (ARCStyle*)badgeWithFontSize:(CGFloat)fontSize {
    return
    [ARCShapeStyle styleWithShape:[ARCRoundedRectangleShape shapeWithRadius:10] next:
     [ARCInsetStyle styleWithInset:UIEdgeInsetsMake(1, 1, 1, 1) next:
      [ARCShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.6) blur:4 offset:CGSizeMake(2, 4) next:
       [ARCReflectiveFillStyle styleWithColor:RGBCOLOR(221, 17, 27) next:
        [ARCInsetStyle styleWithInset:UIEdgeInsetsMake(-1, -1, -1, -1) next:
         [ARCSolidBorderStyle styleWithColor:[UIColor whiteColor] width:2 next:
          [ARCBoxStyle styleWithPadding:UIEdgeInsetsMake(1, 7, 2, 7) next:
           [ARCTextStyle styleWithFont:[UIFont boldSystemFontOfSize:fontSize]
                                color:[UIColor whiteColor] next:nil]]]]]]]];
}


- (ARCStyle*)test {
    UIImage* image = ARCIMAGE(@"bundle://contactAddBtn.png");
    ARCImageStyle *style = [ARCImageStyle styleWithImage:image next:nil];
    style.contentMode = UIViewContentModeCenter;
    return style;
}

- (ARCStyle*)blueBadge {
    UIImage* image = [UIImage imageNamed:@"contactAddBtn.png"];
    
    return [self blueBadgeWithFontSize:15];
}


- (ARCStyle*)miniBadge {
    return [self badgeWithFontSize:12];
}


- (ARCStyle*)badge {
    return [self badgeWithFontSize:15];
}


- (ARCStyle*)largeBadge {
    return [self badgeWithFontSize:17];
}


- (ARCStyle*)tabBar {
    UIColor* border = [ARCSTYLEVAR(tabBarTintColor) multiplyHue:0 saturation:0 value:0.7];
    return
    [ARCSolidFillStyle styleWithColor:ARCSTYLEVAR(tabBarTintColor) next:
     [ARCFourBorderStyle styleWithTop:nil right:nil bottom:border left:nil width:1 next:nil]];
}



- (ARCStyle*)tabStrip {
    UIColor* border = [ARCSTYLEVAR(tabTintColor) multiplyHue:0 saturation:0 value:0.4];
    return
    [ARCReflectiveFillStyle styleWithColor:ARCSTYLEVAR(tabTintColor) next:
     [ARCFourBorderStyle styleWithTop:nil right:nil bottom:border left:nil width:1 next:nil]];
}


/*
- (ARCStyle*)tabGrid {
    
    UIColor* color = ARCSTYLEVAR(tabTintColor);
    UIColor* lighter = [color multiplyHue:1 saturation:0.9 value:1.1];
    
    UIColor* highlight = RGBACOLOR(255, 255, 255, 0.7);
    UIColor* shadowColor = [color multiplyHue:1 saturation:1.1 value:0.86];
    
    return
    [ARCShapeStyle styleWithShape:[ARCRoundedRectangleShape shapeWithRadius:4] next:
     [ARCInsetStyle styleWithInset:UIEdgeInsetsMake(0,-1,-1,-2) next:
      [ARCShadowStyle styleWithColor:highlight blur:1 offset:CGSizeMake(0, 1) next:
       [ARCLinearGradientFillStyle styleWithColor1:lighter color2:color next:
        [ARCSolidBorderStyle styleWithColor:shadowColor width:1 next:nil]]]]];
    
}
*/

- (ARCStyle*)tabGrid {

    UIColor* color = ARCSTYLEVAR(tabTintColor);
    UIColor* lighter = [color multiplyHue:1 saturation:0.9 value:1.1];

    return
    [ARCShapeStyle styleWithShape:[ARCRoundedRectangleShape shapeWithRadius:4] next:
       [ARCLinearGradientFillStyle styleWithColor1:lighter color2:color next:nil]];
}


- (ARCStyle*)launcherButton:(UIControlState)state {
    return
    [ARCPartStyle styleWithName:@"image" style:ARCSTYLESTATE(launcherButtonImage:, state) next:
     [ARCTextStyle styleWithFont:[UIFont boldSystemFontOfSize:11] color:RGBCOLOR(180, 180, 180)
                minimumFontSize:11 shadowColor:nil
                   shadowOffset:CGSizeZero next:nil]];
}



- (ARCStyle*)launcherButtonImage:(UIControlState)state {
    ARCStyle* style =
    [ARCBoxStyle styleWithMargin:UIEdgeInsetsMake(-7, 0, 11, 0) next:
     [ARCShapeStyle styleWithShape:[ARCRoundedRectangleShape shapeWithRadius:8] next:
      [ARCImageStyle styleWithImageURL:nil defaultImage:nil contentMode:UIViewContentModeCenter
                                 size:CGSizeZero next:nil]]];
    
    if (state == UIControlStateHighlighted || state == UIControlStateSelected) {
        [style addStyle:
         //[ARCBlendStyle styleWithBlend:kCGBlendModeSourceAtop next:
          [ARCSolidFillStyle styleWithColor:RGBACOLOR(0,0,0,0.5) next:nil]];
    }
    
    return style;
}



- (ARCStyle*)tabGridTabImage:(UIControlState)state {
    return
    [ARCImageStyle styleWithImageURL:nil defaultImage:nil contentMode:UIViewContentModeCenter
                               size:CGSizeMake(48,48) next:nil];
}


- (ARCStyle*)tabGridTab:(UIControlState)state corner:(short)corner {
    ARCShape* shape = nil;
    
    if (corner == 1) {
        shape = [ARCRoundedRectangleShape shapeWithTopLeft:4 topRight:0 bottomRight:0 bottomLeft:0];
        
    } else if (corner == 2) {
        shape = [ARCRoundedRectangleShape shapeWithTopLeft:0 topRight:4 bottomRight:0 bottomLeft:0];
        
    } else if (corner == 3) {
        shape = [ARCRoundedRectangleShape shapeWithTopLeft:0 topRight:0 bottomRight:4 bottomLeft:0];
        
    } else if (corner == 4) {
        shape = [ARCRoundedRectangleShape shapeWithTopLeft:0 topRight:0 bottomRight:0 bottomLeft:4];
        
    } else if (corner == 5) {
        shape = [ARCRoundedRectangleShape shapeWithTopLeft:4 topRight:0 bottomRight:0 bottomLeft:4];
        
    } else if (corner == 6) {
        shape = [ARCRoundedRectangleShape shapeWithTopLeft:0 topRight:4 bottomRight:4 bottomLeft:0];
        
    } else {
        shape = [ARCRectangleShape shape];
    }
    
    UIColor* highlight = RGBACOLOR(255, 255, 255, 0.7);
    UIColor* shadowColor = [ARCSTYLEVAR(tabTintColor) multiplyHue:1 saturation:1.1 value:0.88];
    
    if (state == UIControlStateSelected) {
        return
        [ARCShapeStyle styleWithShape:shape next:
         [ARCSolidFillStyle styleWithColor:RGBCOLOR(150, 168, 191) next:
          [ARCInnerShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.6) blur:3 offset:CGSizeMake(0, 0) next:
           [ARCBoxStyle styleWithPadding:UIEdgeInsetsMake(11, 10, 9, 10) next:
            [ARCPartStyle styleWithName:@"image" style:ARCSTYLESTATE(tabGridTabImage:, state) next:
             [ARCTextStyle styleWithFont:[UIFont boldSystemFontOfSize:12]  color:RGBCOLOR(255, 255, 255)
                        minimumFontSize:10 shadowColor:RGBACOLOR(0,0,0,0.1) shadowOffset:CGSizeMake(-1,-1)
                                   next:nil]]]]]];
        
    } else {
        return
        [ARCShapeStyle styleWithShape:shape next:
         [ARCBevelBorderStyle styleWithHighlight:highlight
                                         shadow:shadowColor
                                          width:1
                                    lightSource:125 next:
          [ARCBoxStyle styleWithPadding:UIEdgeInsetsMake(11, 10, 9, 10) next:
           [ARCPartStyle styleWithName:@"image" style:ARCSTYLESTATE(tabGridTabImage:, state) next:
            [ARCTextStyle styleWithFont:[UIFont boldSystemFontOfSize:12]  color:self.linkTextColor
                       minimumFontSize:10 shadowColor:[UIColor colorWithWhite:255 alpha:0.9]
                          shadowOffset:CGSizeMake(0, -1) next:nil]]]]];
    }
}


- (ARCStyle*)tabGridTabTopLeft:(UIControlState)state {
    return [self tabGridTab:state corner:1];
}

- (ARCStyle*)tabGridTabTopRight:(UIControlState)state {
    return [self tabGridTab:state corner:2];
}


- (ARCStyle*)tabGridTabBottomRight:(UIControlState)state {
    return [self tabGridTab:state corner:3];
}


- (ARCStyle*)tabGridTabBottomLeft:(UIControlState)state {
    return [self tabGridTab:state corner:4];
}


- (ARCStyle*)tabGridTabLeft:(UIControlState)state {
    return [self tabGridTab:state corner:5];
}


- (ARCStyle*)tabGridTabRight:(UIControlState)state {
    return [self tabGridTab:state corner:6];
}


- (ARCStyle*)tabGridTabCenter:(UIControlState)state {
    return [self tabGridTab:state corner:0];
}


- (ARCStyle*)tab:(UIControlState)state {
    if (state == UIControlStateSelected) {
        UIColor* border = [ARCSTYLEVAR(tabBarTintColor) multiplyHue:0 saturation:0 value:0.7];
        
        return
        [ARCShapeStyle styleWithShape:[ARCRoundedRectangleShape shapeWithTopLeft:4.5 topRight:4.5
                                                                   bottomRight:0 bottomLeft:0] next:
         [ARCInsetStyle styleWithInset:UIEdgeInsetsMake(5, 1, 0, 1) next:
          [ARCReflectiveFillStyle styleWithColor:ARCSTYLEVAR(tabTintColor) next:
           [ARCInsetStyle styleWithInset:UIEdgeInsetsMake(-1, -1, 0, -1) next:
            [ARCFourBorderStyle styleWithTop:border right:border bottom:nil left:border width:1 next:
             [ARCBoxStyle styleWithPadding:UIEdgeInsetsMake(6, 12, 2, 12) next:
              [ARCTextStyle styleWithFont:[UIFont boldSystemFontOfSize:14]  color:ARCSTYLEVAR(textColor)
                         minimumFontSize:8 shadowColor:[UIColor colorWithWhite:1 alpha:0.8]
                            shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
        
    } else {
        return
        [ARCInsetStyle styleWithInset:UIEdgeInsetsMake(5, 1, 1, 1) next:
         [ARCBoxStyle styleWithPadding:UIEdgeInsetsMake(6, 12, 2, 12) next:
          [ARCTextStyle styleWithFont:[UIFont boldSystemFontOfSize:14]  color:[UIColor whiteColor]
                     minimumFontSize:8 shadowColor:[UIColor colorWithWhite:0 alpha:0.6]
                        shadowOffset:CGSizeMake(0, -1) next:nil]]];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (ARCStyle*)tabOverflowLeft {
    UIImage* image = ARCIMAGE(@"bundle://overflowLeft.png");
    ARCImageStyle *style = [ARCImageStyle styleWithImage:image next:nil];
    style.contentMode = UIViewContentModeCenter;
    return style;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (ARCStyle*)tabOverflowRight {
    UIImage* image = ARCIMAGE(@"bundle://overflowRight.png");
    ARCImageStyle *style = [ARCImageStyle styleWithImage:image next:nil];
    style.contentMode = UIViewContentModeCenter;
    return style;
}

@end



