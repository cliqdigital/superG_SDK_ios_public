//
//  AdViewController.m
//

#import "AdViewController.h"
#import <MadsSDK/MadsSDK.h>
#import "Thumbr.h"
#import "Thumbr+Private.h"
#import "AppsFlyer.h"
#import "LRResty/LRResty.h"
#import <CommonCrypto/CommonHMAC.h>




@implementation AdViewController
@synthesize adView = _adView;

-(void) stopAds{
    @try {
        [(id)[[[UIApplication sharedApplication] keyWindow] viewWithTag:431431431431431] stopEverythingAndNotifyDelegateOnCleanup];
        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:431431431431431] removeFromSuperview];
        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:431431431431431] release];
        if([[Thumbr statusBarHidden]isEqual:@"TRUE"]){
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }
    }
    @catch (NSException * e) {
    }
    @finally {
    }
}

-(CGSize) currentSize
{
    return [self sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

-(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation
{
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    //overlay ads have a bug where retina screens provide an ad view that is twice the allowed size.
    if([self.adType isEqual: @"overlay"]){
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]
            && [[UIScreen mainScreen] scale] == 2.0) {
            size = CGSizeMake(size.width/2, size.height/2);
        } else {
            size = CGSizeMake(size.width, size.height);
        }
    }
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}

+ (void) getAdSettings{
    //ONLY RETURNS UPDATE TIME INTERVAL FOR NOW.
    Thumbr* instance = [Thumbr instance];
    
    [[LRResty client] get:[NSString stringWithFormat:@"http://ads.thumbr.com/adserver/?getAdSettings=1&debug=0&sid=%@",instance.sid] withBlock:^(LRRestyResponse *response) {
        //NSLog(@"Getting ad settings: http://ads.thumbr.com/adserver/?getAdSettings=1&debug=0&sid=%@",instance.sid);
        if(response.status == 200) {
            @try {
                NSString *csv=[response asString];
                NSArray *list = [csv componentsSeparatedByString:@","];
                
                
                NSLog(@"HIDE THUMBR WINDOW CLOSEBUTTON: %@",[list objectAtIndex:2]);
                NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                if([list objectAtIndex:0]){
                    [prefs setInteger:[[list objectAtIndex:0] intValue] forKey:@"updateTimeIntervalOverride"];
                }
                if([list objectAtIndex:1]){
                    [prefs setInteger:[[list objectAtIndex:1] intValue] forKey:@"showCloseButtonTime"];
                    NSLog(@"INTERSTITIAL ADS SHOW CLOSE BUTTON AFER N SECONDS: %@",[list objectAtIndex:1]);
                }
                if([list objectAtIndex:2]){
                    [prefs setInteger:[[list objectAtIndex:2] intValue] forKey:@"hideThumbrCloseButton"];
                    NSLog(@"INLINE ADS UPDATE TIME INTERVAL: %@",[list objectAtIndex:0]);
                }
            }
            @catch (NSException * e) {
                NSLog(@"Could not parse Ad Settings: %@",e);
            }
        }
    }];
}



-(void) dealloc
{
    _adView.delegate = nil;
    [_adView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
-(NSString*)sha256:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}
-(NSString *) urlEncoded
{
    CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(
                                                                    NULL,
                                                                    (CFStringRef)self,
                                                                    NULL,
                                                                    (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                    kCFStringEncodingUTF8 );
    return [(NSString *)urlString autorelease];
}
-(NSString*)escape:(NSString*)input
{
    NSString *escapedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL,
                                                                                  (CFStringRef)input,
                                                                                  NULL,
                                                                                  CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                  kCFStringEncodingUTF8);
    return escapedString;
}
-(NSDictionary*)getAdditionalParameters{
    NSMutableDictionary* settings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey: @"ThumbrUser"]];
    
    NSArray *keys = [NSArray arrayWithObjects:
                     @"sid", @"client_id", @"handset_id", @"thumbr_id", @"address", @"city", @"country", @"email", @"firstname", @"locale", @"msisdn", @"newsletter", @"status", @"surname", @"username", @"zipcode", @"gender",@"sig",@"date_of_birth",@"housenr",@"token",@"profile_id", nil];
    Thumbr* instance = [Thumbr instance];
    if([settings valueForKey:@"id"] == NULL){[settings setValue: @"" forKey: @"id"];}
    if([settings valueForKey:@"address"] == NULL){[settings setValue: @"" forKey: @"address"];}
    if([settings valueForKey:@"city"] == NULL){[settings setValue: @"" forKey: @"city"];}
    if([settings valueForKey:@"country"] == NULL){[settings setValue: @"" forKey: @"country"];}
    if([settings valueForKey:@"email"] == NULL){[settings setValue: @"" forKey: @"email"];}
    if([settings valueForKey:@"firstname"] == NULL){[settings setValue: @"" forKey: @"firstname"];}
    if([settings valueForKey:@"locale"] == NULL){[settings setValue: @"" forKey: @"locale"];}
    if([settings valueForKey:@"msisdn"] == NULL){[settings setValue: @"" forKey: @"msisdn"];}
    if([settings valueForKey:@"newsletter"] == NULL){[settings setValue: @"" forKey: @"newsletter"];}
    if([settings valueForKey:@"status"] == NULL){[settings setValue: @"" forKey: @"status"];}
    if([settings valueForKey:@"surname"] == NULL){[settings setValue: @"" forKey: @"surname"];}
    if([settings valueForKey:@"username"] == NULL){[settings setValue: @"" forKey: @"username"];}
    if([settings valueForKey:@"zipcode"] == NULL){[settings setValue: @"" forKey: @"zipcode"];}
    if([settings valueForKey:@"gender"] == NULL){[settings setValue: @"" forKey: @"gender"];}
    if([settings valueForKey:@"date_of_birth"] == NULL){[settings setValue: @"" forKey: @"date_of_birth"];}
    if([settings valueForKey:@"housenr"] == NULL){[settings setValue: @"" forKey: @"housenr"];}
    if([settings valueForKey:@"age"] == NULL){[settings setValue: @"" forKey: @"age"];}
    NSString *hashableString = [NSString stringWithFormat:@"%@:%@", @"49b26e3ac8701cf4c5840587d1d5e6eba01ab329b9179f6aef925f362a98065f", [settings valueForKey:@"id"]];
    NSString *sig = [self sha256:hashableString];
    NSLog(@"sig: %@",sig);
    
    NSArray *objects;
    if(instance.sid != NULL){
        objects = [NSArray arrayWithObjects:instance.sid, instance.clientId, [AppsFlyer getAppsFlyerUID],
                   [settings valueForKey:@"id"],
                   [self escape:[settings valueForKey:@"address"]],
                   [self escape:[settings valueForKey:@"city"]],
                   [self escape:[settings valueForKey:@"country"]],
                   [self escape:[settings valueForKey:@"email"]],
                   [self escape:[settings valueForKey:@"firstname"]],
                   [settings valueForKey:@"locale"],
                   [self escape:[settings valueForKey:@"msisdn"]],
                   [settings valueForKey:@"newsletter"],
                   [settings valueForKey:@"status"],
                   [self escape:[settings valueForKey:@"surname"]],
                   [self escape:[settings valueForKey:@"username"]],
                   [self escape:[settings valueForKey:@"zipcode"]],
                   [settings valueForKey:@"gender"],
                   sig,
                   [self escape:[settings valueForKey:@"date_of_birth"]],
                   [settings valueForKey:@"housenr"],
                   [Thumbr getAccesTokenFromSettings],
                   [settings valueForKey:@"id"],
                   nil];
    }else{
        objects = [NSArray arrayWithObjects:@"", @"", @"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",sig,@"",@"",@"",@"",nil];
    }
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    return dictionary;
}

