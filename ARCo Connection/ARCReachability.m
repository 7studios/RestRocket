
//
// Copyright 2011 Greg Gentling 7Studios
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//


#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#import <CoreFoundation/CoreFoundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

#import "ARCReachability.h"
#import "NIDebuggingTools.h"



@interface ARCReachability (Private)

@property (nonatomic, assign) BOOL reachabilityEstablished;

+ (ARCReachability*)reachabilityWithAddress: (const struct sockaddr_in*) hostAddress;

// Internal initializer
- (id)initWithReachabilityRef:(SCNetworkReachabilityRef)reachabilityRef;
- (void)scheduleObserver;
- (void)unscheduleObserver;
@end



#define kShouldPrintReachabilityFlags 0

// Constants
NSString* const ARCReachabilityStateChangedNotification = @"ARCReachabilityStateChangedNotification";
NSString* const ARCReachabilityStateWasDeterminedNotification = @"ARCReachabilityStateWasDeterminedNotification";



static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info) {
#pragma unused (target, flags)
    @autoreleasepool
    {
        ARCReachability* observer = (__bridge_transfer ARCReachability*) info;
        
        if (!observer.reachabilityEstablished) {
            NIDINFO(@"Network availability has been determined for reachability observer %@", observer);
            observer.reachabilityEstablished = YES;
        }
        
        // Post a notification to notify the client that the network reachability changed.
        [[NSNotificationCenter defaultCenter] postNotificationName:ARCReachabilityStateChangedNotification object:observer];
    }
		
}

static void PrintReachabilityFlags(SCNetworkReachabilityFlags    flags, const char* comment)
{
#if kShouldPrintReachabilityFlags
    NIDINFO(@"Reachability Flag Status: %c%c %c%c%c%c%c%c%c %s\n",
          (flags & kSCNetworkReachabilityFlagsIsWWAN)				  ? 'W' : '-',
          (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
          
          (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
          (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
          (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
          (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
          (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-',
          comment
          );
#endif
}


@implementation ARCReachability

@synthesize hostName = hostName_;



- (id)initWithHostname:(NSString*)hostName {
    self = [self init];    
    if (self) {
        hostName_ = hostName;
        
        // Try to determine if we have an IP address or a hostname
        struct sockaddr_in sa;
        char* hostNameOrIPAddress = (char*) [hostName UTF8String];
        int result = inet_pton(AF_INET, hostNameOrIPAddress, &(sa.sin_addr));
        
        if (result != 0) {
            // IP Address
            struct sockaddr_in remote_saddr;
            
            bzero(&remote_saddr, sizeof(struct sockaddr_in));
            remote_saddr.sin_len = sizeof(struct sockaddr_in);
            remote_saddr.sin_family = AF_INET;
            inet_aton(hostNameOrIPAddress, &(remote_saddr.sin_addr));
            
            reachabilityRef_ = SCNetworkReachabilityCreateWithAddress(CFAllocatorGetDefault(), (struct sockaddr*)&remote_saddr);
            
            // We can immediately determine reachability to an IP address
            reachabilityEstablished_ = YES;
            
            NIDINFO(@"Reachability observer initialized with IP address %@.", hostName);
        } else {
            // Hostname
            reachabilityRef_ = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), hostNameOrIPAddress);
            
            NIDINFO(@"Reachability observer initialized with hostname %@", hostName);
        }
        
        if (reachabilityRef_) {
            [self scheduleObserver];
        } else {
            NIDERROR(@"Unable to initialize reachability reference");
        }
    }
    
    return self;
}

- (void)dealloc {
    NIDINFO(@"Deallocating reachability observer %@", self);

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self unscheduleObserver];
    
    if (reachabilityRef_) {
        CFRelease(reachabilityRef_);
    }
}


//** Helper
+ (ARCReachability*)reachabilityWithAddress: (const struct sockaddr_in*) hostAddress;
{
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)hostAddress);
	ARCReachability* retVal = NULL;
	if(reachability!= NULL)
	{
		retVal= [[self alloc] init];
		if(retVal!= NULL)
		{
			retVal->reachabilityRef_ = reachability;
			retVal->localWiFiRef_ = NO;
		}
	}
	return retVal;
}


+ (ARCReachability*)reachabilityWithHostName: (NSString*) hostName;
{
	ARCReachability* retVal = NULL;
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
	if(reachability!= NULL)
	{
		retVal= [[self alloc] init];
		if(retVal!= NULL)
		{
			retVal->reachabilityRef_ = reachability;
			retVal->localWiFiRef_ = NO;
		}
	}
	return retVal;
}

+ (ARCReachability*)reachabilityForInternetConnection;
{
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	return [self reachabilityWithAddress: &zeroAddress];
}

+ (ARCReachability*)reachabilityForLocalWiFi;
{
	struct sockaddr_in localWifiAddress;
	bzero(&localWifiAddress, sizeof(localWifiAddress));
	localWifiAddress.sin_len = sizeof(localWifiAddress);
	localWifiAddress.sin_family = AF_INET;
    
	// IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
	localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
	ARCReachability* retVal = [self reachabilityWithAddress: &localWifiAddress];
	if(retVal!= NULL)
	{
		retVal->localWiFiRef_ = YES;
	}
	return retVal;
}


- (ARCNetworkStatus)networkStatus {
	NSAssert(reachabilityRef_ != NULL, @"currentNetworkStatus called with NULL reachabilityRef");
    
	ARCNetworkStatus status = ARCReachabilityNotReachable;
	SCNetworkReachabilityFlags flags;
	
	if (!self.reachabilityEstablished) {
        NIDINFO(@"ARC Reachability %@ has not yet established reachability. networkStatus = %@", self, @"ReachabilityIndeterminate");
		return ARCReachabilityIndeterminate;
	}
	
	if (SCNetworkReachabilityGetFlags(reachabilityRef_, &flags)) {
        
		if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
			// if target host is not reachable
            //RKLogTrace(@"Reachability observer %@ determined networkStatus = %@", self, @"RKReachabilityNotReachable");
			return ARCReachabilityNotReachable;
		}
		
		if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
			// if target host is reachable and no connection is required
			//  then we'll assume (for now) that your on Wi-Fi
			//RKLogTrace(@"Reachability observer %@ determined networkStatus = %@", self, @"RKReachabilityReachableViaWiFi");
            status = ARCReachabilityReachableViaWiFi;
		}
		
		
		if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
			 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
			// ... and the connection is on-demand (or on-traffic) if the
			//     calling application is using the CFSocketStream or higher APIs
			
			if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
				// ... and no [user] intervention is needed
				status = ARCReachabilityReachableViaWiFi;
                //RKLogTrace(@"Reachability observer %@ determined networkStatus = %@", self, @"RKReachabilityReachableViaWiFi");
			}
		}
        
