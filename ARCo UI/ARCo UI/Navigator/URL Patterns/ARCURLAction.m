//
//  ARCURLAction.m
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCURLAction.h"

@implementation ARCURLAction

@synthesize urlPath       = _urlPath,
            parentURLPath = _parentURLPath,
            query = _query,
            state = _state,
            animated = _animated,
            withDelay = _withDelay,
            sourceRect = _sourceRect,
            sourceView = _sourceView,
            sourceButton  = _sourceButton,
            transition    = _transition,
            modalPresentationStyle = _modalPresentationStyle;


+ (id)action {
    return [[self alloc] init];
}

+ (id)actionWithURLPath:(NSString*)urlPath {
    return [[self alloc] initWithURLPath:urlPath];
}


- (id)initWithURLPath:(NSString*)urlPath {
	self = [super init];
    if (self) {
        self.urlPath = urlPath;
        self.animated = NO;
        self.withDelay = NO;
        self.transition = UIViewAnimationTransitionNone;
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
	self = [self initWithURLPath:nil];
    if (self) {
    }
    
    return self;
}




///////////////////////////////////////////////////////////////////////////////////////////////////
- (ARCURLAction*)applyParentURLPath:(NSString*)parentURLPath {
    self.parentURLPath = parentURLPath;
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (ARCURLAction*)applyQuery:(NSDictionary*)query {
    self.query = query;
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (ARCURLAction*)applyState:(NSDictionary*)state {
    self.state = state;
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (ARCURLAction*)applyAnimated:(BOOL)animated {
    self.animated = animated;
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (ARCURLAction*)applyWithDelay:(BOOL)withDelay {
    self.withDelay = withDelay;
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (ARCURLAction*)applySourceRect:(CGRect)sourceRect {
    self.sourceRect = sourceRect;
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (ARCURLAction*)applySourceView:(UIView*)sourceView {
    self.sourceView = sourceView;
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (ARCURLAction*)applySourceButton:(UIBarButtonItem*)sourceButton {
    self.sourceButton = sourceButton;
    return self;
}


- (ARCURLAction*)applyTransition:(UIViewAnimationTransition)transition {
    self.transition = transition;
    return self;
}



@end
