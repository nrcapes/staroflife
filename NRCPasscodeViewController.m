//
// 
//

#import "NRCPasscodeViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioServices.h>

@interface NRCPasscodeViewController ()

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
- (void)internalResetWithAnimation:(NSNumber *)animationStyleNumber;
- (void)notifyDelegate:(NSString *)passcode;

@end

@implementation NRCPasscodeViewController

@synthesize delegate;

@synthesize animationView;

@synthesize titleLabel;
@synthesize instructionLabel;

@synthesize bulletField0;
@synthesize bulletField1;
@synthesize bulletField2;
@synthesize bulletField3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    fakeField = [[UITextField alloc] initWithFrame:CGRectZero];
    fakeField.delegate = self;
    fakeField.keyboardType = UIKeyboardTypeNumberPad;
    fakeField.secureTextEntry = YES;
    fakeField.text = @"";
    [fakeField becomeFirstResponder];
    [self.view addSubview:fakeField];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = NSLocalizedString(@"Passcode", @"");
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    fakeField = nil;
    
    self.animationView = nil;
    
    self.titleLabel = nil;
    self.instructionLabel = nil;
    
    self.bulletField0 = nil;
    self.bulletField1 = nil;
    self.bulletField2 = nil;
    self.bulletField3 = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)internalResetWithAnimation:(NSNumber *)animationStyleNumber
{
    NRCPasscodeAnimationStyle animationStyle = [animationStyleNumber intValue];
    switch (animationStyle) {
        case NRCPasscodeAnimationStyleInvalid:
        {
            
            // Vibrate to indicate error
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
            [animation setDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
            [animation setDuration:0.025];
            [animation setRepeatCount:8];
            [animation setAutoreverses:YES];
            [animation setFromValue:[NSValue valueWithCGPoint:
                                     CGPointMake([animationView center].x - 14.0f, [animationView center].y)]];
            [animation setToValue:[NSValue valueWithCGPoint:
                                   CGPointMake([animationView center].x + 14.0f, [animationView center].y)]];
        [[animationView layer] addAnimation:animation forKey:@"position"];
    }
            break;
        case NRCPasscodeAnimationStyleConfirm:
            ;
        {
            // This will cause the 'new' fields to appear without bullets already in them
            self.bulletField0.text = nil;
            self.bulletField1.text = nil;
            self.bulletField2.text = nil;
            self.bulletField3.text = nil;
            
            CATransition *transition = [CATransition animation]; 
            [transition setDelegate:self]; 
            [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
            [transition setType:kCATransitionPush]; 
            [transition setSubtype:kCATransitionFromRight]; 
            [transition setDuration:0.5f];
            [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]]; 
            [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1]; 
            [[animationView layer] addAnimation:transition forKey:@"swipe"];
        }
            break;
        case NRCPasscodeAnimationStyleNone:
        {
        default:
            self.bulletField0.text = nil;
            self.bulletField1.text = nil;
            self.bulletField2.text = nil;
            self.bulletField3.text = nil;
            
            fakeField.text = @"";
        }
            break;
    }
}

- (void)resetWithAnimation:(NRCPasscodeAnimationStyle)animationStyle {
    // Do the animation a little later (for better animation) as it's likely this method is called in our delegate method
    [self performSelector:@selector(internalResetWithAnimation:) withObject:[NSNumber numberWithInt:animationStyle] afterDelay:0];
}

- (void)notifyDelegate:(NSString *)passcode {
    [self.delegate passcodeController:self passcodeEntered:passcode];
    fakeField.text = @"";
}

#pragma mark - CAAnimationDelegate 
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.bulletField0.text = nil;
    self.bulletField1.text = nil;
    self.bulletField2.text = nil;
    self.bulletField3.text = nil;
    
    fakeField.text = @"";
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *passcode = [textField text];
    passcode = [passcode stringByReplacingCharactersInRange:range withString:string];

    switch ([passcode length]) {
        case 0:
            self.bulletField0.text = nil;
            self.bulletField1.text = nil;
            self.bulletField2.text = nil;
            self.bulletField3.text = nil;
            break;
        case 1:
            self.bulletField0.text = @"*";
            self.bulletField1.text = nil;
            self.bulletField2.text = nil;
            self.bulletField3.text = nil;
            break;
        case 2:
            self.bulletField0.text = @"*";
            self.bulletField1.text = @"*";
            self.bulletField2.text = nil;
            self.bulletField3.text = nil;
            break;
        case 3:
            self.bulletField0.text = @"*";
            self.bulletField1.text = @"*";
            self.bulletField2.text = @"*";
            self.bulletField3.text = nil;
            break;
        case 4:
            self.bulletField0.text = @"*";
            self.bulletField1.text = @"*";
            self.bulletField2.text = @"*";
            self.bulletField3.text = @"*";
        
            // Notify delegate a little later so we have a chance to show the 4th bullet
            [self performSelector:@selector(notifyDelegate:) withObject:passcode afterDelay:0];
            
            return NO;
            
            break;
        default:
            break;
    }

    return YES;
}

@end
