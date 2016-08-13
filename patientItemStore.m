//
//  patientItemStore.m
//  EMSTimers
//
//  Created by Nelson Capes on 1/18/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//
// This class is a singleton storage class for the application's Model. It handles the creation, removal, listing, moving, and archiving the patientItems. It uses the NSKeyedArchiver and NSKeyedUnarchiver methods to save the data to disk in a persistent state. Its saveChanges method is called from the AppDelegate.m when the application enters background.

#import "patientItemStore.h"

@interface patientItemStore ()

@property (nonatomic) NSMutableArray *privateItems;
@end

@implementation patientItemStore

+ (instancetype)sharedStore
{
    static patientItemStore *sharedStore;
    
    // Do I need to create a sharedStore?
    /*
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    */
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc]initPrivate];
    });
    return sharedStore;
}

// If a programmer calls [[NRCItemStore alloc] init], let him
// know the error of his ways
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[patientItemStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

// Here is the real (secret) initializer
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        NSString *path = [self itemArchivePath];
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If the array hadn't been saved previously, create a new empty one
        if (!_privateItems) {
            _privateItems = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (NSString *)itemArchivePath
{
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    
    // Returns YES on success
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
}
-(BOOL)saveChangedPrivateItems:(NSMutableArray*)items{
    NSString *path = [self itemArchivePath];
    
    // Returns YES on success
    return [NSKeyedArchiver archiveRootObject:items toFile:path];
}
- (NSArray *)allItems
{
    return [self.privateItems copy];
}
-(NSArray*)allItemsActual{
    return self.privateItems;
}
- (patientItem *)createItem
{
    patientItem *item = [[patientItem alloc] init];
    
    [self.privateItems addObject:item];
    
    return item;
}
-(void)addItem:(patientItem *)item{
    [self.privateItems addObject:item];
}
- (void)removeItem:(patientItem *)item
{
    

    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)itemReplace:(patientItem*)item1
               with:(patientItem*)item2
{
    NSUInteger index = [self.privateItems indexOfObjectIdenticalTo:item1];
    [self.privateItems replaceObjectAtIndex:index withObject:item2];
}

- (void)moveItemAtIndex:(NSInteger)fromIndex
                toIndex:(NSInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    // Get pointer to object being moved so you can re-insert it
    patientItem *item = self.privateItems[fromIndex];
    
    // Remove item from array
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    // Insert item in array at new location
    [self.privateItems insertObject:item atIndex:toIndex];
}

-(void)sortByDate:(BOOL)direction{
    if(direction){
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"contactTime" ascending:YES];
        [self.privateItems sortUsingDescriptors:@[sortDescriptor]];
    }else{
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"contactTime" ascending:YES];
    [self.privateItems sortUsingDescriptors:@[sortDescriptor]];
    }
}

@end
