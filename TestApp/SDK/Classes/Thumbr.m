//
//  Thumbr.m
//  Thumbr
//
//  Created by aiso haikens on 28-02-12.
//  Updated by Stephnie Mossel ;)
//  Copyright (c) 2012 ideesoft.nl. All rights reserved.
//

#import "Thumbr.h"
#import "Thumbr+Private.h"
#import "ThumbrReachability.h"
#import "PortalViewController.h"
#import "scoreBoard.h"
#import "AppsFlyer.h"
#import <MadsSDK/MadsSDK.h>
#import "AdViewController.h"

NSString* ThumbrSettingStatusBarHidden              = @"ThumbrSettingStatusBarHidden";
NSString* ThumbrSettingPresentationWindow           = @"ThumbrSettingPresentationWindow";
NSString* ThumbrSettingPortalOrientation            = @"ThumbrSettingPortalOrientation";
NSString* ThumbrSettingChangeOrientationOnRotation  = @"ThumbrSettingChangeOrientationOnRotation";
NSString* ThumbrSettingClientId                     = @"ThumbrSettingClientId";
NSString* ThumbrSettingSid                          = @"ThumbrSettingSid";
NSString* ThumbrSettingRegisterUrl                  = @"ThumbrSettingRegisterUrl";
NSString* ThumbrSettingSwitchUrl                    = @"ThumnrSettingRegisterUrl";
NSString* ThumbrSettingPortalUrl                    = @"ThumbrSettingPortalUrl";
NSString* ThumbrSettingShowLoadingErrors            = @"ThumbrSettingShowLoadingErrors";
NSString* ThumbrSettingShowCloseButton              = @"ThumbrSettingShowCloseButton";
NSString* ThumbrSettingnew_country                  = @"new_country";
NSString* ThumbrSettingnew_locale                   = @"new_locale";
NSString* ThumbrSettingScoreGameID                  = @"ThumbrSettingScoreGameID";

ThumbrReachability* thumbrReachability;

//TODO: remove maybe

@interface ThumbrUser () {
@protected
    NSString* uid; 
    NSString* username;
    NSInteger status;
}

@property (readwrite, strong) NSString* uid; //readwrite,
@property (readwrite, strong) NSString* username;
@property (readwrite) NSInteger status;

@end

//--------

@implementation ThumbrUser

@synthesize uid;
@synthesize username;
@synthesize status;

@end


@interface Thumbr() {
@protected
    id <ThumbrSDKDelegate> delegate;
    UIWindow* presentationWindow;
    UIViewController* portalViewController;
    UIDeviceOrientation portalOrientation;
    NSString* statusBarHidden;
    NSString* sid;
    NSString* clientId;
    NSString* country;
    NSString* locale;
    NSString* state;
    NSString* registerUrl;
    NSString* switchUrl;
    NSString* portalUrl;
    NSURL* currentUrl;
    NSString* accessToken;
    BOOL changeOrientationWithRotation;
    BOOL showLoadingErrors;
    BOOL showCloseButton;
}

@property(assign) id<ThumbrSDKDelegate> delegate;
@property(strong) UIWindow* presentationWindow;
@property(strong) UIViewController* portalViewController;
@property UIDeviceOrientation portalOrientation;
@property(strong) NSString* statusBarHidden;
@property(strong) NSString* sid;
@property(strong) NSString* clientId;
@property(strong) NSString* country;
@property(strong) NSString* locale;
@property(strong) NSString* state;
@property(strong) NSString* registerUrl;
@property(strong) NSString* switchUrl;
@property(strong) NSString* portalUrl;
@property(strong) NSString* appsFlyerId;
@property(strong) NSURL* currentUrl;
@property(strong) NSString* accessToken;
@property(assign) BOOL changeOrientationWithRotation;
@property(assign) BOOL showLoadingErrors;
@property(assign) BOOL showCloseButton;
@property(strong) NSValue* portalCenter;
@property(strong) NSValue* buttonCenter;


@end

@implementation Thumbr


@synthesize delegate;
@synthesize presentationWindow;
@synthesize statusBarHidden;
@synthesize portalViewController;
@synthesize portalOrientation;
@synthesize sid;
@synthesize clientId;
@synthesize state;
@synthesize locale;
@synthesize country;
@synthesize registerUrl;
@synthesize switchUrl;
@synthesize portalUrl;
@synthesize appsFlyerId;
@synthesize currentUrl;
@synthesize accessToken;
@synthesize changeOrientationWithRotation;
@synthesize showLoadingErrors;
@synthesize showCloseButton;
@synthesize portalCenter;
@synthesize buttonCenter;

#pragma mark - init Thumbr SDK

