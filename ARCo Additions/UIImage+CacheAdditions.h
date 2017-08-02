//
//  UIImage+CacheAdditions.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CacheAdditions)


+ (UIImage *)blendImageWithWhiteBkg:(UIImage*)image;

+ (UIImage *)imageNamed:(NSString *)name;
+ (void)clearCache;


/*
 * Resizes an image. Optionally rotates the image based on imageOrientation.
 */
- (UIImage*)transformWidth:(CGFloat)width height:(CGFloat)height rotate:(BOOL)rotate;

/**
 * Returns a CGRect positioned within rect given the contentMode.
 */
- (CGRect)convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode;

/**
 * Draws the image using content mode rules.
 */
- (void)drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode;

/**
 * Draws the image as a rounded rectangle.
 */
- (void)drawInRect:(CGRect)rect radius:(CGFloat)radius;
- (void)drawInRect:(CGRect)rect radius:(CGFloat)radius contentMode:(UIViewContentMode)contentMode;




@end
