//
//  patientItemStore.h
//  EMSTimers
//
//  Created by Nelson Capes on 1/18/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "patientItem.h"
@interface patientItemStore : NSObject

@property (nonatomic, readonly) NSMutableArray *allItems;
@property (nonatomic) NSMutableArray *allItemsActual;

+ (instancetype)sharedStore;
- (patientItem *)createItem;
-(void)addItem:(patientItem *)item;
- (void)removeItem:(patientItem *)item;

- (void)moveItemAtIndex:(NSInteger)fromIndex
                toIndex:(NSInteger)toIndex;
- (void)itemReplace:(patientItem*)item1
               with:(patientItem*)item2;
-(void)sortByDate:(BOOL)direction;

- (BOOL)saveChanges;
-(BOOL)saveChangedPrivateItems:(NSMutableArray*)items;
@end