+ (void) initializeSDKWithSettings: (NSDictionary*)_settings andDelegate: (id)_delegate;
{

    [MadsAdServer startWithLocationEnabled:YES withLocationPurpose:NSLocalizedString(@"To show you other players near you", nil) withAppTargetingEnabled:YES];
    Thumbr* instance = [Thumbr instance];
    [Thumbr synchronizeScores];
    
    instance.delegate = _delegate;

    if (NSClassFromString(@"AppsFlyer")) {
        NSLog(@"AppsFlyer is installed: %@",NSClassFromString(@"AppsFlyer"));
        Class AppsFlyer = NSClassFromString(@"AppsFlyer");
        NSLog(@"AppsFlyer ID: %@",[AppsFlyer getAppsFlyerUID]);
        instance.appsFlyerId = [AppsFlyer getAppsFlyerUID];
    } else {
        NSLog(@"AppsFlyer is NOT installed");
        instance.appsFlyerId = @"";
    }

    //settings
    instance.statusBarHidden = [_settings objectForKey:ThumbrSettingStatusBarHidden];
    if (![instance.statusBarHidden length]) {
        [NSException raise:NSInvalidArgumentException format:@"ThumbrSDK ERROR: ThumbrSettingStatusBarHidden is not properly set"];
    }
    
    instance.presentationWindow = [_settings objectForKey:ThumbrSettingPresentationWindow];
    if (![instance.presentationWindow isKindOfClass:[UIWindow class]]) {
        [NSException raise:NSInvalidArgumentException format:@"ThumbrSDK ERROR: ThumbrSettingPresentationWindow is not properly set"];
    }
    
    instance.portalOrientation = (UIDeviceOrientation)[[_settings objectForKey:ThumbrSettingPortalOrientation] intValue];
    if (![[_settings objectForKey:ThumbrSettingPortalOrientation] isKindOfClass:[NSNumber class]]) {
        [NSException raise:NSInvalidArgumentException format:@"ThumbrSDK ERROR: ThumbrSettingPortalOrientation is not properly set"];
    }
    
    instance.changeOrientationWithRotation = [[_settings objectForKey:ThumbrSettingChangeOrientationOnRotation] boolValue];
    if (![[_settings objectForKey:ThumbrSettingChangeOrientationOnRotation] isKindOfClass:[NSNumber class]]) {
        [NSException raise:NSInvalidArgumentException format:@"ThumbrSDK ERROR: ThumbrSettingChangeOrientationOnRotation is not properly set"];
    }
    
    
    instance.clientId = [_settings objectForKey:ThumbrSettingClientId];
    if (![instance.clientId length]) {
        [NSException raise:NSInvalidArgumentException format:@"ThumbrSDK ERROR: ThumbrSettingClientId is not properly set"];
    }
    
    instance.sid = [_settings objectForKey:ThumbrSettingSid];
    if (![instance.sid length]) {
        [NSException raise:NSInvalidArgumentException format:@"ThumbrSDK ERROR: ThumbrSettingSid is not properly set"];
    }
    
    instance.registerUrl = [_settings objectForKey:ThumbrSettingRegisterUrl];
    if (![instance.registerUrl length] ) {
        [NSException raise:NSInvalidArgumentException format:@"ThumbrSDK ERROR: ThumbrSettingRegisterUrl is not properly set"];
    }
    
    instance.switchUrl = [_settings objectForKey:ThumbrSettingSwitchUrl];
    if (![instance.switchUrl length]) {
        [NSException raise:NSInvalidArgumentException format:@"ThumbrSDK ERROR: ThumbrSettingSwitchUrl is not properly set"];
    }
    
    instance.portalUrl = [_settings objectForKey:ThumbrSettingPortalUrl];
    if (![instance.portalUrl length]) {
        [NSException raise:NSInvalidArgumentException format:@"ThumbrSDK ERROR: ThumbrSettingPortalUrl is not properly set"];
    }

    
    instance.showLoadingErrors = [[_settings objectForKey:ThumbrSettingShowLoadingErrors] boolValue];
    if (![[_settings objectForKey:ThumbrSettingShowLoadingErrors] isKindOfClass:[NSNumber class]]) {
        instance.showLoadingErrors = NO;
    } 
    
    instance.showCloseButton = [[_settings objectForKey:ThumbrSettingShowCloseButton] boolValue];
    if (![[_settings objectForKey:ThumbrSettingShowCloseButton] isKindOfClass:[NSNumber class]]) {
        instance.showCloseButton = NO;
    }   
    instance.state = @"dpuujt1gmv72vrntu4ht9t8ru6";
    
    //set local settings )language and country
    instance.country = [_settings objectForKey:ThumbrSettingnew_country];
    if (![instance.country length]) {
        NSLog(@"Country: %@", instance.country);
    instance.country    = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    }

    instance.locale = [_settings objectForKey:ThumbrSettingnew_locale];
    if (![instance.locale length]) {
        instance.locale     = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
    }

    
    if (instance.changeOrientationWithRotation) {
        if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        }

        [[NSNotificationCenter defaultCenter] addObserver:instance
                                                 selector:@selector(didRotate:)
                                                     name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    
    //get stored access token 
    instance.accessToken = [self getAccesTokenFromSettings];
    if ([instance.accessToken length] < 1) {
        instance.accessToken = @"";
    }
    
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey: @"ThumbrSettings"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[Thumbr getResourceBundle] pathForResource:@"defaults" ofType: @"plist"]]];
}



