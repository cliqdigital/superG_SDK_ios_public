/*
 Copyright (c) 2010, Dante Torres All rights reserved.
 
 Redistribution and use in source and binary forms, with or without 
 modification, are permitted provided that the following conditions 
 are met:
 
 * Redistributions of source code must retain the above copyright 
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright 
 notice, this list of conditions and the following disclaimer in the 
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its 
 contributors may be used to endorse or promote products derived from 
 this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE.
 */

#import "JSBridgeWebView.h"
#import "Thumbr.h"

@implementation JSBridgeWebView

@synthesize bridgeDelegate;

/*
	Init the JSBridgeWebView object. It sets the regular UIWebview delegate to self,
	since the object will be listening to JS notifications.
*/

- (id) initWithCoder: (NSCoder*) decoder {
    //NSLog(@"jsbridgewebview: initwithcoder");
	if (self = [super initWithCoder: decoder]) {
		super.delegate = self;
		bridgeDelegate = nil;
	}
    return self;
}

/*
	This is the reimplementation of the superclass setter method for the delegate property.
	This reimplementation hides the internal functionality of the class.
 
	It checks if the newDelegate object conforms to the JSBridgeWebViewDelegate.
 */
-(void) setDelegate:(id <UIWebViewDelegate>) newDelegate
{
    //NSLog(@"jsbridgewebview: setdelegate");
	if([newDelegate conformsToProtocol:@protocol(JSBridgeWebViewDelegate)])
	{
		bridgeDelegate = (id<JSBridgeWebViewDelegate>) newDelegate;
	} else 
	{
		assert(@"The delegate should comforms to the JSBridgeWebViewDelegate protocol.");
	}
}

/*
	This is the reimplementation of the superclass getter method for the delegate property.
 
	The method returns the bridgeDelegate object. The regular super.delegate object is used 
	internally only and it is set to self.
 */
-(id) delegate
{
	return bridgeDelegate;
}

/*
	Listen to any try of page loading. This method checks, by the URL to be loaded, if
	it is a JS notification.
 */
- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{           [[NSURLCache sharedURLCache] removeAllCachedResponses];
	BOOL result = TRUE;
//    NSLog(@"jsbridgewebview: request: %@", [[request URL] absoluteURL]);
//    NSLog(@"jsbridgewebview: scheme: %@", [[request URL] scheme]);
//    NSLog(@"jsbridgewebview: host: %@", [[request URL] host]);

	// Checks if it is a JS notification. It returns the ID ob the JSON object in the JS code. Returns nil if it is not.
	NSURL* requestURL = [request URL];
//    NSLog(@"requestURL: %@", [[request URL] description] );
    if ([[requestURL scheme] isEqualToString: @"thumbr"]) {
        if ([[[request URL] host] isEqualToString: @"stop"]) {
            [bridgeDelegate close: nil];
//            NSLog(@"jsbridgewebview: received thumbr stop request");
            
            result = NO;
        }
        else if ([[[request URL] host] isEqualToString: @"loadPortal"]) {
//            NSLog(@"jsbridgewebview: received thumbr loadPortal request");

            //load portal
//            thumbr://loadPortal
            
            [Thumbr startThumbrPortal];
            result =  NO;
        }
		// Returns FALSE, indicating it should not load the page. It is not an actual page to load.
		result = NO;
    } else if (bridgeDelegate) {
		// If it is not a JS notification, pass it to the delegate.
//        NSLog(@"jsbridgewebview:request is not a JS notification");
		result = [bridgeDelegate webView:wv shouldStartLoadWithRequest:request navigationType:navigationType];
	}

    if ([requestURL fragment] && result) {
        NSLog(@"jsbridgewebview: received query: %@", [requestURL fragment]);
        [bridgeDelegate handleQuery:[request URL] ];
	} 
//	NSLog(@"Result: %i ", result);
	return result;
}

/*
	Just pass the webViewDidFinishLoad notification to the external delegate.
 */
- (void)webViewDidFinishLoad:(UIWebView *)wv {
    
//    NSLog(@"JSBridge: webViewDidFinishLoad: %@", [[[wv request] URL] standardizedURL]);

	if(bridgeDelegate) {
		[bridgeDelegate webViewDidFinishLoad:wv];
	}
        
   }

/*
	Just pass the webViewDidStartLoad notification to the external delegate.
 */
- (void)webViewDidStartLoad:(UIWebView *)wv {
	if (bridgeDelegate) {
		[bridgeDelegate webViewDidStartLoad:wv];
	}
}

/*
 Just pass the didFailLoadWithError notification to the external delegate.
 */
- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
	if (bridgeDelegate) {
		[bridgeDelegate webView: wv didFailLoadWithError:[error copy]];
	}
    
//    NSLog(@"jsbridgewebview didFailLoadWithError: %@", [error description]);
    
    
    
}

@end
