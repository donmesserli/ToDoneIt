//
//  SingleListViewController.h
//  ToDoneIt
//
//  Created by Don Messerli on 12/6/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToDoList;

@interface SingleListViewController : UITableViewController

- (void)setList:(ToDoList*)list;
@end