-(void) adOverlay:(NSDictionary*)adSettings
{
    MadsAdView *adview = nil;
    
    NSLog(@"width: %f",[self currentSize].width);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        adview = [[MadsAdView alloc] initWithFrame:CGRectZero zone:[adSettings objectForKey:@"iPhone_Overlay_zoneid"] secret:[adSettings objectForKey:@"iPhone_Overlay_secret"] delegate:self];
    }
    else
    {
        adview = [[MadsAdView alloc] initWithFrame:CGRectZero zone:[adSettings objectForKey:@"iPad_Overlay_zoneid"] secret:[adSettings objectForKey:@"iPad_Overlay_secret"] delegate:self];
    }
    adview.tag = 431431431431431;
    adview.adServerUrl=adUrl;
    adview.showCloseButtonTime = [[adSettings objectForKey:@"showCloseButtonTime"] floatValue];
    adview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    adview.madsAdType=MadsAdTypeOverlay;
    adview.updateTimeInterval = 0;
    self.adType=@"overlay";
    NSLog(@"adview: %@",adview);
    NSMutableDictionary* settings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey: @"ThumbrUser"]];
    if([[settings valueForKey:@"zipcode"] isKindOfClass:[NSNull class]] == false){adview.zip = [settings valueForKey:@"zipcode"];}
    if([[settings valueForKey:@"gender"] isKindOfClass:[NSNull class]] == false){adview.gender = [settings valueForKey:@"gender"];}
    if([[settings valueForKey:@"age"] isKindOfClass:[NSNull class]] == false){adview.age = [settings valueForKey:@"age"];}
    if([[settings valueForKey:@"city"] isKindOfClass:[NSNull class]] == false){adview.city = [settings valueForKey:@"city"];}
    if([[settings valueForKey:@"country"] isKindOfClass:[NSNull class]] == false){adview.country = [settings valueForKey:@"country"];}
    if([[settings valueForKey:@"income"] isKindOfClass:[NSNull class]] == false){adview.income = [settings valueForKey:@"income"];}
    if([[settings valueForKey:@"id"] isKindOfClass:[NSNull class]] == false){adview.idx = [settings valueForKey:@"id"];}
    
    adview.additionalParameters = [self getAdditionalParameters];
    adview.maxSize = [self currentSize];
    
    self.adView = adview;
    [[[UIApplication sharedApplication] keyWindow] addSubview:adview];
    
    [adview release];
}


