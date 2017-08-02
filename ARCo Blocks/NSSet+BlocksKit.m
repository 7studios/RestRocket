//
//  NSSet+BlocksKit.m
//  BlocksKit
//

#import "NSSet+BlocksKit.h"

@implementation NSSet (BlocksKit)

- (void)each:(ARCSenderBlock)block {
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        block(obj);
    }];
}

- (id)match:(ARCValidationBlock)block {
    return [[self objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        if (block(obj)) {
            *stop = YES;
            return YES;
        }
        return NO;
    }] anyObject];
}

- (NSSet *)select:(ARCValidationBlock)block {    
    NSSet *list = [self objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        return (block(obj));
    }];
    
    if (!list.count)
        return nil;
    
    return list;
}

- (NSSet *)reject:(ARCValidationBlock)block {
    NSSet *list = [self objectsPassingTest:^BOOL(id obj, BOOL *stop) {
        return (!block(obj));
    }];
    
    if (!list.count)
        return nil;
    
    return list;
}

- (NSSet *)map:(ARCTransformBlock)block {
    NSMutableSet *result = [[NSMutableSet alloc] initWithCapacity:self.count];
    
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        id value = block(obj);
        if (!value)
            value = [NSNull null];
        
        [result addObject:value];
    }];

    return result;
}



@end
