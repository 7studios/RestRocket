//
//  LRAbstractTableModel.m
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "ARCTableModelAbstract.h"


@implementation ARCTableModelAbstract

@synthesize cellProvider;


- (id)init {
  return [self initWithCellProvider:nil];
}


- (id)initWithCellProvider:(id<ARCTableModelCellProvider>)theCellProvider {
  if (self = [super init]) {
    eventListeners = [[NSMutableArray alloc] init];
    cellProvider = theCellProvider;
  }
  return self;
}


- (void)notifyListeners:(ARCTableModelEvent *)event {
    for (id<ARCTableModelEventListener> listener in eventListeners) {
        [listener tableModelChanged:event];
    }
}


- (void)beginUpdates {
    for (id<ARCTableModelEventListener> listener in eventListeners) {
        [listener tableModelWillBeginUpdates];
    }
}


- (void)endUpdates {
    for (id<ARCTableModelEventListener> listener in eventListeners) {
        [listener tableModelDidEndUpdates];
    }
}


- (void)addTableModelListener:(id<ARCTableModelEventListener>)listener {
    [eventListeners addObject:listener];
}


- (void)removeTableModelListener:(id<ARCTableModelEventListener>)listener {
    [eventListeners removeObject:listener];
}



- (NSInteger)numberOfSections {
    return 1;
}


- (NSInteger)numberOfRowsInSection:(NSInteger)sectionIndex {
    return 0;
}


- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


- (NSString *)headerforSection:(NSInteger)section {
    return nil;
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *reuseIdentifier = @"ARCBaseCellIdentifier";
  
  if ([cellProvider respondsToSelector:@selector(cellReuseIdentifierForIndexPath:)]) {
    reuseIdentifier = [cellProvider cellReuseIdentifierForIndexPath:indexPath];
  }  
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    if ([cellProvider respondsToSelector:@selector(cellForObjectAtIndexPath:reuseIdentifier:)]) {
      cell = [cellProvider cellForObjectAtIndexPath:indexPath reuseIdentifier:reuseIdentifier];
    } else {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
  }
  [cellProvider configureCell:cell forObject:[self objectAtIndexPath:indexPath] atIndexPath:indexPath];
  
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self numberOfSections];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
  return [self numberOfRowsInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return [self headerforSection:section];
}

@end
