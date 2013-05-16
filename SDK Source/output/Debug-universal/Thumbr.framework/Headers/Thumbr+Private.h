//
//  Thumbr+Private.h
//  Thumbr
//
//  Created by aiso haikens on 29-02-12.
//  Updated by Stephnie Mossel ;)
//  Copyright (c) 2012 ideesoft.nl. All rights reserved.
//

#define BUTTONVIEWTAG 1234
#define PORTALVIEWTAG 2345

#import "Thumbr.h"
#import <Foundation/Foundation.h>

@interface ThumbrUser (Private)
    
    @property ( readwrite, strong) NSString* uid; //readwrite,
    @property ( readwrite, strong) NSString* username;
    @property (readwrite) NSInteger status;

- (void) setThumbrUserWithProfile: (NSDictionary*) profile;

@end

@interface Thumbr (Private)

@property(strong) NSString* registerUrl;
@property(strong) NSString* switchUrl;
@property(strong) NSString* portalUrl;
@property(strong) NSURL* currentUrl;
@property(strong) NSString* accessToken;
@property(strong) NSString* sid;
@property(strong) NSString* clientId;
@property(strong) NSString* locale;
@property(strong) NSString* country;
@property(strong) NSString* state;
@property(strong) NSNumber* changeOrientationWithRotation;
@property(strong) UIWindow* presentationWindow;
@property UIDeviceOrientation portalOrientation;
@property(strong) NSNumber* showLoadingErrors;
@property(nonatomic) BOOL showCloseButton;
@property(strong) NSValue* portalCenter;
@property(strong) NSValue* buttonCenter;
@property(assign) id<ThumbrSDKDelegate> delegate;

+ (Thumbr*) instance;
+ (NSBundle*) getResourceBundle;
+ (UIImage*) loadImage: (NSString*) imageName forType: (NSString*) type;
+ (NSString*) getAccesTokenFromSettings;
+ (void) saveAccesToken: (NSString*)accessToken;
+ (void) receivedProfile: (NSDictionary*)profile;
//+ (void) scoreCallback:(NSString *)method method:(NSObject *)parsedData;

+ (void) closedThumbrPortal;
- (void) handleRotation;

+ (void) sendAnimateAdIn:(id)sender;
+ (void) sendAnimateAdOut:(id)sender;

@end
