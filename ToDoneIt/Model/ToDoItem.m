//
//  ToDoItem.m
//  ToDoneIt
//
//  Created by Don Messerli on 12/6/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import "ToDoItem.h"

#import "ToDoList.h"
#import "ListManager.h"

@interface ToDoItem ()
@property (nonatomic, strong) NSString *description;
@property (nonatomic, assign) NSInteger itemID;
@property (nonatomic, assign) NSInteger listID;
@property (nonatomic, assign) BOOL completed;
@end

@implementation ToDoItem

- (id)init
{
    self = [super init];
    
    if (self) {
        _completed = NO;
    }
    
    return self;
}

+ (id)createItemWithDescription:(NSString*)description inList:(ToDoList*)list
{
    ToDoItem *item = [[ToDoItem alloc] init];
    
    if (item) {
        item.description = description;
        item.listID = [list getID];
    }
    
    [list addItem:item];
    
    return item;
}

- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [self init];
    
    if (self) {
        if (dict) {
            _itemID = [[dict objectForKey:@"itemid"] integerValue];
            _description = [dict objectForKey:@"description"];
            _listID = [[dict objectForKey:@"list"] integerValue];
            _completed = [[dict objectForKey:@"completed"] boolValue];
        }
    }
    
    return self;
}

- (NSInteger)getID
{
    return _itemID;
}

- (void)setID:(NSInteger)itemID
{
    _itemID = itemID;
}

- (NSString*)getDescription
{
    return _description;
}

- (NSInteger)getListID
{
    return _listID;
}

- (void)setListID:(NSInteger)listID
{
    _listID = listID;
}

- (BOOL)isCompleted
{
    return _completed;
}

- (void)setCompleted:(BOOL)isComplete
{
    _completed = isComplete;
    
    [[ListManager sharedInstance] updateItemInStorage:self];
}

@end
