//
//  iapstore.m
//  EMS Timers Professional
//
//  Created by Nelson Capes on 3/28/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import "iapstore.h"

@implementation iapstore

static iapstore *singletonInstance;

+(iapstore *)getInstance{
    /*
    if(singletonInstance == nil){
        singletonInstance = [[super alloc]init];
    }
     */
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonInstance = [[super alloc]init];
    });
    return singletonInstance;
}
-(void)saveData:(NSArray *)array{
    iapdata = array;
}
-(NSArray *)getData{
    return iapdata;
}

@end
