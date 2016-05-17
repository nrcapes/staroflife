//
//  NRCInterfaceController1.m
//  EMSTimers
//
//  Created by Nelson Capes on 12/19/15.
//  Copyright © 2015 Nelson Capes. All rights reserved.
//

#import "NRCInterfaceController1.h"

@interface NRCInterfaceController1 ()

@end

@implementation NRCInterfaceController1
- (IBAction)PatientContact {
    NSDate *date =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:date];
    [self.PatientContactTime setText:dateString];
}
- (IBAction)Dispatch {
    NSDate *date =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:date];
    [self.dispatchTime setText:dateString];
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


@end



