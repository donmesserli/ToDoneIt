//
//  DataStore.m
//  ToDoneIt
//
//  Created by Don Messerli on 12/8/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import "DataStore.h"

// Since there is no such thing as an abstract class in Objective-C, we need to throw exceptions if methods are called.

#define mustOverride() @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil]

#define methodNotImplemented() mustOverride()

@implementation DataStore

- (void)addList:(ToDoList*)list
{
    mustOverride();
}

- (void)deleteList:(ToDoList*)list
{
    mustOverride();
}

- (void)addItem:(ToDoItem*)item
{
    mustOverride();
}

- (void)updateItem:(ToDoItem*)item
{
    mustOverride();
}

- (void)deleteItem:(ToDoItem*)item
{
    mustOverride();
}
@end
