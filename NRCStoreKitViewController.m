//
//  NRCStoreKitViewController.m
//  EMS Timers Professional
//
//  Created by Nelson Capes on 5/5/17.
//  Copyright © 2017 Nelson Capes. All rights reserved.
//

#import "NRCStoreKitViewController.h"
#import "MKStoreKit.h"
#import <StoreKit/StoreKit.h>
#import "constants.h"
@interface NRCStoreKitViewController ()

@end

// View tags to differeniate alert views
static NSUInteger const kProductPurchasedAlertViewTag = 1;

@implementation NRCStoreKitViewController
-(instancetype)init{
    self = [super init];
    if(self){
        UINavigationItem *navItem = self.navigationItem;
        navItem.hidesBackButton = YES;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        
        [nc addObserver:self selector:@selector(notifyOfAvailableProducts:) name:kNotificationOfAvailableProducts object:nil];
        [nc addObserver:self selector:@selector(notifyOfProductPurchase:) name:kNotificationOfProductPurchase object:nil];
        [nc addObserver:self selector:@selector(notifyOfRestoredPurchase:) name:kNotificationOfRestoredPurchase object:nil];
        [nc addObserver:self selector:@selector(notifyOfFailedProductPurchase:) name:KNotificationOfFailedProductPurchase object:nil];
        [nc addObserver:self selector:@selector(notifyOfFailedReceiptValidation:) name:kNotificationOfFailedReceiptValidation object:nil];
        [nc addObserver:self selector:@selector(notifyOfSubscriptionExpiry:) name:kNotificationOfSubscriptionExpiry object:nil];
        [nc addObserver:self selector:@selector(notifyOfValidReceipt:) name:kNotificationOfValidReceipt object:nil];
    }
    return self;
}
-(void)notifyOfValidReceipt:(NSNotification *)notification{
    NSLog(@"receipt was valid");
    NSLog(@"userInfo: %@", notification);
    NSDictionary *userinfo = [notification userInfo];
    NSArray *array = [userinfo objectForKey:kAvailableProductKey];
    NSNotification *note = [array objectAtIndex:0];
    NSString * productToUnlock = [note object];
    [self unlockFeature:productToUnlock];
}
-(void)notifyOfProductPurchase:(NSNotification *)notification{
    NSLog(@"Product purchased");
    NSLog(@"userInfo: %@", notification);
    NSDictionary *userinfo = [notification userInfo];
    NSArray *array = [userinfo objectForKey:kAvailableProductKey];
    NSNotification *note = [array objectAtIndex:0];
    NSString *productToUnlock = [note object];
    [self unlockFeature:productToUnlock];
}
-(void)notifyOfRestoredPurchase:(NSNotification *)notification{
    NSLog(@"Purchases restored");
    NSLog(@"userInfo: %@", notification);
    NSDictionary *userinfo = [notification userInfo];
    NSArray *array = [userinfo objectForKey:kAvailableProductKey];
    NSNotification *note = [array objectAtIndex:0];
    NSString *productToUnlock = [note object];
    [self unlockFeature:productToUnlock];
}
-(void)notifyOfFailedProductPurchase:(NSNotification *)notification{
    NSLog(@"Purchase failed");
    NSLog(@"userInfo: %@", notification);
    NSDictionary *userinfo = [notification userInfo];
    NSArray *array = [userinfo objectForKey:kAvailableProductKey];
    NSNotification *note = [array objectAtIndex:0];
    self.productToLock = [note object];
    [self lockFeature];
}
-(void)notifyOfFailedReceiptValidation:(NSNotification *)notification{
    NSLog(@"Receipt validation failed");
    NSLog(@"userInfo: %@", notification);
    NSDictionary *userinfo = [notification userInfo];
    NSArray *array = [userinfo objectForKey:kAvailableProductKey];
    NSNotification *note = [array objectAtIndex:0];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Bad receipt!" message:@"There is something wrong with your subscription.  This may be due to failing to renew the subscription.  If not, you can restore prior purchases by touching on 'Restore Purchases.'" delegate:self cancelButtonTitle:@"" otherButtonTitles:nil];
        [alert addButtonWithTitle:@"Continue"];
        [alert show];
    });
    self.productToLock = [note object];
    [self lockFeature];
}

