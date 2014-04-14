//
//  AppDelegate.m
//  TestSDK
//

#import "AppDelegate.h"
#import "ViewController.h"


@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
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

    [PUSH handle:userInfo State:[application applicationState]] ;
    //HANDLE APPLICATION SPECIFIC ACTIONS AFTER PUSH NOTIFICATION HERE:
    NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
   // NSString *action = [[userInfo valueForKey:@"aps"] valueForKey:@"action"];
    
    NSLog(@"%@",message);
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pushToken {
    [PUSH didRegister:pushToken];
}
@end