//
//  ARCRouter+ARCRouter_Store.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARCRouter.h"
#import "ARCStoreRecord.h"


@interface ARCStoreRecord (Router)


+ (ARCRouterMap*)mapForRequestMethod:(ARCRequestMethod)method;

@end
