//
//  ToDoneItOperation.m
//  ToDoneIt
//
//  Created by Don Messerli on 12/8/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import "ToDoneItOperation.h"

#import "ASIHTTPRequest.h"

#define kHostName @"REPLACETHISWITHYOURHOSTNAME"
#define kTIMEOUTINTERVAL	30

@implementation ToDoneItOperation

- (void)sendRESTRequest:(NSString*)urlString withMethod:(NSString*)method
{
	_data = nil;
	
	// Create the request
    NSString *localURLString = [NSString stringWithFormat:@"%@%@", kHostName, urlString];
    
    // Parse out the host name from the urlString
    NSArray *parts = [localURLString componentsSeparatedByString:@"/"];
	
    NSURL *url = [NSURL URLWithString:localURLString];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	request.shouldContinueWhenAppEntersBackground = YES;
	request.requestMethod = method;
	request.shouldAttemptPersistentConnection = NO;
	[request addRequestHeader:@"User-Agent" value:@"ToDoneIt"];
	[request addRequestHeader:@"Host" value:[parts objectAtIndex:2]];
	[request addRequestHeader:@"Connection" value:@"close"];
	[ASIHTTPRequest setDefaultTimeOutSeconds:kTIMEOUTINTERVAL];
	[request setDownloadCache:nil];
    
	// Send the request
	// We send it synchronously because we are already running in the background since we are an NSOperation
    // BUGBUG - Since our RESTful API is ficticious, don't send the request
	//[request startSynchronous];
    
	_statusCode = [request responseStatusCode];
	//NSLog(@"Status Code: %d", _statusCode);
	
	NSError *error = [request error];
	if (!error) {
		//NSString *response = [request responseString];
		_data = [request responseData];
		//NSLog(@"Received %d bytes of data", [_data length]);
	} else {
		// BUGBUG - handle errors
	}
	
	if (_statusCode != 200) {
		_data = nil;
	}
}

@end
