//
//  AdViewController.h
//

#import <UIKit/UIKit.h>
#import <MadsSDK/MadsSDK.h>

@class MadsAdView;
@interface AdViewController : UIViewController <MadsAdViewDelegate>
{
    MadsAdView *_adView;
}
@property(nonatomic,retain) MadsAdView *adView;
-(void) setupMadsAdView;
-(void) showRefreshButton;
@end
