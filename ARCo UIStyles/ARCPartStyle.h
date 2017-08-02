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

@class ARCStyleContext;


@interface ARCPartStyle : ARCStyle {
    
  NSString*     name_;
  ARCStyle*     style_;

}

@property (nonatomic, copy)   NSString* name;
@property (nonatomic, strong) ARCStyle*  style;


+ (ARCPartStyle*)styleWithName:(NSString*)name style:(ARCStyle*)style next:(ARCStyle*)next;

- (void)drawPart:(ARCStyleContext*)context;

@end