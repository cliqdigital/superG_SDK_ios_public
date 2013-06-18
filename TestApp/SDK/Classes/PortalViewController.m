//
//  PortalViewController.m
//  Thumbr
//
//  Created by aiso haikens on 01-03-12.
//  Updated by Stephnie Mossel ;)
//  Updated by Henri de Mooij
//  Copyright (c) 2012 ideesoft.nl. All rights reserved.
//

#define LOADTIMEOUT 30

#import "Thumbr+Private.h"
#import "PortalViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ThumbrReachability.h"

ThumbrReachability* thumbrReachability;

@implementation PortalViewController

@synthesize connectionHolder;


#pragma mark - View lifecycle

- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
        return FALSE;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    Thumbr* instance = [Thumbr instance];
        
    noConnectionView.hidden = YES;
    loadingImage.hidden = NO;
    
    if (instance.showCloseButton) {
        [closeButton setHidden:YES];
    }else {
        [closeButton setHidden:NO];
    }
   // NSLog(@"Showclosebutton: %@", instance.showCloseButton ? @"YES" : @"NO");
    closeButton.hidden = !instance.showCloseButton;

    //get the noconnection image for the user language from the device bundel
    if([Thumbr loadImage:[NSString stringWithFormat:@"no_connection_%@", instance.locale]  forType:@"png"]){
    [noConnectionImage setImage: [Thumbr loadImage:[NSString stringWithFormat:@"no_connection_%@", instance.locale]  forType:@"png"]];
    }
    if([Thumbr loadImage:[NSString stringWithFormat:@"refresh-%@", instance.locale] forType:@"png"]){
        //NSLog(@"Changed refresh image for no-connection window");
    [refreshButton setImage:[Thumbr loadImage:[NSString stringWithFormat:@"refresh-%@", instance.locale] forType:@"png"] forState:UIControlStateNormal];
        }
    [refreshButton addTarget:self action:@selector(refreshButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    refreshButton.hidden = YES;
    
    //init
    connectionHolder = [[NSMutableDictionary alloc] init];
    myReceivedData = [[NSMutableData alloc] init];
    
    //get cookies from user settings and add store them in the browser
    NSDictionary* settings = [[NSUserDefaults standardUserDefaults] dictionaryForKey: @"ThumbrSettings"];
    NSDictionary* cookiesdict = [settings valueForKey: @"cookies"];
    //NSLog(@"cookiesdict: %@", cookiesdict);
    for (NSString* _url in cookiesdict) {
        NSArray* props = [cookiesdict objectForKey: _url];
        NSMutableArray* cookies = [NSMutableArray arrayWithCapacity: [props count]];
        for (NSDictionary *prop in props) {
            NSHTTPCookie* cookie = [NSHTTPCookie cookieWithProperties:prop];
            [cookies addObject:cookie];
        }
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookies forURL:[NSURL URLWithString: _url] mainDocumentURL:nil];
    }

    //set webview settings
    loading = NO;
    dispatched = NO;
    webview.scrollView.bounces = NO;
    [webview reload];
    backgroundview.alpha = 0.0f;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        [[webview layer] setCornerRadius: 14.0f];
    }
    [[webview layer] setMasksToBounds:YES];
