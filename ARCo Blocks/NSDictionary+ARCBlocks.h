


@interface NSDictionary (ARCBlocks)

- (BOOL)all:(BOOL (^)(id object))block;
- (BOOL)any:(BOOL (^)(id object))block;
- (void)each:(void (^)(id key, id object))block;
- (void)eachWithStop:(void (^)(id key, id object, BOOL *stop))block;
- (NSDictionary *)select:(BOOL (^)(id key, id object))block;
- (NSDictionary *)map:(id (^)(id object))block;

/** Loops through a dictionary to find the key/value pairs not matching the block.
 
 This selector performs *literally* the exact same function as select: but in reverse.
 
 This is useful, as one may expect, for filtering objects.
 NSDictionary *strings = [userData reject:^BOOL(id key, id value) {
 return ([obj isKindOfClass:[NSString class]]);
 }];
 
 @param block A BOOL-returning code block for a key/value pair.
 @return Returns a dictionary of all objects not found, `nil` if all are excluded.
 */
- (NSDictionary *)reject:(BOOL (^)(id key, id object))block;

@end