#pragma mark -  open/close Portal Method

//general portal start call
+ (void) openPortalWithUrl: (NSURL*)url {
    //load the portalview with the url
//     NSLog(@"******* openPortalWithUrl: %@", url);
    
    Thumbr* instance = [Thumbr instance];
    instance.currentUrl = url;
    UIView* portalview = [instance.presentationWindow viewWithTag:PORTALVIEWTAG];
    if (!portalview) {
        if(instance.portalOrientation==1||instance.portalOrientation==2){
//PORTRAIT
            NSString *viewname;
            CGSize screenSize = [[UIScreen mainScreen] bounds].size;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                if (screenSize.height > 480.0f) {
                    /*Do iPhone 5 stuff here.*/
            viewname=@"PortalView_portrait_iphone5";
                } else {
                    /*Do iPhone Classic stuff here.*/
            viewname=@"PortalView_portrait";
                }
            } else {
                /*Do iPad stuff here.*/
            viewname=@"PortalView_portrait";                
            }
            
            PortalViewController* vc = [[[PortalViewController alloc] initWithNibName: viewname bundle: [Thumbr getResourceBundle]] autorelease];
            instance.portalCenter = [NSValue valueWithCGPoint:vc.view.center];
            vc.view.tag = PORTALVIEWTAG;
            [instance.presentationWindow addSubview: vc.view];
            CGRect frame = vc.view.frame;
            
            vc.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);

            [instance handleRotation];
            instance.portalViewController = vc;
        }else{
//LANDSCAPE
            PortalViewController* vc = [[[PortalViewController alloc] initWithNibName: @"PortalView" bundle: [Thumbr getResourceBundle]] autorelease];
            instance.portalCenter = [NSValue valueWithCGPoint:vc.view.center];
            vc.view.tag = PORTALVIEWTAG;
            [instance.presentationWindow addSubview: vc.view];
            CGRect frame = vc.view.frame;
            
            if (frame.size.width < frame.size.height) { // force landscape size
                vc.view.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
            }
            [instance handleRotation];
            instance.portalViewController = vc;
        }

    }

        NSLog(@"Open portal view with url: %@",url);
    [(PortalViewController*)instance.portalViewController loadPortalWithUrl:url];
}


//stop portal
+ (void) closeThumbrPortal {
    //NSLog(@"******* closeThumbrPortal..");
    Thumbr* instance = [Thumbr instance];
    PortalViewController* vc = (PortalViewController*)instance.portalViewController;
    [vc close:nil];
}

#pragma mark - target methods for Thumbr buttons

// start portal at the authorization page
+ (void) startThumbrPortalLogin{
    Thumbr* instance = [Thumbr instance];
    //    NSLog(@"******* startThumbrPortalLogin..");
    
    //load init startUrl with auth parameters
    NSString* url = [NSString stringWithFormat:@"%@client_id=%@&response_type=token&state=%@&sid=%@&country=%@&locale=%@&access_token=%@&handset_id=%@",instance.registerUrl,instance.clientId, instance.state, instance.sid, instance.country, instance.locale, instance.accessToken,instance.appsFlyerId];
    int counter=[Thumbr storeCounter];
    url=[NSString stringWithFormat:@"%@&count=%d&sdk=1",url,counter];
    [self openPortalWithUrl:[NSURL URLWithString: url]];
}

+ (NSString *) statusBarHidden{
        Thumbr* instance = [Thumbr instance];
    return instance.statusBarHidden;
}


//start portal to switch users
+ (void) startThumbrPortalSwitch{
//     NSLog(@"******* startThumbrPortalSwitch..");

    Thumbr* instance = [Thumbr instance];

    //load init startUrl with auth parameters
    NSString* url = [NSString stringWithFormat:@"%@client_id=%@&response_type=token&state=%@&sid=%@&country=%@&locale=%@&step=switchaccount&handset_id=%@&sdk=1",instance.switchUrl, instance.clientId, instance.state, instance.sid, instance.country, instance.locale,instance.appsFlyerId];
    
    [self openPortalWithUrl:[NSURL URLWithString: url]];
}

// start portal to start registration
+ (void) startThumbrPortalRegistration{
    
//    NSLog(@"******* startThumbrPortalRegistration..");
    Thumbr* instance = [Thumbr instance];
    
    //load init startUrl with auth parameters
    NSString* url = [NSString stringWithFormat:@"%@client_id=%@&response_type=token&state=%@&sid=%@&country=%@&locale=%@&handset_id=%@",instance.registerUrl, instance.clientId, instance.state, instance.sid, instance.country, instance.locale,instance.appsFlyerId];
    int counter=[Thumbr storeCounter];
    NSString *action=[Thumbr getAction];
    url=[NSString stringWithFormat:@"%@&action=%@&count=%d&sdk=1",url,action,counter];
    [self openPortalWithUrl:[NSURL URLWithString: url]];
}

