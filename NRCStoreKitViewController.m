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

@implementation NRCStoreKitViewController
-(instancetype)init{
    self = [super init];
    if(self){
        UINavigationItem *navItem = self.navigationItem;
        navItem.hidesBackButton = YES;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        
        [nc addObserver:self selector:@selector(notifyOfAvailableProducts:) name:kNotificationOfAvailableProducts object:nil];
        [nc addObserver:self selector:@selector(notifyOfProductPurchase:) name:kNotificationOfProductPurchase object:nil];
    }
    return self;
}
/*
-(void)startMHStoreKit{
  [[MKStoreKit sharedKit] startProductRequest];  
}
 */
-(void)notifyOfProductPurchase:(NSNotification *)notification{
    NSLog(@"userInfo: %@", notification);
    NSDictionary *userinfo = [notification userInfo];
    NSArray *array = [userinfo objectForKey:kAvailableProductKey];
    NSNotification *not = [array objectAtIndex:0];
    _productTitle.text = @"Product Purchased";
    self.productToUnlock = [not object];
    [self unlockFeature];
    
}
-(void)notifyOfAvailableProducts:(NSNotification *)notification{
    NSLog(@"userInfo: %@", notification);
    NSDictionary *userinfo = [notification userInfo];
    NSArray *array = [userinfo objectForKey:kAvailableProductKey];
    NSNotification *not = [array objectAtIndex:0];
    self.products = [not object];
    NSMutableArray *productArray = [[NSMutableArray alloc]init];
    SKProduct *product;
    for(product in self.products){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:product.productIdentifier forKey:@"product_productIdentifier"];
        [dict setObject:product.localizedTitle forKey:@"product_localizedTitle"];
        [dict setObject:product.localizedDescription forKey:@"product_localizedDescription"];
        [dict setObject:product.price forKey:@"product_price"];
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
                                                                                     self.productIdentifier = productIdentifier;
                                                                                     //self.payment = [SKPayment paymentWithProduct:skProduct];
                                                                                     
                                                                                 }];
                    
                    [alert addAction:buySpeechRecognition];
                }else{
                    NSLog(@"invalid product identifier");
                }
            }
        }
    }
    [self presentViewController:alert animated:YES completion:nil];
};


-(NSString *)formatPrice:(NSDecimalNumber *)price{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
 //   [numberFormatter setLocale:product.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:price];
    return formattedString;
}
-(IBAction)restoreProduct:(id)sender{
    
}
-(IBAction)buyProduct:(id)sender{

    [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:self.productIdentifier];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)unlockFeature
{
    
    /*
    SKPayment *payment = self.transaction.payment;
    NSString *productIdPayment = payment.productIdentifier;
     */
    // ************** testing ***********
    // productId2 = kInAppPurchaseAlertViewerKey;
    
    if([self.productToUnlock isEqual:kInAppPurchaseUnlimitedEmailsKey]){
        NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
        [storage setBool:YES forKey:kunlimitedEmailsUnlockedKey];
        [storage synchronize];
        self.productTitle.text = @"Purchase completed";
    }else{// alert editor includes alert viewer
        if([self.productToUnlock isEqual:kInAppPurchaseSpeechRecognitionUnlockedKey]){
            NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
            [storage setBool:YES forKey:kspeechRecognitionUnlockedKey];
            NSInteger numberOfSpeechRecognitionRequests = 0;
            [storage setInteger:numberOfSpeechRecognitionRequests forKey:kNumberOfSpeechRecognitonRequests];
            [storage synchronize];
            self.productTitle.text = @"Purchase completed";
        }
    }
    
    /*
     ****** testing ********
     NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
     [storage setBool:YES forKey:kspeechRecognitionUnlockedKey];
     [storage synchronize];
     */
}
- (IBAction)finished:(id)sender {
    // [self  unlockFeature];
    NSLog(@"initiating unwind from purchase controller to initial controller");
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