-(void)notifyOfSubscriptionExpiry:(NSNotification *)notification{
    NSLog(@"Subscription expired");
    NSLog(@"userInfo: %@", notification);
    NSDictionary *userinfo = [notification userInfo];
    NSArray *array = [userinfo objectForKey:kAvailableProductKey];
    NSNotification *note = [array objectAtIndex:0];
  //  NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
  //  dict = [note object];
  //  NSString *subscription = [note object];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
/*
    dispatch_async(dispatch_get_main_queue(), ^{
    if(![subscription isEqualToString:@"SKOrigBundleRef"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"An auto-renewing subscription has expired" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        [alert addButtonWithTitle:@"Continue"];
        [alert show];
        }
    });
    */
   // _productTitle.text = @"Expired!";
    self.productToLock = [note object];
    [self lockFeature];
}
-(void)notifyOfAvailableProducts:(NSNotification *)notification{
    NSLog(@"userInfo: %@", notification);
    NSDictionary *userinfo = [notification userInfo];
    NSArray *array = [userinfo objectForKey:kAvailableProductKey];
    NSNotification *note = [array objectAtIndex:0];
    self.products = [note object];
    NSMutableArray *productArray = [[NSMutableArray alloc]init];
    SKProduct *product;
    for(product in self.products){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:product.productIdentifier forKey:@"product_productIdentifier"];
        [dict setObject:product.localizedTitle forKey:@"product_localizedTitle"];
        [dict setObject:product.localizedDescription forKey:@"product_localizedDescription"];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:product.priceLocale];
        NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];
        [dict setObject:formattedPrice forKey:@"product_localizedPrice"];
        // [dict setObject:product.priceLocale forKey:@"product_price_locale"];
        [productArray addObject:dict];
    }
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    [storage setObject:productArray forKey:kProductsArrayKey];
    [storage synchronize];
    // [self displayAvailableProducts:self.products];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    // _buyButton.enabled = NO;
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    NSMutableArray *productArray = [[NSMutableArray alloc]init];
    productArray = [storage objectForKey:kProductsArrayKey];
    [self displayAvailableProducts:productArray];
    
    
    // Do any additional setup after loading the view.
}
-(void)displayAvailableProducts:(NSMutableArray *)availableProducts{
    NSLog(@"available products %@", availableProducts);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Purchase Products" message:@"Which product do you want to purchase or restore?" preferredStyle:UIAlertControllerStyleAlert];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    for (dict in availableProducts) {
        NSString *productIdentifier = [dict objectForKey:@"product_productIdentifier"];
        NSString *productLocalizedTitle = [dict objectForKey:@"product_localizedTitle"];
        NSString *productLocalizedDescription = [dict objectForKey:@"product_localizedDescription"];
        NSString *productLocalizedPrice = [dict objectForKey:@"product_localizedPrice"];
        //  NSDecimalNumber *productPrice = [dict objectForKey:@"product_price"];
        NSLog(@"Found product: %@ – Product", productLocalizedTitle);
        if (availableProducts.count != 0)
        {
            if([productIdentifier isEqualToString:kInAppPurchaseUnlimitedEmailsKey]){
                UIAlertAction *buyUnlimitedEmails = [self alertTheUser:@"Unlimited Emails" :kInAppPurchaseUnlimitedEmailsKey :productLocalizedTitle :productLocalizedDescription :productLocalizedPrice];
                [alert addAction:buyUnlimitedEmails];
            }else if ([productIdentifier isEqualToString:kInAppPurchaseProfessionalOneYearKey]){
                UIAlertAction *buyOneYearProfessional = [self alertTheUser:@"Professional Version (One Year)" :kInAppPurchaseProfessionalOneYearKey :productLocalizedTitle :productLocalizedDescription :productLocalizedPrice];
                [alert addAction:buyOneYearProfessional];
            }else if ([productIdentifier isEqualToString:kInAppPurchaseProfessionalOneWeekKey]){
                UIAlertAction *buyOneWeekProfessional = [self alertTheUser:@"Professional Version (One Week" :kInAppPurchaseProfessionalOneWeekKey :productLocalizedTitle :productLocalizedDescription :productLocalizedPrice];
                [alert addAction:buyOneWeekProfessional];
            }
            else{
                if([productIdentifier isEqualToString:kInAppPurchaseSpeechRecognitionUnlockedKey]){
                    UIAlertAction *buySpeechRecognition = [self alertTheUser:@"Unlimited Speech Recognition" :kInAppPurchaseSpeechRecognitionUnlockedKey :productLocalizedTitle :productLocalizedDescription :productLocalizedPrice];
                    [alert addAction:buySpeechRecognition];
                }else{
                    if([productIdentifier isEqualToString:kInAppPurchaseEmails7DayTrialKey]){
                        UIAlertAction *buyemails7daytrial =  [self alertTheUser:@"One Week of Emals" :kInAppPurchaseEmails7DayTrialKey :productLocalizedTitle :productLocalizedDescription :productLocalizedPrice];
                        [alert addAction:buyemails7daytrial];
                    }else{
                    if([productIdentifier isEqualToString:kInAppPurchaseBasicFunctionsOneWeekKey]){
                        UIAlertAction *buybasicFunctionOneWeek = [self alertTheUser:@"One Week of Backup/Restore" :kInAppPurchaseBasicFunctionsOneWeekKey  :productLocalizedTitle :productLocalizedDescription :productLocalizedPrice];
                        [alert addAction:buybasicFunctionOneWeek];
                    }else if ([productIdentifier isEqualToString:kInAppPurchaseSpeechRecognition7DayTrialKey]){
                        UIAlertAction *buyspeechRecognition7DayTrial = [self alertTheUser:@"One Week of Speech Recognition" :kInAppPurchaseSpeechRecognition7DayTrialKey :productLocalizedTitle :productLocalizedDescription :productLocalizedPrice];
                        [alert addAction:buyspeechRecognition7DayTrial];
                        }
                    }
                }
            }
        }
    };
    [self presentViewController:alert animated:YES completion:nil];
}
-(UIAlertAction *)alertTheUser:(NSString *)actionName :(NSString *)productIdentifier :(NSString *)productTitle :(NSString *)productDescription :(NSString *)productPrice{
    UIAlertAction *action = [UIAlertAction actionWithTitle:actionName style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
    _productTitle.text = productTitle;
    _productDescription.text = productDescription;
    _price.text = productPrice;
    self.productIdentifier = productIdentifier;
    }];
    return action;
}
-(NSString *)formatPrice:(NSDecimalNumber *)price{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    //   [numberFormatter setLocale:product.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:price];
    return formattedString;
}
-(IBAction)restoreProduct:(id)sender{
     [[MKStoreKit sharedKit]restorePurchases];
    
   // [[MKStoreKit sharedKit]refreshAppStoreReceipt];
}
-(IBAction)buyProduct:(id)sender{
    
    [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:self.productIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)unlockFeature:(NSString *)productToUnlock
{
    if([productToUnlock isEqual:kInAppPurchaseUnlimitedEmailsKey]){
        [self informTheUser:productToUnlock :kunlimitedEmailsUnlockedKey :kunlimitedEmailsUnlockedKey];
    }else if ([productToUnlock isEqual:kInAppPurchaseProfessionalOneYearKey]){
        [self informTheUser:productToUnlock :kProfessionalOneYearUnlockedKey :kProfessionalOneYearUnlockedKey];
    }else if ([productToUnlock isEqual:kInAppPurchaseProfessionalOneWeekKey]){
        [self informTheUser:productToUnlock :kProfessionalOneWeekUnlockedKey :kProfessionalOneWeekUnlockedKey];
    }/*
    else{
        if([productToUnlock isEqual:kInAppPurchaseSpeechRecognitionUnlockedKey]){
            [self informTheUser:productToUnlock :kInAppPurchaseSpeechRecognitionUnlockedKey :kspeechRecognitionUnlockedKey];
        }else{
            if([productToUnlock isEqual:kInAppPurchaseEmails7DayTrialKey]){
                [self informTheUser:productToUnlock :kemails7DayTrialUnlockedKey :kemails7DayTrialUnlockedKey];
            }
            if([productToUnlock isEqual:kInAppPurchaseSpeechRecognition7DayTrialKey]){
                [self informTheUser:productToUnlock :kspeechRecognition7DayTrialUnlockedKey :kspeechRecognition7DayTrialUnlockedKey];
            }else if ([productToUnlock isEqual:kInAppPurchaseBasicFunctionsOneWeekKey]){
                [self informTheUser:productToUnlock :kBasicFunctionsOneWeekUnlockedKey :kBasicFunctionsOneWeekUnlockedKey];
            }else if ([productToUnlock isEqualToString:kInAppPurchaseUnlimitedBasicFunctionsKey]){
                [self informTheUser:productToUnlock :kUnlimitedBasicFunctionsUnlockedKey :kUnlimitedBasicFunctionsUnlockedKey];
            }
            else{
                self.productToUnlock = kInAppPurchaseUnknownProductKey;
            };
        }
    }
    */
}
-(void)informTheUser:(NSString *)productToUnlock :(NSString *)lockKey :(NSString *)message{
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    BOOL itsUnlocked = [storage boolForKey:lockKey];
    if(itsUnlocked == NO){
        [storage setBool:YES forKey:lockKey];
        [storage synchronize];
        dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:message message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
                        alert.tag = kProductPurchasedAlertViewTag;
                        [alert show];
                    });
    }
}
-(void)informTheUserOfLocked:(NSString *)productToLock :(NSString *)lockKey :(NSString *)message{
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    BOOL itsUnlocked = [storage boolForKey:lockKey];
    if(itsUnlocked == YES){
        [storage setBool:NO forKey:lockKey];
        [storage synchronize];
        dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:message message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
                alert.tag = kProductPurchasedAlertViewTag;
                [alert show];
            });
        }
    }
