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

// Style
#import "ARCStyle.h"

@interface ARCFourBorderStyle : ARCStyle {
  UIColor*  _top;
  UIColor*  _right;
  UIColor*  _bottom;
  UIColor*  _left;
  CGFloat   _width;
}

@property (nonatomic, strong) UIColor*  top;
@property (nonatomic, strong) UIColor*  right;
@property (nonatomic, strong) UIColor*  bottom;
@property (nonatomic, strong) UIColor*  left;
@property (nonatomic)         CGFloat   width;



+ (ARCFourBorderStyle*)styleWithTop:(UIColor*)top right:(UIColor*)right bottom:(UIColor*)bottom
                              left:(UIColor*)left width:(CGFloat)width next:(ARCStyle*)next;

+ (ARCFourBorderStyle*)styleWithTop:(UIColor*)top width:(CGFloat)width next:(ARCStyle*)next;
+ (ARCFourBorderStyle*)styleWithRight:(UIColor*)right width:(CGFloat)width next:(ARCStyle*)next;
+ (ARCFourBorderStyle*)styleWithBottom:(UIColor*)bottom width:(CGFloat)width next:(ARCStyle*)next;
+ (ARCFourBorderStyle*)styleWithLeft:(UIColor*)left width:(CGFloat)width next:(ARCStyle*)next;


@end
