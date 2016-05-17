//
//  NRCMedicalHistoryDisplayTableViewController.h
//  EMSTimers
//
//  Created by Nelson Capes on 2/13/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "assessmentItem.h"
#import "patientItem.h"
@interface NRCMedicalHistoryDisplayTableViewController : UITableViewController <UITextFieldDelegate>
@property IBOutlet UITextField *chiefComplaint;
@property IBOutlet UITextField *clinicalImpression;
@property IBOutlet UITextField *medicalHistory;
@property IBOutlet UITextField *currentMedications;
@property IBOutlet UITextField *allergies;
@property IBOutlet UITextField *mechanismOfInjury;
@property IBOutlet UITextField *treatments;
@property IBOutlet UITextField *narrative;
@property assessmentItem *item;
@property (strong, nonatomic) UITableViewCell *cellToZoom;
@property patientItem *patientItem;
@property NSMutableArray *medications;
@property NSMutableArray *interventions;
@property NSInteger row;
@end
