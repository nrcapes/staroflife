//
//  AssessmentListTableViewController.h
//  EMSTimers
//
//  Created by Nelson Capes on 2/3/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "assessmentItem.h"
#import "patientItem.h"
@interface AssessmentListTableViewController : UITableViewController <UITextFieldDelegate, UITableViewDataSource>
@property (nonatomic) NSMutableArray *patients;
@property (nonatomic) patientItem *patientItem;
@property (nonatomic) assessmentItem *assessmentItem;
@property (nonatomic) NSMutableArray *assessments;
@property NSMutableArray *medications;
@property NSMutableArray *interventions;
@end
