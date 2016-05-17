//
//  NRCPatientDataTableViewCell.h
//  EMSTimers
//
//  Created by Nelson Capes on 1/17/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NRCPatientDataTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic) IBOutlet UITextField *patientTextField;

@property (weak, nonatomic) IBOutlet UILabel *patientLabel;

@property UILabel *label;
@end
