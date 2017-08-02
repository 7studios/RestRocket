//
//  SearchTableModel.h
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCTableModelBase.h"


@interface ARCSearchTableModel : ARCTableModelBase {
    
    NSArray*        filteredObjects_;
    
}

@property (nonatomic, strong) NSArray* filteredObjects;


@end
