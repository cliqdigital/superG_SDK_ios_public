//
//  ViewController.h
//  TestSDK
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ViewController : UIViewController

@property (retain, nonatomic) IBOutlet NSArray *values;
@property (retain, nonatomic) IBOutlet UIView *thumbrTView;

@property (retain, nonatomic) IBOutlet UISegmentedControl *switchOrientation;
@end
