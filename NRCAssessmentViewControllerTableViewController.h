//
//  NRCAssessmentViewControllerTableViewController.h
//  EMSTimers
//
//  Created by Nelson Capes on 2/2/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "assessmentItem.h"
#import "patientItem.h"
@interface NRCAssessmentViewControllerTableViewController : UITableViewController <UITextFieldDelegate>
@property (nonatomic)IBOutlet UITextField *sytolicBloodPressure;
@property (nonatomic) IBOutlet  UITextField *diastolicBloodPressure;
@property (nonatomic) IBOutlet UITextField *pulse;
@property (nonatomic) IBOutlet UITextField *respirations;
@property (nonatomic) IBOutlet UITextField *spO2;
@property NSMutableArray *labels;
@property NSMutableArray *types;
@property NSMutableArray *taskCategories;
@property NSIndexPath *currentCategory;
@property assessmentItem *assessmentItem;
@property (strong, nonatomic)patientItem * patientItem;
@property NSMutableArray *medications;
@property NSMutableArray *interventions;
-(BOOL)verifyRange:(int)lowValue highValue:(int)highValue value:(int)value;
@end
