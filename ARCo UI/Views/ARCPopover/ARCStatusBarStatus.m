


#import "ARCStatusBarStatus.h"


@interface ARCStatusBarStatus ()
@property (nonatomic, copy) ARCStatusBarStatusStateHandler stateHandler;

- (ARCStatusBarState)calculateState;
- (void)setupNotifications;
@end


@implementation ARCStatusBarStatus

@synthesize stateHandler=_stateHandler;
@synthesize state=_state;
@synthesize frame=_frame;


- (id)initWithStateHandler:(ARCStatusBarStatusStateHandler)stateHandler
{
    if ( !(self = [super init]) ) return nil;
    
    _frame = [[UIApplication sharedApplication] statusBarFrame];
    _state = [self calculateState];
    self.stateHandler = stateHandler;
    
    [self setupNotifications];
    
    [self addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:NULL];
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"state"])
    {
        if (self.stateHandler)
        {
            self.stateHandler(self.state);
        }
    }
}


#pragma mark - Private methods

- (ARCStatusBarState)calculateState
{
    ARCStatusBarState state = ARCStatusBarStateUnknown;
    
    if (_frame.size.height == 0.0f)
    {
        state = ARCStatusBarStateHidden;
    }
    if (_frame.size.height == 20.0f)
    {
        state = ARCStatusBarStateNormal;
    }
    else if(_frame.size.height == 40.0f)
    {
        state = ARCStatusBarStateExpanded;
    }
    
    return state;
}

- (void)setupNotifications
{
    void(^updateStatusBarFrameBlock)(NSNotification *) = ^(NSNotification *note) {
        
        NSValue* rectValue = [[note userInfo] valueForKey:UIApplicationStatusBarFrameUserInfoKey];
        _frame = [rectValue CGRectValue];
        self.state = [self calculateState];
    };
    
    NSNotificationCenter *notifiCenter = [NSNotificationCenter defaultCenter];
    
    [notifiCenter addObserverForName:UIApplicationWillChangeStatusBarFrameNotification
                              object:nil
                               queue:nil
                          usingBlock:updateStatusBarFrameBlock];
    
    [notifiCenter addObserverForName:UIApplicationWillChangeStatusBarOrientationNotification
                              object:nil
                               queue:nil
                          usingBlock:updateStatusBarFrameBlock];
}

@end
