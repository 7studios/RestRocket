//
//  ARCURLAction.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * This object bundles up a set of parameters and ships them off
 * to ARCBasicNavigator's openURLAction method. This object is designed with the chaining principle
 * in mind. Once you've created a ARCURLAction object, you can apply any other property to the
 * object via the apply* methods. Each of these methods returns self, allowing you to chain them.
 *
 * Example:
 * [[ARCURLAction actionWithURLPath:@"arc://some/path"] applyAnimated:YES];
 * Create an URL action object with the path @"arc://some/path" that is animated.
 *
 * For the default values, see the apply method documentation below.
 */

@interface ARCURLAction : NSObject {
    
    NSString*       _urlPath;
    NSString*       _parentURLPath;
    NSDictionary*   _query;
    NSDictionary*   _state;
    BOOL            _animated;
    BOOL            _withDelay;
    
    CGRect          _sourceRect;
    UIView*         _sourceView;
    UIBarButtonItem* _sourceButton;
    
    UIViewAnimationTransition _transition;
    UIModalPresentationStyle _modalPresentationStyle;

}


@property (nonatomic, copy)   NSString*     urlPath;
@property (nonatomic, copy)   NSString*     parentURLPath;
@property (nonatomic, copy)   NSDictionary* query;
@property (nonatomic, copy)   NSDictionary* state;
@property (nonatomic, assign) BOOL          animated;
@property (nonatomic, assign) BOOL          withDelay;
@property (nonatomic, assign) CGRect        sourceRect;
@property (nonatomic, strong) UIView*       sourceView;
@property (nonatomic, strong) UIBarButtonItem* sourceButton;
@property (nonatomic, assign) UIViewAnimationTransition transition;
@property (nonatomic, assign) UIModalPresentationStyle modalPresentationStyle;


+ (id)action;
+ (id)actionWithURLPath:(NSString*)urlPath;


- (id)initWithURLPath:(NSString*)urlPath;
- (id)init;



/**
 * @default nil
 */
- (ARCURLAction*)applyParentURLPath:(NSString*)parentURLPath;

/**
 * @default nil
 */
- (ARCURLAction*)applyQuery:(NSDictionary*)query;

/**
 * @default nil
 */
- (ARCURLAction*)applyState:(NSDictionary*)state;

/**
 * @default NO
 */
- (ARCURLAction*)applyAnimated:(BOOL)animated;

/**
 * @default NO
 */
- (ARCURLAction*)applyWithDelay:(BOOL)withDelay;

/**
 * @default CGRectZero
 */
- (ARCURLAction*)applySourceRect:(CGRect)sourceRect;

/**
 * @default nil
 */
- (ARCURLAction*)applySourceView:(UIView*)sourceView;

/**
 * @default nil
 */
- (ARCURLAction*)applySourceButton:(UIBarButtonItem*)sourceButton;


/**
 * @default UIViewAnimationTransitionNone
 */
- (ARCURLAction*)applyTransition:(UIViewAnimationTransition)transition;


@end
