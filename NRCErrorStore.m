//
//  NRCErrorStore.m
//  EMS Timers Professional
//
//  Created by Nelson Capes on 3/19/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import "NRCErrorStore.h"

@implementation NRCErrorStore


static NRCErrorStore *singleInstance;

+(NRCErrorStore *)getInstance{
    /*
    if(singleInstance == nil){
        singleInstance = [[super alloc]init];
    }
     */
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleInstance = [[super alloc]init];
    });
    return singleInstance;
}

-(void)saveData:(id)errorToLog{
    error = errorToLog;
    if(!self.errorArray){
        self.errorArray = [[NSMutableArray alloc]init];
    }
    self.errorArray = [self.errorArray arrayByAddingObject:error];
    
}
-(id)getData{
    return error;
}
@end
