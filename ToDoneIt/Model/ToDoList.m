//
//  ToDoList.m
//  ToDoneIt
//
//  Created by Don Messerli on 12/6/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import "ToDoList.h"

#import "ListManager.h"

#define kCompletedKey @"completed"

@interface ToDoList ()
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger listID;
@property (nonatomic, assign) NSInteger itemsCompleted;
@end

@implementation ToDoList

- (id)init
{
    self = [super init];
    
    if (self) {
        _items = [NSMutableArray array];
        _itemsCompleted = 0;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [self init];
    
    if (self) {
        if (dict) {
            _listID = [[dict objectForKey:@"listid"] integerValue];
            _name = [dict objectForKey:@"name"];
        }
    }
    
    return self;
}

- (void)addItemFromDictionary:(NSDictionary*)dict
{
    ToDoItem *item = [[ToDoItem alloc] initWithDictionary:dict];
    if (item) {
        [_items addObject:item];
        if ([item isCompleted]) _itemsCompleted++;
        [item addObserver:self
                  forKeyPath:kCompletedKey
                     options:(NSKeyValueObservingOptionNew |
                              NSKeyValueObservingOptionOld)
                     context:NULL];
    }
}

+ (id)createWithName:(NSString*)name
{
    ToDoList *list = [[ToDoList alloc] init];
    
    if (list) {
        list.name = name;
    }
    
    return list;
}

- (void)addItem:(ToDoItem*)item
{
    [item setListID:_listID];
    [_items addObject:item];
    if ([item isCompleted]) _itemsCompleted++;
    [[ListManager sharedInstance] addItemToStorage:item];
    [item addObserver:self
           forKeyPath:kCompletedKey
              options:(NSKeyValueObservingOptionNew |
                       NSKeyValueObservingOptionOld)
              context:NULL];
}

- (void)deleteItem:(ToDoItem*)item
{
    [[ListManager sharedInstance] deleteItemFromStorage:item];
    if ([item isCompleted]) _itemsCompleted--;
    [item removeObserver:self forKeyPath:kCompletedKey context:NULL];
    [_items removeObject:item];
}

- (NSArray*)getItems
{
    return _items;
}

- (NSInteger)getID
{
    return _listID;
}

- (void)setID:(NSInteger)listID
{
    _listID = listID;
}

- (NSString*)getName
{
    return _name;
}

- (NSInteger)getItemsCompleted
{
    return _itemsCompleted;
}

- (NSInteger)getNumItems
{
    return [_items count];
}

- (BOOL)itemExistsWithDescription:(NSString*)description
{
    for (ToDoItem *item in _items) {
        if ([description isEqualToString:[item getDescription]]) return YES;
    }
    
    return NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kCompletedKey]) {
        BOOL old = [[change objectForKey:@"old"] boolValue];
        BOOL new = [[change objectForKey:@"new"] boolValue];
        
        if (old != new) {
            if (new) {
                _itemsCompleted++;
            } else {
                _itemsCompleted--;
            }
        }
    }
}
@end
