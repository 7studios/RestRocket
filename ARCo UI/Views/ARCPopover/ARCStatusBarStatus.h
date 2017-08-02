


typedef enum
{
    ARCStatusBarStateUnknown,
    ARCStatusBarStateHidden,
    ARCStatusBarStateNormal,
    ARCStatusBarStateExpanded
} ARCStatusBarState;


typedef void(^ARCStatusBarStatusStateHandler)(ARCStatusBarState state);


@interface ARCStatusBarStatus : NSObject

@property (nonatomic, assign) ARCStatusBarState state;
@property (nonatomic, assign) CGRect frame;

- (id)initWithStateHandler:(ARCStatusBarStatusStateHandler)stateHandler;

@end