-(void)lockFeature{
    NSLog(@"relocking feature");
    if([self.productToLock isEqual:kInAppPurchaseUnlimitedEmailsKey]){
        [self informTheUserOfLocked:self.productToLock :kunlimitedEmailsUnlockedKey :kUnlimitedEmailsLockedKey];
    }else if ([self.productToLock isEqual:kInAppPurchaseProfessionalOneYearKey]){
        [self informTheUserOfLocked:self.productToLock :kProfessionalOneYearUnlockedKey :kProfessionalOneYearLockedKey];
    } else if ([self.productToLock isEqual:kInAppPurchaseProfessionalOneWeekKey]){
        [self informTheUserOfLocked:self.productToLock :kProfessionalOneWeekUnlockedKey :kProfessionalOneWeekLockedKey];
        }
        /*
    else{
        if([self.productToLock isEqual:kInAppPurchaseSpeechRecognitionUnlockedKey]){
            NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
            [self informTheUserOfLocked:self.productToLock :kspeechRecognitionUnlockedKey :kspeechRecognitionLockedKey];
            [storage setBool:NO forKey:kspeechRecognitionUnlockedKey];
            NSInteger numberOfSpeechRecognitionRequests = 0;
            [storage setInteger:numberOfSpeechRecognitionRequests forKey:kNumberOfSpeechRecognitonRequests];
            [storage synchronize];
        }
        else{
            if([self.productToLock isEqual:kInAppPurchaseEmails7DayTrialKey]){
                [self informTheUserOfLocked: self.productToLock :kInAppPurchaseEmails7DayTrialKey :kemails7DayTrialLockedKey];
            }else if ([self.productToLock isEqual:kInAppPurchaseBasicFunctionsOneWeekKey]){
                [self informTheUserOfLocked:self.productToLock :kInAppPurchaseBasicFunctionsOneWeekKey :kBasicFunctionsOneWeekLockedKey];
            }else if ([self.productToLock isEqual:kInAppPurchaseUnlimitedBasicFunctionsKey]){
            [self informTheUserOfLocked:self.productToLock :kInAppPurchaseUnlimitedBasicFunctionsKey :kUnlimitedBasicFunctionsLockedKey];
            }
        }
    }
    */
}

- (IBAction)finished:(id)sender {
    // [self  unlockFeature];
    NSLog(@"initiating unwind from purchase controller to initial controller");
    [self performSegueWithIdentifier:kSegueIdentifierStoreKitToTableView sender:self];
}
-(void)finishedIt{
    [self performSegueWithIdentifier:kSegueIdentifierStoreKitToTableView sender:self];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