-(void) adInline:(NSDictionary*)adSettings adSettings:(UIView*)view atPoint:(CGPoint)point
{
    [AdViewController getAdSettings];
    MadsAdView *adview = nil;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        adview = [[MadsAdView alloc] initWithFrame:CGRectMake(point.x, point.y, 320, 50) zone:[adSettings objectForKey:@"iPhone_Inline_zoneid"] secret:[adSettings objectForKey:@"iPhone_Inline_secret"] delegate:self];
    }
    else
    {
        adview = [[MadsAdView alloc] initWithFrame:CGRectMake(point.x, point.y, 728, 90) zone:[adSettings objectForKey:@"iPad_Inline_zoneid"] secret:[adSettings objectForKey:@"iPad_Inline_secret"] delegate:self];
    }
    
    adview.adServerUrl=adUrl;
    adview.contentAlignment=NO;
    adview.madsAdType=MadsAdTypeInline;
    adview.tag = 431431431431431;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSInteger updateTimeIntervalOverride = [prefs integerForKey:@"updateTimeIntervalOverride"];
    NSLog(@"TIO: %d",updateTimeIntervalOverride);
    if(updateTimeIntervalOverride >= 0){
        adview.updateTimeInterval = updateTimeIntervalOverride;
    }
    else{
        adview.updateTimeInterval = [[adSettings objectForKey:@"updateTimeInterval"] floatValue];
    }
    
    //adview.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    self.adType=@"inline";
    
    NSMutableDictionary* settings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey: @"ThumbrUser"]];
    if([[settings valueForKey:@"zipcode"] isKindOfClass:[NSNull class]] == false){adview.zip = [settings valueForKey:@"zipcode"];}
    if([[settings valueForKey:@"gender"] isKindOfClass:[NSNull class]] == false){adview.gender = [settings valueForKey:@"gender"];}
    if([[settings valueForKey:@"age"] isKindOfClass:[NSNull class]] == false){adview.age = [settings valueForKey:@"age"];}
    if([[settings valueForKey:@"city"] isKindOfClass:[NSNull class]] == false){adview.city = [settings valueForKey:@"city"];}
    if([[settings valueForKey:@"country"] isKindOfClass:[NSNull class]] == false){adview.country = [settings valueForKey:@"country"];}
    if([[settings valueForKey:@"income"] isKindOfClass:[NSNull class]] == false){adview.income = [settings valueForKey:@"income"];}
    if([[settings valueForKey:@"id"] isKindOfClass:[NSNull class]] == false){adview.idx = [settings valueForKey:@"id"];}
    
    adview.additionalParameters = [self getAdditionalParameters];
    
    self.adView = adview;
    [view addSubview:adview];
    [view bringSubviewToFront:adview];
    
    [adview release];
};



