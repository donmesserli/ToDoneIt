//
//  ListManager.h
//  ToDoneIt
//
//  Created by Don Messerli on 12/6/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ToDoList.h"
#import "ToDoItem.h"

@interface ListManager : NSObject

+ (ListManager*)sharedInstance;

- (ToDoList*)addList:(NSString*)name;
- (void)deleteList:(ToDoList*)list;

- (NSArray*)getLists;

- (void)addItemToStorage:(ToDoItem*)item;
- (void)deleteItemFromStorage:(ToDoItem*)item;
- (void)updateItemInStorage:(ToDoItem*)item;

- (BOOL)listExistsWithName:(NSString*)name;
@end
