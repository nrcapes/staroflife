//
//  NRCInterfaceController2.h
//  EMSTimers
//
//  Created by Nelson Capes on 12/19/15.
//  Copyright © 2015 Nelson Capes. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface NRCInterfaceController2 : WKInterfaceController
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *transportTime;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *hospitalTime;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *dateStarted;
@end