+ (void) resume{
    [Thumbr synchronizeScores];
}

//start thumbr portal
+ (void) startThumbrPortal{
//    NSLog(@"******* startThumbrPortal..");
    Thumbr* instance = [Thumbr instance];
    
    //load init startUrl with auth parameters
    NSString* url = [NSString stringWithFormat:@"%@&sid=%@&handset_id=%@&sdk=1",instance.portalUrl, instance.sid, instance.appsFlyerId];
    NSLog(@"Start portal: %@",url);
    [self openPortalWithUrl:[NSURL URLWithString: url]];
}


// start scores overview
+ (void) openScores{
    
    //NSURL *url =[NSURL fileURLWithPath:[[Thumbr getResourceBundle ] pathForResource:@"score" ofType:@"html"]isDirectory:NO];
    //NSString *URLString = [url absoluteString];
    NSString *URLString = @"http://twimmer.com/scoreoid";
    
    NSString *queryString = @"?sms=1&i[]=scores&i[]=assets&i[]=goals&i[]=levels&i[]=inventory&a[]=bonus&a[]=gold&a[]=money&a[]=kills&a[]=lives&a[]=xp&a[]=energy&ab=50&ag=10&am=100&ak=10&al=5&ax=99&ae=88&sm=100&sc=50&s1=100&s2=90&s3=80&s4=70&s5=60&s6=50&s7=40&s8=30&s9=20&s10=10&su1=jan&su2=klaas&su3=piet&su4=henkmetdelangeachternaam&su5=truus&su6=bep&su7=tina&su8=bert&su9=fluppie&su10=willem&l[]=1,1,first%20level&l[]=2,1,second%20level&l[]=3,1,third%20level&l[]=4,0,fourth%20level&l[]=5,0,fifth%20level&l[]=6,0,sixth%20level&l[]=7,0,seventh%20level&l[]=8,0,eighth%20level&n[]=1,1,bike&n[]=2,1,car&n[]=3,0,flashlight&n[]=4,0,hammer&n[]=5,0,scizzors&n[]=6,0,good%20luck&n[]=7,0,wisdom&n[]=8,0,sunshine&n[]=9,0,wealth&n[]=10,0,health&g[]=1,1,beginner&g[]=2,1,slightly%20better&g[]=3,0,somewhat%20good&g[]=4,0,fairly%20good&g[]=5,0,good&g[]=6,0,pretty%20good&g[]=7,0,really%20good&g[]=8,0,excellent&g[]=9,0,brilliant&g[]=10,0,expert";
    NSString *URLwithQueryString = [URLString stringByAppendingString: queryString];
    NSLog(@"open scores with url:  %@",URLwithQueryString);
    NSURL *finalURL = [NSURL URLWithString:URLwithQueryString];
    
    [self openPortalWithUrl:finalURL];
}


+ (UIButton *)loadThumbrT:(float)relativeSize relativeSize:(NSString *)position{
    int iconSize;
    int y;
    int x;

    NSString *TL=@"TL";
    NSString *TR=@"TR";
    NSString *BL=@"BL";
    NSString *BR=@"BR";
    

    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    //determine relative Thumbr T icon size
    iconSize=[[UIScreen mainScreen] bounds].size.height /relativeSize;
    if(iconSize > 190){iconSize=190;}
    
    if(position == TL){
        y=0;
        x=0;
    }
    else if (position == TR){
        y=0;
        x=screenWidth - iconSize;
    }
    else if (position == BL){
        y=screenHeight - iconSize;
        x=0;
    }
    else if (position == BR){
        y=screenHeight - iconSize;
        x=screenWidth - iconSize;
    }
    else{
        y=0;
        x=0;
    }
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSUInteger i = 0; i <= 95; i++) {
        int a=i;
        if(a <30){a=30;}
        NSString *imageName = [NSString stringWithFormat:@"Thumbr-iPad.bundle/thumbr_000%d.png", a];
        [imageArray addObject:[UIImage imageNamed:imageName]];
    }
    
    //create the button
	UIButton * thumbrT = [[UIButton alloc] initWithFrame:CGRectMake(x,y,iconSize,iconSize)];

    [thumbrT setImage:[UIImage imageNamed:@"Thumbr-iPad.bundle/thumbr_00030.png"] forState:UIControlStateNormal];
    
	thumbrT.imageView.animationImages = imageArray;
	thumbrT.imageView.animationDuration = 5;

    thumbrT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    thumbrT.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
	[thumbrT.imageView startAnimating];


    //add click event to the button
    [thumbrT addTarget:self action:@selector(thumbrTClicked) forControlEvents:UIControlEventTouchUpInside];
    return thumbrT;
}

