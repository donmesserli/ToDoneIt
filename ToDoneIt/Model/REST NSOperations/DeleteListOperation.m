//
//  DeleteListOperation.m
//  ToDoneIt
//
//  Created by Don Messerli on 12/8/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import "DeleteListOperation.h"

@interface DeleteListOperation ()
@property (nonatomic, strong) ToDoList *list;

@end

@implementation DeleteListOperation

- (id)initWithList:(ToDoList*)list
{
    if (self = [super init]) {
		_list = list;
	}
	
	return self;
}

- (void)main
{
	NSString *urlString = [NSString stringWithFormat:@"/RESTServices.svc/DeleteList?listname=%@&id=%d", [_list getName], [_list getID]];
    
    [super sendRESTRequest:urlString withMethod:@"GET"];
    
	if (super.data != nil) {
		if ([super.data length] > 0) {
            // Handle the response
		}
	}
}
@end
