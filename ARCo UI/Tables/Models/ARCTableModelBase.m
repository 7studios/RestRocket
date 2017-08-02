
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


#import "ARCTableModelBase.h"
#import "ARCTableModelEvent.h"



@interface ARCTableModelBase ()
- (NSArray *)sortedObjects;
@end



@implementation ARCTableModelBase

@synthesize sortOrder = sortOrder_;



- (id)initWithCellProvider:(id<ARCTableModelCellProvider>)theCellProvider;
{
    if (self = [super initWithCellProvider:theCellProvider]) {
        objects = [[NSMutableArray alloc] init];
        sortOrder_ = SortOrderUnordered;
    }
    return self;
}


- (NSArray *)sortedObjects {
    if (sortOrder_ == SortOrderUnordered) {
        return objects;
    }
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:(sortOrder_ == SortOrderAscending)];
    
    return [objects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}


- (void)setSortOrder:(SortOrder)newSortOrder {
    sortOrder_ = newSortOrder;
    [self notifyListeners:[ARCTableModelEvent refreshedData]];
}


- (void)addObject:(id)anObject {
    [objects addObject:anObject];

    NSInteger indexOfNewObject = [objects indexOfObject:anObject];
    [self notifyListeners:[ARCTableModelEvent insertionAtRow:indexOfNewObject section:0]];
}


- (void)removeObject:(id)anObject {
    NSInteger indexOfObject = [objects indexOfObject:anObject];

    [objects removeObject:anObject];
    [self notifyListeners:[ARCTableModelEvent deletedRow:indexOfObject section:0]];
}


- (void)replaceObjectAtIndex:(NSInteger)index withObject:(id)anObject {
    
    [objects replaceObjectAtIndex:index withObject:anObject];

    [self notifyListeners:[ARCTableModelEvent updatedRow:index section:0]];
}

- (void)setObjects:(NSArray *)newObjects {
    
    [objects removeAllObjects];
    [objects setArray:newObjects];
    [self notifyListeners:[ARCTableModelEvent refreshedData]];
}


- (void)insertObject:(id)anObject atIndex:(NSInteger)index;
{
    [objects insertObject:anObject atIndex:index];
    [self notifyListeners:[ARCTableModelEvent insertionAtRow:index section:0]];
}

- (void)filterObjectsWithPrefix:(NSString *)prefix {
    //** sub classes override
}

- (void)clearSearchFilter {
    //** sub classes override
}

#pragma mark -
#pragma mark ARCTableModel methods

- (NSInteger)numberOfRowsInSection:(NSInteger)sectionIndex;
{
    return [objects count]; 
}


- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
{
    return [[self sortedObjects] objectAtIndex:indexPath.row];
}

@end