//    [[webview layer] setBorderWidth: 1.0f];
  //  [[webview layer] setBorderColor: [[UIColor colorWithRed:163.0f/255.0f green:148.0f/255.0f blue:141.0f/255.0f alpha:1.0f] CGColor]];
    
    CGRect appframe = [[UIScreen mainScreen] applicationFrame];
    NSLog(@"orient= %d",instance.portalOrientation);
    
    if(instance.portalOrientation == 3 || instance.portalOrientation == 4){
        // make landscape
        appframe = CGRectMake(CGRectGetMinX(appframe), CGRectGetMinY(appframe), CGRectGetHeight(appframe), CGRectGetWidth(appframe));

        CGRect modalframe = modalview.frame;
        modalframe.origin = CGPointMake(CGRectGetMidX(appframe) - modalframe.size.width/2, CGRectGetMaxY(appframe));
        modalview.frame = modalframe;
    }
    
    //webview startup animations
    [UIView animateWithDuration: 0.3f animations:^(void) {
        backgroundview.alpha = 0.7f;
    }];
    float overshoot = .065f * appframe.size.height;
    [UIView animateWithDuration: 0.3f animations:^(void) {
        CGRect modalframe = modalview.frame;
        modalframe.origin = CGPointMake(CGRectGetMinX(modalframe), CGRectGetMidY(appframe) - modalframe.size.height/2 - overshoot);
        modalview.frame = modalframe;
    } completion:^(BOOL finished) {
        if(finished){
            [UIView animateWithDuration: 0.3f animations:^(void) {
                CGRect modalframe = modalview.frame;
    if(instance.portalOrientation == 3 || instance.portalOrientation == 4){
                modalframe.origin = CGPointMake(modalframe.origin.x, 0);
    }else{
                modalframe.origin = CGPointMake(0, 0);
    }
                modalview.frame = modalframe;
                //PRINT VERSION LABEL IN SDK SCREEN
                versionLabel.text=VERSION;
                [self.view bringSubviewToFront:versionLabel];
            }];
        }
    }];
    
    [self startReachabiltyChecking];
    
}

#pragma mark - alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self close:nil];
}


#pragma mark - button methods

- (IBAction) thumbr:(id) sender {
    
    [Thumbr startThumbrPortal];
}

- (void) refreshButtonClicked: (id) sender {
    loading = YES;
    loadingImage.hidden = FALSE;
//    noConnectionView.hidden = YES;
//    refreshButton.hidden = YES;
    [webview reload];
}

#pragma mark - webview delegate

- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSMutableURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request respondsToSelector:@selector(setValue:forHTTPHeaderField:)]) {
        [request setValue:[NSString stringWithFormat:@"sdk"] forHTTPHeaderField:@"X-Thumbr-Method"];
        [request setValue:[NSString stringWithFormat:VERSION] forHTTPHeaderField:@"X-Thumbr-Version"];
    }
    
//    NSLog(@"portalviewcontroller: shouldStartLoadWithRequest url: %@", [[[wv request] URL] standardizedURL]);

    //check if url should be opened in SDK webview or external browser
    NSURL *url = [request URL];
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSString *urlString = [url absoluteString];
        
        if ([urlString rangeOfString:@"thumbr.com"].location == NSNotFound && [urlString rangeOfString:@"cliqdigital.com"].location == NSNotFound  && [urlString rangeOfString:@"gasp.uat-gasp.dev.cliqdigital.com"].location == NSNotFound && [urlString rangeOfString:@"openinbrowser"].location == NSNotFound) {
            [[UIApplication sharedApplication] openURL:url];
            return FALSE;
        }
    }
    
    //set connection timeout
    if (![url fragment]) { // only start animating when there ain't a fragment in the url
        [activiyIndicator startAnimating];
        if (!dispatched) { // allow only 1 timeout dispatch at one time
            loading = YES;
            dispatched = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, LOADTIMEOUT * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
//                NSLog(@"loading: %@", loading ? @"yes" : @"no");
                dispatched = NO;
                if (loading) {
                    loading = NO;
//                    [[[[UIAlertView alloc] initWithTitle:@"" message:@"Connection Timed Out" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] autorelease] show];
                    [wv stopLoading];
                    noConnectionView.hidden = NO;
                    //refreshButton.hidden = NO;
                }
            });
        }
    }
        


//    NSLog(@"portalviewcontroller: Should page load? %@", [request URL]);
	return TRUE;
}

- (void)webViewDidStartLoad:(UIWebView *)wv {
    NSLog(@"portalviewcontroller: Page did start load. %@", [[[wv request] URL] standardizedURL]);
    Thumbr* instance = [Thumbr instance];
    if(instance.portalOrientation == 3 ){
        [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeLeft];
    }
    else if(instance.portalOrientation == 4){
        [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeRight];
    }else{
        [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationPortrait];    
    }
    

}

