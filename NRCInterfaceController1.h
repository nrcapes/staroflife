//
//  NRCInterfaceController1.h
//  EMSTimers
//
//  Created by Nelson Capes on 12/19/15.
//  Copyright © 2015 Nelson Capes. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface NRCInterfaceController1 : WKInterfaceController
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *PatientContactTime;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *dispatchTime;

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *dateStarted;
@end
