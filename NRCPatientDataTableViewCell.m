//
//  NRCPatientDataTableViewCell.m
//  EMSTimers
//
//  Created by Nelson Capes on 1/17/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import "NRCPatientDataTableViewCell.h"

@implementation NRCPatientDataTableViewCell

- (IBAction)textFieldInput:(UITextField *)sender {
    NSLog(@"Text field input");
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)becomeFirstResponder
{
    return [self.patientTextField becomeFirstResponder];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
