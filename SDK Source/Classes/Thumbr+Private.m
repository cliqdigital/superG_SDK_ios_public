//
//  Thumbr+Private.m
//  Thumbr
//
//  Created by aiso haikens on 29-02-12.
//  Updated by Stephnie Mossel ;)
//  Copyright (c) 2012 ideesoft.nl. All rights reserved.
//

#import "Thumbr+Private.h"

@implementation ThumbrUser (Private)

@dynamic uid;
@dynamic username;
@dynamic status;

//retrieve the uid, username and status from the profile
- (void) setThumbrUserWithProfile:(NSDictionary *)profile
{
    [self setUid:[profile valueForKey:@"id"]];
    [self setUsername:[profile valueForKey:@"username"]];
    
    if ([[profile valueForKey:@"status"] isEqualToString:@"active"]) {
        [self setStatus: REGISTERED];
    } else {
        [self setStatus: UNREGISTERED];
    }
}

@end


@implementation Thumbr (Private)

@dynamic delegate;
@dynamic registerUrl;
@dynamic switchUrl;
@dynamic portalUrl;
@dynamic currentUrl;
@dynamic accessToken;
@dynamic sid;
@dynamic clientId;
@dynamic locale;
@dynamic country;
@dynamic state;
@dynamic changeOrientationWithRotation;
@dynamic presentationWindow;
@dynamic portalOrientation;
@dynamic showLoadingErrors;
@dynamic showCloseButton;
@dynamic portalCenter;
@dynamic buttonCenter;

#pragma mark - Singleton method

+ (Thumbr*) instance {
    static Thumbr* sInstance;
    
    if (!sInstance) {
        sInstance = [[Thumbr alloc] init];
    }
    
    return sInstance;
}

#pragma mark - Image loading

+ (NSBundle*)getResourceBundle {
    static NSBundle *bundle = nil;
    if (!bundle) {
        NSString* bundleName;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            bundleName = @"Thumbr-iPad";
        } else {
            bundleName = @"Thumbr-iPhone";
        }
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource: bundleName ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath: bundlePath];
        if (!bundle) {
            [[[[UIAlertView alloc] initWithTitle: @"no bundle" message: [NSString stringWithFormat: @"Cannot find %@.bundle for this device", bundleName] delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil] autorelease] show];
        }
    }
	
    return bundle;
}

+ (UIImage*) loadImage: (NSString*) imageName forType: (NSString*) type {
    return [UIImage imageWithContentsOfFile:[[Thumbr getResourceBundle] pathForResource:imageName ofType:type]];
}


#pragma mark - delegate methods


//convert the profile to ThumbrUser data and send to delegate (the game)
+ (void) receivedProfile:(NSDictionary *)profile
{    NSLog(@"profile received: %@",profile);
    Thumbr* instance = [Thumbr instance];
    //set create ThumbrUser
    ThumbrUser* user = [[ThumbrUser alloc] init];
    [user setThumbrUserWithProfile:profile];
    
    NSMutableDictionary* settings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey: @"ThumbrUser"]];
    if([[profile valueForKey:@"address"] isKindOfClass:[NSNull class]] == false){[settings setValue: [profile valueForKey:@"address"] forKey: @"address"];}
    if([[profile valueForKey:@"city"] isKindOfClass:[NSNull class]] == false){[settings setValue: [profile valueForKey:@"city"] forKey: @"city"];}
    if([[profile valueForKey:@"country"] isKindOfClass:[NSNull class]] == false){[settings setValue: [profile valueForKey:@"country"] forKey: @"country"];}
    if([[profile valueForKey:@"email"] isKindOfClass:[NSNull class]] == false){[settings setValue: [profile valueForKey:@"email"] forKey: @"email"];}
    if([[profile valueForKey:@"firstname"] isKindOfClass:[NSNull class]] == false){[settings setValue: [profile valueForKey:@"firstname"] forKey: @"firstname"];}
    if([[profile valueForKey:@"id"] isKindOfClass:[NSNull class]] == false){[settings setValue: [profile valueForKey:@"id"] forKey: @"id"];}
    if([[profile valueForKey:@"locale"] isKindOfClass:[NSNull class]] == false){[settings setValue: [profile valueForKey:@"locale"] forKey: @"locale"];}
    if([[profile valueForKey:@"msisdn"] isKindOfClass:[NSNull class]] == false){[settings setValue: [profile valueForKey:@"msisdn"] forKey: @"msisdn"];}
    if([[profile valueForKey:@"newsletter"] isKindOfClass:[NSNull class]] == false){[settings setValue: [profile valueForKey:@"newsletter"] forKey: @"newsletter"];}
    if([[profile valueForKey:@"status"] isKindOfClass:[NSNull class]] == false){[settings setValue: [profile valueForKey:@"status"] forKey: @"status"];}
    if([[profile valueForKey:@"surname"] isKindOfClass:[NSNull class]] == false){[settings setValue: [profile valueForKey:@"surname"] forKey: @"surname"];}
    if([[profile valueForKey:@"username"] isKindOfClass:[NSNull class]] == false){[settings setValue: [profile valueForKey:@"username"] forKey: @"username"];}
    if([[profile valueForKey:@"zipcode"] isKindOfClass:[NSNull class]] == false){[settings setValue: [profile valueForKey:@"zipcode"] forKey: @"zipcode"];}
    if([[profile valueForKey:@"gender"] isKindOfClass:[NSNull class]] == false){[settings setValue: [profile valueForKey:@"gender"] forKey: @"gender"];}
    if([[profile valueForKey:@"date_of_birth"] isKindOfClass:[NSNull class]] == false){[settings setValue: [profile valueForKey:@"date_of_birth"] forKey: @"date_of_birth"];}
    if([[profile valueForKey:@"housenr"] isKindOfClass:[NSNull class]] == false){[settings setValue: [profile valueForKey:@"housenr"] forKey: @"housenr"];}
    [[NSUserDefaults standardUserDefaults] setObject: settings forKey: @"ThumbrUser"];

    //Send user information to delegate (game)
    [instance.delegate thumbrSDK:instance didLoginUser: user];
}

