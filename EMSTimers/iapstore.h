//
//  iapstore.h
//  EMS Timers Professional
//
//  Created by Nelson Capes on 3/28/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iapstore : NSObject{NSArray *iapdata;
}

+(iapstore *)getInstance;

-(void)saveData:(NSArray *)array;
-(NSArray *)getData;

@end