- (void)webViewDidFinishLoad:(UIWebView *)wv {
    
    //get the request returned to the webview
    NSURL* _url = [[wv request] URL];
    NSLog(@"portalviewcontroller: Page did finish load. %@", [_url standardizedURL]);
    
    //stop the loading animation
    loadingImage.hidden = YES;
    loading = NO;
    [activiyIndicator stopAnimating];

    //check if the request has cookies stored in the browser and store them in the user settings
    NSArray* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: _url];
    if (cookies) {
        NSMutableArray* props = [NSMutableArray arrayWithCapacity: [cookies count]];
        for (NSHTTPCookie *cookie in cookies) {
            [props addObject: cookie.properties];
        }
        NSMutableDictionary* settings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey: @"ThumbrSettings"]];
        NSMutableDictionary* cookiesdict = [NSMutableDictionary dictionaryWithDictionary:[settings objectForKey: @"cookies"]];

        [cookiesdict setValue: props forKey: [NSString stringWithFormat: @"%@://%@", [_url scheme], [_url host]]];
        [settings setValue: cookiesdict forKey: @"cookies"];
        [[NSUserDefaults standardUserDefaults] setObject: settings forKey: @"ThumbrSettings"];
    }
    
}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {

    loading = NO;
    [activiyIndicator stopAnimating];

    Thumbr* instance = [Thumbr instance];
    //show loading error for testing
    if (instance.showLoadingErrors) {
        NSLog(@"portalviewcontroller: Page did fail with error. %@", [[[wv request] URL] standardizedURL]);
//        [[[[UIAlertView alloc] initWithTitle: @"Loading error" message: [NSString stringWithFormat: @"Page failed loading with error: %@",[error localizedDescription]] delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil] autorelease] show];

    }
}

#pragma mark - Reachability

- (void) checkNetworkStatus:(NSNotification *)notice {

    NetworkStatus hostStatus = [thumbrReachability currentReachabilityStatus];
    if (hostStatus == NotReachable) {
        noConnectionView.hidden = FALSE;
        refreshButton.hidden = FALSE;
//        NSLog(@"No Internet Connection detected!!!");

    } else {
        //if there was no connection before reload, otherwise do nothing
        loadingImage.hidden = FALSE;
        loading = YES;
        [activiyIndicator startAnimating];
        if(!noConnectionView.hidden){
        //Get the current url of the web view (url is lost when it cannot be loaded the first time)
        Thumbr* instance = [Thumbr instance];
        NSLog(@"Current url: %@",instance.currentUrl);
        NSMutableURLRequest* thumbrRequest = [NSMutableURLRequest requestWithURL: instance.currentUrl];
            [thumbrRequest setValue:@"sdk" forHTTPHeaderField:@"X-Thumbr-Method"];
            [thumbrRequest setValue:[NSString stringWithFormat:VERSION] forHTTPHeaderField:@"X-Thumbr-Version"];
        //[webview stopLoading];
        [webview loadRequest:thumbrRequest];
        }
        noConnectionView.hidden = TRUE;
        refreshButton.hidden = TRUE;
            
//        NSLog(@"You are online again");
    }
}

- (void) startReachabiltyChecking {
    
    //add observer for network changes:
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:ThumbrReachabilityChangedNotification object:nil];
    NSString* connection_test_url = @"http://google.com";
    thumbrReachability = [[ThumbrReachability reachabilityWithHostName: [[NSURL URLWithString: connection_test_url] host]] retain];
    [thumbrReachability startNotifier];
}


#pragma mark - Service Methods

- (void) loadPortalWithUrl:(NSURL *)url
{

    //load initial authorization url with webView
    NSMutableURLRequest* thumbrRequest = [NSMutableURLRequest requestWithURL: url];
    [thumbrRequest setValue:@"sdk" forHTTPHeaderField:@"X-Thumbr-Method"];
    [thumbrRequest setValue:[NSString stringWithFormat:VERSION] forHTTPHeaderField:@"X-Thumbr-Version"];
    [webview stopLoading];
    [webview loadRequest:thumbrRequest];
    
}