//+ (void) scoreCallback:(NSString *)method method:(NSObject *)parsedData
//{
//    Thumbr* instance = [Thumbr instance];
//    [instance.delegate scoreCallback:method method:parsedData];
//}

//let the (game) delegate know that the portalview is closed
+ (void) closedThumbrPortal
{   //NSLog(@"***** close portal");
    Thumbr* instance = [Thumbr instance];
    
    [instance.delegate closedSDKPortalView];
}

+ (void) sendAnimateAdIn:(id)sender{
    Thumbr* instance = [Thumbr instance];
    [instance.delegate animateAdIn:sender];
}
+ (void) sendAnimateAdOut:(id)sender{
    Thumbr* instance = [Thumbr instance];
    [instance.delegate animateAdOut:sender];
}
+ (void) sendInterstitialClosed:(id)sender{
    Thumbr* instance = [Thumbr instance];
    [instance.delegate interstitialClosed:sender];
}


#pragma mark - save/get settings
+ (void) saveAccesToken: (NSString*)accessToken
{
    //get stored authorization settings
    NSMutableDictionary* settings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey: @"ThumbrSettings"]];
    NSMutableDictionary* authorization = [NSMutableDictionary dictionaryWithDictionary:[settings objectForKey: @"authorization"]];
    
    //store accessToken in authorization settings
    [authorization setValue: accessToken forKey:@"access_token"];
    
    //store the authorization settings in the userdefaults
    [settings setValue: authorization forKey: @"authorization"];
    [[NSUserDefaults standardUserDefaults] setObject: settings forKey: @"ThumbrSettings"];
}

+ (NSString*) getAccesTokenFromSettings
{
    //get stored authorization settings
    NSMutableDictionary* settings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey: @"ThumbrSettings"]];
    NSMutableDictionary* authorization = [NSMutableDictionary dictionaryWithDictionary:[settings objectForKey: @"authorization"]];
    //get access token
    NSString* accessToken = [NSString stringWithFormat:@"%@", [authorization valueForKey:@"access_token"]];;

    return accessToken;
}

#pragma mark - Rotation handling methods

- (void)transformView:(UIView*)view toOrientation:(UIDeviceOrientation)orientation forCenter:(CGPoint)center {
    CGRect bounds = [[UIScreen mainScreen] applicationFrame];
    float angle = 0.f;
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
            angle = M_PI_2;
            center = CGPointMake(CGRectGetMaxX(bounds) - center.y, center.x);
            break;
        case UIDeviceOrientationLandscapeRight:
            angle = -M_PI_2;
            center = CGPointMake(center.y, CGRectGetMaxY(bounds) - center.x);
            break;
        case UIDeviceOrientationPortrait:
            angle = M_PI*2;
            center = CGPointMake(center.x, center.y);
            break;
        default:
            break;
    }
    view.transform = CGAffineTransformMakeRotation(angle);
    
    Thumbr* instance = [Thumbr instance];
    if(instance.portalOrientation == 3 || instance.portalOrientation == 4){
        view.center = center;
        //[[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationPortrait];
    }
}

- (void)transformViewsToOrientation:(UIDeviceOrientation)orientation {
    
    UIView* portalview = [self.presentationWindow viewWithTag:PORTALVIEWTAG];
    if (portalview) {
        [self transformView:portalview toOrientation:orientation forCenter:[self.portalCenter CGPointValue]];
    }
    
}

- (void) handleRotation {
    UIDeviceOrientation o = self.portalOrientation;
    Thumbr* instance = [Thumbr instance];
    if (self.changeOrientationWithRotation) {
        UIDeviceOrientation no = [[UIDevice currentDevice] orientation];
        if(instance.portalOrientation == 1 || instance.portalOrientation ==2){
            switch (no) {
                case UIDeviceOrientationPortrait:
                    o = no;
                    //[[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationPortrait];
                    break;
                default: break;
            }
        }
        else{
            switch (no) {
                case UIDeviceOrientationLandscapeLeft:
                    //[[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeLeft];
                    o = no;
                    break;
                case UIDeviceOrientationLandscapeRight:
                    //[[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeRight];
                    o = no;
                    break;
                default: break;
            }
        }
        
    }
    [self transformViewsToOrientation:o];
}

- (void)didRotate:(NSNotification *)notification {
    Thumbr* instance = [Thumbr instance];
    UIDeviceOrientation o = [[UIDevice currentDevice] orientation];
    if(instance.portalOrientation == 1 || instance.portalOrientation ==2){
        switch (o) {
            case UIDeviceOrientationPortrait:
                [self handleRotation];
                break;
            default: break;
        }
    }
    else{
        switch (o) {
            case UIDeviceOrientationLandscapeLeft:
            case UIDeviceOrientationLandscapeRight:
                [self handleRotation];
                break;
            default: break;
        }
    }
}


@end
