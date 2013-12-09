//
//  RESTDataStore.m
//  ToDoneIt
//
//  Created by Don Messerli on 12/6/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import "RESTDataStore.h"

#import "ToDoList.h"
#import "ToDoItem.h"

#import "AddListOperation.h"
#import "DeleteListOperation.h"
#import "AddItemOperation.h"
#import "UpdateItemOperation.h"
#import "DeleteItemOperation.h"

@interface RESTDataStore ()
@property (nonatomic, strong) NSOperationQueue *queue;
@end

@implementation RESTDataStore

- (id)init
{
    self = [super init];
    
    if (self) {
        _queue = [[NSOperationQueue alloc] init];
		[_queue setMaxConcurrentOperationCount:1];
    }
    
    return self;
}

- (void)cancelOutstandingOperations
{
	[_queue cancelAllOperations];
}

- (void)pauseOperations
{
	[_queue setSuspended:YES];
}

- (void)restartOperations
{
	[_queue setSuspended:NO];
}

- (void)addList:(ToDoList*)list
{
    AddListOperation *op = [[AddListOperation alloc] initWithList:list];
    op.dataStore = self;
    [_queue addOperation:op];
}

- (void)deleteList:(ToDoList*)list
{
    DeleteListOperation *op = [[DeleteListOperation alloc] initWithList:list];
    op.dataStore = self;
    [_queue addOperation:op];
}

- (void)addItem:(ToDoItem*)item
{
    AddItemOperation *op = [[AddItemOperation alloc] initWithItem:item];
    op.dataStore = self;
    [_queue addOperation:op];
}

- (void)updateItem:(ToDoItem*)item;
{
    UpdateItemOperation *op = [[UpdateItemOperation alloc] initWithItem:item];
    op.dataStore = self;
    [_queue addOperation:op];
}

- (void)deleteItem:(ToDoItem*)item
{
    DeleteItemOperation *op = [[DeleteItemOperation alloc] initWithItem:item];
    op.dataStore = self;
    [_queue addOperation:op];
}

@end
