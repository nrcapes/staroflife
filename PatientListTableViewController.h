//
//  PatientListTableViewController.h
//  EMSTimers
//
//  Created by Nelson Capes on 2/3/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "patientItem.h"
#import "NRCPasscodeViewController.h"
@interface PatientListTableViewController : UITableViewController <UITextFieldDelegate,NRCPasscodeViewControllerDelegate, UITableViewDataSource>
@property (nonatomic) NSMutableArray *patients;
@property (nonatomic) patientItem *patientItem;
@property NSMutableArray *medications;
@property NSMutableArray *interventions;
@property (strong, nonatomic) NSString *password;
@end
