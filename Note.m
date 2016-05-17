//
//  Note.m
//  EMS Timers Professional
//
//  Created by Nelson Capes on 4/1/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import "Note.h"
#import "patientItemStore.h"
#import "patientItem.h"
@implementation Note



-(id)contentsForType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError{
    //self.patients = [[patientItemStore sharedStore]allItems];
    self.data = [[NSMutableData alloc]init];
    /*
    NSMutableArray *items = [[patientItemStore sharedStore]allItems];
    if(items){
        patientItem *item = [items lastObject];
     */
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:self.data];
    [archiver encodeObject:self.patient forKey:@"patient"];
        [archiver finishEncoding];
        return self.data;}
    //   return self.data;
   // }
//}

// called whenever the application reads data from the file system
-(BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError{
    if ([contents length] > 0) {
        
            self.data = [[NSMutableData alloc]initWithData:contents];
        
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:self.data];
        //NSMutableArray *items = [[patientItemStore sharedStore]allItems];

        self.patient = [unarchiver decodeObjectForKey:@"patient"];
        // initial view controller will be notified and set its self.patientItem to self.patient

    } else {
        // When the note is first created, assign some default content
        self.data = [[NSMutableData alloc]initWithBytes:@"Empty" length:5];
    }
    // set up notification in NRCTableViewController viewDidLoad.
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"noteModified"
     object:self];
    return YES;
}


@end
