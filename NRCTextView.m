//
//  NRCTextView.m
//  EMS Timers Professional
//
//  Created by Nelson Capes on 4/27/17.
//  Copyright © 2017 Nelson Capes. All rights reserved.
//

#import "NRCTextView.h"

@implementation NRCTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    self.selectable = NO;
}
@end
