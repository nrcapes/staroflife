//
//  NRCMedicalHistoryTableViewCell.h
//  EMSTimers
//
//  Created by Nelson Capes on 2/14/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NRCMedicalHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *item;
@property (weak, nonatomic) IBOutlet UITextField *text;

@end
