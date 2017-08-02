//
//  NSArray+BlocksKit.h
//  %PROJECT
//



/** Block extensions for NSArray.

 Both inspired by and resembling Smalltalk syntax, these utilities
 allows for iteration of an array in a concise way that
 saves quite a bit of boilerplate code for filtering or finding
 objects or an object.

 Includes code by the following:

- Robin Lu.       <https://github.com/robin>.      2009. MIT.
- Michael Ash.    <https://github.com/mikeash>.    2010. BSD.
- Aleks Nesterow. <https://github.com/nesterow>.   2010. BSD.
- Zach Waldowski. <https://github.com/zwaldowski>. 2011. MIT.

 @see NSDictionary(BlocksKit)
 @see NSSet(BlocksKit)
 */
@interface NSArray (BlocksKit)

/** Loops through an array and executes the given block with each object.
 
 @param block A single-argument, void-returning code block.
 */
- (void)each:(ARCSenderBlock)block;

/** Loops through an array to find the object matching the block.
 
 match: is functionally identical to select:, but will stop and return
 on the first match.
 
 @param block A single-argument, `BOOL`-returning code block.
 @return Returns the object if found, `nil` otherwise.
 @see select:
 */
- (id)match:(ARCValidationBlock)block;

/** Loops through an array to find the objects matching the block.
 
 @param block A single-argument, BOOL-returning code block.
 @return Returns an array of the objects found, `nil` otherwise.
 @see match:
 */
- (NSArray *)select:(ARCValidationBlock)block;

/** Loops through an array to find the objects not matching the block.
 
 This selector performs *literally* the exact same function as select: but in reverse.
 
 This is useful, as one may expect, for removing objects from an array.
     NSArray *new = [computers reject:^BOOL(id obj) {
       return ([obj isUgly]);
     }];
 
 @param block A single-argument, BOOL-returning code block.
 @return Returns an array of all objects not found, `nil` if all are excluded.
 */
- (NSArray *)reject:(ARCValidationBlock)block;

/** Call the block once for each object and create an array of the return values.
 
 This is sometimes referred to as a transform, mutating one of each object:
     NSArray *new = [stringArray map:^id(id obj) {
       return [obj stringByAppendingString:@".png"]);
     }];
 
 @param block A single-argument, object-returning code block.
 @return Returns an array of the objects returned by the block.
 */
- (NSArray *)map:(ARCTransformBlock)block;


@end