//
//  jsonStore.m
//  EMS Timers Professional
//
//  Created by Nelson Capes on 3/16/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import "jsonStore.h"

@implementation jsonStore

static jsonStore *singletonInstance;

+(jsonStore *)getInstance{
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
-(void)saveData:(NSDictionary *)dict{
    jsonData= dict;
}
-(NSDictionary *)getData{
    return jsonData;
}
@end