+ (void)thumbrTClicked{
    [Thumbr startThumbrPortalRegistration];
}

//Store the number of SDK opens
+ (int) storeCounter{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger openCounter = [prefs integerForKey:@"openCounter"];
    if(!openCounter){openCounter=0;}
    openCounter = openCounter + 1;
    [prefs setInteger:openCounter forKey:@"openCounter"];
    return openCounter;
}

#pragma mark - store action to be added to registration url
+ (void) setAction:(NSString*)action{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:action forKey:@"action"];
}

+ (NSString *) getAction{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *action = [prefs stringForKey:@"action"];
    if(!action || (![action isEqual:@"registration"] && ![action isEqual:@"optional_registration"])){action=@"default";}
    return action;
}

/*
 SCOREOID
*/

+(void)synchronizeScores{
    [scoreBoard synchronizeScores];
}



/*
 ** getNotification**;
 ** method lets you pull your game's in game notifications.
 **/
+ (NSObject *) getNotification{
    NSMutableDictionary *scoreParams = [NSMutableDictionary dictionary];
    method = @"getNotification";
    NSObject* result=[scoreBoard send:scoreParams params:method];
    return result;
}
/*
 ** getGameTotal**;
 ** gets the total for the following game field's bonus, gold, money, kills, lifes, time_played and unlocked_levels.
 *  REQUIRED: field                         String Value, (bonus, gold, money, kills, lifes, time_played, unlocked_levels)
 *  OPTIONAL: start_date                    String Value, YYY-MM-DD format
 *  OPTIONAL: end_date                      String Value, YYY-MM-DD format
 *  OPTIONAL: platform                      The players platform needs to match the string value that was used when creating the player
 **/
+ (NSObject *) getGameTotal:(NSString *)field :(NSMutableDictionary *)scoreParams{
    method = @"getGameTotal";
    [scoreParams setObject:field forKey:@"field"];
    NSObject* result=[scoreBoard send:scoreParams params:method];
    return result;
}
/*
 ** getGameLowest**;
 ** gets the lowest vaule for the following game field's bonus, gold, money, kills, lifes, time_played and unlocked_levels.
 *  REQUIRED: field                         String Value, (bonus, gold, money, kills, lifes, time_played, unlocked_levels)
 *  OPTIONAL: start_date                    String Value, YYY-MM-DD format
 *  OPTIONAL: end_date                      String Value, YYY-MM-DD format
 *  OPTIONAL: platform                      The players platform needs to match the string value that was used when creating the player
 **/
+ (NSObject *) getGameLowest:(NSString *)field :(NSMutableDictionary *)scoreParams{
    method = @"getGameLowest";
    [scoreParams setObject:field forKey:@"field"];
    NSObject* result=[scoreBoard send:scoreParams params:method];
    return result;
}
/*
 ** getGameTop**;
 ** gets the top value for the following game field's bonus, gold, money, kills, lifes, time_played and unlocked_levels.
 *  REQUIRED: field                         String Value, (bonus, gold, money, kills, lifes, time_played, unlocked_levels)
 *  OPTIONAL: start_date                    String Value, YYY-MM-DD format
 *  OPTIONAL: end_date                      String Value, YYY-MM-DD format
 *  OPTIONAL: platform                      The players platform needs to match the string value that was used when creating the player
 **/
+ (NSObject *) getGameTop:(NSString *)field :(NSMutableDictionary *)scoreParams{
    method = @"getGameTop";
    [scoreParams setObject:field forKey:@"field"];
    NSObject* result=[scoreBoard send:scoreParams params:method];
    return result;
}
/*
 ** getGameAverage**;
 ** gets the average for the following game field's bonus, gold, money, kills, lifes, time_played and unlocked_levels.
 *  REQUIRED: field                         String Value, (bonus, gold, money, kills, lifes, time_played, unlocked_levels)
 *  OPTIONAL: start_date                    String Value, YYY-MM-DD format
 *  OPTIONAL: end_date                      String Value, YYY-MM-DD format
 *  OPTIONAL: platform                      The players platform needs to match the string value that was used when creating the player
 **/
+ (NSObject *) getGameAverage:(NSString *)field :(NSMutableDictionary *)scoreParams{
    method = @"getGameAverage";
    [scoreParams setObject:field forKey:@"field"];
    NSObject* result=[scoreBoard send:scoreParams params:method];
    return result;
}
/*
 ** getPlayers**;
 ** API method lets you get all the players for a specif game.getGameField
 *  OPTIONAL: order_by                      String Value, (date or score)
 *  OPTIONAL: order                         String Value, asc or desc
 *  OPTIONAL: limit                         Number Value, the limit, "20" retrieves rows 1 - 20 | "10,20" retrieves 20 scores starting from the 10th
 *  OPTIONAL: start_date                    String Value, YYY-MM-DD format
 *  OPTIONAL: end_date                      String Value, YYY-MM-DD format
 *  OPTIONAL: platform                      String Value, needs to match the string value that was used when creating the player
 **/
