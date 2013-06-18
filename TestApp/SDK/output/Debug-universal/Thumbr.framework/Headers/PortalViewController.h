//
//  PortalViewController.h
//  Thumbr
//
//  Created by aiso haikens on 01-03-12.
//  Updated by Stephnie Mossel ;)
//  Copyright (c) 2012 ideesoft.nl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSBridgeWebView.h"
#import "JSON.h"


@interface PortalViewController : UIViewController <JSBridgeWebViewDelegate> {
    IBOutlet UIButton* backgroundview;
    IBOutlet UIView* modalview;
    IBOutlet JSBridgeWebView* webview;
    IBOutlet UIActivityIndicatorView* activiyIndicator;
    IBOutlet UIImageView* loadingImage;
    BOOL loading;
    BOOL dispatched;
    IBOutlet UIImageView *noConnectionImage;
    IBOutlet UIView *noConnectionView;
    IBOutlet UIButton *refreshButton;
    IBOutlet UIButton *closeButton;
    IBOutlet UILabel *versionLabel;
    
    NSMutableData *myReceivedData;
    SBJSON *jsonParser;
}

@property (nonatomic, assign) NSMutableDictionary *connectionHolder;

- (void) loadPortalWithUrl:(NSURL *)url;

- (IBAction) close: (id) sender;
- (IBAction) thumbr: (id) sender;

@end


#pragma mark - Return codes

#define CODE_OK                         200
#define CODE_PARTIALLY_OK               206
#define CODE_NEW_IDS                    302
#define CODE_UP_TO_DATE                 304
#define CODE_INVALID_INPUT              400
#define CODE_SESSION_ID_MISSING         401
#define CODE_USER_NOT_ACTIVATED         402
#define CODE_UNAME_PWD_WRONG            403


#pragma mark - JSON return keys

#define RETURNCODE_KEY      @"httpCode"
#define ACCESTOKEN_KEY      @"at"
#define REDIRECTURL_KEY     @"ru"
