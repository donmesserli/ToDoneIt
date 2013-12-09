//
//  LocalDataStore.m
//  ToDoneIt
//
//  Created by Don Messerli on 12/6/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import "LocalDataStore.h"

#import "SQLiteManager.h"
#import "ListManager.h"

@interface LocalDataStore ()
@property (nonatomic, strong) SQLiteManager *dbManager;
@property (nonatomic, strong) NSMutableArray *lists;
@end

@implementation LocalDataStore

- (id)init
{
    self = [super init];
    
    if (self) {
        _lists = [NSMutableArray array];
        
        _dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"todoneit.db"];
        
        NSError *error = [_dbManager doQuery:@"CREATE TABLE IF NOT EXISTS lists (listid INTEGER primary key autoincrement, name TEXT);"];
        if (error != nil) {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
        
        error = [_dbManager doQuery:@"CREATE TABLE IF NOT EXISTS items (itemid INTEGER primary key autoincrement, description TEXT, itemlist INTEGER NOT NULL, completed INTEGER);"];
        if (error != nil) {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
        
        NSString *sqlStr = nil;
        
        sqlStr = @"SELECT * from lists";
        NSArray *array = [_dbManager getRowsForQuery:sqlStr];
        
        for (NSDictionary *dict in array) {
            ToDoList *list = [[ToDoList alloc] initWithDictionary:dict];
            if (list) {
                [_lists addObject:list];
            }
        }

        for (ToDoList *list in _lists) {
            sqlStr = [NSString stringWithFormat:@"SELECT * FROM items WHERE itemlist=%d", [list getID]];
            array = [_dbManager getRowsForQuery:sqlStr];
            
            for (NSDictionary *dict in array) {
                [list addItemFromDictionary:dict];
            }
        }
    }
    
    return self;
}

- (void)addList:(ToDoList*)list
{
    NSArray *params = [NSArray arrayWithObject:[list getName]];
    NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO lists (name) values (?);"];
    NSError *error = [_dbManager doUpdateQuery:sqlStr withParams:params];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
        return;
    }
    
    sqlStr = [NSString stringWithFormat:@"SELECT listid FROM lists WHERE name='%@'", [list getName]];
    NSArray *array = [_dbManager getRowsForQuery:sqlStr];
    
    NSDictionary *dict = [array objectAtIndex:0];
    NSInteger listid = [[dict objectForKey:@"listid"] integerValue];
    [list setID:listid];
    [_lists addObject:list];
}

- (void)deleteList:(ToDoList*)list
{
    // Delete all the items that have the list as their foreign key.
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM items WHERE itemlist=%d", [list getID]];
    NSError *error = [_dbManager doQuery:sqlStr];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }

    
    sqlStr = [NSString stringWithFormat:@"DELETE FROM lists WHERE listid=%d", [list getID]];
    error = [_dbManager doQuery:sqlStr];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    [_lists removeObject:list];
}

- (void)addItem:(ToDoItem*)item
{
    NSArray *params = [NSArray arrayWithObjects:[item getDescription], [NSNumber numberWithInt:[item getListID]], [NSNumber numberWithBool:[item isCompleted]], nil];
    NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO items (description, itemlist, completed) values (?,?,?);"];
    NSError *error = [_dbManager doUpdateQuery:sqlStr withParams:params];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
    
    sqlStr = [NSString stringWithFormat:@"SELECT itemid FROM items WHERE description='%@'", [item getDescription]];
    NSArray *array = [_dbManager getRowsForQuery:sqlStr];
    
    NSDictionary *dict = [array objectAtIndex:0];
    NSInteger itemid = [[dict objectForKey:@"itemid"] integerValue];
    [item setID:itemid];
}

- (void)updateItem:(ToDoItem*)item
{
    NSArray *params = [NSArray arrayWithObjects:[NSNumber numberWithBool:[item isCompleted]], [NSNumber numberWithInt:[item getID]], nil];
    NSString *sqlStr = [NSString stringWithFormat:@"UPDATE items SET completed=? WHERE itemid=?"];
    NSError *error = [_dbManager doUpdateQuery:sqlStr withParams:params];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
}

- (void)deleteItem:(ToDoItem*)item
{
    NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM items WHERE itemid=%d", [item getID]];
    NSError *error = [_dbManager doQuery:sqlStr];
    if (error != nil) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
}

- (NSArray*)getLists
{
    return _lists;
}
@end
