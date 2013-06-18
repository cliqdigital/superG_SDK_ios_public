//
//  AppDelegate.h
//  Ads Only
//
//  Created by Henri de Mooij on 6/17/13.
//  Copyright (c) 2013 Henri de Mooij. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Thumbr/Thumbr.h"
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

+(NSDictionary*) getAdSettings;
- (void) initilizeSDK;
- (void) animateAdIn:(id)sender;
- (void) animateAdOut:(id)sender;

@end