+ (NSObject *) getPlayers:(NSMutableDictionary *)scoreParams{
    method = @"getPlayers";
    NSObject* result=[scoreBoard send:scoreParams params:method];
    return result;
}
/*
 ** getGameField**;
 ** method lets you pull a specific field from your game info.
 *  OPTIONAL: field                         name,short_description,description,game_type,version,levels,platform,play_url,website_url,created,updated,player_count,scores_count,locked,status,
 **/
+ (NSObject *) getGameField:(NSMutableDictionary *)scoreParams{
    method = @"getGameField";
    NSObject* result=[scoreBoard send:scoreParams params:method];
    return result;
}
/*
 ** getGame**;
 ** method lets you pull all your game information.
 **/
+ (NSObject *) getGame{
    NSMutableDictionary *scoreParams = [NSMutableDictionary dictionary];
    method = @"getGame";
    NSObject* result=[scoreBoard send:scoreParams params:method];
    return result;
}
/*
 ** getPlayerScores**;
 ** method lets you pull all the scores for a player.
 *  REQUIRED: username                      String Value, the players username
 *  OPTIONAL: start_date                    String Value, YYY-MM-DD format
 *  OPTIONAL: end_date                      String Value, YYY-MM-DD format
 *  OPTIONAL: difficulty                    Integer Value, between 1 to 10 (don't use 0 as it's the default value)
 **/
+ (NSObject *) getPlayerScores:(NSString *)username :(NSMutableDictionary *)scoreParams{
    method = @"getPlayerScores";
    [scoreParams setObject:username forKey:@"username"];
    NSObject* result=[scoreBoard send:scoreParams params:method];
    return result;
}
/*
 ** getPlayer**;
 ** method Check if player exists and returns the player information. Post parameters work as query conditions. This method can be used for login by adding username and password parameters.
 *  OPTIONAL: id                            The players ID [String]
 *  REQUIRED: username                      String Value, the players username
 *  OPTIONAL: password                      The players password [String]
 **/
+ (NSObject *) getPlayer:(NSString *)username :(NSMutableDictionary *)scoreParams{
    method = @"getPlayer";
    [scoreParams setObject:username forKey:@"username"];
    NSObject* result=[scoreBoard send:scoreParams params:method];
    return result;
}
/*
 ** editPlayer**;
 ** method lets you edit your player information.
 *  REQUIRED: username                      String Value, the players username
 *  OPTIONAL: password                      The players password [String]
 *  OPTIONAL: unique_id                     Integer Value,
 *  OPTIONAL: first_name                    The players first name [String]
 *  OPTIONAL: last_name                     The players last name [String]
 *  OPTIONAL: created                       The date the player was created calculated by Scoreoid [YYYY-MM-DD hh:mm:ss]
 *  OPTIONAL: updated                       The last time the player was updated calculated by Scoreoid [YYYY-MM-DD hh:mm:ss]
 *  OPTIONAL: bonus                         The players bonus [Integer]
 *  OPTIONAL: achievements                  The players achievements [String, comma-separated]
 *  OPTIONAL: best_score                    The players best score calculated by Scoreoid [Integer]
 *  OPTIONAL: gold                          The players gold [Integer]
 *  OPTIONAL: money                         The players money [Integer]
 *  OPTIONAL: kills                         The players kills [Integer]
 *  OPTIONAL: lives                         The players lives [Integer]
 *  OPTIONAL: time_played                   The time the player played [Integer]
 *  OPTIONAL: unlocked_levels               The players unlocked levels [Integer]
 *  OPTIONAL: unlocked_items                The players unlocked items [String, comma-separated]
 *  OPTIONAL: inventory                     The players inventory [String, comma-separated]
 *  OPTIONAL: last_level                    The players last level [Integer]
 *  OPTIONAL: current_level                 The players current level [Integer]
 *  OPTIONAL: current_time                  The players current time [Integer]
 *  OPTIONAL: current_bonus                 The players current bonus [Integer]
 *  OPTIONAL: current_kills                 The players current kills [Integer]
 *  OPTIONAL: current_achievements          The players current achievements [String, comma-separated]
 *  OPTIONAL: current_gold                  The players current gold [Integer]
 *  OPTIONAL: current_unlocked_levels       The players current unlocked levels [Integer]
 *  OPTIONAL: current_unlocked_items        The players current unlocked items [String, comma-separated]
 *  OPTIONAL: current_lifes                 The players current lifes [Integer]
 *  OPTIONAL: xp                            The players XP [Integer]
 *  OPTIONAL: energy                        The players energy [Integer]
 *  OPTIONAL: boost                         The players energy [Integer]
 *  OPTIONAL: latitude                      The players GPS latitude [Integer]
 *  OPTIONAL: longitude                     The players GPS longitude [Integer]
 *  OPTIONAL: game_state                    The players game state [String]
 *  OPTIONAL: platform                      The players platform needs to match the string value that was used when creating the player
 **/
