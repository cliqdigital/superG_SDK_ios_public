//
//  AdViewController.h
//

#import <UIKit/UIKit.h>
#import <MadsSDK/MadsSDK.h>
#import "Thumbr.h"
#import "JSON.h"
#import "SBJSON.h"
SBJsonParser *jsonParser;

@class AdView;
@interface AdViewController : UIViewController <UIApplicationDelegate,MadsAdViewDelegate>
{
    MadsAdView *_adView;
}


@property(nonatomic,retain) MadsAdView *adView;
@property(nonatomic,retain) NSString *adType;
-(void) adOverlay:(NSDictionary*)adSettings;
-(void) adInline:(NSDictionary*)adSettings adSettings:(UIView*)view;
-(void) adInterstitial:(NSDictionary*)adSettings;
-(NSDictionary*)getAdditionalParameters;
+(void) getAdSettings;
-(NSString*)escape:(NSString*)input;
-(void) stopAds;
@end


