
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


#import "ARCAlertView+Blocks.h"
#import "NSObject+AssociatedObjects.h"


@interface UIAlertView (ARCBlocksPrivate)
    @property (nonatomic, strong) NSMutableDictionary *blocks;
@end


@implementation UIAlertView (BlocksKit)

static char *kAlertViewBlockDictionaryKey = "UIAlertViewBlockHandlers";
static NSString *kAlertViewWillShowBlockKey = @"UIAlertViewWillShowBlock";
static NSString *kAlertViewDidShowBlockKey = @"UIAlertViewDidShowBlock";
static NSString *kAlertViewWillDismissBlockKey = @"UIAlertViewWillDismissBlock";
static NSString *kAlertViewDidDismissBlockKey = @"UIAlertViewDidDismissBlock";



#pragma mark Initializers

+ (id)alertWithTitle:(NSString *)title {
    return [self alertWithTitle:title message:nil];
}

+ (id)alertWithTitle:(NSString *)title message:(NSString *)message {
    return [[UIAlertView alloc] initWithTitle:title message:message];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message {
    return [self initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
}

#pragma mark Public methods

- (NSInteger)addButtonWithTitle:(NSString *)title handler:(ARCBlock)block {
    if (!self.delegate)
        self.delegate = self;
    NSAssert([self.delegate isEqual:self], @"A block-backed button cannot be added when the delegate isn't self.");
    
    NSAssert(title.length, @"A button without a title cannot be added to the alert view.");
    NSInteger index = [self addButtonWithTitle:title];
    
    ARCBlock handler = [block copy];
    [self.blocks setObject:handler forKey:[NSNumber numberWithInteger:index]];
    
    return index;
}

- (NSInteger)setCancelButtonWithTitle:(NSString *)title handler:(ARCBlock)block {
    if (!self.delegate)
        self.delegate = self;
    NSAssert([self.delegate isEqual:self], @"A block-backed button cannot be added when the delegate isn't self.");    
    
    if (!title) title = NSLocalizedString(@"Cancel", nil);
    NSInteger index = [self addButtonWithTitle:title];
    self.cancelButtonIndex = index;
    
    ARCBlock handler = [block copy];
    [self.blocks setObject:handler forKey:[NSNumber numberWithInteger:index]];
    
    return index;
}

#pragma mark Properties

- (NSMutableDictionary *)blocks {
    NSMutableDictionary *blocks = [self associatedValueForKey:kAlertViewBlockDictionaryKey];
    if (!blocks) {
        blocks = [NSMutableDictionary dictionary];
        [self associateValue:blocks withKey:kAlertViewBlockDictionaryKey];
    }
    return blocks;
}

- (void)setBlocks:(NSMutableDictionary *)blocks {
    [self associateValue:blocks withKey:kAlertViewBlockDictionaryKey];
}

- (ARCBlock)cancelBlock {
    NSNumber *key = [NSNumber numberWithInteger:self.cancelButtonIndex];
    return [self.blocks objectForKey:key];
}

- (void)setCancelBlock:(ARCBlock)block {
    if (!self.delegate)
        self.delegate = self;
    NSAssert([self.delegate isEqual:self], @"A block-backed button cannot be added when the delegate isn't self.");
    
    if (self.cancelButtonIndex == -1) {
        [self setCancelButtonWithTitle:nil handler:block];
    } else {
        ARCBlock handler = [block copy];
        NSNumber *key = [NSNumber numberWithInteger:self.cancelButtonIndex];
        
        [self.blocks setObject:handler forKey:key];
    }
}

- (ARCBlock)willShowBlock {
    return [self.blocks objectForKey:kAlertViewWillShowBlockKey];    
}

- (void)setWillShowBlock:(ARCBlock)block {
    if (!self.delegate)
        self.delegate = self;
    NSAssert([self.delegate isEqual:self], @"A block-backed button cannot be added when the delegate isn't self.");
    
    ARCBlock handler = [block copy];
    [self.blocks setObject:handler forKey:kAlertViewWillShowBlockKey];
}

- (ARCBlock)didShowBlock {
    return [self.blocks objectForKey:kAlertViewDidShowBlockKey];
}

- (void)setDidShowBlock:(ARCBlock)block {
    if (!self.delegate)
        self.delegate = self;
    NSAssert([self.delegate isEqual:self], @"A block-backed button cannot be added when the delegate isn't self.");
    
    ARCBlock handler = [block copy];
    [self.blocks setObject:handler forKey:kAlertViewDidShowBlockKey];
}

- (ARCIndexBlock)willDismissBlock {
    return [self.blocks objectForKey:kAlertViewWillDismissBlockKey];
}

- (void)setWillDismissBlock:(ARCIndexBlock)block {
    if (!self.delegate)
        self.delegate = self;
    NSAssert([self.delegate isEqual:self], @"A block-backed button cannot be added when the delegate isn't self.");
    
    ARCIndexBlock handler = [block copy];
    [self.blocks setObject:handler forKey:kAlertViewWillDismissBlockKey];
}

- (ARCIndexBlock)didDismissBlock {
    return [self.blocks objectForKey:kAlertViewDidDismissBlockKey];
}

- (void)setDidDismissBlock:(ARCIndexBlock)block {
    if (!self.delegate)
        self.delegate = self;
    NSAssert([self.delegate isEqual:self], @"A block-backed button cannot be added when the delegate isn't self.");
    
    ARCIndexBlock handler = [block copy];
    [self.blocks setObject:handler forKey:kAlertViewDidDismissBlockKey];
}

#pragma mark Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    ARCBlock block = [self.blocks objectForKey:[NSNumber numberWithInteger:buttonIndex]];
    if (block)
        block();
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    ARCBlock block = [self.blocks objectForKey:kAlertViewWillShowBlockKey];
    if (block)
        block();
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
    ARCBlock block = [self.blocks objectForKey:kAlertViewDidShowBlockKey];
    if (block)
        block();
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    ARCIndexBlock block = [self.blocks objectForKey:kAlertViewWillDismissBlockKey];
    if (block)
        block(buttonIndex);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    ARCIndexBlock block = [self.blocks objectForKey:kAlertViewDidDismissBlockKey];
    if (block)
        block(buttonIndex);
}

@end
