//
//  InterfaceController.m
//  EMSTimers WatchKit 1 Extension
//
//  Created by Nelson Capes on 12/18/15.
//  Copyright © 2015 Nelson Capes. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}
- (IBAction)Start {
    NSDate *date =[NSDate date];
    self.dateStarted = date;
    NSTimeInterval timeInterval = 1.0;
    self.elapsedTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(calculateTimer:) userInfo:self.elapsedTimer repeats:YES];
    [self.elapsedTimer fire];
}
- (IBAction)Stop {
    NSArray *initialPhrases = @[@"Do you want to stop the timer?", @"YES", @"NO"];
    [self presentTextInputControllerWithSuggestions:initialPhrases allowedInputMode:WKTextInputModePlain completion:^(NSArray *results){
         if (results && results.count >0){
             id aResult = [results objectAtIndex:0];
             if ([aResult  isEqual: @"YES"]){
                 [self.elapsedTimer invalidate];}
             else{
             }
         }
    }
         ];
}
-(void)calculateTimer:(NSTimer *)theTimer
{
    
    NSTimeInterval interval = [self.dateStarted timeIntervalSinceNow];
    interval = (-1 * interval);
    
    int time = round(interval);
    div_t h = div(time, 3600); //seconds total, divided by 3600 equals
    int hours = h.quot;         // hours, divided by 60 equals
    div_t m = div(h.rem, 60);   // minutes
    int minutes = m.quot;
    int seconds = m.rem;        // and remainder is seconds
    
    
    NSString *intervalString = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    [self.ElapsedTime setText:intervalString];
}
- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
-(IBAction)Dispatch{
    
}
-(void)requestStop{
    [self.elapsedTimer invalidate];
}

@end



