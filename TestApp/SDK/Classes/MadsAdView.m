//
//  AdViewController.m
//

#import "MadsAdView.h"
#import <MadsSDK/MadsSDK.h>

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

-(void) setupMadsAdView
{
    MadsAdView *anAdView = nil;
    
    CGRect keyFrame = [UIApplication sharedApplication].keyWindow.frame;
    if(([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) ||
       ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown))
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            anAdView = [[MadsAdView alloc] initWithFrame:CGRectZero zone:iPhone_Overlay_zoneid secret:iPhone_Overlay_secret delegate:self];
            anAdView.madsAdType=MadsAdTypeOverlay;
            anAdView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            anAdView.animationType = MadsAdAnimationTypeBottom;
            anAdView.testMode = TRUE;
            anAdView.logMode = 2;            
        }
        else
        {
            anAdView = [[MadsAdView alloc] initWithFrame:CGRectZero zone:iPad_Overlay_zoneid secret:iPad_Overlay_secret delegate:self];
            anAdView.madsAdType=MadsAdTypeOverlay;
            anAdView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            anAdView.animationType = MadsAdAnimationTypeBottom;
            anAdView.testMode = TRUE;
            anAdView.logMode = 2;            
        }
    }
    else
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            anAdView = [[MadsAdView alloc] initWithFrame:CGRectMake(0.0, 0.0, keyFrame.size.height, 54.0) zone:iPhone_Overlay_zoneid secret:iPhone_Overlay_secret delegate:self];
            anAdView.madsAdType=MadsAdTypeOverlay;
            anAdView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            anAdView.animationType = MadsAdAnimationTypeBottom;
            anAdView.testMode = TRUE;            
            anAdView.logMode = 2;
        }
        else
        {
            anAdView = [[MadsAdView alloc] initWithFrame:CGRectMake(0.0, 0.0, keyFrame.size.height, 54.0) zone:iPad_Inline_banner_zoneid secret:iPad_Inline_banner_secret delegate:self];
            anAdView.madsAdType=MadsAdTypeOverlay;
            anAdView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            anAdView.animationType = MadsAdAnimationTypeBottom;
            anAdView.testMode = TRUE;
            anAdView.logMode = 2;
        }
    }

    anAdView.updateTimeInterval = 0.0; // only manual updates
    anAdView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.adView = anAdView;

    [self.view addSubview:anAdView];
}

-(void) buttonPressed
{
    [self.adView update];
}

-(void) showRefreshButton
{
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [refreshButton setTitle:@"refresh adView" forState:UIControlStateNormal];
    
    CGRect keyFrame = [UIApplication sharedApplication].keyWindow.frame;
    
    if(([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) ||
       ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown))
    {
        refreshButton.frame = CGRectMake(85.0, keyFrame.size.height - 100.0, 150.0, 25.0);
    }
    else
    {
        refreshButton.frame = CGRectMake(85.0, keyFrame.size.width - 100.0, 150.0, 25.0);
    }
    
    refreshButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [refreshButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshButton];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
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
}

- (void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
    // we wait untl now to make sure there is a key window loaded that we use to position
    // elements on screen
    if(!self.adView)
    {
        [self setupMadsAdView];
    }
    
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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

// MadsAdViewDelegate
- (void)willReceiveAd:(id)sender
{
    NSLog(@"willReceiveAd");
}
- (void)didReceiveAd:(id)sender
{
    NSLog(@"didReceiveAd");
    
}
- (void)didReceiveThirdPartyRequest:(id)sender content:(NSDictionary*)content
{
    NSLog(@"didReceiveThirdPartyRequest");
}

- (void)didFailToReceiveAd:(id)sender withError:(NSError*)error
{
    NSLog(@"didFailToReceiveAd");
    
}
- (void)adWillStartFullScreen:(id)sender
{
    NSLog(@"adWillStartFullScreen");
    
}

- (void)adDidEndFullScreen:(id)sender
{
    NSLog(@"adDidEndFullScreen");
    
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
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

}

- (void)mraidProcess:(id)sender event:(NSString*)event parameters:(NSDictionary*)parameters
{
    NSLog(@"mraidProcess");
    
}
@end