#if TARGET_OS_IPHONE
		if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
			// ... but WWAN connections are OK if the calling application
			//     is using the CFNetwork (CFSocketStream?) APIs.
			status = ARCReachabilityReachableViaWWAN;
            //RKLogTrace(@"Reachability observer %@ determined networkStatus = %@", self, @"RKReachabilityReachableViaWWAN");
		}
#endif
	}
    
	return status;	
}

- (BOOL)isNetworkReachable {
    BOOL reachable = (ARCReachabilityNotReachable != [self networkStatus]);
    
    NIDINFO(@"Reachability observer %@ determined isNetworkReachable = %d", self, reachable);
	
    return reachable;
}

- (BOOL)isConnectionRequired {
	NSAssert(reachabilityRef_ != NULL, @"connectionRequired called with NULL reachabilityRef");
	
    SCNetworkReachabilityFlags flags;
    BOOL required = NO;
	if (SCNetworkReachabilityGetFlags(reachabilityRef_, &flags)) {
        required = (flags & kSCNetworkReachabilityFlagsConnectionRequired);        
	}
    
    NIDINFO(@"Reachability observer %@ determined isConnectionRequired = %d", self, required);
	return required;
}



#pragma mark Observer scheduling

- (void)scheduleObserver {    
	SCNetworkReachabilityContext context = {0, (__bridge_retained void *)self, NULL, NULL, NULL};
    
    NIDINFO(@"Scheduling reachability observer %@ in current run loop", self);
	if (! SCNetworkReachabilitySetCallback(reachabilityRef_, ReachabilityCallback, &context)) {
        return;
    }
    if (!SCNetworkReachabilitySetDispatchQueue(reachabilityRef_, dispatch_get_current_queue())) {
        return;
    }
}

- (void)unscheduleObserver {    
	if (reachabilityRef_) {
        NIDINFO(@"%@: Unscheduling reachability observer from current run loop", self);
        if (!SCNetworkReachabilitySetDispatchQueue(reachabilityRef_, NULL)) {
			return;
		}
	} else {
        NIDWARNING(@"%@: Failed to unschedule reachability observer %@: reachability reference is nil.", self, reachabilityRef_);
    }
}

- (BOOL)reachabilityEstablished {
    return reachabilityEstablished_;
}

- (void)setReachabilityEstablished:(BOOL)reachabilityEstablished {
    reachabilityEstablished_ = reachabilityEstablished;
    [[NSNotificationCenter defaultCenter] postNotificationName:ARCReachabilityStateWasDeterminedNotification object:self];
}

@end
