//
//  AppsFlyer.h
//
//  Copyright 2012 AppsFlyer. All rights reserved.
//  Version 2.5.1.7

#import <Foundation/Foundation.h>


@interface AppsFlyer : NSObject{
    
}

+(void) setAppUID:(NSString*)appUID;
+(void)notifyAppID: (NSString*) strdata;
+(void)notifyAppID: (NSString*) strdata event:(NSString*)eventName eventValue:(NSString*)eventValue;
+(NSString *) getAppsFlyerUID;

@end
