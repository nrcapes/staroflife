//
//  NRCPasscodeController2ViewController.m
//  EMSTimers
//
//  Created by Nelson Capes on 1/29/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//
// This controller is called by the PatientListTableViewController if the Settings Bundle had the password enabled switch turned ON.
// It displays one passcode field and checks that the user enters only a 4-digit numeric code. If the password does not match the
// password that was entered by NRCTableViewController, shakeAnimation is called to shake the view.  The code only unwinds a segue
// back to the PatientListTableViewController if the passcode matched. If not, there is no way for the user to get back to the
// PatientListTableViewController.

#import "NRCPasscodeController2ViewController.h"

@interface NRCPasscode2ControllerViewController ()

@end

@implementation NRCPasscode2ControllerViewController
-(void)shakeAnimation:(UIView*) view {
    const int reset = 5;
    const int maxShakes = 6;
    
    //pass these as variables instead of statics or class variables if shaking two controls simultaneously
    static int shakes = 0;
    static int translate = reset;
    
    [UIView animateWithDuration:0.09-(shakes*.01) // reduce duration every shake from .09 to .04
                          delay:0.01f//edge wait delay
                        options:(enum UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                     animations:^{view.transform = CGAffineTransformMakeTranslation(translate, 0);}
                     completion:^(BOOL finished){
                         if(shakes < maxShakes){
                             shakes++;
                             
                             //throttle down movement
                             if (translate>0)
                                 translate--;
                             
                             //change direction
                             translate*=-1;
                             [self shakeAnimation:view];
                         } else {
                             view.transform = CGAffineTransformIdentity;
                             shakes = 0;//ready for next time
                             translate = reset;//ready for next time
                             return;
                         }
                     }];
}

- (IBAction)checkPasswords:(id)sender {
    // if a password has not been entered, display
    // both password fields
    
    if((self.passwordWasEntered == NO)){
        
        // password1 must be 4 characters in length
        
    if ([self.password1.text length] == 4) {
        //self.password1.textColor = [UIColor greenColor];
    } else {
        self.password1.text =@"Passcode1 Invalid!";
       // self.password1.textColor = [UIColor redColor];
        [self shakeAnimation:self.view];
        
    }
        // password2 must be 4 characters in length
        
    if ([self.password2.text length] == 4) {
       // self.password2.textColor = [UIColor greenColor];
    } else {
       self.password2.text =@"Passcode2 Invalid!";
       // self.password2.textColor = [UIColor redColor];
        [self shakeAnimation:self.view];
    }
        // passwords must match
        
    if([self.password1.text isEqual:self.password2.text]){
        //self.password2.textColor = [UIColor greenColor];
        // passwords match, so set the password and segue back
        
        self.password = self.password1.text;
        [self performSegueWithIdentifier:@"unwindToDisplay" sender:self];
    }
    else{
       // self.password2.textColor = [UIColor redColor];
        [self shakeAnimation:self.view];
    }
        
    }
    // if password has already been entered, just check the first password
    // field against the entered password.
    else if ([self.password1.text length] == 4 && [self.password isEqualToString: self.password1.text]){
        
        // password matches entered password, so set the password and segue back
        //self.password1.textColor = [UIColor greenColor];
        [self performSegueWithIdentifier:@"unwindToDisplay" sender:self];
    }
        else{
            // password does not match entered password
            //self.password1.textColor = [UIColor redColor];
           // self.password = self.password1.text;
            [self shakeAnimation:self.view];
        }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [super resignFirstResponder];
    [textField resignFirstResponder];
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.password1.delegate = self;
    self.password2.delegate = self;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    // if self.password is not nil, a password has already been entered
    // so only display one password field to check.
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
