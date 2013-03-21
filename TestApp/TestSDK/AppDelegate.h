//
//  AppDelegate.h
//  TestSDK
//

#import <UIKit/UIKit.h>
#import "Thumbr/Thumbr.h"
#import "AppDelegate.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, ThumbrSDKDelegate>

@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) ViewController *viewController;

FOUNDATION_EXPORT NSString *const sid;
FOUNDATION_EXPORT NSString *const client_id;
FOUNDATION_EXPORT NSString *const country;
FOUNDATION_EXPORT NSString *const locale;
FOUNDATION_EXPORT NSString *const appsflyerNotifyAppID;
FOUNDATION_EXPORT NSString *const registerUrl;

- (void) initilizeSDK;

@end
