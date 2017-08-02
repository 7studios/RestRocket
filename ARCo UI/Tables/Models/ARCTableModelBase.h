
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

#import "ARCTableModelAbstract.h"


typedef enum {
  SortOrderUnordered = 0,
  SortOrderAscending,
  SortOrderDescending
} SortOrder;



@interface ARCTableModelBase : ARCTableModelAbstract  {
  
    NSMutableArray*     objects;
    SortOrder           sortOrder_; 
    
}


@property (nonatomic, assign) SortOrder sortOrder;


- (void)addObject:(id)anObject;
- (void)removeObject:(id)anObject;
- (void)insertObject:(id)anObject atIndex:(NSInteger)index;
- (void)replaceObjectAtIndex:(NSInteger)index withObject:(id)anObject;
- (void)setObjects:(NSArray *)newObjects;


- (void)filterObjectsWithPrefix:(NSString *)prefix;
- (void)clearSearchFilter;


@end
