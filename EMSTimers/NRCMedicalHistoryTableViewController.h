//
//  NRCMedicalHistoryTableViewController.h
//  EMSTimers
//
//  Created by Nelson Capes on 2/12/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "patientItem.h"
#import "NRCSelectDataTableViewController.h"
@interface NRCMedicalHistoryTableViewController : UITableViewController <UITextFieldDelegate>
@property IBOutlet UITextField *chiefComplaint;
@property IBOutlet UITextField *clinicalImpression;
@property IBOutlet UITextField *medicalHistory;
@property IBOutlet UITextField *currentMedications;
@property IBOutlet UITextField *allergies;
@property IBOutlet UITextField *mechanismOfInjury;
@property IBOutlet UITextField *treatments;
@property IBOutlet UITextField *narrative;
@property assessmentItem *item;
@property  UITableViewCell *cellToZoom;
@property (weak, nonatomic) IBOutlet UITextView *displayedText;
@property IBOutlet UITextView * textView;
@property (strong, nonatomic) patientItem *patientItem;
@property NSMutableArray *medications;
@property NSMutableArray *interventions;
@property NSInteger row;
@end
