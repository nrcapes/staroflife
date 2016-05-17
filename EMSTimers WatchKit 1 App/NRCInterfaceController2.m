//
//  NRCInterfaceController2.m
//  EMSTimers
//
//  Created by Nelson Capes on 12/19/15.
//  Copyright © 2015 Nelson Capes. All rights reserved.
//

#import "NRCInterfaceController2.h"

@interface NRCInterfaceController2 ()

@end

@implementation NRCInterfaceController2
- (IBAction)Transport {
    NSDate *date =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:date];
    [self.transportTime setText:dateString];
}
- (IBAction)Hospital {
    NSDate *date =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:date];
    [self.hospitalTime setText:dateString];
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



