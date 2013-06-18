//
//  ViewController.m
//  Ads Only
//
//  Created by Henri de Mooij on 6/17/13.
//  Copyright (c) 2013 Henri de Mooij. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// On loading this view you can show either one of the advertisements below (inline, overlay or interstitial).
    
//    Example 1: Inline advertisement (banner):
    
//    NSDictionary* adSettings = [AppDelegate getAdSettings];
//    [[[[AdViewController alloc] init] retain] adInline:adSettings adSettings:self.adView];
    

    
//    Example 2: Overlay advertisement:
    
//    NSDictionary* adSettings = [AppDelegate getAdSettings];
//    [[[[AdViewController alloc] init] retain] adOverlay:adSettings];
    

    
//    Example 3: Interstitial advertisement (fullscreen):
        NSDictionary* adSettings = [AppDelegate getAdSettings];
    
    //delayed for 1 second, to make sure the app is ready.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{

        [[[[AdViewController alloc] init] retain] adInterstitial:adSettings];
        
    });
   
    
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
