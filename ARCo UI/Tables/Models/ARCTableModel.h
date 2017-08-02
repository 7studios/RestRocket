//
//  LRTableViewModel.h
//  TableViewModel
//
//  Created by Luke Redpath on 09/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ARCTableModelEventListener.h"
#import "ARCTableModelCellProvider.h"



@protocol ARCTableModel <NSObject>

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)sectionIndex;
- (NSString *)headerforSection:(NSInteger)section;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

- (void)addTableModelListener:(id<ARCTableModelEventListener>)listener;
- (void)removeTableModelListener:(id<ARCTableModelEventListener>)listener;

@end
