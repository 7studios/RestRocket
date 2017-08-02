//
//  UIControl+BlocksKit.m
//  BlocksKit
//

#import "UIControl+BlocksKit.h"
#import "NSObject+AssociatedObjects.h"
#import "NSSet+BlocksKit.h"

static char *kControlHandlersKey = "UIControlBlockHandlers";


#pragma mark Private

@interface ARCControlWrapper : NSObject <NSCopying>
    - (id)initWithHandler:(ARCSenderBlock)aHandler forControlEvents:(UIControlEvents)someControlEvents;
    
    @property (retain) ARCSenderBlock handler;
    @property (assign) UIControlEvents controlEvents;
    
    - (void)invoke:(id)sender;

@end



@implementation ARCControlWrapper

@synthesize handler, controlEvents;

- (id)initWithHandler:(ARCSenderBlock)aHandler forControlEvents:(UIControlEvents)someControlEvents {
    if ((self = [super init])) {
        self.handler = aHandler;
        self.controlEvents = someControlEvents;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[ARCControlWrapper alloc] initWithHandler:self.handler forControlEvents:self.controlEvents];
}

- (void)invoke:(id)sender {
    ARCSenderBlock block = self.handler;
    if (block) dispatch_async(dispatch_get_main_queue(), ^{ block(sender); });
}


@end


#pragma mark Category

@implementation UIControl (BlocksKit)

- (void)addEventHandler:(ARCSenderBlock)handler forControlEvents:(UIControlEvents)controlEvents {
    NSMutableDictionary *events = [self associatedValueForKey:&kControlHandlersKey];
    if (!events) {
        events = [NSMutableDictionary dictionary];
        [self associateValue:events withKey:&kControlHandlersKey];
    }
    
    NSNumber *key = [NSNumber numberWithUnsignedInteger:controlEvents];
    NSMutableSet *handlers = [events objectForKey:key];
    if (!handlers) {
        handlers = [NSMutableSet set];
        [events setObject:handlers forKey:key];
    }
    
    ARCSenderBlock blockCopy = [handler copy];
    ARCControlWrapper *target = [[ARCControlWrapper alloc] initWithHandler:blockCopy forControlEvents:controlEvents];
    [handlers addObject:target];
    [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
}

- (void)removeEventHandlersForControlEvents:(UIControlEvents)controlEvents {
    NSMutableDictionary *events = [self associatedValueForKey:&kControlHandlersKey];
    if (!events) {
        events = [NSMutableDictionary dictionary];
        [self associateValue:events withKey:&kControlHandlersKey];
    }
    
    NSNumber *key = [NSNumber numberWithUnsignedInteger:controlEvents];
    NSSet *handlers = [events objectForKey:key];

    if (!handlers)
        return;
    
    [handlers each:^(id sender) {
        [self removeTarget:sender action:NULL forControlEvents:controlEvents];
    }];
    
    [events removeObjectForKey:key];
}

- (BOOL)hasEventHandlersForControlEvents:(UIControlEvents)controlEvents {
    NSMutableDictionary *events = [self associatedValueForKey:&kControlHandlersKey];
    if (!events) {
        events = [NSMutableDictionary dictionary];
        [self associateValue:events withKey:&kControlHandlersKey];
    }
    
    NSNumber *key = [NSNumber numberWithUnsignedInteger:controlEvents];
    NSSet *handlers = [events objectForKey:key];
    
    if (!handlers)
        return NO;
    
    return (handlers.count);
}

@end
