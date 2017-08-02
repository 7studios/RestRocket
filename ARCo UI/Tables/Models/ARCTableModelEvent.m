//
//  LRTableModelEvent.m
//  TableViewModel
//
//  Created by Luke Redpath on 10/08/2010.
//  Copyright 2010 LJR Software Limited. All rights reserved.
//

#import "ARCTableModelEvent.h"


@implementation ARCTableModelEvent

@synthesize type;
@synthesize indexPath;



- (id)initWithEventType:(ARCTableModelEventType)eventType indexPath:(NSIndexPath *)theIndexPath {
    
    if (self = [super init]) {
        type = eventType;
        indexPath = theIndexPath;
    }
    return self;
}


- (NSArray *)indexPaths {
    return [NSArray arrayWithObject:indexPath];
}


- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    return [self isEqualToEvent:object];
}


- (BOOL)isEqualToEvent:(ARCTableModelEvent *)otherEvent {
    if (self.indexPath == nil) {
        return self.type == otherEvent.type;
    }

    return [otherEvent.indexPath isEqual:self.indexPath] && otherEvent.type == self.type;
}


+ (id)insertionAtRow:(NSInteger)row section:(NSInteger)section;
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    return [[self alloc] initWithEventType:ARCTableModelInsertRowEvent indexPath:indexPath];
}

+ (id)updatedRow:(NSInteger)row section:(NSInteger)section;
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    return [[self alloc] initWithEventType:ARCTableModelUpdateRowEvent indexPath:indexPath];
}

+ (id)deletedRow:(NSInteger)row section:(NSInteger)section;
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    return [[self alloc] initWithEventType:ARCTableModelDeleteRowEvent indexPath:indexPath];
}

+ (id)refreshedData;
{
    return [[self alloc] initWithEventType:ARCTableModelRefreshDataEvent indexPath:nil];
}


- (NSString *)description {
    
    NSString *eventType = nil;
    
    switch (self.type) {
        case ARCTableModelInsertRowEvent:
            eventType = @"ARCTableModelInsertRowEvent";
            break;
            
        case ARCTableModelUpdateRowEvent:
            eventType = @"ARCTableModelUpdateRowEvent";
            break;
            
        case ARCTableModelDeleteRowEvent:
            eventType = @"ARCTableModelDeleteRowEvent";
            break;
            
        case ARCTableModelRefreshDataEvent:
            eventType = @"ARCTableModelRefreshDataEvent";
            break;
            
        default:
            eventType = @"UnknownEventType";
            break;
            
    }
    
    return [NSString stringWithFormat:@"%@ atIndexPath:{%d, %d}", eventType, self.indexPath.section, self.indexPath.row];
}   


@end
