//
//  LocalDataStore.h
//  ToDoneIt
//
//  Created by Don Messerli on 12/6/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DataStore.h"
#import "ToDoList.h"

@interface LocalDataStore : DataStore
- (NSArray*)getLists;
@end
