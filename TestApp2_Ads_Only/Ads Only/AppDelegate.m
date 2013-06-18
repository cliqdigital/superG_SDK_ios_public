//
//  AppDelegate.m
//  Ads Only
//
//  Created by Henri de Mooij on 6/17/13.
//  Copyright (c) 2013 Henri de Mooij. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

//AD SERVING SETTINGS
#define updateTimeInterval @"0"//default number of seconds before Inline Ad refreshes (can be overridden serverside)
#define autocloseInterstitialTime @"600"//number of seconds before interstitial Ad closes
#define showCloseButtonTime @"6"//Number of seconds before the Ad close button appears
#define iPad_Inline_zoneid @"0337178053"
#define iPad_Inline_secret @"F0B4E489B0CFC0BB"
#define iPad_Inline_square_zoneid @"3336754051"
#define iPad_Inline_square_secret @"874A4100056D61D6"
#define iPad_Overlay_zoneid @"8336743053"
#define iPad_Overlay_secret @"BEF5D9D4D3E9B3CC"
#define iPad_Interstitial_zoneid @"0336739057"
#define iPad_Interstitial_secret @"DA018F2094E8189C"
#define iPhone_Inline_zoneid @"3327876051"
#define iPhone_Inline_secret @"5AC993C91380875B"
#define iPhone_Overlay_zoneid @"0335449053"
#define iPhone_Overlay_secret @"9CD3FF68A812A11F"
#define iPhone_Interstitial_zoneid @"9335783055"
#define iPhone_Interstitial_secret @"A487B22CA7A032DF"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    //INITIALIZE THE THUMBR SDK
    [self initilizeSDK];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}



- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    [Thumbr stop];
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [Thumbr stop];
}

- (void) initilizeSDK
{
    
    [Thumbr initializeSDKForAdsOnly];
    
}


+ (NSDictionary*)getAdSettings{
    
    NSDictionary *adSettings = [NSDictionary dictionaryWithObjectsAndKeys:showCloseButtonTime,@"showCloseButtonTime",autocloseInterstitialTime ,@"autocloseInterstitialTime",iPad_Inline_zoneid,@"iPad_Inline_zoneid",iPad_Inline_secret,@"iPad_Inline_secret",iPad_Overlay_zoneid,@"iPad_Overlay_zoneid",iPad_Overlay_secret,@"iPad_Overlay_secret",iPad_Interstitial_zoneid,@"iPad_Interstitial_zoneid",iPad_Interstitial_secret,@"iPad_Interstitial_secret",iPhone_Inline_zoneid,@"iPhone_Inline_zoneid",iPhone_Inline_secret,@"iPhone_Inline_secret",iPhone_Overlay_zoneid,@"iPhone_Overlay_zoneid",iPhone_Overlay_secret,@"iPhone_Overlay_secret",iPhone_Interstitial_zoneid,@"iPhone_Interstitial_zoneid",iPhone_Interstitial_secret,@"iPhone_Interstitial_secret",updateTimeInterval,@"updateTimeInterval", nil];
    return adSettings;
}

- (void) animateAdIn:(id)sender{
    NSLog(@"animate Ad in");
    _viewController.adView.hidden = NO;
    CGRect adViewFrame = _viewController.adView.frame;
    int frameheight=640;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        frameheight = _viewController.view.frame.size.width;
    }
    else{
        frameheight = _viewController.view.frame.size.height;
    }
    adViewFrame.origin.y = frameheight-adViewFrame.size.height;
    
    CGRect frame = [sender frame];
    if(frame.size.height>10){
        float height = frame.size.height;
        adViewFrame.origin.y = frameheight-height;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    _viewController.adView.frame = adViewFrame;
    [UIView commitAnimations];
}

- (void) animateAdOut:(id)sender{
    NSLog(@"animate Ad out");
    CGRect adViewFrame = _viewController.adView.frame;
    int frameheight=640;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        frameheight = _viewController.view.frame.size.width;
    }
    else{
        frameheight = _viewController.view.frame.size.height;
    }
    
    adViewFrame.origin.y = frameheight;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    _viewController.adView.frame = adViewFrame;
    [UIView commitAnimations];
}

@end
