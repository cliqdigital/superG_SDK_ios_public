//
//  SuperG.h
//  SuperG
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


#define VERSION @"3.0.2"

#pragma mark - keys for settings
extern NSString* SuperGSettingClientId;
extern NSString* SuperGSettingSid;
extern NSString* SuperGSettingShowLoadingErrors;
extern NSString* SuperGSettingnew_country;
extern NSString* SuperGSettingnew_locale;
NSInteger* openCounter;
@class SuperG;
NSString* method;

#pragma mark - SuperGSDKDelegate protocol
@protocol SuperGSDKDelegate <NSObject>

@optional
- (void) interstitialClosed:(id)sender;

@end



@interface SuperG : UIViewController

#pragma mark - init SuperG SDK

/**
 Entrypoint for SDK as a whole.
 @param delegate The delegate to handle all kinds stuff. Can be set to self.
 */
+ (void) initializeSDK: (id)delegate;

/**
 Stops the sdk from syncing events and stops ads. Should be called when closing the app.
 */
+ (void) stop;

/**
 Resumes the sdk after a stop. Should be called when resuming from the background
 */
+ (void) resume;


#pragma mark - url path definitions (PRODUCTION)
#define AuthorizationUrlPath            @"http://gasp.thumbr.com/auth/authorize?"
#define AccesTokenValidationUrlPath    @"http://gasp.thumbr.com/auth/validate?"
#define profileAccesUrlPath             @"http://gasp.thumbr.com/api/v1/profile?"
#define portalUrlPath                   @"http://m.thumbr.com/?"
#define adUrl                   @"http://ads.thumbr.com/adserver/?"

#define REGISTERED      1
#define UNREGISTERED    0

@end
