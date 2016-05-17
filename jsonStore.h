//
//  jsonStore.h
//  EMS Timers Professional
//
//  Created by Nelson Capes on 3/16/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//
//
#import <Foundation/Foundation.h>

@interface jsonStore : NSObject{
    NSDictionary *jsonData;
}

+(jsonStore *) getInstance;

-(void)saveData:(NSDictionary *)dict;
-(NSDictionary*) getData;

@end
