//
//  ToDoItem.h
//  ToDoneIt
//
//  Created by Don Messerli on 12/6/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ToDoList;

@interface ToDoItem : NSObject

- (id)initWithDictionary:(NSDictionary*)dict;

+ (id)createItemWithDescription:(NSString*)description inList:(ToDoList*)list;

- (NSInteger)getID;
- (void)setID:(NSInteger)itemID;
- (NSString*)getDescription;
- (NSInteger)getListID;
- (void)setListID:(NSInteger)listID;

- (BOOL)isCompleted;
- (void)setCompleted:(BOOL)isComplete;
@end
