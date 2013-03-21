//
//  AppDelegate.m
//  TestSDK
//

#import "AppDelegate.h"
#import "AppsFlyer.h"
#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

//SETTINGS
NSString *const sid = @"your_sid";
NSString *const client_id = @"your_client_id";
NSString *const appsflyerNotifyAppID = @"your_appsflyer_id";
NSString *const scoreGameID = @"";

NSString *const registerUrl = @"https://gasp.thumbr.com/auth/authorize?";
NSString *const switchUrl = @"https://gasp.thumbr.com/auth/authorize?";
NSString *const portalUrl = @"https://mobile.thumbr.com/start?";

//LOCAL SETTINGS :: LEAVE EMPTY UNLESS SPECIFICALLY REQUIRED
NSString *const country = @"";
NSString *const locale = @"";

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
     -optional_registration (extra registration that can be used to earn more 'credits'
     */
    [Thumbr setAction:@"optional_registration"];
    
    //OPEN THE SDK UPON APP START
    [Thumbr startThumbrPortalRegistration];
    
    return YES;
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
    
        NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:scoreGameID,scoreGameID,country,ThumbrSettingnew_country, locale,ThumbrSettingnew_locale,self.window, ThumbrSettingPresentationWindow, client_id, ThumbrSettingClientId, sid , ThumbrSettingSid, registerUrl, ThumbrSettingRegisterUrl, portalUrl , ThumbrSettingPortalUrl, switchUrl , ThumbrSettingSwitchUrl, [NSNumber numberWithBool:NO], ThumbrSettingChangeOrientationOnRotation, ThumbrOrientation, ThumbrSettingPortalOrientation, [NSNumber numberWithBool:YES], ThumbrSettingShowLoadingErrors, [NSNumber numberWithBool:TRUE], ThumbrSettingShowCloseButton, nil];
    
    [Thumbr initializeSDKWithSettings:settings andDelegate:self];
            
}

#pragma mark Thumbr SDK delegate
- (void) thumbrSDK:(Thumbr *)sdk didLoginUser:(ThumbrUser *)user
{
    NSLog(@"Game Thumbr user: %@ ", [user description]);
    NSLog(@"uid: %@", user.uid);
    NSLog(@"username: %@", user.username);    
    NSLog(@"status: %@", user.status ? @"Registered" : @"Temporary");

}

- (void) closedSDKPortalView
{
    NSLog(@"The Game was notified about the closing PortalView");
}

@end