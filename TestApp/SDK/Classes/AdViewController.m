//
//  AdViewController.m
//

#import "AdViewController.h"
#import <MadsSDK/MadsSDK.h>
#import "Thumbr.h"

//iPad
#define iPad_Inline_banner_zoneid @"0337178053"
#define iPad_Inline_banner_secret @"F0B4E489B0CFC0BB"

#define iPad_Inline_square_zoneid "3336754051"
#define iPad_Inline_square_secret @"874A4100056D61D6"

#define iPad_Overlay_zoneid @"8336743053"
#define iPad_Overlay_secret @"BEF5D9D4D3E9B3CC"

#define iPad_Interstitial_zoneid @"0336739057"
#define iPad_Interstitial_secret @"DA018F2094E8189C"

//iPhone
#define iPhone_Inline_zoneid @"3327876051"
#define iPhone_Inline_secret @"5AC993C91380875B"

#define iPhone_Overlay_zoneid @"0335449053"
#define iPhone_Overlay_secret @"9CD3FF68A812A11F"

#define iPhone_Interstitial_zoneid @"9335783055"
#define iPhone_Interstitial_secret @"A487B22CA7A032DF"


@implementation AdViewController
@synthesize adView = _adView;


-(void) dealloc
{
    _adView.delegate = nil;
    [_adView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void) showAd
{
    
    MadsAdView *adview = nil;
    
    CGRect keyFrame = [UIApplication sharedApplication].keyWindow.frame;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        adview = [[MadsAdView alloc] initWithFrame:CGRectMake(0.0, 0.0, keyFrame.size.height, 54.0) zone:iPhone_Overlay_zoneid secret:iPhone_Overlay_secret delegate:self];
    }
    else
    {
        adview = [[MadsAdView alloc] initWithFrame:CGRectMake(0.0, 0.0, keyFrame.size.height, 54.0) zone:iPad_Overlay_zoneid secret:iPad_Overlay_secret delegate:self];
        
    }
    
    [self transformAdView:adview];
    
    adview.center = CGPointMake(keyFrame.size.width/2, keyFrame.size.height/2);//fix this
    adview.madsAdType=MadsAdTypeOverlay;
    adview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    adview.animationType = MadsAdAnimationTypeBottom;
    adview.updateTimeInterval = 0.0;
    
    self.adView = adview;
    [self.view addSubview:adview];
}

- (void) transformAdView:(UIView *)adview{
    
    if ([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft){
        //do something or rather
        [self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        //        float angle = 0.f;
        //        angle = M_PI_2;
        //        adview.transform = CGAffineTransformMakeRotation(angle);
    }
    else if ([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
        [self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
        
    }
    else if ([[UIDevice currentDevice]orientation] == UIInterfaceOrientationPortrait){
        [self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
        
    }
    else if ([[UIDevice currentDevice]orientation] == UIInterfaceOrientationPortraitUpsideDown){
        [self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortraitUpsideDown];
        
    }
    else{
        [self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }
    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    if([[Thumbr statusBarHidden]isEqual:@"TRUE"]){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([[Thumbr statusBarHidden]isEqual:@"TRUE"]){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    // we wait untl now to make sure there is a key window loaded that we use to position
    // elements on screen
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    //        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    //    } else {
    //        return YES;
    //    }
    return NO;
}

// MadsAdViewDelegate
- (void)willReceiveAd:(id)sender
{
    if([[Thumbr statusBarHidden]isEqual:@"TRUE"]){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    NSLog(@"willReceiveAd");
}
- (void)didReceiveAd:(id)sender
{
    NSLog(@"didReceiveAd");
    if([[Thumbr statusBarHidden]isEqual:@"TRUE"]){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}
- (void)didReceiveThirdPartyRequest:(id)sender content:(NSDictionary*)content
{
    NSLog(@"didReceiveThirdPartyRequest");
}

- (void)didFailToReceiveAd:(id)sender withError:(NSError*)error
{
    NSLog(@"didFailToReceiveAd");
    if([[Thumbr statusBarHidden]isEqual:@"TRUE"]){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}
- (void)adWillStartFullScreen:(id)sender
{
    NSLog(@"adWillStartFullScreen");
    
}

- (void)adDidEndFullScreen:(id)sender
{
    NSLog(@"adDidEndFullScreen");
    if([[Thumbr statusBarHidden]isEqual:@"TRUE"]){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}

- (void)adWillExpandFullScreen:(id)sender
{
    NSLog(@"adWillExpandFullScreen");
    
}

- (void)adDidCloseExpandFullScreen:(id)sender
{
    NSLog(@"adDidCloseExpandFullScreen");
    
}


- (void)adWillOpenVideoFullScreen:(id)sender
{
    NSLog(@"adWillOpenVideoFullScreen");
    
}

- (void)adDidCloseVideoFullScreen:(id)sender
{
    NSLog(@"adDidCloseVideoFullScreen");
    
}

- (void)adWillOpenMessageUIFullScreen:(id)sender
{
    NSLog(@"adWillOpenMessageUIFullScreen");
    
}

- (void)adDidCloseMessageUIFullScreen:(id)sender
{
    NSLog(@"adDidCloseMessageUIFullScreen");
    
}


- (void)didClosedAd:(id)sender usageTimeInterval:(NSTimeInterval)usageTimeInterval
{
    NSLog(@"didClosedAd");
    
    if([[Thumbr statusBarHidden]isEqual:@"TRUE"]){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}

- (void)mraidProcess:(id)sender event:(NSString*)event parameters:(NSDictionary*)parameters
{
    NSLog(@"mraidProcess");
    if([[Thumbr statusBarHidden]isEqual:@"TRUE"]){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}
@end
