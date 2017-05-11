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
                UIAlertAction* buyUnlimitedEmails = [UIAlertAction actionWithTitle:@"Unlimited Emails" style:UIAlertActionStyleDefault
                                                                           handler:^(UIAlertAction * action) {
                                                                               
                                                                               NSLog(@"PurchaseViewController(productsRequestdidReceiveResponse) localized title: %@", _productTitle.text);
                                                                               _productTitle.text = productLocalizedTitle;
                                                                               //_price.text = productPrice;
                                                                               _productDescription.text = productLocalizedDescription;
                                                                               _price.text = productLocalizedPrice;
                                                                               self.productIdentifier = productIdentifier;
                                                                               // SKProduct *productToBuy = [[SKProduct alloc]init];
                                                                               
                                                                           }];
                [alert addAction:buyUnlimitedEmails];
            }else{
                if([productIdentifier isEqualToString:kInAppPurchaseSpeechRecognitionUnlockedKey]){
                    UIAlertAction* buySpeechRecognition = [UIAlertAction actionWithTitle:@"Speech Recognition" style:UIAlertActionStyleDefault
                                                                                 handler:^(UIAlertAction * action) {
                                                                                     NSLog(@"PurchaseViewController(productsRequestdidReceiveResponse) localized title: %@", _productTitle.text);
                                                                                     _productTitle.text = productLocalizedTitle;
                                                                                     //_price.text = productPrice;
                                                                                     _productDescription.text = productLocalizedDescription;
                                                                                     _price.text = productLocalizedPrice;
                                                                                     self.productIdentifier = productIdentifier;
                                                                                     //self.payment = [SKPayment paymentWithProduct:skProduct];
                                                                                     
                                                                                 }];
                    
                    [alert addAction:buySpeechRecognition];
                }else{
                    if([productIdentifier isEqualToString:kInAppPurchaseEmails7DayTrialKey]){
                        UIAlertAction* buyemails7daytrial = [UIAlertAction actionWithTitle:@"Send Emails (Trial)" style:UIAlertActionStyleDefault
                                                                                   handler:^(UIAlertAction * action) {
                                                                                       NSLog(@"PurchaseViewController(productsRequestdidReceiveResponse) localized title: %@", _productTitle.text);
                                                                                       _productTitle.text = productLocalizedTitle;
                                                                                       //_price.text = productPrice;
                                                                                       _productDescription.text = productLocalizedDescription;
                                                                                       _price.text = productLocalizedPrice;
                                                                                       self.productIdentifier = productIdentifier;
                                                                                       //self.payment = [SKPayment paymentWithProduct:skProduct];
                                                                                       
                                                                                   }];
                        
                        [alert addAction:buyemails7daytrial];
                    }
                }
            }
        }
    };
    [self presentViewController:alert animated:YES completion:nil];
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
    NSString* title = [[NSString alloc]init];
    if([productToUnlock isEqual:kInAppPurchaseUnlimitedEmailsKey]){
        NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
        BOOL itsUnlocked = [storage boolForKey:kunlimitedEmailsUnlockedKey];
        if(itsUnlocked == NO){
            [storage setBool:YES forKey:kunlimitedEmailsUnlockedKey];
            [storage synchronize];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Unlimited emails is unlocked." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
                alert.tag = kProductPurchasedAlertViewTag;
                [alert show];
                
            });
        }
    }else{
        if([productToUnlock isEqual:kInAppPurchaseSpeechRecognitionUnlockedKey]){
            NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
            BOOL itsUnlocked = [storage boolForKey:kspeechRecognitionUnlockedKey];
            if(itsUnlocked == NO){
                [storage setBool:YES forKey:kspeechRecognitionUnlockedKey];
                NSInteger numberOfSpeechRecognitionRequests = 0;
                [storage setInteger:numberOfSpeechRecognitionRequests forKey:kNumberOfSpeechRecognitonRequests];
                [storage synchronize];
                NSString *featureUnlocked = kspeechRecognitionUnlockedKey;
                title = featureUnlocked;
                title = [title stringByAppendingString:@" Unlocked"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Unlimited speech recognition is unlocked." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
                    alert.tag = kProductPurchasedAlertViewTag;
                    [alert show];
                });
            }
        }else{
            if([productToUnlock isEqual:kInAppPurchaseEmails7DayTrialKey]){
                NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
                BOOL itsUnlocked = [storage boolForKey:kemails7DayTrialUnlockedKey];
                if(itsUnlocked == NO){
                    
                    [storage setBool:YES forKey:kemails7DayTrialUnlockedKey];
                    [storage synchronize];
                    NSString *featureUnlocked = kemails7DayTrialUnlockedKey;
                    title = featureUnlocked;
                    title = [self.title stringByAppendingString:@" Unlocked"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"One week unlimited emails is unlocked." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
                        alert.tag = kProductPurchasedAlertViewTag;
                        [alert show];
                    });
                }
            }else{
                self.productToUnlock = kInAppPurchaseUnknownProductKey;
                /*
                 NSString *featureUnlocked = kInAppPurchaseUnknownProductKey;
                 title = featureUnlocked;
                 title = [title stringByAppendingString:@" Unlocked"];
                 dispatch_async(dispatch_get_main_queue(), ^{
                 if(![title isEqual:kInAppPurchaseUnknownProductKey]){
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
                 alert.tag = kProductPurchasedAlertViewTag;
                 [alert show];
                 }
                 });
                 */
            };
        }}
}
-(void)lockFeature{
    NSLog(@"relocking feature");
    if([self.productToLock isEqual:kInAppPurchaseUnlimitedEmailsKey]){
        NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
        BOOL itsUnlocked = [storage boolForKey:kunlimitedEmailsUnlockedKey];
        if(itsUnlocked == YES){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Unlimited emails is locked." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
                alert.tag = kProductPurchasedAlertViewTag;
                [alert show];
            });}
        [storage setBool:NO forKey:kunlimitedEmailsUnlockedKey];
        [storage synchronize];
    }else{
        if([self.productToLock isEqual:kInAppPurchaseSpeechRecognitionUnlockedKey]){
            NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
            BOOL itsUnlocked = [storage boolForKey:kspeechRecognitionUnlockedKey];
            if(itsUnlocked == YES){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Speech recognition is locked." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
                    alert.tag = kProductPurchasedAlertViewTag;
                    [alert show];
                });
                [storage setBool:NO forKey:kspeechRecognitionUnlockedKey];
                NSInteger numberOfSpeechRecognitionRequests = 0;
                [storage setInteger:numberOfSpeechRecognitionRequests forKey:kNumberOfSpeechRecognitonRequests];
                [storage synchronize];
            }
        }else{
            if([self.productToLock isEqual:kInAppPurchaseEmails7DayTrialKey]){
                NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
                BOOL itsUnlocked = [storage boolForKey:kemails7DayTrialUnlockedKey];
                if(itsUnlocked == YES){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Email 7 day trial is locked." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
                        alert.tag = kProductPurchasedAlertViewTag;
                        [alert show];
                    });
                    [storage setBool:NO forKey:kemails7DayTrialUnlockedKey];
                    [storage synchronize];
                    
                }
            }
        }
    }
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
