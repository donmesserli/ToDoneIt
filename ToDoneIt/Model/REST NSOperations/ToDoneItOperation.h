//
//  ToDoneItOperation.h
//  ToDoneIt
//
//  Created by Don Messerli on 12/8/13.
//  Copyright (c) 2013 Don Messerli. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RESTDataStore.h"

// Keys for NSDictionary returned from sendRESTRequest:
#define KStatusCode @"StatusCode"
#define kData @"Data"

@interface ToDoneItOperation : NSOperation

- (void)sendRESTRequest:(NSString*)urlString withMethod:(NSString*)method;

@property (nonatomic, strong) RESTDataStore *dataStore;
@property (nonatomic, assign) int statusCode;
@property (nonatomic, strong) NSData *data;

@end
