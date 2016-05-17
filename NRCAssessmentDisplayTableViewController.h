//
//  NRCAssessmentDisplayTableViewController.h
//  EMSTimers
//
//  Created by Nelson Capes on 2/6/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "assessmentItem.h"
#import "patientItem.h"
@interface NRCAssessmentDisplayTableViewController : UITableViewController <UITextFieldDelegate>
@property (nonatomic)IBOutlet UITextField *sytolicBloodPressure;
@property (nonatomic) IBOutlet  UITextField *diastolicBloodPressure;
@property (nonatomic) IBOutlet UITextField *pulse;
@property (nonatomic) IBOutlet UITextField *respirations;
@property (nonatomic) IBOutlet UITextField *spO2;
@property NSMutableArray *labels;
@property NSMutableArray *types;
@property NSMutableArray *taskCategories;
@property NSIndexPath *currentCategory;
@property (nonatomic)assessmentItem *assessmentItem;
@property (nonatomic) NSMutableArray *patients;
@property patientItem *patientItem;
@property NSMutableArray *medications;
@property NSMutableArray *interventions;
@end
