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
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    _buyButton.enabled = NO;
    if(!self.productDict){
        self.productDict = [[NSMutableDictionary alloc]init];
    }
    
    [[MKStoreKit sharedKit] startProductRequest];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductsAvailableNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Products available: %@", [[MKStoreKit sharedKit] availableProducts]);
                                                      self.products = [[MKStoreKit sharedKit] availableProducts];
                                                      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Purchase Products" message:@"Which product do you want to purchase or restore?" preferredStyle:UIAlertControllerStyleAlert];
                                                      for (SKProduct * skProduct in self.products) {
                                                          NSLog(@"Found product: %@ – Product: %@ – Price: %0.2f", skProduct.productIdentifier, skProduct.localizedTitle, skProduct.price.floatValue);
                                                          if (self.products.count != 0)
                                                          {
                                                              NSString *productIdentifier = skProduct.productIdentifier;
                                                              if([productIdentifier isEqualToString:kInAppPurchaseUnlimitedEmailsKey]){
                                                                  UIAlertAction* buyUnlimitedEmails = [UIAlertAction actionWithTitle:@"Unlimited Emails" style:UIAlertActionStyleDefault
                                                                                                                             handler:^(UIAlertAction * action) {
                                                                                                                                 _buyButton.enabled = YES;
                                                                                                                                 _productTitle.text = skProduct.localizedTitle;
                                                                                                                                 NSLog(@"PurchaseViewController(productsRequestdidReceiveResponse) localized title: %@", _productTitle.text);
                                                                                                                                 _productDescription.text = skProduct.localizedDescription;
                                                                                                                                 self.payment = [SKPayment paymentWithProduct:skProduct];
                                                                                                                                 NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
                                                                                                                                 if(!self.productDict){
                                                                                                                                     self.productDict = [storage objectForKey:@"productDict"];
                                                                                                                                 }
                                                                                                                                 [self.productDict setObject:skProduct.productIdentifier forKey:kInAppPurchaseUnlimitedEmailsKey];
                                                                                                                                 [storage setObject:self.productDict forKey:@"productDict"];
                                                                                                                                 [storage synchronize];
                                                                                                                             }];
                                                                  [alert addAction:buyUnlimitedEmails];
                                                              }else{
                                                                  if([productIdentifier isEqualToString:kInAppPurchaseSpeechRecognitionUnlockedKey]){
                                                                      UIAlertAction* buySpeechRecognition = [UIAlertAction actionWithTitle:@"Speech Recognition" style:UIAlertActionStyleDefault
                                                                                                                                   handler:^(UIAlertAction * action) {
                                                                                                                                       _buyButton.enabled = YES;
                                                                                                                                       _productTitle.text = skProduct.localizedTitle;
                                                                                                                                       NSLog(@"PurchaseViewController(productsRequestdidReceiveResponse) localized title: %@", _productTitle.text);
                                                                                                                                       _productDescription.text = skProduct.localizedDescription;
                                                                                                                                       self.payment = [SKPayment paymentWithProduct:skProduct];
                                                                                                                                       NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
                                                                                                                                       if(!self.productDict){
                                                                                                                                           self.productDict = [storage objectForKey:@"productDict"];
                                                                                                                                       }
                                                                                                                                       [self.productDict setObject:skProduct.productIdentifier forKey:kInAppPurchaseSpeechRecognitionUnlockedKey];
                                                                                                                                       [storage setObject:self.productDict forKey:@"productDict"];
                                                                                                                                       [storage synchronize];
                                                                                                                                   }];
                                                                      
                                                                      [alert addAction:buySpeechRecognition];
                                                                  }
                                                              }
                                                          }
                                                      }
                                                      [self presentViewController:alert animated:YES completion:nil];
                                                  }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchasedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Purchased/Subscribed to product with id: %@", [note object]);
                                                      self.productToUnlock = [note object];
                                                      [self unlockFeature];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoredPurchasesNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Restored Purchases");
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoringPurchasesFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Failed restoring purchases with error: %@", [note object]);
                                                  }];
    
    
    // Do any additional setup after loading the view.
}
-(IBAction)restoreProduct:(id)sender{
    
}
-(IBAction)buyProduct:(id)sender{
    [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:self.payment.productIdentifier];
    
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
