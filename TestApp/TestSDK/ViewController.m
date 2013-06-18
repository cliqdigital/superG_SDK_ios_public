//
//  ViewController.m
//  TestSDK
//
#import "AppDelegate.h"
#import "ViewController.h"
#import "Thumbr/Thumbr.h"
#import "Thumbr/AdViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc
{
    [_inlinebutton release];
    [_Banner release];
    [_adView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"background@2x~ipad.png"]];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        _inlinebutton.enabled = NO;
    }
    
    //SET THE THUMBR BUTTON HERE
    
    //POSITION OF THE THUMBR BUTTON
    //TL = topleft; TR = topright; BL = bottomleft; BR = bottomright
    //NSString *position=@"TR";
    //SIZE OF THE THUMBR BUTTON
    //relativeSize=8 will result in a width and height of 1/8 of the portrait screen width (with a max. of 190px)
    //int relativeSize=6;
    
    //IMPLEMENTATION EXAMPLE DIRECTLY ON MAIN VIEW (CORNERS ONLY)
    
    //    UIButton *thumbrT = [Thumbr loadThumbrT:relativeSize relativeSize:position];
    //    [self.view addSubview:thumbrT];//add the view
    //    [self.view bringSubviewToFront:thumbrT];//make sure it is on front
    
    
    //IMPLEMENTATION EXAMPLE ON SUBVIEW (MAKE SURE POSITION IS TL)
    //create a sub view in your NIB and add the Thumbr-T-Logo to it
    int relativeSize=6;
    UIButton *thumbrT2 = [Thumbr loadThumbrT:relativeSize relativeSize:@"TL"];
    [self.thumbrTView addSubview:thumbrT2 ];
    
}

- (void)viewDidUnload
{
    [self setInlinebutton:nil];
    [self setBanner:nil];
    [self setAdView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
    else{
        return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
    }
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    //decide number of origination tob supported by Viewcontroller.
    return UIInterfaceOrientationMaskAll;
}

- (void) closedSDKPortalView
{
    NSLog(@"The Game was notified about the closing PortalView");
}

- (void) UISegmentedControl{
    NSLog(@"yoho");
}


-(void) clearAdView{
    for (UIView *subview in self.adView.subviews) {
        [subview removeFromSuperview];
    }
}

- (IBAction)AdOverlay:(UIButton *)sender {
    [self clearAdView];
    NSDictionary* adSettings = [AppDelegate getAdSettings];
    [[[[AdViewController alloc] init] retain] adOverlay:adSettings];
}

- (IBAction)AdInline:(UIButton *)sender {
   [self clearAdView];
    NSDictionary* adSettings = [AppDelegate getAdSettings];
    [[[[AdViewController alloc] init] retain] adInline:adSettings adSettings:self.adView];
}


- (IBAction)AdInterstitial:(UIButton *)sender {
    [self clearAdView];    
    NSDictionary* adSettings = [AppDelegate getAdSettings];
    [[[[AdViewController alloc] init] retain] adInterstitial:adSettings];
}



- (IBAction)Reset:(UIButton *)sender {
    [self reset];
}

//RESET LOCAL STORAGE AND CLEAR COOKIES
- (void) reset
{
    NSError* error = nil;
    NSLog(@"reset called");
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"defaults" error:&error];
    for (NSString *strName in dirContents) {
        [[NSFileManager defaultManager] removeItemAtPath:[@"defaults" stringByAppendingPathComponent:strName] error:&error];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

@end