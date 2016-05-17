//
//  NRCZoomViewController.h
//  EMSTimers
//
//  Created by Nelson Capes on 2/14/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "assessmentItem.h"
#import "NRCMedicalHistoryTableViewCell.h"
@interface NRCZoomViewController : UIViewController
@property  UITableViewCell *cellToZoom;
@property (weak, nonatomic) IBOutlet UITextView *displayedText;
@property UITextView * textView;
@end
