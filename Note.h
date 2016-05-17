//
//  Note.h
//  EMS Timers Professional
//
//  Created by Nelson Capes on 4/1/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "patientItem.h"
#import "patientItemStore.h"
@interface Note : UIDocument

@property (strong) NSMutableData *data;
@property (strong) NSMutableArray *patients;
@property (strong) NSURL *iCloudURL;
@property patientItem *patient;
@end
