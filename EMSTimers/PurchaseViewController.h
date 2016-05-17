//
//  PurchaseViewController.h
//  EMS Timers Professional
//
//  Created by Nelson Capes on 3/27/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "NRCTableViewController.h"
#import "NRCErrorStore.h"
@class NRCTableViewController;
@interface PurchaseViewController : UIViewController <SKPaymentTransactionObserver, SKProductsRequestDelegate>
@property (strong) NSString *productToBuy;
@property (strong, nonatomic) SKProduct *product;
@property (strong, nonatomic) NSString *productID;
@property (strong, nonatomic) SKPaymentTransaction *transaction;
@property (strong, nonatomic) SKPayment *payment;
@property (strong, nonatomic) IBOutlet UILabel *productTitle;
@property (strong) NSString *productToUnlock;
@property (strong, nonatomic) IBOutlet UIButton *buyButton;
@property (strong, nonatomic) IBOutlet UITextView *productDescription;
@property BOOL centralAdminUnlocked;
@property BOOL iCloudSupportUnlocked;
@property BOOL productAvailable;
@property (strong, nonatomic) NSSet *requestSet;
@property (strong, nonatomic) SKProductsRequest *request;
@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) NSDate *transactionDate;
@property (strong, nonatomic) NSDictionary *productDict;
@property (strong, nonatomic) NSMutableDictionary *transactionDates;
@property(strong,nonatomic)NRCTableViewController *homeViewController;
- (IBAction)buyProduct:(id)sender;
- (void)getProductInfo;
-(IBAction)restoreCompletedTransactions:(id)sender;
@end
