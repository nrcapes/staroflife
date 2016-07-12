//
//  PurchaseViewController.m
//  EMS Timers Professional
//
//  Created by Nelson Capes on 3/27/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import "PurchaseViewController.h"
#import "iapstore.h"
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
    
    
    
    //**************testing ONLY!!!!
    
   // [self  unlockFeature];
     
    
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated{
    [self getProductInfo];
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finished:(id)sender {
    NSLog(@"initiating unwind from purchase controller to initial controller");
    [self performSegueWithIdentifier:@"unwindPurchaseToTableView" sender:self];
}

- (IBAction)restoreCompletedTransactions:(id)sender
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
- (IBAction)buyProduct:(id)sender {
    
    [[SKPaymentQueue defaultQueue] addPayment:self.payment];
}
-(void)getProductInfo
{
    //self.homeViewController = viewController;
    
    NSArray *productIDArray = [[NSArray alloc]initWithObjects:@"com.nelsoncapes.emstimerspro.emailunlock", nil];
    
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
    
    
    //if(!self.transactionDates){
    //    self.transactionDates = [[NSMutableDictionary alloc]initWithCapacity:10];
    //}
    if (self.products.count != 0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Purchase Products" message:@"Which product do you want to purchase or restore?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* centralAdmin = [UIAlertAction actionWithTitle:@"Unlimited emails" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 
                                                                 _product = [self.products objectAtIndex:0];
                                                                 _buyButton.enabled = YES;
                                                                 _productTitle.text = _product.localizedTitle;
                                                                 NSLog(@"PurchaseViewController(productsRequestdidReceiveResponse) localized title: %@", _productTitle.text);
                                                                 
                                        
                                                                 
                                                                 _productDescription.text = _product.localizedDescription;
                                                                 
                                                                 SKProduct *product = _product;
                                                                 self.payment = [SKPayment paymentWithProduct:product];
                                                                
                                                            
                                                                 
                                                                 if(!self.productDict){
                                                                     self.productDict = [[NSMutableDictionary alloc]init];
                                                                 }
                                                                 
                                                                 [self.productDict setValue:self.payment.productIdentifier  forKey:@"com.nelsoncapes.emstimerspro.emailunlock"];
                                                                 NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
                                                                 [storage setObject:self.productDict forKey:@"productDict"];
                                                                 [storage synchronize];
                                                                

                                                                 
                                                             }];
        /*
        UIAlertAction* iCloud = [UIAlertAction actionWithTitle:@"iCloud support" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           if(self.products.count > 1){
                                                           _product = [self.products objectAtIndex:1];
                                                           _buyButton.enabled = YES;
                                                           _productTitle.text = _product.localizedTitle;
                                                            NSLog(@"PurchaseViewController(productsRequestdidReceiveResponse) localized title: %@", _productTitle.text);
                                                               
                                                               
                                                           _productDescription.text = _product.localizedDescription;
                                                               
                                                               SKProduct *product = _product;
                                                               self.payment = [SKPayment paymentWithProduct:product];
                                                        
                                                               
                                                               //self.transactionDate = [NSDate date];
                                                               if(!self.productDict){
                                                                   self.productDict = [[NSMutableDictionary alloc]init];
                                                               }
                                                               [self.productDict setValue:self.payment.productIdentifier  forKey:@"iCloudSupport"];
                                                               NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
                                                               [storage setObject:self.productDict forKey:@"productDict"];
                                                               [storage synchronize];
                                                           }
                                                           else{
                                                               _productDescription.text =@"This upgrade is not available";
                                                           }
                                                       }];
        */
        
        [alert addAction:centralAdmin];
        //[alert addAction:iCloud];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        _productTitle.text = @"Product not found";
        self.products = response.invalidProductIdentifiers;
        
        for (SKProduct *product in self.products)
        {
            NSLog(@"Product not found: %@", product);
        };
    }
    
    
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
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:_transaction];
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
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    self.productDict = [storage objectForKey:@"productDict"];
    NSString *productId1 = [self.productDict objectForKey:@"com.nelsoncapes.emstimerspro.emailunlock"];
    SKPayment *payment = self.transaction.payment;

    NSString *productId2 = payment.productIdentifier;
    
    if([productId1 isEqual:productId2]){
        NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
        [storage setBool:YES forKey:@"email_unlocked"];
        [storage setBool:NO forKey:@"maximumEmailsExceeded"];
        [storage synchronize];
    }else{
        // here would be support for other in app purchases.
        }
        
    
    /*
    if(centAdmin == YES){
    self.centralAdminUnlocked = YES;
    }
    if (keyIcloud == YES)
    {
        self.iCloudSupportUnlocked = YES;
    }
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSArray *keys = [[NSArray alloc]initWithObjects:@"central_admin_enabled",@"iCloud_support_enabled",  nil];
    [array addObject:[NSNumber numberWithBool:self.centralAdminUnlocked]];
    [array addObject:[NSNumber numberWithBool:self.iCloudSupportUnlocked]];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjects:array forKeys:keys];
    iapstore *singleton = [iapstore getInstance];
    [singleton saveData:dict];
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
