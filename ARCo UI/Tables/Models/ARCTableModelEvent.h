//
//  LRTableModelEvent.h
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  ARCTableModelInsertRowEvent = 0,
  ARCTableModelUpdateRowEvent,
  ARCTableModelDeleteRowEvent,
  ARCTableModelRefreshDataEvent
} ARCTableModelEventType;



@interface ARCTableModelEvent : NSObject {
    
  ARCTableModelEventType    type;
  NSIndexPath*              indexPath;
    
}


@property (nonatomic, readonly) ARCTableModelEventType type;
@property (nonatomic, readonly) NSIndexPath *indexPath;


+ (id)insertionAtRow:(NSInteger)row section:(NSInteger)section;
+ (id)updatedRow:(NSInteger)row section:(NSInteger)section;
+ (id)deletedRow:(NSInteger)row section:(NSInteger)section;
+ (id)refreshedData;


- (id)initWithEventType:(ARCTableModelEventType)eventType indexPath:(NSIndexPath *)theIndexPath;
- (BOOL)isEqualToEvent:(ARCTableModelEvent *)otherEvent;

- (NSArray *)indexPaths;


@end
