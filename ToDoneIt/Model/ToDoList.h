//
//  ToDoList.h
//  ToDoneIt
//
//  Created by Don Messerli on 12/6/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ToDoItem.h"

@interface ToDoList : NSObject

- (NSInteger)getID;
- (void)setID:(NSInteger)listID;
- (NSString*)getName;

- (void)addItem:(ToDoItem*)item;
- (void)deleteItem:(ToDoItem*)item;
- (NSArray*)getItems;

- (void)addItemFromDictionary:(NSDictionary*)dict;
- (id)initWithDictionary:(NSDictionary*)dict;

+ (id)createWithName:(NSString*)name;

- (NSInteger)getNumItems;
- (NSInteger)getItemsCompleted;

- (BOOL)itemExistsWithDescription:(NSString*)description;
@end
