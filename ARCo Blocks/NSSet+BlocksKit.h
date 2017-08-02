//
//  NSSet+BlocksKit.h
//  %PROJECT
//

#import "ARCGlobalCommon.h"


/** Block extensions for NSSet.

 Both inspired by and resembling Smalltalk syntax, these utilities
 allows for iteration of a set in a logical way that
 saves quite a bit of boilerplate code for filtering or finding
 objects or an object.

 Includes code by the following:

- Michael Ash.    <https://github.com/mikeash>.    2010. BSD.
- Corey Floyd.    <https://github.com/coreyfloyd>. 2010.
- Aleks Nesterow. <https://github.com/nesterow>.   2010. BSD.
- Zach Waldowski. <https://github.com/zwaldowski>. 2011. MIT.

 @see NSArray(BlocksKit)
 @see NSDictionary(BlocksKit)
 */
@interface NSSet (BlocksKit)

/** Loops through a set and executes the given block with each object.

 @param block A single-argument, void-returning code block.
 */
- (void)each:(ARCSenderBlock)block;

/** Loops through a set to find the object matching the block.

 match: is functionally identical to select:, but will stop and return
 on the first match.

 @param block A single-argument, BOOL-returning code block.
 @return Returns the object if found, `nil` otherwise.
 @see select:
 */
- (id)match:(ARCValidationBlock)block;

/** Loops through a set to find the objects matching the block.

 @param block A single-argument, BOOL-returning code block.
 @return Returns a set of the objects found, `nil` otherwise.
 @see match:
 */
- (NSSet *)select:(ARCValidationBlock)block;

/** Loops through a set to find the objects not matching the block.

 This selector performs *literally* the exact same function as select, but in reverse.

 This is useful, as one may expect, for removing objects from a set:
     NSSet *new = [reusableWebViews reject:^BOOL(id obj) {
       return ([obj isLoading]);
     }];

 @param block A single-argument, BOOL-returning code block.
 @return Returns an array of all objects not found, `nil` if all are excluded.
 */
- (NSSet *)reject:(ARCValidationBlock)block;

/** Call the block once for each object and create a set of the return values.
 
 This is sometimes referred to as a transform, mutating one of each object:
     NSSet *new = [mimeTypes map:^id(id obj) {
       return [@"x-company-" stringByAppendingString:obj]);
     }];

 @param block A single-argument, object-returning code block.
 @return Returns a set of the objects returned by the block.
 */
- (NSSet *)map:(ARCTransformBlock)block;


@end