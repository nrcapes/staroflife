//
//  NRCMedicalHistoryTableViewCell.m
//  EMSTimers
//
//  Created by Nelson Capes on 2/14/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import "NRCMedicalHistoryTableViewCell.h"

@implementation NRCMedicalHistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  //  UIColor *color = [UIColor colorWithRed:0.0f/255 green:125.0f/255 blue:150.0f/255 alpha:0.8f];
    [super setSelected:selected animated:animated];
    
    
        NSArray *subViews = self.subviews;
        UIView *displayedText = subViews[0];
        [displayedText setBackgroundColor:[UIColor whiteColor]];
       // [displayedText setBackgroundColor:[UIColor colorWithRed:0.0f green:0.2f blue:.8f alpha:0.1f]];
        
        UIView *heldText = subViews[1];
        [heldText setBackgroundColor:[UIColor whiteColor]];
        [self setNeedsDisplay];
    
}
@end
