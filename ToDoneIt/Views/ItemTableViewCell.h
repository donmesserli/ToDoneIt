//
//  ItemTableViewCell.h
//  ToDoneIt
//
//  Created by Don Messerli on 12/7/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToDoItem;

@interface ItemTableViewCell : UITableViewCell
{
    ToDoItem *item;
}
@property (nonatomic,strong) ToDoItem *item;
@end
