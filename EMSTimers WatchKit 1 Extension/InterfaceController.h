//
//  InterfaceController.h
//  EMSTimers WatchKit 1 Extension
//
//  Created by Nelson Capes on 12/18/15.
//  Copyright © 2015 Nelson Capes. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *ElapsedTime;

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *dispatchTime;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *dateStarted;
@property (strong, nonatomic) NSTimer *elapsedTimer;

@end
