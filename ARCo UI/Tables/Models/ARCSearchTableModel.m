//
//  SearchTableModel.m
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "ARCSearchTableModel.h"
#import "ARCTableCellObject.h"



@interface ARCSearchTableModel ()
    - (NSArray *)activeCollection;
@end




@implementation ARCSearchTableModel

@synthesize filteredObjects = filteredObjects_;



- (id)init {
    if (self = [super init]) {
        filteredObjects_ = nil;
    }
    return self;
}



NSPredicate *predicateForPrefix(NSString *prefix) {
    return [NSPredicate predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings) {
        return [[(ARCTableCellObject *)evaluatedObject title] hasPrefix:prefix];
    }];
}


- (NSArray *)activeCollection {
    if (filteredObjects_ != nil) {
        return filteredObjects_;
    }
    return objects;
}


- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return [[self activeCollection] count];
}


- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [[self activeCollection] objectAtIndex:indexPath.row];
}


- (void)filterObjectsWithPrefix:(NSString *)prefix {
    filteredObjects_ = [objects filteredArrayUsingPredicate:predicateForPrefix(prefix)];
    
    [self notifyListeners:[ARCTableModelEvent refreshedData]];
}


- (void)clearSearchFilter {
  filteredObjects_ = nil;
  [self notifyListeners:[ARCTableModelEvent refreshedData]];
}



@end
