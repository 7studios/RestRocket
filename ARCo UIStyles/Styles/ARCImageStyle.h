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

@interface ARCImageStyle : ARCStyle {
  NSString*         _imageURL;
  UIImage*          _image;
  UIImage*          _defaultImage;

  CGSize            _size;

  UIViewContentMode _contentMode;
}

@property (nonatomic, copy)   NSString* imageURL;
@property (nonatomic, strong) UIImage*  image;
@property (nonatomic, strong) UIImage*  defaultImage;
@property (nonatomic)         CGSize    size;

@property (nonatomic)         UIViewContentMode contentMode;


+ (ARCImageStyle*)styleWithImageURL:(NSString*)imageURL next:(ARCStyle*)next;

+ (ARCImageStyle*)styleWithImageURL:(NSString*)imageURL defaultImage:(UIImage*)defaultImage
                              next:(ARCStyle*)next;

+ (ARCImageStyle*)styleWithImageURL:(NSString*)imageURL defaultImage:(UIImage*)defaultImage
                       contentMode:(UIViewContentMode)contentMode
                              size:(CGSize)size next:(ARCStyle*)next;

+ (ARCImageStyle*)styleWithImage:(UIImage*)image next:(ARCStyle*)next;

+ (ARCImageStyle*)styleWithImage:(UIImage*)image defaultImage:(UIImage*)defaultImage next:(ARCStyle*)next;

+ (ARCImageStyle*)styleWithImage:(UIImage*)image defaultImage:(UIImage*)defaultImage
                    contentMode:(UIViewContentMode)contentMode
                           size:(CGSize)size next:(ARCStyle*)next;

@end
