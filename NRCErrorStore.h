//
//  NRCErrorStore.h
//  EMS Timers Professional
//
//  Created by Nelson Capes on 3/19/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NRCErrorStore : NSObject {NSError *error;
}
+(NRCErrorStore *)getInstance;
@property NSArray *errorArray;
-(void)saveData:(id)errorToLog;
-(id) getData;
@end