-(void) adInterstitial:(NSDictionary*)adSettings
{
    //create a progress dialog over all other content
    //remove it with tag 3298572938475
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.frame = CGRectMake(0.0, 0.0, screenWidth, screenHeight);
    indicator.center = self.view.center;
    indicator.backgroundColor=[UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.7];
    [[[UIApplication sharedApplication] keyWindow] addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    indicator.tag = 3298572938475;
    [indicator startAnimating];
    
    
    MadsAdView *adview = nil;
    adview.tag = 431431431431431;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        adview = [[MadsAdView alloc] initWithFrame:CGRectMake(0.0, 0.0, [self currentSize].width, [self currentSize].height) zone:[adSettings objectForKey:@"iPhone_Interstitial_zoneid"] secret:[adSettings objectForKey:@"iPhone_Interstitial_secret"] delegate:self];
    }
    else
    {
        adview = [[MadsAdView alloc] initWithFrame:CGRectMake(0.0, 0.0, [self currentSize].width, [self currentSize].height) zone:[adSettings objectForKey:@"iPad_Interstitial_zoneid"] secret:[adSettings objectForKey:@"iPad_Interstitial_secret"] delegate:self];
    }
    adview.adServerUrl=adUrl;
    adview.updateTimeInterval = 0; // only manual updates
    adview.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin);
    NSLog(@"Interstitial will close in: %f seconds",[[adSettings objectForKey:@"autocloseInterstitialTime"] floatValue]);
    
    adview.showCloseButtonTime = [[adSettings objectForKey:@"showCloseButtonTime"] floatValue];
    adview.autocloseInterstitialTime = [[adSettings objectForKey:@"autocloseInterstitialTime"] floatValue];
    adview.animationType = MadsAdAnimationTypeAppear;
    self.adType=@"interstitial";
    
    NSMutableDictionary* settings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey: @"ThumbrUser"]];
    if([[settings valueForKey:@"zipcode"] isKindOfClass:[NSNull class]] == false){adview.zip = [settings valueForKey:@"zipcode"];}
    if([[settings valueForKey:@"gender"] isKindOfClass:[NSNull class]] == false){adview.gender = [settings valueForKey:@"gender"];}
    if([[settings valueForKey:@"age"] isKindOfClass:[NSNull class]] == false){adview.age = [settings valueForKey:@"age"];}
    if([[settings valueForKey:@"city"] isKindOfClass:[NSNull class]] == false){adview.city = [settings valueForKey:@"city"];}
    if([[settings valueForKey:@"country"] isKindOfClass:[NSNull class]] == false){adview.country = [settings valueForKey:@"country"];}
    if([[settings valueForKey:@"income"] isKindOfClass:[NSNull class]] == false){adview.income = [settings valueForKey:@"income"];}
    if([[settings valueForKey:@"id"] isKindOfClass:[NSNull class]] == false){adview.idx = [settings valueForKey:@"id"];}
    
    adview.additionalParameters = [self getAdditionalParameters];
    
    self.adView = adview;
    [[[UIApplication sharedApplication] keyWindow] addSubview:adview];
    [adview release];
}




