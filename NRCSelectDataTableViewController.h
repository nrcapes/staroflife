//
//  SelectDataTableViewController.h
//  EMS Timers Professional
//
//  Created by Nelson Capes on 3/14/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NRCTableViewController.h"
@interface NRCSelectDataTableViewController : UITableViewController <UITextFieldDelegate>
@property NSMutableArray *medications;
@property NSArray *medicationsSorted;
@property NSArray *medicationKeys;
@property NSMutableArray *interventions;
@property NSArray *interventionsSorted;
@property NSArray *interventionsKeys;
@property NSMutableArray *chiefComplaint;
@property NSArray *chiefComplaintSorted;
@property NSArray *chiefComplaintKeys;
@property NSMutableArray *clinicalImpression;
@property NSArray *clinicalImpressionSorted;
@property NSArray *clinicalImpressionKeys;
@property NSMutableArray *medicalHistory;
@property NSArray *medicalHistorySorted;
@property NSArray *medicalHistoryKeys;
@property NSMutableArray *allergies;
@property NSArray *allergiesSorted;
@property NSArray *allergiesKeys;
@property NSMutableArray *moinoi;
@property NSArray *moinoiSorted;
@property NSArray *moinoiKeys;
@property NSDictionary *jsonData;
@property NSString *selectedItem;
@property NSInteger rowCount;
@property NSArray *iapdata;
@property BOOL centralAdminActivated;
@property BOOL centralAdminSelected;
@end