+ (NSObject *) editPlayer:(NSString *)username :(NSMutableDictionary *)scoreParams{
    method = @"editPlayer";
    [scoreParams setObject:username forKey:@"username"];
    NSObject* result=[scoreBoard send:scoreParams params:method];
    return result;
}
/*
 ** countPlayers**;
 ** method lets you count all your players.
 *  OPTIONAL: start_date                    String Value, YYY-MM-DD format
 *  OPTIONAL: end_date                      String Value, YYY-MM-DD format
 *  OPTIONAL: platform                      The players platform needs to match the string value that was used when creating the player
 **/
+ (NSObject *) countPlayers:(NSMutableDictionary *)scoreParams{
    method = @"countPlayers";
    NSObject* result=[scoreBoard send:scoreParams params:method];
    return result;
}
/*
 ** updatePlayerField**;
 ** method lets you update your player field's.
 *  REQUIRED: username                      String Value, the players username
 *  REQUIRED: field                         password,unique_id,first_name,last_name,created,updated,bonus,achievements,gold,money,kills,lives,time_played,unlocked_levels,unlocked_items,inventory,last_level,current_level,current_time,current_bonus,current_kills,current_achievements,current_gold,current_unlocked_levels,current_unlocked_items,current_lifes,xp,energy,boost,latitude,longitude,game_state,platform,
 *  REQUIRED: value                         String Value, the field value
 **/
+ (NSObject *) updatePlayerField:(NSString *)username :(NSString *)field :(NSString *)value :(NSMutableDictionary *)scoreParams{
    method = @"updatePlayerField";
    [scoreParams setObject:username forKey:@"username"];
    [scoreParams setObject:field forKey:@"field"];
    [scoreParams setObject:value forKey:@"value"];
    NSObject* result=[scoreBoard send:scoreParams params:method];
    return result;
}
/*
 ** createPlayer**;
 ** method lets you create a player with a number of optional values.
 *  REQUIRED: username                      The players username [String]
 *  OPTIONAL: password                      The players password used if you would like to create user log-in [String]
 *  OPTIONAL: score                         Integer Value
 *  OPTIONAL: difficulty                    Integer Value, between 1 to 10 (don't use 0 as it's the default value)
 *  OPTIONAL: unique_id                     Integer Value,
 *  OPTIONAL: first_name                    The players first name [String]
 *  OPTIONAL: last_name                     The players last name [String]
 *  OPTIONAL: created                       The date the player was created calculated by Scoreoid [YYYY-MM-DD hh:mm:ss]
 *  OPTIONAL: updated                       The last time the player was updated calculated by Scoreoid [YYYY-MM-DD hh:mm:ss]
 *  OPTIONAL: bonus                         The players bonus [Integer]
 *  OPTIONAL: achievements                  The players achievements [String, comma-separated]
 *  OPTIONAL: best_score                    The players best score calculated by Scoreoid [Integer]
 *  OPTIONAL: gold                          The players gold [Integer]
 *  OPTIONAL: money                         The players money [Integer]
 *  OPTIONAL: kills                         The players kills [Integer]
 *  OPTIONAL: lives                         The players lives [Integer]
 *  OPTIONAL: time_played                   The time the player played [Integer]
 *  OPTIONAL: unlocked_levels               The players unlocked levels [Integer]
 *  OPTIONAL: unlocked_items                The players unlocked items [String, comma-separated]
 *  OPTIONAL: inventory                     The players inventory [String, comma-separated]
 *  OPTIONAL: last_level                    The players last level [Integer]
 *  OPTIONAL: current_level                 The players current level [Integer]
 *  OPTIONAL: current_time                  The players current time [Integer]
 *  OPTIONAL: current_bonus                 The players current bonus [Integer]
 *  OPTIONAL: current_kills                 The players current kills [Integer]
 *  OPTIONAL: current_achievements          The players current achievements [String, comma-separated]
 *  OPTIONAL: current_gold                  The players current gold [Integer]
 *  OPTIONAL: current_unlocked_levels       The players current unlocked levels [Integer]
 *  OPTIONAL: current_unlocked_items        The players current unlocked items [String, comma-separated]
 *  OPTIONAL: current_lifes                 The players current lifes [Integer]
 *  OPTIONAL: xp                            The players XP [Integer]
 *  OPTIONAL: energy                        The players energy [Integer]
 *  OPTIONAL: boost                         The players energy [Integer]
 *  OPTIONAL: latitude                      The players GPS latitude [Integer]
 *  OPTIONAL: longitude                     The players GPS longitude [Integer]
 *  OPTIONAL: game_state                    The players game state [String]
 *  OPTIONAL: platform                      The players platform needs to match the string value that was used when creating the player
 **/
