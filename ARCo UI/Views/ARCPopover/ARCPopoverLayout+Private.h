


#import "ARCPopoverLayout.h"

struct ARCScreenMatrix
{
    CGRect topLeft;
    CGRect topCenter;
    CGRect topRight;
    CGRect centerLeft;
    CGRect center;
    CGRect centerRight;
    CGRect bottomLeft;
    CGRect bottomCenter;
    CGRect bottomRight;
};
typedef struct ARCScreenMatrix ARCScreenMatrix;


@interface ARCPopoverLayout ()
@property (nonatomic, assign) ARCScreenMatrix screenMatrix;
@end


@interface ARCPopoverLayout (Private)
- (ARCScreenMatrix)calculateScreenMatrix;
@end
