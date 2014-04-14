//
//  AppDelegate.h
//  TestSDK
//

#import <UIKit/UIKit.h>
#import "SuperG/SuperG.h"
#import "SuperG/PUSH.h"
#import "SuperG/EVA.h"
#import "AppDelegate.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, SuperGSDKDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;


@end
