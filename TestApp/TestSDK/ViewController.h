//
//  ViewController.h
//  TestSDK
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SuperG/SuperG.h"
#import "SuperG/EVA.h"
#import "ACParallaxView.h"

@interface ViewController : UIViewController <ACParallaxViewDelegate>

@property (strong, nonatomic) IBOutlet NSArray *values;
@property (strong, nonatomic) IBOutlet UIView *thumbrTView;


@property (strong, nonatomic) IBOutlet ACParallaxView *parallaxView;


- (IBAction)achievement:(UIButton *)sender;
- (IBAction)click:(UIButton *)sender;
- (IBAction)purchase:(UIButton *)sender;
- (IBAction)start_level:(UIButton *)sender;
- (IBAction)finish_level:(UIButton *)sender;
- (IBAction)up_sell:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIView *Banner;

@property (strong, nonatomic) IBOutlet UIButton *inlinebutton;

@property (strong, nonatomic) IBOutlet UIView *bg1;
@property (strong, nonatomic) IBOutlet UIView *bg2;
@property (strong, nonatomic) IBOutlet UIView *bg3;
@end
