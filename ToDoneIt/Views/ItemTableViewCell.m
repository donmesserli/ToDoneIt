//
//  ItemTableViewCell.m
//  ToDoneIt
//
//  Created by Don Messerli on 12/7/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import "ItemTableViewCell.h"

#import "ToDoItem.h"

@interface ItemTableViewCell ()

@end

@implementation ItemTableViewCell

@synthesize item;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setItem:(ToDoItem*)item_
{
    item = item_;
    
    self.textLabel.text = [item getDescription];
    
    if ([item isCompleted]) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }

    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
