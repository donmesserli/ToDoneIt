//
//  RESTDataStore.m
//  ToDoneIt
//
//  Created by Don Messerli on 12/6/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import "RESTDataStore.h"

#import "ToDoList.h"
#import "ToDoItem.h"

#import "SQLiteManager.h"

#import "Reachability.h"
#import "ASIHTTPRequest.h"

#define kMethodGET      @"GET"
#define kMethodPUT      @"PUT"
#define kMethodPOST     @"POST"
#define kMethodDELETE   @"DELETE"

#define kHostName @"REPLACETHISWITHYOURHOSTNAME"
#define kTIMEOUTINTERVAL	30

@interface RESTDataStore ()
@property (nonatomic, strong) SQLiteManager *dbManager;
@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, strong) NSCondition *sendCondition;
@property (nonatomic, assign) BOOL bNetworkReachable;
@property (nonatomic, assign) BOOL bRunning;
@end

@implementation RESTDataStore

- (id)init
{
    self = [super init];
    
    if (self) {
       _dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"todoneitevents.db"];
        
        NSError *error = [_dbManager doQuery:@"CREATE TABLE IF NOT EXISTS events (eventid INTEGER primary key autoincrement, whenadded DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, command TEXT NOT NULL, method TEXT NOT NULL, payload TEXT);"];
        if (error != nil) {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
        
        // Register for app state changes
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(goingToBackground)
													 name: @"UIApplicationDidEnterBackgroundNotification"
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(goingToBackground)
													 name: @"UIApplicationWillTerminate"
												   object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(enteringForeground)
													 name: @"UIApplicationWillEnterForegroundNotification"
												   object:nil];
		
		// watch for reachability change
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
		_reachability = [Reachability reachabilityWithHostName:kHostName];
		[_reachability startNotifier];
        
        _bNetworkReachable = [self isNetworkReachable];
        _bRunning = YES;
        
        _sendCondition = [[NSCondition alloc] init];
        
        // Start a background thread to send commands to the server
        [NSThread detachNewThreadSelector:@selector(threadMethod:) toTarget:self withObject:nil];
    }
    
    return self;
}

// NOTE - Since the lists and items already have IDs, we send them when we create the list or item
// They need to match what we have locally

- (void)addList:(ToDoList*)list
{
    NSString *urlString = @"/RESTServices.svc/lists";
    // TODO - create body
    // Fake it to avoid NSAssertion
    NSString *fake = @"FAKE";
    [self addCommandToDatabase:urlString andPayload:fake withMethod:kMethodPOST];
}

- (void)deleteList:(ToDoList*)list
{
    NSString *urlString = [NSString stringWithFormat:@"/RESTServices.svc/DeleteList?listname=%@&id=%d", [list getName], [list getID]];
    [self addCommandToDatabase:urlString andPayload:nil withMethod:kMethodDELETE];
}

- (void)addItem:(ToDoItem*)item
{
	NSString *urlString = [NSString stringWithFormat:@"/RESTServices.svc/lists/%d/items", [item getListID]];
    // TODO - create body
    // Fake it to avoid NSAssertion
    NSString *fake = @"FAKE";
    [self addCommandToDatabase:urlString  andPayload:fake withMethod:kMethodPOST];
}

- (void)updateItem:(ToDoItem*)item;
{
    NSString *urlString = [NSString stringWithFormat:@"/RESTServices.svc/lists/%d/items/%d", [item getListID], [item getID]];
    // TODO - create body
    // Fake it to avoid NSAssertion
    NSString *fake = @"FAKE";
    [self addCommandToDatabase:urlString  andPayload:fake withMethod:kMethodPUT];
}

- (void)deleteItem:(ToDoItem*)item
{
    NSString *urlString = [NSString stringWithFormat:@"/RESTServices.svc/lists/%d/items/%d", [item getListID], [item getID]];
    [self addCommandToDatabase:urlString  andPayload:nil withMethod:kMethodDELETE];
}

