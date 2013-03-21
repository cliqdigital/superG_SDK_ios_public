//
//  ViewController.m
//  TestSDK
//

#import "ViewController.h"
#import "Thumbr/Thumbr.h"

@interface ViewController ()

@end

@implementation ViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc
{
    [_switchOrientation release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"background@2x~ipad.png"]];
    
    //SET THE THUMBR BUTTON HERE
    
    //POSITION OF THE THUMBR BUTTON
//TL = topleft; TR = topright; BL = bottomleft; BR = bottomright
    NSString *position=@"TL";
//SIZE OF THE THUMBR BUTTON
    //relativeSize=8 will result in a width and height of 1/8 of the portrait screen width (with a max. of 190px)
    int relativeSize=6;
    
//IMPLEMENTATION EXAMPLE DIRECTLY ON MAIN VIEW (CORNERS ONLY)

    /*    UIButton *thumbrT = [Thumbr loadThumbrT:relativeSize relativeSize:position];
    	[self.view addSubview:thumbrT];//add the view
        [self.view bringSubviewToFront:thumbrT];//make sure it is on front
     */

//IMPLEMENTATION EXAMPLE ON SUBVIEW (MAKE SURE POSITION IS TL)
    //create a sub view in your NIB and add the Thumbr-T-Logo to it
    UIButton *thumbrT2 = [Thumbr loadThumbrT:relativeSize relativeSize:position];
    [self.thumbrTView addSubview:thumbrT2 ];
    
}

- (void)viewDidUnload
{
    [self setSwitchOrientation:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
    else{
        return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
    }

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

@end
