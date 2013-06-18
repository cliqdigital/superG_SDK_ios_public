#Ads Only  :: SuperG SDK for iOS
================================


Easy SDK Setup
==

•  **Step 1**
-

Clone this repository to you local disk and drag the contents of ** *SDK Files* ** to the file browser of your XCode project

•  **Step 2**
-

Open your AppDelegate.h file and add to your imports:

	#import "Thumbr/Thumbr.h"

Then declare (or add to existing delegate):

	@interface AppDelegate : UIResponder <UIApplicationDelegate, ThumbrSDKDelegate>

And register the following methods and variables:

	+(NSDictionary*) getAdSettings;
	- (void) initilizeSDK;
	- (void) animateAdIn:(id)sender;
	- (void) animateAdOut:(id)sender;

•  **Step 3**
-

Below your @synthesize section, add the Thumbr Settings (get them from your Thumbr game manager):
	
	//AD SERVING SETTINGS
	#define updateTimeInterval @"0"//default number of seconds before Inline Ad refreshes (can be overridden serverside)
	#define autocloseInterstitialTime @"600"//number of seconds before interstitial Ad closes
	#define showCloseButtonTime @"6"//Number of seconds before the Ad close button appears
	#define iPad_Inline_zoneid @"0337178053"
	#define iPad_Inline_secret @"F0B4E489B0CFC0BB"
	#define iPad_Overlay_zoneid @"8336743053"
	#define iPad_Overlay_secret @"BEF5D9D4D3E9B3CC"
	#define iPad_Interstitial_zoneid @"0336739057"
	#define iPad_Interstitial_secret @"DA018F2094E8189C"
	#define iPhone_Inline_zoneid @"5383077054"
	#define iPhone_Inline_secret @"C9AC24EF9CB18FFD"
	#define iPhone_Overlay_zoneid @"8383057050"
	#define iPhone_Overlay_secret @"A2E465BF955D25A5"
	#define iPhone_Interstitial_zoneid @"8383057050"
	#define iPhone_Interstitial_secret @"A2E465BF955D25A5"
	

And add these lines to your ** *didFinishLaunchingWithOptions* ** method:
	
	[self initilizeSDK];


Last, in this file, add (or update) these methods:
	
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
	
•  **Step 4**
-

Add a View to your ViewController.xib that will hold the advertisement.

Open the view controller where the Thumbr button and / or the advertisements will be.

Add this to your imports in your viewcontroller.h:

	#import "Thumbr/Thumbr.h"
	#import "Thumbr/AdViewController.h"
	#import "AppDelegate.h"

	@property (retain, nonatomic) IBOutlet UIView *adView;

##### Now connect the 'adView' IBOutlet to the view that will hold the advertisement.

In your "viewcontroller.m" calling the different advertisements uses these methods:

#####Overlay advertisement:

    NSDictionary* adSettings = [AppDelegate getAdSettings];
    [[[[AdViewController alloc] init] retain] adOverlay:adSettings];

#####Inline advertisement (banner):

    NSDictionary* adSettings = [AppDelegate getAdSettings];
    [[[[AdViewController alloc] init] retain] adInline:adSettings adSettings:self.adView];

#####Interstitial advertisement (fullscreen):

    NSDictionary* adSettings = [AppDelegate getAdSettings];
    [[[[AdViewController alloc] init] retain] adInterstitial:adSettings];

    

•  Step 5 (important!)
-

Add:

	-all_load -ObjC
	
to the 'Other linker flags' in (your project)->Build Settings->Linking

Make sure that the following frameworks are included in your Build Phases->Link Binaries With Libraries:

Frameworks:
	• CoreGraphics 	• Foundation 	• SystemConfiguration 	• UIKit 
	• AdSupport
	• CoreLocation
	• CoreTelephony
	• EventKit
	• MediaPlayer
	• MessageUI
	• CFNetwork
Vendor libraries:
	
	• libAppsFlyerLib.a
	• LRResty
	• MadsSDK
	• Thumbr
	
•  REMARKS
-
For best results hide the status bar.

To hide the status bar, add 

 	Status bar is initially hidden: YES
 	
to your application Info.plist

