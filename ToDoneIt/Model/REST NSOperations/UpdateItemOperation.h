//
//  UpdateItemOperation.h
//  ToDoneIt
//
//  Created by Don Messerli on 12/8/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import "ToDoneItOperation.h"

@class ToDoItem;

@interface UpdateItemOperation : ToDoneItOperation

- (id)initWithItem:(ToDoItem*)item;
@end
