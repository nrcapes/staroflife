//
//  NRCPasscodeControllerViewController.h
//  EMSTimers
//
//  Created by Nelson Capes on 1/29/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NRCPasscodeControllerViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *password1;
@property (weak, nonatomic) IBOutlet UITextField *password2;
@property (strong, nonatomic) NSString *password;
@property (nonatomic) BOOL passwordWasEntered;
@property (nonatomic, copy) void (^passcodeError)(void);
@end
