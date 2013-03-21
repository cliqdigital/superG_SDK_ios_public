//
//  scoreBaord.h
//  Thumbr
//
//  Created by Henri de Mooij on 1/15/13.
//  Copyright (c) 2013 ideesoft.nl. All rights reserved.
//
#import <LRResty/LRResty.h>
#import <Thumbr/Thumbr.h>
#import "JSBridgeWebView.h"
#import "JSON.h"

extern NSString * const scoreGameID;
    NSTimer* timer;
    LRURLRequestOperation* request;
    SBJSON* jsonParser;

@interface scoreBoard : Thumbr

+ (NSObject *) send:(NSMutableDictionary*)params params:(NSString*)method;
+ (void)cancelURLConnection:(NSTimer *)timer;
+ (void)synchronizeScores;

@end
