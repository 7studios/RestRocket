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
#import "ARCGlobalCommon.h"


@interface ARCBoxStyle : ARCStyle {
  UIEdgeInsets  _margin;
  UIEdgeInsets  _padding;
  CGSize        _minSize;
  ARCPosition    _position;
}

@property (nonatomic) UIEdgeInsets  margin;
@property (nonatomic) UIEdgeInsets  padding;
@property (nonatomic) CGSize        minSize;
@property (nonatomic) ARCPosition   position;


+ (ARCBoxStyle*)styleWithMargin:(UIEdgeInsets)margin next:(ARCStyle*)next;
+ (ARCBoxStyle*)styleWithPadding:(UIEdgeInsets)padding next:(ARCStyle*)next;
+ (ARCBoxStyle*)styleWithFloats:(ARCPosition)position next:(ARCStyle*)next;

+ (ARCBoxStyle*)styleWithMargin:(UIEdgeInsets)margin padding:(UIEdgeInsets)padding next:(ARCStyle*)next;

+ (ARCBoxStyle*)styleWithMargin:(UIEdgeInsets)margin padding:(UIEdgeInsets)padding
                       minSize:(CGSize)minSize position:(ARCPosition)position next:(ARCStyle*)next;

@end
