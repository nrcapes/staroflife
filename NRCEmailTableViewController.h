//
//  NRCEmailTableViewController.h
//  EMSTimers
//
//  Created by Nelson Capes on 17/4/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "patientItem.h"
#import <MessageUI/MessageUI.h>

@interface NRCEmailTableViewController : UITableViewController <UITextFieldDelegate, MFMailComposeViewControllerDelegate>

@property UITextField *firstNameField;
@property UITextField *middleNameField;
@property UITextField *lastNameField;
@property UITextField *dateofBirthField;
@property UITextField *genderField;
@property UITextField *streetAddressField;
@property UITextField *cityAddressField;
@property UITextField *stateAddressField;
@property UITextField *zipCodeField;
@property UITextField *phoneNumberField;
@property UITextField *venueField;
@property UITextField *eventField;
@property NSString *firstName;
@property NSString *middleName;
@property NSString *lastName;
@property NSString *dateOfBirth;
@property NSString *gender;
@property NSString *streetAddress;
@property NSString *cityAddress;
@property NSString *stateAddress;
@property NSString *zipCode;
@property NSString *phoneNumber;
@property NSString *venue;
@property NSString *event;
@property (nonatomic) patientItem *item;
@property (nonatomic, copy) NSMutableArray *patients;
@property (nonatomic) NSMutableArray *assessments;
@property (nonatomic) BOOL emailActivated;
@property (nonatomic) BOOL centralAdmin;
@property UITextView * textView;
@property NSMutableArray *checkedArray;
@property (strong, nonatomic)NSString *emailAddress;
@property (strong, nonatomic) NSArray *toRecipients;
@property (strong,nonatomic) NSString *tempBody;
@property (strong, nonatomic) NSString *messageBody;
@property (strong, nonatomic) NSMutableArray *assessmentsForEmail;
@property NSInteger numberOfEmailsSent;
@property NSInteger maxEmails;
@property patientItem *localItem;
-(void)checkUserSelectedPatientData:(patientItem *)item;
@property (nonatomic) BOOL myValue;
@property NSArray *iapdata;
@property BOOL centralAdminSelected;
@property (nonatomic) BOOL unlimitedEmailsUnlocked;
@property (nonatomic) BOOL trialEmailsUnlocked;
@end
