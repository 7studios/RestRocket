//
//  NSArray+BlocksKit.m
//  BlocksKit
//

#import "NSArray+BlocksKit.h"

@implementation NSArray (BlocksKit)

- (void)each:(ARCSenderBlock)block {
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj);
    }];
}

- (id)match:(ARCValidationBlock)block {
    NSIndexSet *indexes = [self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj)) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    
    if (!indexes.count)
        return nil;
    
    return [self objectAtIndex:[indexes firstIndex]];
}

- (NSArray *)select:(ARCValidationBlock)block {
    NSArray *list = [self objectsAtIndexes:[self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return (block(obj));
    }]];
    
    if (!list.count)
        return nil;
    
    return list;
}

- (NSArray *)reject:(ARCValidationBlock)block {
    NSArray *list = [self objectsAtIndexes:[self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return (!block(obj));
    }]];
    
    if (!list.count)
        return nil;
    
    return list;
}

- (NSArray *)map:(ARCTransformBlock)block {
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:self.count];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id value = block(obj);
        if (!value)
            value = [NSNull null];
        
        [result addObject:value];
    }];
    
    return result;
}



@end
