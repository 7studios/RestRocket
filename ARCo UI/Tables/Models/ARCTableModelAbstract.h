//
//  LRAbstractTableModel.h
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ARCTableModel.h"


@class ARCTableModel;
@class ARCTableModelCellProvider;
@class ARCTableModelEvent;


@interface ARCTableModelAbstract : NSObject <ARCTableModel, UITableViewDataSource> {
    
    NSMutableArray*                   eventListeners;
    id<ARCTableModelCellProvider>     cellProvider;

}


@property (nonatomic, strong) id<ARCTableModelCellProvider> cellProvider;


- (id)initWithCellProvider:(id<ARCTableModelCellProvider>)theCellProvider;
- (void)notifyListeners:(ARCTableModelEvent *)event;
- (void)beginUpdates;
- (void)endUpdates;

@end
