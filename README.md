#SuperG SDK for iOS
===============


Revision history
----------------

<table>
	<tr>
		<td>3.0.2</td>
		<td>-Removed ad serving: Just add your own ad serving SDK. Cliq Digital works with MADS. You can download the MADS SDK here: <br />
		<a href="http://developer.madsone.com/IOS_SDK">http://developer.madsone.com/IOS_SDK</a><br />
		-Removed the Thumbr subscription flow<br />
		-Removed all assets that are no longer needed<br />
		-Added Generic Event<br />
		-Removed mandatory settings. All is automatically set within the SDK now.<br />
		</td>
	</tr>
	<tr>
		<td>3.0.1</td>
		<td>
			-Bugfixes
		</td>
	</tr>
	<tr>
		<td>3.0.0</td>
		<td>
		-Rebranded to SuperG<br />
		-Event logging<br />
		-Push Notifications Support<br />
		-Separate Thumbr T animation Framework<br />
		-AppsFlyer made optional<br />
		-iOS 7 Support<br />
		-Removal of deprecated methods<br />
		-Performance optimizations<br />
		</td>
	</tr>
	<tr>
		<td>2.0.323</td>
		<td>
		-Removed status bar after stopAds<br />
		-Added customizible CGPoint for inline ads
		</td>
	</tr>
	<tr>
		<td>2.0.322</td>
		<td>
		-Added stopAds function (currently loading ads will be cancelled)<br />
		</td>
	</tr>
	<tr>
		<td>2.0.321</td>
		<td>
		-Ad overlay bug fix<br />
		</td>
	</tr>
	<tr>
		<td>2.0.32</td>
		<td>
		-Possibility to hide the Thumbr close button (remote configuration)<br />
		-Improved interstitial ads<br />
		-Added demo and manual for Ad-only integration
		</td>
	</tr>
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

**Step 1**
-

Clone this repository to you local disk and drag the ** *SDK Files* ** into the file browser of your XCode project ( Copy files and create group! )


####Add this to the 'Other linker flags' in (your project)->Build Settings->Linking:

	-all_load -ObjC


Make sure that the following frameworks are included in your Build Phases->Link Binaries With Libraries:

<table>
<tr><td>Name</td><td>Status</td></tr>
<tr><td><strong>Internal frameworks</strong></td></tr>

<tr><td>AdSupport.framework</td><td>Required</td></tr>
<tr><td>AudioToolbox.framework</td><td>Required</td></tr>
<tr><td>AVFoundation.framework</td><td>Required</td></tr>
<tr><td>CFNetwork.framework</td><td>Required</td></tr>
<tr><td>CoreAudio.framework</td><td>Required</td></tr>
<tr><td>CoreLocation.framework</td><td>Required</td></tr>
<tr><td>CoreTelephony</td><td>Required</td></tr>
<tr><td>EventKit.framework</td><td>Required</td></tr>
<tr><td>Foundation.framework</td><td>Required</td></tr>
<tr><td>libz.dylib</td><td>Required</td></tr>
<tr><td>libsqlite3.0.dylib</td><td>Required</td></tr>
<tr><td>MediaPlayer.framework</td><td>Required</td></tr>
<tr><td>MessageUI.framework</td><td>Required</td></tr>
<tr><td>SystemConfiguration.framework</td><td>Required</td></tr>
<tr><td>UIKit.framework</td><td>Required</td></tr>
<tr><td>QuartzCore.framework</td><td>Required</td></tr>

<tr><td><strong>External libraries (from the SDK package)</strong></td></tr>
<tr><td>SuperG.framework</td><td>Required</td></tr>
<tr><td>LRResty.framework</td><td>Required</td></tr>
</table>

**Step 2**
-
Add the .caf files to your project root. These are the custom push notification sounds.

**Step 3**
-

Open your AppDelegate.h file and add to the top:

	#import "SuperG/SuperG.h"
	#import "SuperG/PUSH.h"
	#import "SuperG/EVA.h"

	@class ViewController;//<=The name of your main view controller
	
Then declare (or add to existing delegate):

	@interface AppDelegate : UIResponder <UIApplicationDelegate, SuperGSDKDelegate>


    
**Step 4**
-

In your appDelegate.m, add (or update) these methods:
	
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
	 	//..other code..///
	 	
	    [SuperG initializeSDK:self];
	    return YES;
	}
	
	- (void)applicationWillEnterForeground:(UIApplication *)application {
	    [SuperG initializeSDK:self];
	}
	
	- (void)applicationWillTerminate:(UIApplication *)application
	{
	    [SuperG stop];
	}
	
	- (void)applicationDidEnterBackground:(UIApplication *)application
	{
	    [SuperG stop];
	}

	- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    	[PUSH handle:userInfo :[application applicationState]];
    
	   //HANDLE YOUR OWN APPLICATION SPECIFIC ACTIONS AFTER PUSH NOTIFICATION HERE:
	   //NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
	   //NSString *action = [[userInfo valueForKey:@"aps"] valueForKey:@"action"];
	    
	}


Step 5 :: Events
-

If you want to log custom events, add this line to your imports:
	
	#import "SuperG/EVA.h"

These custom event methods are available:

	+ (void) click:(NSString*)clickedItem;
	Example: 
    [EVA click:@"TestButton"];
		
	+ (void) purchase:(NSString*)currency :(NSString*)payment_method :(NSString*)price :(NSString*)purchasedItem;
	Example: 
    [EVA purchase:@"coins" WithCurrency:@"EUR" PaymentMethod:@"in-app" AndPrice:@"0.79"];
		
	+ (void) achievementEarned:(NSString*)achievementName;
	Example: 
	[EVA achievementEarned:@"Found gold"];
	
	+ (void) startLevel:(NSString*)game_mode :(NSString*)level :(NSString*)score_type :(NSString*)score_value;
	Example: 
    [EVA start_level:@"1" inMode:@"attach_mode" withScoreType:@"win" andScoreValue:@"1"];
    
	+ (void) finish_level:(NSString*)game_mode :(NSString*)level :(NSString*)score_type :(NSString*)score_value ;
	Example: 
    [EVA finish_level:@"100" inMode:@"attack mode" withScoreType:@"win" andScoreValue:@"1" ];
    
	+ (void) upSell:(NSString*)currency :(NSString*)payment_method;
	Example: 
    [EVA upSell:@"EUR" PaymentMethod:@"in-app"];

	+(void)generic: (NSString*)generic_key GenericValue: (NSString*)generic_value;
	Example: 
    [EVA generic:@"myEvent" GenericValue:@"it fired!"];	

 