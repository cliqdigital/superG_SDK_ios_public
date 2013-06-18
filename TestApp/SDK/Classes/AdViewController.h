//
//  AdViewController.h
//

#import <UIKit/UIKit.h>
#import <MadsSDK/MadsSDK.h>
#import "Thumbr.h"

@class AdView;
@interface AdViewController : UIViewController <UIApplicationDelegate,MadsAdViewDelegate>
{
    MadsAdView *_adView;
}

@property(nonatomic,retain) MadsAdView *adView;
-(void) showAd;
@end
