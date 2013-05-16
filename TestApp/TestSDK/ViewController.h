//
//  ViewController.h
//  TestSDK
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ViewController : UIViewController

@property (retain, nonatomic) IBOutlet NSArray *values;
@property (retain, nonatomic) IBOutlet UIView *thumbrTView;
- (IBAction)AdOverlay:(UIButton *)sender;
- (IBAction)AdInline:(UIButton *)sender;
- (IBAction)AdInterstitial:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UIView *Banner;

@property (retain, nonatomic) IBOutlet UIButton *inlinebutton;

@property (retain, nonatomic) IBOutlet UIView *adView;


@end
