//
//  AddItemViewController.h
//  ToDoneIt
//
//  Created by Don Messerli on 12/8/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToDoList;

@interface AddItemViewController : UIViewController
@property (nonatomic, weak) ToDoList *list;
@end
