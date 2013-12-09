//
//  ListTableViewCell.m
//  ToDoneIt
//
//  Created by Don Messerli on 12/7/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import "ListTableViewCell.h"

#import "ToDoList.h"

@implementation ListTableViewCell

@synthesize list;

- (void)setList:(ToDoList *)list_
{
    list = list_;
    
    self.textLabel.text = [list getName];
    self.detailTextLabel.text = [NSString stringWithFormat:@"%d items / %d completed", [list getNumItems], [list getItemsCompleted]];
    [self setNeedsLayout];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
            self.detailTextLabel.text = @"Test";
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
