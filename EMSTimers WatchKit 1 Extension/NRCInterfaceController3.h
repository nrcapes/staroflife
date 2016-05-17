//
//  NRCInterfaceController3.h
//  EMSTimers
//
//  Created by Nelson Capes on 12/19/15.
//  Copyright © 2015 Nelson Capes. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface NRCInterfaceController3 : WKInterfaceController
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *ClearedTime;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *InServiceTime;

@end