- (void) getProfile 
{
//    NSLog(@"getting profile..");
    Thumbr* instance = [Thumbr instance];

    //request profile with access token   
    if ([instance.accessToken length] > 0) {
        NSString * url = [NSString stringWithFormat:@"%@access_token=%@",profileAccesUrlPath, instance.accessToken];
        
//        NSLog(@"getting profile with url: %@", [url description]);

        [self requestUrl:[NSURL URLWithString: url] withServiceName:@"GET_PROFILE"];
    }
}

#pragma mark - JSBridgeWebViewDelegate

- (IBAction) close:(id) sender {
    //NSLog(@"clicked");
    [UIView animateWithDuration: 0.6f animations:^(void) {
        backgroundview.alpha = 0.0f;
    }];
    CGRect appframe = [[UIScreen mainScreen] applicationFrame];
    // make landscape
    appframe = CGRectMake(CGRectGetMinX(appframe), CGRectGetMinY(appframe), CGRectGetHeight(appframe), CGRectGetWidth(appframe));
    [UIView animateWithDuration: 0.3f animations:^(void) {
        CGRect modalframe = modalview.frame;
        modalframe.origin = CGPointMake(CGRectGetMinX(modalframe), CGRectGetMaxY(appframe));
        modalview.frame = modalframe;
    } completion:^(BOOL finished) {
        if(finished){
            [self.view removeFromSuperview];
            [Thumbr closedThumbrPortal];
            self.view = nil;
            webview=nil;
           [[NSURLCache sharedURLCache] removeAllCachedResponses];
        }
    }];
}

- (void) handleQuery:(NSURL *)url
{
    Thumbr* instance = [Thumbr instance];

    //parse the callback url
    NSDictionary* callbackVariablesDictionary = [[self parseQueryUrl:url] copy];
    
    //if the parseddata has authorization data save it in userdefaults
    if ([callbackVariablesDictionary count] > 0) {        
        NSString* accessToken = [callbackVariablesDictionary valueForKey:@"access_token"] ;        
        if ([accessToken length] > 0) {
//            NSLog(@"Found a new access token... going to save it..");
            
            //store the authorization settings in the userdefaults
            instance.accessToken = accessToken;
            [Thumbr saveAccesToken:instance.accessToken];
            
            //get profile
            [self getProfile];
        }
                
    } else {
//        NSLog(@" No acess token found");
    } 
//    NSLog(@"----------------- End handleQuery -------------");
}

#pragma mark - connection handler methods

- (void)requestUrl:(NSURL*)url withServiceName:(NSString*)serviceName
{
    NSMutableURLRequest* profileRequest = [NSMutableURLRequest requestWithURL: url];
        [profileRequest setValue:@"sdk" forHTTPHeaderField:@"X-Thumbr-Method"];
        [profileRequest setValue:[NSString stringWithFormat:VERSION] forHTTPHeaderField:@"X-Thumbr-Version"];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:profileRequest delegate:self];
    [connectionHolder setObject:connection forKey:serviceName];
    [connection start];
}


#pragma mark - Parse methods