+ (NSObject *) createPlayer:(NSString *)username :(NSMutableDictionary *)scoreParams{
    method = @"createPlayer";
    [scoreParams setObject:username forKey:@"username"];
    NSObject* result=[scoreBoard send:scoreParams params:method];
    return result;
}
/*
 ** countBestScores**;
 ** method lets you count all your game best scores.
 *  OPTIONAL: start_date                    String Value, YYY-MM-DD format
 *  OPTIONAL: end_date                      String Value, YYY-MM-DD format
 *  OPTIONAL: platform                      The players platform needs to match the string value that was used when creating the player
 *  OPTIONAL: difficulty                    Integer Value, between 1 to 10 (don't use 0 as it's the default value)
 **/
+ (NSObject *) countBestScores:(NSMutableDictionary *)scoreParams{
    method = @"countBestScores";
    NSObject* result=[scoreBoard send:scoreParams params:method];
    return result;
}
/*
 ** getAverageScore**;
 ** method lets you get all your game average scores.
 *  OPTIONAL: start_date                    String Value, YYY-MM-DD format
 *  OPTIONAL: end_date                      String Value, YYY-MM-DD format
 *  OPTIONAL: platform                      The players platform needs to match the string value that was used when creating the player
 *  OPTIONAL: difficulty                    Integer Value, between 1 to 10 (don't use 0 as it's the default value)
 **/
+ (NSObject *) getAverageScore:(NSMutableDictionary *)scoreParams{
    method = @"getAverageScore";
    NSObject* result=[scoreBoard send:scoreParams params:method];
    return result;
}
/*
 ** getBestScores**;
 ** method lets you get all your games best scores.
 *  OPTIONAL: order_by                      String Value, (date or score)
 *  OPTIONAL: order                         String Value, asc or desc
 *  OPTIONAL: limit                         Number Value, the limit, "20" retrieves rows 1 - 20 | "10,20" retrieves 20 scores starting from the 10th
 *  OPTIONAL: start_date                    String Value, YYY-MM-DD format
 *  OPTIONAL: end_date                      String Value, YYY-MM-DD format
 *  OPTIONAL: platform                      The players platform needs to match the string value that was used when creating the player
 *  OPTIONAL: difficulty                    Integer Value, between 1 to 10 (don't use 0 as it's the default value)
 **/
+ (NSObject *) getBestScores:(NSMutableDictionary *)scoreParams{
    method = @"getBestScores";
    NSObject* result=[scoreBoard send:scoreParams params:method];
    return result;
}
/*
 ** countScores**;
 ** method lets you count all your game scores.
 *  OPTIONAL: start_date                    String Value, YYY-MM-DD format
 *  OPTIONAL: end_date                      String Value, YYY-MM-DD format
 *  OPTIONAL: platform                      The players platform needs to match the string value that was used when creating the player
 *  OPTIONAL: difficulty                    Integer Value, between 1 to 10 (don't use 0 as it's the default value)
 **/
+ (NSObject *) countScores:(NSMutableDictionary *)scoreParams{
    method = @"countScores";
    NSObject* result=[scoreBoard send:scoreParams params:method];
    return result;
}
/*
 ** getScores**;
 ** method lets you pull all your game scores.
 *  OPTIONAL: order_by                      String Value, (date or score)
 *  OPTIONAL: order                         String Value, asc or desc
 *  OPTIONAL: limit                         Number Value, the limit, "20" retrieves rows 1 - 20 | "10,20" retrieves 20 scores starting from the 10th
 *  OPTIONAL: start_date                    String Value, YYY-MM-DD format
 *  OPTIONAL: end_date                      String Value, YYY-MM-DD format
 *  OPTIONAL: platform                      The players platform needs to match the string value that was used when creating the player
 *  OPTIONAL: difficulty                    Integer Value, between 1 to 10 (don't use 0 as it's the default value)
 **/
+ (NSObject *) getScores:(NSMutableDictionary *)scoreParams{
    method = @"getScores";
    NSObject* result=[scoreBoard send:scoreParams params:method];
    return result;
}
/*
 ** createScore**;
 ** method lets you create a user score.
 *  REQUIRED: username                      String Value, if user does not exist it well be created
 *  REQUIRED: score                         Integer Value,
 *  OPTIONAL: platform                      String Value,
 *  OPTIONAL: unique_id                     Integer Value,
 *  OPTIONAL: difficulty                    Integer Value, between 1 to 10 (don\t use 0 as it's the default value)
 **/
+ (NSObject *) createScore:(NSString *)username :(NSString *)score :(NSMutableDictionary *)scoreParams{
    method = @"createScore";
    [scoreParams setObject:username forKey:@"username"];
    [scoreParams setObject:score forKey:@"score"];
    NSObject* result=[scoreBoard send:scoreParams params:method];
    return result;
}


@end