- (void)addCommandToDatabase:(NSString*)command andPayload:(NSString*)payload withMethod:(NSString*)method;
{
    // Even though the HTTP spec doesn't preclude these situations, we will for now
    NSAssert(!([method isEqualToString:kMethodGET] && payload != nil), @"GET with a body is not allowed");
    NSAssert(!([method isEqualToString:kMethodDELETE] && payload != nil), @"DELETE with a body is not allowed");
    NSAssert(!([method isEqualToString:kMethodPOST] && payload == nil), @"POST without a body is not allowed");
    // Might have to remove this based on the REST implementation
    NSAssert(!([method isEqualToString:kMethodPUT] && payload == nil), @"PUT without a body is not allowed");
    
    NSArray *params = [NSArray arrayWithObjects:command, method, payload, nil];
    NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO events (command, method, payload) values (?,?,?);"];
    
    @synchronized(self) {
        NSError *error = [_dbManager doUpdateQuery:sqlStr withParams:params];
        if (error != nil) {
            NSLog(@"Error: %@",[error localizedDescription]);
        }
    }
}

- (void)threadMethod:(NSObject*)object
{
    for (;;) {
        [_sendCondition lock];
        
        while (!_bRunning || !_bNetworkReachable) [_sendCondition wait];
        
        [self nextCommand];
        
        [_sendCondition unlock];
    }
}

- (void)nextCommand
{
    NSArray *array = nil;
    
    // Get the command from the database
    @synchronized(self) {
        NSString *sqlStr = @"SELECT * FROM events ORDER BY whenadded LIMIT 1";
        array = [_dbManager getRowsForQuery:sqlStr];
    }
    
    if (array && array.count == 1) {
        NSDictionary *dict = [array objectAtIndex:0];
        
        NSInteger eventID = [[dict objectForKey:@"eventid"] integerValue];
        NSString *command = [dict objectForKey:@"command"];
        NSString *payload = [dict objectForKey:@"payload"];
        if ([payload isEqual:[NSNull null]]) payload = nil;
        NSString *method = [dict objectForKey:@"method"];
        
        if ([self sendCommand:command andPayload:payload withMethod:method]) {
            // Success, remove the event from the database
            @synchronized(self) {
                NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM events WHERE eventid=%d", eventID];
                NSError *error = [_dbManager doQuery:sqlStr];
                if (error != nil) {
                    NSLog(@"Error: %@",[error localizedDescription]);
                }
            }
        }
    }
}

- (BOOL)sendCommand:(NSString*)command andPayload:(NSString*)payload withMethod:(NSString*)method
{
    BOOL bReturn = YES;
    NSData *data = nil;
    
    // Create the request
    NSString *localURLString = [NSString stringWithFormat:@"%@%@", kHostName, command];
    
    // Parse out the host name from the urlString
    NSArray *parts = [localURLString componentsSeparatedByString:@"/"];

    NSURL *url = [NSURL URLWithString:localURLString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:method];
    if (payload != nil) {
        [request setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    [request setTimeoutInterval:kTIMEOUTINTERVAL];
    [request setValue:@"ToDoneIt" forHTTPHeaderField:@"User-Agent"];
    [request setValue:[parts objectAtIndex:2] forHTTPHeaderField:@"Host"];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    // Send the request
    // We send it synchronously because we are already running in the background
    // BUGBUG - Since our RESTful API is ficticious, don't send the request
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Did we fail?
    if (error || ![response respondsToSelector:@selector(statusCode)]) {
        bReturn = NO;
    } else {
        // TODO - handle response data
    }

    // Since we aren't actually sending the commands, just say we did
    // BUGBUG return bReturn;
    return YES;
}

#pragma mark --
#pragma mark Application State
#pragma mark --

- (void)goingToBackground
{
    _bRunning = NO;
}

- (void)enteringForeground
{
    _bRunning = YES;
}

#pragma mark --
#pragma mark Reachability
#pragma mark --

- (void)reachabilityChanged:(NSNotification*)note
{
    _bNetworkReachable = ([_reachability currentReachabilityStatus] != NotReachable);
}

- (BOOL)isNetworkReachable
{
	return ([_reachability currentReachabilityStatus] != NotReachable);
}

@end
