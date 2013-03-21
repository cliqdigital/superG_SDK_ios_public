/*
 * scoreBoard.m
 * Thumbr
 *
 * Created by Henri de Mooij on 1/15/13.
 * Copyright (c) 2013 Entertainment Is My Life BV. All rights reserved.
 */

#import "Thumbr.h"
#import "scoreBoard.h"
#import "Thumbr+Private.h"


    @implementation scoreBoard
    NSString *scoreBoardUrl=@"http://gasp.uat-gasp.dev.cliqdigital.com/score_proxy.php";


+ (NSObject *) send:(NSMutableDictionary*)params params:(NSString*)method{
    NSObject *parsedData = NULL;
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              params, @"params",
                              method, @"method",
                              nil];
    
    if (timer == NULL) {timer = [NSTimer scheduledTimerWithTimeInterval: 12 target: self selector:@selector(cancelURLConnection:) userInfo: userInfo repeats: NO]; [timer retain]; }
    
    NSString *Url =[NSString stringWithFormat: @"%@?game_id=%@",scoreBoardUrl,scoreGameID];

    [params setObject:@"JSON" forKey:@"response"];
    [params setObject:method forKey:@"method"];
    [params setObject:@"iOS" forKey:@"platform"];
    [params setObject:@"curl_request" forKey:@"action"];
    [params setObject:scoreGameID forKey:@"game_id"];
        
    request =  [[LRResty client] post: Url payload:params withBlock:^(LRRestyResponse *response) {
                    if(response.status == 200) {
                        [timer invalidate];
                        
                        if (jsonParser == nil) {
                            jsonParser = [SBJSON new];
                        }
                        id parsedData = [jsonParser objectWithString: [response asString] error: nil];
                        NSLog(@"string response: %@", [response asString]);

                        [Thumbr scoreCallback:method method:parsedData];
                    }
                }];

    return parsedData;
}

+ (void)cancelURLConnection:(NSTimer *)timer{
    NSDictionary *userInfo = [timer userInfo];
    NSObject *params = [userInfo objectForKey:@"params"];
    method = [userInfo objectForKey:@"method"];
    
    NSObject *parsedData = nil;
    
    if ([method rangeOfString:@"create"].location == NSNotFound && [method rangeOfString:@"update"].location == NSNotFound && [method rangeOfString:@"edit"].location == NSNotFound) {
    parsedData = @"connection timeout";
    }
    else{
    parsedData = @"connection timeout :: storing the request for later submit";
        NSLog(@"params: %@",params);
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:params forKey:[NSString stringWithFormat:@"scores_%f_",[[NSDate date] timeIntervalSince1970]]];    
    }
    
    [Thumbr scoreCallback:method method:parsedData];
    [timer invalidate];
}

+ (void)synchronizeScores{
    NSLog(@"Optionally synchronizing scores to server");
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [prefs dictionaryRepresentation];
    for (id key in dict) {
        if ([key rangeOfString:@"scores_"].location != NSNotFound) {
            NSLog(@"key: %@",key);
            NSObject *pref = [prefs objectForKey:key];
            NSString *method= [pref objectForKey:@"method"];//ignore 'may not respond' warning
        [self send:(NSMutableDictionary*)pref params:(NSString*)method];
            [prefs removeObjectForKey:key];
        }
    }
    [prefs synchronize];
}

@end
