


#import "NSDictionary+ARCBlocks.h"


@implementation NSDictionary (ARCBlocks)

- (BOOL)all:(BOOL (^)(id object))block {
  for (id obj in self) {
    if (!block(obj)) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)any:(BOOL (^)(id object))block {
  for (id obj in self) {
    if (block(obj)) {
      return YES;
    }
  }
  return NO;
}

- (void)each:(void (^)(id key, id object))block {
  [self enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) { block(key, object); }];
}

- (void)eachWithStop:(void (^)(id key, id object, BOOL *stop))block {
  [self enumerateKeysAndObjectsUsingBlock:block];
}

- (NSDictionary *)select:(BOOL (^)(id key, id object))block {
  NSMutableDictionary *result = [NSMutableDictionary dictionary];
  [self each:^ (id key, id object) {
    if(block(key, object)) {
      [result setObject:object forKey:key];
    }
  }];
  return result;
}

- (NSDictionary *)map:(id (^)(id object))block {
  NSMutableDictionary *result = [NSMutableDictionary dictionary];
  [self each:^ (id key, id object) {
    [result setObject:block(object) forKey:key];
  }];
  return result;
}


- (NSDictionary *)reject:(BOOL (^)(id key, id object))block {
    NSMutableDictionary *list = [NSMutableDictionary dictionaryWithCapacity:self.count];
    
    [self each:^(id key, id obj) {
        if (!block(key, obj))
            [list setObject:obj forKey:key];
    }];
    
    if (!list.count)
        return nil;
    
    return list;    
}


@end