#Thumbr SDK iOS
===============

You develop a cool game, we do the rest
=======================================
Millions of gamers and one worldwide SDK, GROW YOUR BUSINESS AND GET STARTED. 
Monetize your game with more than just ITEM SALES, boost revenue and expand your userbase. Connect with thumbr to get unique user IDs, social features, advertising options, fun features, client relationship management with high-engaged, Average Revenue Per User players worldwide!
Of course all with realtime statistics on your game.

Apply for a Thumbr developer account
------------------------------------
To apply for a Thumbr developer account for your game, please visit:
<a target="_blank" href="http://cliqdigital.com/developers#one-sdk">http://cliqdigital.com/developers#one-sdk</a>

Revision history
----------------

<table>
	<tr>
		<td>2.0.31</td>
		<td>
		-Personalized Ad serving support<br />
		-Technical updates
		</td>
	</tr>
	<tr>
		<td>2.0.3</td>
		<td>
		-Ad serving support<br />
		-SSL support<br />
		-Technical updates
		</td>
	</tr>
	<tr>
		<td>2.0.22</td>
		<td>
		-Fixed memory leaks, improved memory clean up<br />
		-Removed refresh button in iPad layout<br />
		-Catch url's that contain 'openinbrowser' and open them in browser<br />
		-Send along SDK version number to Thumbr server<br />
		-Improved orientation behavior<br />
		-Upgraded to Xcode 4.6.1 requirements
		</td>
	</tr>
	<tr>
		<td>2.0.21</td><td>
		-Better Thumbr T-button resizing<br />
		-Added visual SDK version to Thumbr window<br />
		-Added Customizable Orientation<br />
		-Added extra parameters to registration flow: default,registration,optional_registration<br />
		-Added a counter to the 'opens' of the Thumbr SDK window<br />
		-Let external URL's (within the SDK window) be opened in the default browser<br />
		-Bug fix: better orientation handling in general<br />
		-Let Thumbr server know that back end is loaded from within the SDK (via GET param (&sdk=1) + via HEADER (x-thumbr-method))<br />
		-Added version header (X-Thumbr-Version)<br />
		</td>
	</tr>
	<tr>
		<td>2.0.2</td><td>
		-Updated version number to match iOS version (for better release planning)<br />
		-Added Animated Thumbr T-button support<br />
		-Added SDK version number to Thumbr screen<br />
		-Bug fixes<br />
		</td>
	</tr>	
	<tr>
		<td>1.1</td><td>
		- Added Appsflyer support
		</td>
	</tr>	
	<tr>
		<td>1.0.1</td><td>
		- Bug fixes
		</td>
	</tr>	
	<tr>
		<td>1.0</td><td>
		- Initital version
		</td>
	</tr>	
</table>

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
	
	FOUNDATION_EXPORT NSString *const sid;
	FOUNDATION_EXPORT NSString *const client_id;
	FOUNDATION_EXPORT NSString *const country;
	FOUNDATION_EXPORT NSString *const locale;
	FOUNDATION_EXPORT NSString *const appsflyerNotifyAppID;
	FOUNDATION_EXPORT NSString *const registerUrl;

	- (void) initilizeSDK;	

•  **Step 3**
-

Open your AppDelegate.m and add to your imports:

	#import "AppsFlyer.h"

Add this line to the ** *applicationDidBecomeActive* ** method:

	[AppsFlyer notifyAppID: appsflyerNotifyAppID];

Below your @synthesize section, add the Thumbr Settings (get them from your Thumbr game manager):
	
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

And add these lines to your ** *didFinishLaunchingWithOptions* ** method:
	
	[self initilizeSDK];

    /*
     AT ANY POINT IN THE GAME, YOU CAN CHANGE THE ACTION BEHIND THE THUMBR BUTTON
     ALL POSSIBLE VALUES:
     
     -default (the default behaviour)
     -registration (forced registration form)
     -optional_registration (registration behaviour can be influenced server sided)
     */
    [Thumbr setAction:@"optional_registration"];
    
    //OPEN THE SDK UPON APP START
    [Thumbr startThumbrPortalRegistration];

Last, in this file, add these methods:

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
	
•  Step 4
-
Open the view controller where the Thumbr button will be.

Add this to your imports:

	#import "Thumbr/Thumbr.h"

and add these lines to your ** *viewDidLoad* ** method:

		    //POSITION OF THE THUMBR BUTTON
			//TL = topleft; TR = topright; BL = bottomleft; BR = bottomright
	    NSString *position=@"TL";
			//SIZE OF THE THUMBR BUTTON
    		//relativeSize=8 will result in a width and height of 1/8 of the portrait screen width (with a max. of 190px)
	    int relativeSize=6;

	    UIButton *thumbrT = [Thumbr loadThumbrT:relativeSize relativeSize:position];
    	[self.view addSubview:thumbrT];//add the view
	    [self.view bringSubviewToFront:thumbrT];//make sure it is on front

**To add the Thumbr button to a sub view (for custom positions), please consult the Demo application**


•  Step 5 (important!)
-
Add 

	-all_load -ObjC
	
to the 'Other linker flags' in (your project)->Build Settings->Linking

Make sure that the following frameworks are included in your Build Phases->Link Binaries With Libraries:
	• CoreGraphics • Foundation • SystemConfiguration • UIKit • Thumbr

•  REMARKS
-
If your application has the status bar enabled, the Thumbr close button will not be visible.

To hide the status bar, add 

 	Status bar is initially hidden: YES
 	
to your application Info.plist

