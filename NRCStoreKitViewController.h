//
//  NRCStoreKitViewController.h
//  EMS Timers Professional
//
//  Created by Nelson Capes on 5/5/17.
//  Copyright © 2017 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
@interface NRCStoreKitViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *productTitle;
@property (strong, nonatomic) IBOutlet UIButton *buyButton;
@property (strong, nonatomic) IBOutlet UITextView *productDescription;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic)  NSArray *products;
@property (strong) NSString *productToBuy;
@property (strong, nonatomic) SKProduct *product;
@property (strong, nonatomic) NSString *productID;
@property (strong, nonatomic) SKPaymentTransaction *transaction;
@property (strong, nonatomic) SKPayment *payment;
@property (strong) NSString *productToUnlock;
@property NSString *productToLock;
@property BOOL centralAdminUnlocked;
@property BOOL iCloudSupportUnlocked;
@property BOOL productAvailable;
@property (strong, nonatomic) NSSet *requestSet;
@property (strong, nonatomic) SKProductsRequest *request;
@property (strong, nonatomic) NSDate *transactionDate;
@property (strong, nonatomic) NSMutableDictionary *productDict;
@property (strong, nonatomic) NSMutableDictionary *transactionDates;
@property (strong, nonatomic) NSString *productIdentifier;
@property NSString *title;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property UIAlertView * alert;
#pragma clang diagnostic pop
-(void)notifyOfAvailableProducts:(NSNotification *)userInfo;
-(void)displayAvailableProducts:(NSMutableArray *)availableProducts;
-(void)notifyOfFailedProductPurchase:(NSNotification *)notification;
-(void)unlockFeature:(NSString *)productToUnlock;
@end
