//
//  UpdateItemOperation.m
//  ToDoneIt
//
//  Created by Don Messerli on 12/8/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import "UpdateItemOperation.h"

@interface UpdateItemOperation ()
@property (nonatomic, strong) ToDoItem *item;

@end

@implementation UpdateItemOperation

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
	NSString *urlString = [NSString stringWithFormat:@"/RESTServices.svc/UpdateItem?id=%d&completed=%s", [_item getID], ([_item isCompleted] ? "1" : "0")];
    
    [super sendRESTRequest:urlString withMethod:@"GET"];
    
	if (super.data != nil) {
		if ([super.data length] > 0) {
            // Handle the response
		}
	}
}
@end