- (NSDictionary*) parseQueryUrl:(NSURL *)url
{
//    NSLog(@" parseQueryUrl of url: %@", [url standardizedURL]);
    //parse everything after #
    NSMutableDictionary* parsedVariablesDictionary = [[NSMutableDictionary alloc] initWithCapacity:1];
    NSArray* queryElements = [[url fragment] componentsSeparatedByString:@"&"];
    for (NSString *element in queryElements) {
        NSArray *keyVal = [element componentsSeparatedByString:@"="];
        if (keyVal.count > 0) {
            NSString *key = [keyVal objectAtIndex:0];
            NSString *value = (keyVal.count == 2) ? [keyVal lastObject] : nil;
            [parsedVariablesDictionary setValue:value forKey:key];
        }
    }
//    //shouldnt there be a timestamp?
//    NSLog(@"parsedVariablesDictionary: %@", [parsedVariablesDictionary description]);

    
    return parsedVariablesDictionary;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning within thumbr window");
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [myReceivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [myReceivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
        [[[[UIAlertView alloc] initWithTitle: @"Network error" message: [NSString stringWithFormat: @"Network error: %@",[error localizedDescription]] delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil] autorelease] show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{    
    Thumbr* instance = [Thumbr instance];
    
    //parse data
    NSString *response = [[NSString alloc] initWithData:myReceivedData encoding:NSUTF8StringEncoding];
    
    if (jsonParser == nil) {
		jsonParser = [SBJSON new];
	}
    	
	id parsedData = [jsonParser objectWithString: response error: nil];
    
//    NSLog(@"parsedData, %@", [parsedData description]);
    
    //if data succesfully parsed
    if(parsedData != nil){
        //Check return code
//        if (![[parsedData valueForKeyPath:RETURNCODE_KEY] isEqual:[NSNull null]]) {
            
        int returnCode = [[parsedData valueForKeyPath:RETURNCODE_KEY] integerValue];
        
//        NSLog(@"returnCode: %@ ", returnCode);
            
        if ([connectionHolder objectForKey:@"VALIDATE_ACCES_TOKEN"] == connection) {
            if (returnCode == CODE_OK ) {
                //if there, get access token value
                if (![[parsedData valueForKeyPath:ACCESTOKEN_KEY] isEqual:[NSNull null]]) {
                    instance.accessToken = [[parsedData valueForKeyPath:ACCESTOKEN_KEY] stringValue];
                    
                    //save access Token in userDefault settings
                    [Thumbr saveAccesToken:instance.accessToken];
                }
            } else if (returnCode == CODE_SESSION_ID_MISSING) {
                //if the token is not valid, ask new token
                //So go back to the authorization page
                //maybe show a message like your sesion has expired?
//                NSLog(@"!#$!##! The token send with the profile is not valid, what do we do now??...");
            }
          //clean up connection holder
//          [connectionHolder removeObjectForKey:@"VALIDATE_ACCES_TOKEN"];

        } else if ([connectionHolder objectForKey:@"GET_PROFILE"] == connection) {
            if (returnCode == CODE_SESSION_ID_MISSING) {
                //if the token is not valid, ask new token
                //So go back to the authorization page
                //maybe show a message like your sesion has expired?
//                NSLog(@"!#$!##! The token send with the profile is not valid, what do we do now??...");
            }else {
                //succesfully retrieves profile:
                //send to ThumbrSDKDelegate so that it can be received by the game
                [Thumbr receivedProfile: parsedData];
            }
          //clean up connection holder
//          [connectionHolder removeObjectForKey:@"GET_PROFILE"];                   
        }
    }
//    }
}


#pragma mark - Validation methods
//validate acces_token
- (BOOL)validateAccessToken:(NSString*)accesstoken
{
    BOOL isValid = NO;
    
    if (accesstoken != nil) {
        NSString * url = [NSString stringWithFormat:@"%@access_token=%@",AccesTokenValidationUrlPath, accesstoken];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url]];
            [request setValue:@"sdk" forHTTPHeaderField:@"X-Thumbr-Method"];
            [request setValue:[NSString stringWithFormat:VERSION] forHTTPHeaderField:@"X-Thumbr-Version"];
        NSHTTPURLResponse* response = nil;
        NSError* error = nil;
        
        //do a synchronous request
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if ([response statusCode] == CODE_OK ) {
//            NSLog(@"token is valid!");
            isValid = YES;
        } else if ([response statusCode] == CODE_SESSION_ID_MISSING ) {
//            NSLog(@"token is not valid!!");
        }
    }
    return isValid;
}

//TODO:
//string validation
//array validation

- (void)dealloc {
    [closeButton release];
    [versionLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    NSLog(@"hiep hiep hoera");
    [closeButton release];
    closeButton = nil;
    [versionLabel release];
    versionLabel = nil;
    [super viewDidUnload];
}


@end
