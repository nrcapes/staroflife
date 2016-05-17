//
//  NRCNarrativeViewController.h
//  EMS Timers Professional
//
//  Created by Nelson Capes on 4/14/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "patientItem.h"
@interface NRCNarrativeViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *narrative;
@property IBOutlet UITextView * textView;
@property  UITableViewCell *cellToZoom;
@property (weak, nonatomic) IBOutlet UITextView *displayedText;
@property patientItem *patientItem;
@end
