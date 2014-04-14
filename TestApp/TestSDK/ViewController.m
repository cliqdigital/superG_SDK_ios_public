//
//  ViewController.m
//  TestSDK
//
#import "AppDelegate.h"
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc{
    [super dealloc];
}

#pragma mark - ACParallaxViewDelegate

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.parallaxView.parallax = YES;

    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else
    {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.bg1 setBackgroundColor:[UIColor clearColor]];
            [self.bg2 setBackgroundColor:[UIColor clearColor]];
            [self.bg3 setBackgroundColor:[UIColor clearColor]];
        });
    }
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        _inlinebutton.enabled = NO;
    }
    
    



    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
}

- (void)viewDidUnload
{
    [self setInlinebutton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {
        return YES;
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && UIInterfaceOrientationIsPortrait(interfaceOrientation))
    {
        return YES;
    }
    
    return NO;
}


- (NSUInteger)supportedInterfaceOrientations
{
    //decide number of origination tob supported by Viewcontroller.
    return UIInterfaceOrientationMaskAll;
}

- (void) closedSDKPortalView
{
    NSLog(@"The Game was notified about the closing PortalView");
}

- (void) UISegmentedControl{
    NSLog(@"yoho");
}


- (IBAction)achievement:(UIButton *)sender {
    [EVA achievementEarned:@"Found gold"];
}

- (IBAction)click:(UIButton *)sender {
    [EVA click:@"TestButton"];
}

- (IBAction)purchase:(UIButton *)sender {
    [EVA purchase:@"coins" WithCurrency:@"EUR" PaymentMethod:@"in-app" AndPrice:@"0.79"];
}

- (IBAction)start_level:(UIButton *)sender {
    [EVA start_level:@"1" inMode:@"attach_mode" withScoreType:@"win" andScoreValue:@"1"];
}

- (IBAction)finish_level:(UIButton *)sender {
    [EVA finish_level:@"100" inMode:@"attack mode" withScoreType:@"win" andScoreValue:@"1" ];
}

- (IBAction)up_sell:(UIButton *)sender {
    [EVA upSell:@"EUR" PaymentMethod:@"in-app"];
}


UIDeviceOrientation currentOrientation;

- (void)deviceOrientationDidChange:(NSNotification *)notification {

}


@end