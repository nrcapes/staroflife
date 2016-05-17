//
//  NRCViewController.h
//  EMS Timer
//
//  Created by Nelson Capes on 11/2/15.
//  Copyright © 2015 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NRCViewController :  UITableViewController < UITableViewDataSource>
@property (weak, nonatomic) NSString *elapsedTime;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UIButton *dispatchButton;
@property (weak, nonatomic) IBOutlet UIButton *ptContactButton;
@property (weak, nonatomic) IBOutlet UIButton *transportButton;
@property (weak, nonatomic) IBOutlet UIButton *clearedButton;

@property (weak, nonatomic) IBOutlet UIButton *resetAllButton;
@property (weak, nonatomic) IBOutlet UIButton *hospitalButton;
@property (weak, nonatomic) NSString *startDate;
@property (weak, nonatomic) NSString *dispatchTime;
@property (weak, nonatomic) NSString *transportTime;
@property (weak, nonatomic) NSString *hospitalTime;
@property (weak, nonatomic) NSString *clearedTime;
@property (weak, nonatomic) NSString *contactTime;
@property NSTimer *elapsedTimer;
@property (strong, nonatomic) NSDate *dispatchDate;
@property (strong, nonatomic) NSDate *contactDate;
@property (strong, nonatomic) NSDate *transportDate;
@property (strong, nonatomic) NSDate *hospitalDate;
@property (strong, nonatomic)NSDate *clearedDate;
@property (strong, nonatomic) NSDate *dateStarted;
@property NSString *outputString;

@property NSMutableArray *labels;
@property NSMutableArray *types;

@property NSInteger timerType;
// ********************changed 9/30/05
// these properties are needed for exclusive selection of timer type in didSelectRowForIndexPath
@property NSInteger prev;
@property NSMutableArray *taskCategories;
@property NSIndexPath *currentCategory;
@end

