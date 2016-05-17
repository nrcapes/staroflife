//
//  NRCMedicalHistoryItemTableViewController.h
//  EMSTimers
//
//  Created by Nelson Capes on 2/14/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "patientItem.h"
@interface NRCMedicalHistoryItemTableViewController : UITableViewController <UITextViewDelegate>
@property  UITableViewCell *cellToZoom;
@property (weak, nonatomic) IBOutlet UITextView *displayedText;
@property IBOutlet UITextView * textView;
@property patientItem *patientItem;
@property NSMutableArray *medications;
@property NSMutableArray *interventions;
@property NSInteger row;
@end
