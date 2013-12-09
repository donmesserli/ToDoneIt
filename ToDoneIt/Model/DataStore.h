//
//  DataStore.h
//  ToDoneIt
//
//  Created by Don Messerli on 12/8/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ToDoItem.h"
#import "ToDoList.h"

@interface DataStore : NSObject
- (void)addList:(ToDoList*)list;
- (void)deleteList:(ToDoList*)list;

- (void)addItem:(ToDoItem*)item;
- (void)updateItem:(ToDoItem*)item;
- (void)deleteItem:(ToDoItem*)item;
@end
