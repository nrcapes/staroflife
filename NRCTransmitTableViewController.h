//
//  NRCTransmitTableViewController.h
//  EMS Timers Professional
//
//  Created by Nelson Capes on 7/20/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NRCEmailTableViewController.h"
#import "DBBViewController.h"
#import "patientItemStore.h"
@interface NRCTransmitTableViewController : UITableViewController
@property (strong,nonatomic) NSMutableArray *patients;
@property NSMutableArray *checkedArray;
@end
