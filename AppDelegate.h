//
//  AppDelegate.h
//  EMS Timer
//
//  Created by Nelson Capes on 11/2/15.
//  Copyright © 2015 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseViewController.h"
#import "Note.h"
#import "patientItem.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PurchaseViewController *purchaseController;
@property patientItem *item;
@property (strong) Note *doc;
@property (strong)NSMetadataQuery *query;
@end

