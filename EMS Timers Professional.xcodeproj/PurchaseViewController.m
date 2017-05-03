//
//  PurchaseViewController.m
//  TimeChime v. 11.3 3/30/17
//
//  Created by Nelson Capes on 3/30/17.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import "PurchaseViewController.h"

#import "constants.h"
@interface PurchaseViewController ()
//@property (strong, nonatomic) NRCTableViewController *homeViewController;
@end

@implementation PurchaseViewController

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
    _buyButton.enabled = NO;
    if(!self.productDict){
        self.productDict = [[NSMutableDictionary alloc]init];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getProductInfo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finished:(id)sender {
   // [self  unlockFeature];
    NSLog(@"initiating unwind from purchase controller to initial controller");
    [self performSegueWithIdentifier:kSegueIdentifierToTableView sender:self];
}

- (IBAction)restoreCompletedTransactions:(id)sender
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
- (IBAction)buyProduct:(id)sender {
    //[self showTransactionAsInProgress:_transaction];
    
        [[SKPaymentQueue defaultQueue] addPayment:self.payment];
     //   [[SKPaymentQueue defaultQueue] addPayment:self.payment2];
    
    }

-(void)getProductInfo
{
    //self.homeViewController = viewController;
    
    NSArray *productIDArray = [[NSArray alloc]initWithObjects:kInAppPurchaseUnlimitedEmailsKey,kInAppPurchaseSpeechRecognitionUnlockedKey , nil];
    
    if ([SKPaymentQueue canMakePayments])
    {
        self.requestSet = [NSSet setWithArray:productIDArray];
        SKProductsRequest *request = [[SKProductsRequest alloc]
                                      initWithProductIdentifiers:[NSSet setWithArray:productIDArray]];
        request.delegate = self;
        self.request = request;
        [request start];
    }
    else
        _productDescription.text =
        @"Please enable In App Purchase in Settings";
}

#pragma mark -
#pragma mark SKProductsRequestDelegate

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    self.products = response.products;
    NSLog(@"Loaded products...");
    NSArray * skProducts = response.products;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Purchase Products" message:@"Which product do you want to purchase or restore?" preferredStyle:UIAlertControllerStyleAlert];
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ – Product: %@ – Price: %0.2f", skProduct.productIdentifier, skProduct.localizedTitle, skProduct.price.floatValue);
        if (self.products.count != 0)
        {
            NSString *productIdentifier = skProduct.productIdentifier;
            if([productIdentifier isEqualToString:kInAppPurchaseUnlimitedEmailsKey]){
                UIAlertAction* buyAlertViewer = [UIAlertAction actionWithTitle:@"Unlimited Emails" style:UIAlertActionStyleDefault
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
                [alert addAction:buyAlertViewer];
            }else{
                if([productIdentifier isEqualToString:kInAppPurchaseSpeechRecognitionUnlockedKey]){
                    UIAlertAction* buyAlertEditor = [UIAlertAction actionWithTitle:@"Speech Recognition" style:UIAlertActionStyleDefault
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
                    
                    [alert addAction:buyAlertEditor];
                }
            }
        }
    }
    [self presentViewController:alert animated:YES completion:nil];
}

-(IBAction)removeAllPayments:(id)sender{
    NSLog(@"Purchase controller: removing all transactions");
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    SKPaymentQueue *currentQueue = [SKPaymentQueue defaultQueue];
    [currentQueue.transactions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        [currentQueue finishTransaction:(SKPaymentTransaction *)obj];
     }];
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
#pragma mark -
#pragma mark SKPaymentTransactionObserver

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    
        NSLog(@"Purchase Controller - paymentQueue");
    
    for (_transaction in transactions)
    {
        NSLog(@"Payment:%@", _transaction.payment.productIdentifier);
        NSLog(@"Transaction state:%ld", (long)_transaction.transactionState);
        switch (_transaction.transactionState) {
                case SKPaymentTransactionStatePurchasing:{
                    NSLog(@"Payment Queue: transactionStatePurchasing");
                break;
            }
                case SKPaymentTransactionStatePurchased:{
                    NSLog(@"Payment Queue: transactionStatePurchased");
                self.transaction = _transaction;
                [self unlockFeature];
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:_transaction];
                }
                break;
                
            case SKPaymentTransactionStateFailed:{
                NSLog(@"Payment Queue: transactionStateFailed");
                
                [self failedTransaction:_transaction];
                //[[SKPaymentQueue defaultQueue]
                // finishTransaction:_transaction];
            }
                break;
            case SKPaymentTransactionStateRestored:{
                NSLog(@"Payment Queue: Purchase restored: %@", _transaction.payment.productIdentifier);
                    self.productTitle.text = @"Purchases Restored";
                self.transaction = _transaction;
                    [self unlockFeature];
                if(_transaction.transactionState == SKPaymentTransactionStatePurchasing){
                    [[SKPaymentQueue defaultQueue]
                     finishTransaction:_transaction];
                }
            }
            case SKPaymentTransactionStateDeferred:{
                NSLog(@"Payment Queue: transactionStateDeferred");
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:_transaction];}
                break;
            
        
            default:
                break;
            }
        }
    }
-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    // Log the error
    NSLog(@"%@", [transaction.error localizedDescription]);
    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        
    
        [[SKPaymentQueue defaultQueue]
         finishTransaction:_transaction];
        
                       
    } else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userCancel" object:self userInfo:nil];
    }
}
-(void)unlockFeature
{
    /*
    _buyButton.enabled = NO;
    //[_buyButton setTitle:@"Purchased"
    //            forState:UIControlStateDisabled];
    
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    BOOL centAdmin = [storage boolForKey:@"central_admin_requested"];
    BOOL keyIcloud = [storage boolForKey:@"iCloud_support_requested"];
    */
    
    SKPayment *payment = self.transaction.payment;
    NSString *productIdPayment = payment.productIdentifier;
    // ************** testing ***********
   // productId2 = kInAppPurchaseAlertViewerKey;
    
    if([productIdPayment isEqual:kInAppPurchaseUnlimitedEmailsKey]){
        NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
        [storage setBool:YES forKey:kunlimitedEmailsUnlockedKey];
        [storage synchronize];
        self.productTitle.text = @"Purchase completed";
    }else{// alert editor includes alert viewer
        if([productIdPayment isEqual:kInAppPurchaseSpeechRecognitionUnlockedKey]){
            NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
            [storage setBool:YES forKey:kspeechRecognitionUnlockedKey];
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

-(void)showTransactionAsInProgress:transaction{
   _productTitle.text =@"Waiting for the App Store....";
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
