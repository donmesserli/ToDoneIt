//
//  AddItemOperation.m
//  ToDoneIt
//
//  Created by Don Messerli on 12/8/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import "AddItemOperation.h"

#import "ToDoItem.h"

@interface AddItemOperation ()
@property (nonatomic, strong) ToDoItem *item;

@end

@implementation AddItemOperation

- (id)initWithItem:(ToDoItem*)item
{
    if (self = [super init]) {
		_item = item;
	}
	
	return self;
}

/*
 @property (nonatomic, strong) NSDate *creationDate;
 @property (nonatomic, strong) NSDate *completionDate;
 */

- (void)main
{
	NSString *urlString = [NSString stringWithFormat:@"/RESTServices.svc/AddItem?desc=%@&id=%d&listid=%d&completed=%s", [_item getDescription], [_item getID], [_item getListID], ([_item isCompleted] ? "1" : "0")];
    
    [super sendRESTRequest:urlString withMethod:@"GET"];
    
	
	if (super.data != nil) {
		if ([super.data length] > 0) {
            // Handle the response
		}
	}
}
@end