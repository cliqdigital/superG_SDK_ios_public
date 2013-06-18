//
//  Thumbr.h
//  Thumbr
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MadsSDK/MadsSDK.h>

#define VERSION @"2.0.3"

#pragma mark - keys for settings
extern NSString* ThumbrSettingPresentationWindow;
extern NSString* ThumbrSettingStatusBarHidden;
extern NSString* ThumbrSettingPortalOrientation;
extern NSString* ThumbrSettingScoreGameID;
extern NSString* ThumbrSettingRegisterUrl;
extern NSString* ThumbrSettingSwitchUrl;
extern NSString* ThumbrSettingPortalUrl;
extern NSString* ThumbrSettingChangeOrientationOnRotation;
extern NSString* ThumbrSettingClientId;
extern NSString* ThumbrSettingSid;
extern NSString* ThumbrSettingShowLoadingErrors;
extern NSString* ThumbrSettingShowCloseButton;
extern NSString* ThumbrSettingnew_country;
extern NSString* ThumbrSettingnew_locale;
NSInteger* openCounter;
@class ThumbrUser;
@class Thumbr;
NSString* method;

#pragma mark - ThumbrSDKDelegate protocol
@protocol ThumbrSDKDelegate <NSObject>
- (void) thumbrSDK:(Thumbr*) sdk didLoginUser:(ThumbrUser*) user;
@optional
- (void) closedSDKPortalView;
- (void) scoreCallback:(NSString *)method method:(NSObject *)parsedData;

@end

#pragma mark ThumbrUser object
@interface ThumbrUser : NSObject

@property (readonly, strong) NSString* uid;
@property (readonly, strong) NSString* username;
@property (readonly) NSInteger status;

@end


@interface Thumbr : UIViewController

#pragma mark - init Thumbr SDK
+ (void) initializeSDKWithSettings: (NSDictionary*) settings andDelegate: (id)delegate;

#pragma mark - open/close Portal Methods
+ (void) closeThumbrPortal;

#pragma mark - target methods for Thumbr buttons
+ (void) startThumbrPortalLogin;
+ (void) startThumbrPortalRegistration;
+ (void) startThumbrPortalSwitch;
+ (void) startThumbrPortal;
+ (int) storeCounter;
+ (void) setAction:(NSString*)action;
+ (NSString *) getAction;
+ (UIButton *)loadThumbrT:(float)relativeSize relativeSize:(NSString *)position;

+ (void) resume;
+ (NSString *) statusBarHidden;
+ (void) openScores;
+ (void) synchronizeScores;
+ (NSObject *) getNotification;

+ (NSObject *) getGameTotal:(NSString *)field :(NSMutableDictionary *)scoreParams;
+ (NSObject *) getGameLowest:(NSString *)field :(NSMutableDictionary *)scoreParams;
+ (NSObject *) getGameTop:(NSString *)field :(NSMutableDictionary *)scoreParams;
+ (NSObject *) getGameAverage:(NSString *)field :(NSMutableDictionary *)scoreParams;
+ (NSObject *) getPlayers:(NSMutableDictionary *)scoreParams;
+ (NSObject *) getGameField:(NSMutableDictionary *)scoreParams;
+ (NSObject *) getGame;
+ (NSObject *) getPlayerScores:(NSString *)username :(NSMutableDictionary *)scoreParams;
+ (NSObject *) getPlayer:(NSString *)username :(NSMutableDictionary *)scoreParams;
+ (NSObject *) editPlayer:(NSString *)username :(NSMutableDictionary *)scoreParams;
+ (NSObject *) countPlayers:(NSMutableDictionary *)scoreParams;
+ (NSObject *) updatePlayerField:(NSString *)username :(NSString *)field :(NSString *)value :(NSMutableDictionary *)scoreParams;
+ (NSObject *) createPlayer:(NSString *)username :(NSMutableDictionary *)scoreParams;
+ (NSObject *) countBestScores:(NSMutableDictionary *)scoreParams;
+ (NSObject *) getAverageScore:(NSMutableDictionary *)scoreParams;
+ (NSObject *) getBestScores:(NSMutableDictionary *)scoreParams;
+ (NSObject *) countScores:(NSMutableDictionary *)scoreParams;
+ (NSObject *) getScores:(NSMutableDictionary *)scoreParams;
+ (NSObject *) createScore:(NSString *)username :(NSString *)score :(NSMutableDictionary *)scoreParams;

#pragma mark - url path definitions (USER ACCEPTANCE TESTING)
#define AuthorizationUrlPath_UAT            @"http://gasp.dev.thumbr.com/auth/authorize?"
#define AccesTokenValidationUrlPath_UAT     @"http://gasp.dev.thumbr.com/auth/validate?"
#define profileAccesUrlPath_UAT             @"http://gasp.dev.thumbr.com/api/v1/profile?"
#define portalUrlPath_UAT                   @"http://m.dev.thumbr.com?"

#pragma mark - url path definitions (STAGING)
#define AuthorizationUrlPath_STAGING            @"http://gasp.staging.thumbr.com/auth/authorize?"
#define AccesTokenValidationUrlPath_STAGING     @"http://gasp.staging.thumbr.com/auth/validate?"
#define profileAccesUrlPath_STAGING             @"http://gasp.staging.thumbr.com/api/v1/profile?"
#define portalUrlPath_STAGING                   @"http://m.staging.thumbr.com?"

#pragma mark - url path definitions (PRODUCTION)
#define AuthorizationUrlPath            @"https://gasp.thumbr.com/auth/authorize?"
#define AccesTokenValidationUrlPath    @"https://gasp.thumbr.com/auth/validate?"
#define profileAccesUrlPath             @"https://gasp.thumbr.com/api/v1/profile?"
#define portalUrlPath                   @"https://m.thumbr.com/?"



#define REGISTERED      1
#define UNREGISTERED    0

@end
