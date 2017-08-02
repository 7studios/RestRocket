/*
 The MIT License
 
 Copyright (c) 2009 Free Time Studios and Nathan Eror
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

/**
 A collection of macros used throughout the FTUtils set of tools.
 
 This file need not be included directly since it's included by the other 
 pieces of the library. The macros are useful throughout a project, and 
 it's recommended that you just include the file in your prefix header.
*/

#pragma mark - Version

static const NSUInteger FTUtilsVersion = 010100;
static NSString *const FTUtilsVersionString = @"1.1.0";


#pragma mark - Math
///---------------------------------------------------------------------------
/// @name Math Helpers
///---------------------------------------------------------------------------

/** Convert from degrees to radians */
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)

/** Convert from radians to degrees */
#define RADIANS_TO_DEGREES(r) (r * 180 / M_PI)

#pragma mark - Colors
///---------------------------------------------------------------------------
/// @name Creating colors
///---------------------------------------------------------------------------


/**
 Create a UIColor from a hex value.
 
 For example, `UIColorFromRGB(0xFF0000)` creates a `UIColor` object representing
 the color red.
*/
#define UIColorFromRGB(rgbValue) \
[UIColor \
  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
         green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
          blue:((float)(rgbValue & 0x0000FF))/255.0 \
         alpha:1.0]

/**
 Create a UIColor with an alpha value from a hex value.
 
 For example, `UIColorFromRGBA(0xFF0000, .5)` creates a `UIColor` object 
 representing a half-transparent red. 
*/
#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor \
  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
         green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
          blue:((float)(rgbValue & 0x0000FF))/255.0 \
         alpha:alphaValue]

#pragma mark - Delegates
///---------------------------------------------------------------------------
/// @name Calling Delegates
///---------------------------------------------------------------------------

/**
 Call a delegate method if the selector exists.
*/
#define FT_CALL_DELEGATE(_delegate, _selector) \
do { \
  id _theDelegate = _delegate; \
  if(_theDelegate != nil && [_theDelegate respondsToSelector:_selector]) { \
    [_theDelegate performSelector:_selector]; \
  } \
} while(0);

/**
 Call a delegate method that accepts one argument if the selector exists.
*/
#define FT_CALL_DELEGATE_WITH_ARG(_delegate, _selector, _argument) \
do { \
  id _theDelegate = _delegate; \
  if(_theDelegate != nil && [_theDelegate respondsToSelector:_selector]) { \
    [_theDelegate performSelector:_selector withObject:_argument]; \
  } \
} while(0);

/**
 Call a delegate method that accepts two arguments if the selector exists.
*/
#define FT_CALL_DELEGATE_WITH_ARGS(_delegate, _selector, _arg1, _arg2) \
do { \
  id _theDelegate = _delegate; \
  if(_theDelegate != nil && [_theDelegate respondsToSelector:_selector]) { \
    [_theDelegate performSelector:_selector withObject:_arg1 withObject:_arg2]; \
  } \
} while(0);

