//
//  NRCPatientDataTableViewController.h
//  EMSTimers
//
//  Created by Nelson Capes on 1/16/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "patientItem.h"
#import "NRCAssessmentViewControllerTableViewController.h"

@interface NRCPatientDataTableViewController : UITableViewController <UITextFieldDelegate>

@property UITextField *firstNameField;
@property UITextField *middleNameField;
@property UITextField *lastNameField;
@property UITextField *dateofBirthField;
@property UITextField *genderField;
@property UITextField *streetAddressField;
@property UITextField *streetAddress2Field;
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
@property NSString *streetAddress2;
@property NSString *cityAddress;
@property NSString *stateAddress;
@property NSString *zipCode;
@property NSString *phoneNumber;
@property NSString *venue;
@property NSString *event;
@property (nonatomic) patientItem *item;
@property (nonatomic) NSMutableArray *patients;
@property assessmentItem *assessmentItem;
@property (nonatomic) NSMutableArray *assessments;
-(BOOL) isNumericOrSlash:(NSString*)inputString;
@property UITextView * textView;
-(UITextField *)makeTextField: (NSString *)text
                  placeholder: (NSString *)placeholder
                 type_of_text:(NSInteger)type_of_text;
-(IBAction)textFieldFinished:(id)sender;



@end
