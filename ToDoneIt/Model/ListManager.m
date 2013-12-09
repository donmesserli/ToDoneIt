//
//  ListManager.m
//  ToDoneIt
//
//  Created by Don Messerli on 12/6/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import "ListManager.h"

#import "LocalDataStore.h"
#import "RESTDataStore.h"

@interface ListManager ()
@property (nonatomic, strong) LocalDataStore *localData;
@property (nonatomic, strong) RESTDataStore *restData;
@end

@implementation ListManager

+ (ListManager*)sharedInstance
{
    static ListManager *instance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        instance = [[ListManager alloc] init];
    });
    
    return instance;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        _localData = [[LocalDataStore alloc] init];
        _restData = [[RESTDataStore alloc] init];
    }
    
    return self;
}

- (ToDoList*)addList:(NSString*)name
{
    ToDoList *list = [ToDoList createWithName:name];
    [_localData addList:list];
    [_restData addList:list];
    
    return list;
}

- (void)deleteList:(ToDoList*)list
{
    [_localData deleteList:list];
    [_restData deleteList:list];
}

- (NSArray*)getLists
{
    return [_localData getLists];
}

- (void)addItemToStorage:(ToDoItem*)item
{
    [_localData addItem:item];
    [_restData addItem:item];
}

- (void)deleteItemFromStorage:(ToDoItem*)item
{
    [_localData deleteItem:item];
    [_restData deleteItem:item];
}

- (void)updateItemInStorage:(ToDoItem*)item
{
    [_localData updateItem:item];
    [_restData updateItem:item];
}

- (BOOL)listExistsWithName:(NSString*)name
{
    NSArray *lists = [_localData getLists];
    
    for (ToDoList *list in lists) {
        if ([name isEqualToString:[list getName]]) return YES;
    }
    
    return NO;
}
@end
