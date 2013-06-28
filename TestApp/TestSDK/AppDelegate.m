//
//  AppDelegate.m
//  TestSDK
//

#import "AppDelegate.h"
#import "AppsFlyer.h"
#import "ViewController.h"
#import "Thumbr/AdViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

//SETTINGS
NSString *const sid = @"ski-jump-iphone";
NSString *const client_id = @"84758475-476574";
NSString *const appsflyerNotifyAppID = @"";
NSString *const scoreGameID = @"";

NSString *const registerUrl = @"https://gasp.thumbr.com/auth/authorize?";
NSString *const switchUrl = @"https://gasp.thumbr.com/auth/authorize?";
NSString *const portalUrl = @"https://mobile.thumbr.com/start?";

NSString *const statusBarHidden = @"TRUE";//TRUE or FALSE

//LOCALIZATION SETTINGS :: LEAVE EMPTY UNLESS SPECIFICALLY REQUIRED
NSString *const country = @"";
NSString *const locale = @"";

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


//init score variables
NSMutableDictionary *scoreParams;
NSObject *scoreOutput;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] autorelease];
    } else {
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPad_landscape" bundle:nil] autorelease];
    }
    self.window.rootViewController = self.viewController;
    
    [self.window makeKeyAndVisible];
    
    [self initilizeSDK];
    
    /*
     AT ANY POINT IN THE GAME, YOU CAN CHANGE THE ACTION BEHIND THE THUMBR BUTTON
     ALL POSSIBLE VALUES:
     
     -default (the default behaviour)
     -registration (forced registration form)
     -optional_registration (registration behaviour can be influenced server sided)
     */
    [Thumbr setAction:@"registration"];
    
    //OPEN THE SDK UPON APP START
    //[Thumbr startThumbrPortalRegistration];
    
    
    return YES;
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self initilizeSDK];
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
    //remove keyboard
    for (UIView* view in [_viewController.view subviews]) {
        if ([view isKindOfClass: [UITextField class]] ) {
            if ([view isFirstResponder]) {
                [view resignFirstResponder];
            }
        }
    }
    
    //Implement the SDK
    NSNumber *ThumbrOrientation;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        ThumbrOrientation = [NSNumber numberWithInt: UIDeviceOrientationPortrait];
    }
    else
    {
        ThumbrOrientation = [NSNumber numberWithInt: UIDeviceOrientationLandscapeLeft];
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:scoreGameID,scoreGameID,country,ThumbrSettingnew_country, locale,ThumbrSettingnew_locale,self.window, ThumbrSettingPresentationWindow, client_id, ThumbrSettingClientId, sid , ThumbrSettingSid, registerUrl, ThumbrSettingRegisterUrl, portalUrl , ThumbrSettingPortalUrl, switchUrl , ThumbrSettingSwitchUrl, [NSNumber numberWithBool:YES], ThumbrSettingChangeOrientationOnRotation, ThumbrOrientation, ThumbrSettingPortalOrientation, [NSNumber numberWithBool:YES], ThumbrSettingShowLoadingErrors, [NSNumber numberWithBool:TRUE], ThumbrSettingShowCloseButton,statusBarHidden,ThumbrSettingStatusBarHidden, nil];
    
    [Thumbr initializeSDKWithSettings:settings andDelegate:self];
    
}



#pragma mark Thumbr SDK delegate
- (void) thumbrSDK:(Thumbr *)sdk didLoginUser:(ThumbrUser *)user
{
    NSLog(@"uid: %@", user.uid);
    NSLog(@"username: %@", user.username);
    NSLog(@"status: %@", user.status ? @"Registered" : @"Temporary");
    
}


- (void) closedSDKPortalView
{

    NSLog(@"The Game was notified about the closing PortalView");
}

+ (NSDictionary*)getAdSettings{
    
    NSDictionary *adSettings = [NSDictionary dictionaryWithObjectsAndKeys:showCloseButtonTime,@"showCloseButtonTime",autocloseInterstitialTime ,@"autocloseInterstitialTime",iPad_Inline_zoneid,@"iPad_Inline_zoneid",iPad_Inline_secret,@"iPad_Inline_secret",iPad_Overlay_zoneid,@"iPad_Overlay_zoneid",iPad_Overlay_secret,@"iPad_Overlay_secret",iPad_Interstitial_zoneid,@"iPad_Interstitial_zoneid",iPad_Interstitial_secret,@"iPad_Interstitial_secret",iPhone_Inline_zoneid,@"iPhone_Inline_zoneid",iPhone_Inline_secret,@"iPhone_Inline_secret",iPhone_Overlay_zoneid,@"iPhone_Overlay_zoneid",iPhone_Overlay_secret,@"iPhone_Overlay_secret",iPhone_Interstitial_zoneid,@"iPhone_Interstitial_zoneid",iPhone_Interstitial_secret,@"iPhone_Interstitial_secret",updateTimeInterval,@"updateTimeInterval", nil];
    return adSettings;
}


- (void) interstitialClosed:(id)sender{
    NSLog(@"Interstitial or overlay advertisement has closed. You can resume the game, if you paused it for the interstitial / overlay");
}

-(CGSize) currentSize
{
    return [self sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

-(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation
{
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}

- (void) animateAdIn:(id)sender{
    NSLog(@"animate Ad in");
    _viewController.adView.hidden = NO;
    CGRect adViewFrame = _viewController.adView.frame;
    int frameheight;
    
    frameheight = [self currentSize].height;
    NSLog(@"%d",frameheight);
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
    int frameheight;
    frameheight = [self currentSize].height;
    
    adViewFrame.origin.y = frameheight;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    _viewController.adView.frame = adViewFrame;
    [UIView commitAnimations];
}
@end