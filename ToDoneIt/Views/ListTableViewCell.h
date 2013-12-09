//
//  ListTableViewCell.h
//  ToDoneIt
//
//  Created by Don Messerli on 12/7/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToDoList;

@interface ListTableViewCell : UITableViewCell
{
    ToDoList *list;
}
@property (nonatomic, strong) ToDoList *list;
@end
