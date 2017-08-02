//
//  UIView+ARCInfoView.h
//  ARCo Example
//
//  Created by GREGORY GENTLING on 9/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARCGlobalCommon.h"



typedef enum {    
    ARCInfoPanelTypeInfo,
    ARCInfoPanelTypeError
} ARCInfoPanelType;


// keys used in the dictionary-representation of a status message
#define kARCPanelTitleKey		@"MessageTitle"
#define kARCPanelSubjectKey		@"MessageSubject"
#define kARCPanelTypeKey		@"MessageType"
#define kARCPanelHideAfterKey	@"MessageHideAfter"


@interface UIView (ARCBlocks)



@end
