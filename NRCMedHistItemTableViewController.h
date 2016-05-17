//
//  NRCMedHistItemTableViewController.h
//  EMSTimers
//
//  Created by Nelson Capes on 2/16/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NRCMedHistItemTableViewController : UITableViewController <UITextViewDelegate>
@property  UITableViewCell *cellToZoom;
@property (weak, nonatomic) IBOutlet UITextView *displayedText;
@property IBOutlet UITextView * textView;
@property NSMutableArray *medications;
@property NSMutableArray *interventions;
@property NSInteger row;

@end
