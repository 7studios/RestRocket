


#import "ARCPopoverLayout+Private.h"


@implementation ARCPopoverLayout (Private)

- (ARCScreenMatrix)calculateScreenMatrix
{
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    
    ARCScreenMatrix screenMatrix;
    
    // segment of a 3x3 matrix
    CGFloat segmentWidth = ceilf((appWindow.bounds.size.width / 3) * 100) / 100;
    CGFloat segmentHeight = ceilf((appWindow.bounds.size.height / 3) * 100) / 100;
    
    CGSize segmentSize = CGSizeMake(segmentWidth, segmentHeight);
    
    for (int column = 0; column <= 2; column++)
    {
        for (int row = 0; row <= 2; row++)
        {
            CGRect segmentRect = CGRectZero;
            
            segmentRect.origin.x = column * segmentSize.width;
            segmentRect.origin.y = row * segmentSize.height;
            segmentRect.size = segmentSize;
            
            if (column == 0)
            {
                if (row == 0)
                {
                    screenMatrix.topLeft = segmentRect;
                }
                else if (row == 1)
                {
                    screenMatrix.centerLeft = segmentRect;
                }
                else if (row == 2)
                {
                    screenMatrix.bottomLeft = segmentRect;
                }
                
            }
            else if(column == 1)
            {
                if (row == 0)
                {
                    screenMatrix.topCenter = segmentRect;
                }
                else if (row == 1)
                {
                    screenMatrix.center = segmentRect;
                }
                else if (row == 2)
                {
                    screenMatrix.bottomCenter = segmentRect;
                }
            }
            else if(column == 2)
            {
                if (row == 0)
                {
                    screenMatrix.topRight = segmentRect;
                }
                else if (row == 1)
                {
                    screenMatrix.centerRight = segmentRect;
                }
                else if (row == 2)
                {
                    screenMatrix.bottomRight = segmentRect;
                }
            }
        }
    }
    
    return screenMatrix;
}

@end