- (void) transformAdView:(UIView *)adview{
    if([self.adType isEqual: @"interstitial"]){
        CGFloat degreesOfRotation=0;
        if ([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft){
            [self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
            degreesOfRotation = 270;
            NSLog(@"Landscape Left");
        }
        else if ([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
            [self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
            
            degreesOfRotation = 90;
            NSLog(@"Landscape Right");
        }
        //    else if ([[UIDevice currentDevice]orientation] == UIInterfaceOrientationPortrait){
        //        [self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
        //        degreesOfRotation = 0;
        //        NSLog(@"Portrait");
        //    }
        //    else if ([[UIDevice currentDevice]orientation] == UIInterfaceOrientationPortraitUpsideDown){
        //        [self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortraitUpsideDown];
        //        degreesOfRotation = 180;
        //        NSLog(@"Landscape Portrait Upside Down");
        //    }
        else{
            NSLog(@"Orientation is unknown");
            [self shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight)];
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                degreesOfRotation = 270;
            }else{
                degreesOfRotation = 0;
            }
        }
        CGRect keyFrame = [UIApplication sharedApplication].keyWindow.frame;
        adview.transform = CGAffineTransformMakeRotation(degreesOfRotation * M_PI/180.0);
        adview.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
        adview.center = CGPointMake(keyFrame.size.width/2, keyFrame.size.height/2);
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    if([[Thumbr statusBarHidden]isEqual:@"TRUE"]){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}
- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    NSLog(@"Device did rotate: %d",device.orientation);
    [self transformAdView:self.adView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([[Thumbr statusBarHidden]isEqual:@"TRUE"]){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    // we wait untl now to make sure there is a key window loaded that we use to position
    // elements on screen
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    if([[Thumbr statusBarHidden]isEqual:@"TRUE"]){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"i did rotate");
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


- (void)willReceiveAd:(id)sender
{
    if([[Thumbr statusBarHidden]isEqual:@"TRUE"]){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    if([self.adType isEqual: @"inline"]){
        [Thumbr sendAnimateAdOut:sender];
    }
    NSLog(@"willReceiveAd");
}

- (void)didReceiveAd:(id)sender
{
    NSLog(@"didReceiveAd");
    //Delaying the removal of the progress dialog (indicator), to make sure it stays visible until all ad content is loaded.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:3298572938475] removeFromSuperview];
    });
    
    
    
    if([[Thumbr statusBarHidden]isEqual:@"TRUE"]){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    if([self.adType isEqual: @"inline"]){
        [Thumbr sendAnimateAdIn:sender];
    }
    [self transformAdView:self.adView];
}
- (void)didReceiveThirdPartyRequest:(id)sender content:(NSDictionary*)content
{
    NSLog(@"didReceiveThirdPartyRequest");
}

- (void)didFailToReceiveAd:(id)sender withError:(NSError*)error
{
    NSLog(@"didFailToReceiveAd");
    
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:3298572938475] removeFromSuperview];
    @try{
        [Thumbr sendInterstitialClosed:sender];
    }
    @catch (NSException * e) {
    }
    @finally {
    }
    if([[Thumbr statusBarHidden]isEqual:@"TRUE"]){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    if([self.adType isEqual: @"inline"]){
        [Thumbr sendAnimateAdOut:sender];
    }
}
- (void)adWillStartFullScreen:(id)sender
{
    NSLog(@"adWillStartFullScreen");
    
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:3298572938475] removeFromSuperview];
    if([[Thumbr statusBarHidden]isEqual:@"TRUE"]){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    
    self.adView.autocloseInterstitialTime=0;
    
}

- (void)adDidEndFullScreen:(id)sender
{
    NSLog(@"adDidEndFullScreen");
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:3298572938475] removeFromSuperview];
    if([[Thumbr statusBarHidden]isEqual:@"TRUE"]){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}

- (void)adWillExpandFullScreen:(id)sender
{
    if([[Thumbr statusBarHidden]isEqual:@"TRUE"]){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    NSLog(@"adWillExpandFullScreen");
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:3298572938475] removeFromSuperview];
}

- (void)adDidCloseExpandFullScreen:(id)sender
{
//    if([self.adType isEqual: @"inline"]){
//        [Thumbr sendAnimateAdOut:sender];
//    }
    if([[Thumbr statusBarHidden]isEqual:@"TRUE"]){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:3298572938475] removeFromSuperview];
    NSLog(@"adDidCloseExpandFullScreen");
    
}

- (void)adWillOpenVideoFullScreen:(id)sender
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:3298572938475] removeFromSuperview];
    NSLog(@"adWillOpenVideoFullScreen");
    
}

- (void)adDidCloseVideoFullScreen:(id)sender
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:3298572938475] removeFromSuperview];
    NSLog(@"adDidCloseVideoFullScreen");
    
}

- (void)adWillOpenMessageUIFullScreen:(id)sender
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:3298572938475] removeFromSuperview];
    NSLog(@"adWillOpenMessageUIFullScreen");
    
}

- (void)adDidCloseMessageUIFullScreen:(id)sender
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:3298572938475] removeFromSuperview];
    NSLog(@"adDidCloseMessageUIFullScreen");
    
}


- (void)didClosedAd:(id)sender usageTimeInterval:(NSTimeInterval)usageTimeInterval
{
    [[[[UIApplication sharedApplication] keyWindow] viewWithTag:3298572938475] removeFromSuperview];
    @try{
        [Thumbr sendInterstitialClosed:sender];
    }
    @catch (NSException * e) {
    }
    @finally {
    }
    NSLog(@"didClosedAd");
    if([self.adType isEqual: @"inline"]){
        [Thumbr sendAnimateAdOut:sender];
    }
    if([[Thumbr statusBarHidden]isEqual:@"TRUE"]){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}

- (void)mraidProcess:(id)sender event:(NSString*)event parameters:(NSDictionary*)parameters
{
    NSLog(@"mraidProcess");
    if([[Thumbr statusBarHidden]isEqual:@"TRUE"]){
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}



@end
