//
//  AppDelegate.m
//  EMS Timer
//
//  Created by Nelson Capes on 11/2/15.
//  Copyright © 2015 Nelson Capes. All rights reserved.
//
#define kFILENAME @"emstimerspro"
#import "AppDelegate.h"
#import "NRCTableViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "patientItemStore.h"
#import "PurchaseViewController.h"
#import "NRCEmailTableViewController.h"
#import "constants.h"
#import "NRCStoreKitViewController.h"
#import "MKStoreKit.h"
#import <DropboxSDK/DropboxSDK.h>
@interface AppDelegate () 

@end

@implementation AppDelegate
@class PurchaseViewController;
-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
   // self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   // self.window.backgroundColor = [UIColor whiteColor];
    
    [self registerDefaultsFromSettingsBundle];
    
        return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation {
    NSLog(@"openUrl, %@", source);
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSError *sessionError = nil;
    NSError *activationError = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&sessionError];
    [[AVAudioSession sharedInstance] setActive: YES error: &activationError];
    
    /* uncomment if no longer using MKStoreKit as payment queue observer
    _purchaseController = [[PurchaseViewController alloc]init];
    [[SKPaymentQueue defaultQueue]
     addTransactionObserver:_purchaseController];
     */
    
    // icloud setup
    NSURL *ubiq = [[NSFileManager defaultManager]
                   URLForUbiquityContainerIdentifier:nil];
    if(ubiq){
        NSLog(@"iCloud access at %@", ubiq);
        // TODO: load document
        [self loadDocument];
    }else{
        NSLog(@"No iCloud accss");
    }
    
    self.appKey = @"df9fyg4o6obzreo";
    self.appSecret = @"vwd8zbtew4jj2nd";
    
    DBSession *dbSession = [[DBSession alloc]
                            initWithAppKey:@"df9fyg4o6obzreo"
                            appSecret:@"vwd8zbtew4jj2nd"
                            root:kDBRootAppFolder]; // either kDBRootAppFolder or kDBRootDropbox
    [DBSession setSharedSession:dbSession];
    
    [[MKStoreKit sharedKit] startProductRequest];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductsAvailableNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:note, nil];
                                                      NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:array, kAvailableProductKey, nil];
                                                      NRCStoreKitViewController *storeKitVC = [[NRCStoreKitViewController alloc]init];
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfAvailableProducts object:storeKitVC userInfo:dict];
                                                      NSLog(@"Products available: %@", [[MKStoreKit sharedKit] availableProducts]);
                                                  }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchasedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:note, nil];
                                                      NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:array, kAvailableProductKey, nil];
                                                      NRCStoreKitViewController *storeKitVC = [[NRCStoreKitViewController alloc]init];
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfProductPurchase object:storeKitVC userInfo:dict];

                                                      NSLog(@"Purchased/Subscribed to product with id: %@", [note object]);
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoredPurchasesNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:note, nil];
                                                      NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:array, kAvailableProductKey, nil];
                                                      NRCStoreKitViewController *storeKitVC = [[NRCStoreKitViewController alloc]init];
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfRestoredPurchase object:storeKitVC userInfo:dict];
                                                      NSLog(@"Restored Purchases");
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoringPurchasesFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Failed restoring purchases with error: %@", [note object]);
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitSubscriptionExpiredNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Subscription expired with error: %@", [note object]);
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitReceiptValidationFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:note, nil];
                                                      NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:array, kAvailableProductKey, nil];
                                                      NRCStoreKitViewController *storeKitVC = [[NRCStoreKitViewController alloc]init];
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfValidReceipt object:storeKitVC userInfo:dict];
                                                      NSLog(@"Receipt validation failed with error: %@", [note object]);
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitReceiptValidNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:note, nil];
                                                      NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:array, kAvailableProductKey, nil];
                                                      NRCStoreKitViewController *storeKitVC = [[NRCStoreKitViewController alloc]init];
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOfValidReceipt object:storeKitVC userInfo:dict];
                                                      NSLog(@"Receipt valid");
                                                  }];
    
    
    return YES;
}
-(void)loadDocument{
    NSMetadataQuery *query = [[NSMetadataQuery alloc]init];
    _query = query;
    [query setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == %@", NSMetadataItemFSNameKey, kFILENAME];
    [query setPredicate:pred];
   [[NSNotificationCenter defaultCenter]
    addObserver:self
    selector:@selector(queryDidFinishGathering:)
    name:NSMetadataQueryDidFinishGatheringNotification
    object:query];
    
    [query startQuery];
}
-(void)loadData:(NSMetadataQuery*)query{
    if([query resultCount] == 1){
        NSMetadataItem *item = [query resultAtIndex:0];
        NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
        Note *doc = [[Note alloc]initWithFileURL:url];
        self.doc = doc;
        [self.doc openWithCompletionHandler:^(BOOL success){
            if(success){
                NSLog(@"iCloud document opened");
            }else{
                NSLog(@"failed to open document from iCloud");
            }
        }];
    }else{
        NSURL *ubiq = [[NSFileManager defaultManager]
                       URLForUbiquityContainerIdentifier:nil];
        NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:@"Documents"]
                                    URLByAppendingPathComponent:kFILENAME];
        
        Note *doc = [[Note alloc]initWithFileURL:ubiquitousPackage];
        _item =[[patientItemStore sharedStore] createItem];
        
       // _item = [[patientItem alloc]init];
        _item.firstName =@"***place holder - you may delete this";
        doc.patient = _item;
        
        self.doc = doc;
        [doc saveToURL:[doc fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            if (success){
                [doc openWithCompletionHandler:^(BOOL success){
                    NSLog(@"new document opened from iCloud");
                    NSLog(@"doc = %@",doc);
                    NSLog(@"patient =%@", doc.patient);
                }];
            }
        }];
        
    }
    }

-(void)queryDidFinishGathering:(NSNotification*)notification{
    NSMetadataQuery *query = [notification object];
    [query disableUpdates];
    [query stopQuery];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:NSMetadataQueryDidFinishGatheringNotification
                                                 object:query];
    _query = nil;
    [self loadData:query];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NRCTableViewController *vc = [[NRCTableViewController alloc]init];
    vc.isAuthenticated = NO;
    vc.didReturnFromBackground = YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    NRCTableViewController *vc = [[NRCTableViewController alloc]init];
    
    BOOL userSelectedPatientDataSaved = [vc saveUserSelectedPatientData];
    if(userSelectedPatientDataSaved) {
        NSLog(@"Saved user selected patient data");
    }else{
        NSLog(@"Could not save user selected patient data");
    }
    
    BOOL itWorked =[vc savePassword];
    if(itWorked){
        NSLog(@"Saved the password");
    }else{
        NSLog(@"Could not save password");
    }
    
    BOOL savedProviderID = [vc saveProviderID];
    if(savedProviderID){
        NSLog(@"Saved the Provider ID");
    }else{
        NSLog(@"Could not save Provider ID");
    }
    

    BOOL success = [[patientItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved all of the Items");
    } else {
        NSLog(@"Could not save any of the Items");
    }
    
    
}
- (void)registerDefaultsFromSettingsBundle
{
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle)
    {
        //NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for(NSDictionary *prefSpecification in preferences)
    {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key)
        {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // comment out the following to use iCloud
    /*
    NRCTableViewController *vc = [[NRCTableViewController alloc]init];
    [vc applicationBecameActive];
     */
    }

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
