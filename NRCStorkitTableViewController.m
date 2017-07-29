//
//  NRCStorkitTableViewController.m
//  EMS Timers Professional
//
//  Created by Nelson Capes on 6/19/17.
//  Copyright © 2017 Nelson Capes. All rights reserved.
//

#import "NRCStorkitTableViewController.h"
#import "MKStoreKit.h"
#import <StoreKit/StoreKit.h>
#import "constants.h"
//#import "StorkitTableViewCell.h"
@interface NRCStorkitTableViewController ()

@end
static NSUInteger const kProductPurchasedAlertViewTag = 1;
@implementation NRCStorkitTableViewController
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
        [nc addObserver:self selector:@selector(notifyOfInAppPurchaseDisabled) name:kNotificationOfInAppPurchaseDisabled object:nil];
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
-(void)notifyOfInAppPurchaseDisabled{
// user has disabled in app purchase in Settings
/*
UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"You have disabled in app purchases in Settings"
                                  message:@"Enable it in Settings>General>Restrictions in order to purchase!"
                                  preferredStyle:UIAlertControllerStyleAlert];
UIAlertAction *action = [UIAlertAction actionWithTitle:@"Continue." style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
    
    }];
 [alert addAction:action];
 [self presentViewController:alert animated:YES completion:nil
     ];
     */
     dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"In app purchase is disabled. Enable it in Settings>General>Restrictions in order to purchase!" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
                        [alert show];
                    });
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
        // the App Store will provide the price for the locale of the purchaser's app store account,not the locale that the purchaser is in
        // at the time of purchase.
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
    
}
-(void)displayAvailableProducts:(NSMutableArray *)availableProducts{
// in: productArray of dictionaries
// out: UIAlertController with text and action for each auto-renewing subscription
/*
    NSLog(@"available products %@", availableProducts);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
  self.alertTitle = @"";
    
    for (dict in availableProducts){
    if(![[dict objectForKey:@"product_localizedTitle"] isEqual:@"Send Unlimited Emails"]){
        self.productIdentifier = [dict objectForKey:@"product_productIdentifier"];
        self.productLocalizedTitle = [dict objectForKey:@"product_localizedTitle"];
        self.productLocalizedDescription = [dict objectForKey:@"product_localizedDescription"];
        self.productLocalizedPrice = [dict objectForKey:@"product_localizedPrice"];
        self.alertTitle = [self.alertTitle stringByAppendingString:@"Product: "];
        self.alertTitle = [self.alertTitle stringByAppendingString:[dict objectForKey:@"product_localizedTitle"]];
        self.alertTitle = [self.alertTitle stringByAppendingString:@" Subscription length: "];
        _productSubscriptionLength = [self identiySubscriptionLength:[dict objectForKey:@"product_localizedTitle"]];
        self.alertTitle = [self.alertTitle stringByAppendingString:_productSubscriptionLength];
        self.alertTitle = [self.alertTitle stringByAppendingString:@". Price of subscription: "];
        self.alertTitle = [self.alertTitle stringByAppendingString:[dict objectForKey:@"product_localizedPrice"]];
        }else{
        self.alertTitle = [self.alertTitle stringByAppendingString:@"Product: "];
        self.alertTitle = [self.alertTitle stringByAppendingString:[dict objectForKey:@"product_localizedTitle"]];
        self.alertTitle = [self.alertTitle stringByAppendingString:@" Subscription length: Non-consumable"];
        self.alertTitle = [self.alertTitle stringByAppendingString:@". Price of subscription: "];
        self.alertTitle = [self.alertTitle stringByAppendingString:[dict objectForKey:@"product_localizedPrice"]];
        self.alertTitle = [self.alertTitle stringByAppendingString:@"\n\n"];
        self.alertTitle = [self.alertTitle stringByAppendingString:@"Subscriptions may be managed by the user and auto-renewal may be turned off by going to the user's Account Settings after purchase. Privacy policy is at: http://www.starpointsoftware.com/privacy-policy.html. Terms of Use at http://www.starpointsoftware.com/terms-of-use.html."];
        self.alertTitle = [self.alertTitle stringByAppendingString:@" Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where appropriate."];
    }
    }
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Information"
                                  message:self.alertTitle
                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Send Unlimited Emails" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self identifySelectedProduct:kInAppPurchaseUnlimitedEmailsKey];
        _productTitle.text = self.userSelectedProductLocalizedTitle;
        _productDescription.text = self.userSelectedProductLocalizedDescription;
        _price.text = self.userSelectedProductLocalizedPrice;
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Professional Version (One Week)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self identifySelectedProduct:kInAppPurchaseProfessionalOneWeekKey];
        _productTitle.text = self.userSelectedProductLocalizedTitle;
        _productDescription.text = self.userSelectedProductLocalizedDescription;
        _price.text = self.userSelectedProductLocalizedPrice;
    }];
    
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Professional Version (One Year)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self identifySelectedProduct:kInAppPurchaseProfessionalOneYearKey];
        _productTitle.text = self.userSelectedProductLocalizedTitle;
        _productDescription.text = self.userSelectedProductLocalizedDescription;
        _price.text = self.userSelectedProductLocalizedPrice;
    }];
    

    
    
    [alert addAction:action3];
    [alert addAction:action2];
    [alert addAction:action1];
    
    [self presentViewController:alert animated:YES completion:nil
     ];
*/
}
-(void)identifySelectedProduct:(NSString *)product{
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    NSMutableArray *productArray = [[NSMutableArray alloc]init];
    productArray = [storage objectForKey:kProductsArrayKey];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    for(dict in productArray){
    if([[dict objectForKey:@"product_productIdentifier"] isEqualToString:product]){
        self.userSelectedProductIdentifier = [dict objectForKey:@"product_productIdentifier"];
        self.userSelectedProductLocalizedTitle = [dict objectForKey:@"product_localizedTitle"];
        self.userSelectedProductLocalizedDescription = [dict objectForKey:@"product_localizedDescription"];
        self.userSelectedProductLocalizedPrice = [dict objectForKey:@"product_localizedPrice"];
        }
}

}
-(NSString *)formatPrice:(NSDecimalNumber *)price{
// in: product_locailizedPrice
// out: price as formatted string
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
-(void)buyProduct:(id)sender{
   
    [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:self.userSelectedProductIdentifier];
  
}
-(NSString *)identiySubscriptionLength:(NSString *)localizedTitle{
// in: product_localizedTitle
// out: string with length of subscription
    if([localizedTitle isEqualToString:@"Send Unlimited Emails"]){
    _productSubscriptionLength = @"No Limit";
    }else if ([localizedTitle isEqual:@"Professional (One Year)"]){
    _productSubscriptionLength = @"One Year";
    }else if ([localizedTitle isEqualToString:@"Professional Version (One Week)"]){
    _productSubscriptionLength =@"One Week";
    }
    return _productSubscriptionLength;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    NSString *product =@"";
    NSString *outputString = @"";
    if(indexPath.section == 0){
        product = kInAppPurchaseUnlimitedEmailsKey;
        [self identifySelectedProduct:product];
        outputString = self.userSelectedProductLocalizedTitle;
        outputString = [outputString stringByAppendingString:@" Price: "];
        outputString = [outputString stringByAppendingString:self.userSelectedProductLocalizedPrice];
        NSString *subscriptionLength = [self identiySubscriptionLength:self.userSelectedProductLocalizedTitle];
        outputString = [outputString stringByAppendingString:@" Length: "];
        outputString = [outputString stringByAppendingString:subscriptionLength];
        cell.textLabel.font=[UIFont fontWithName:@"Arial" size:14];
        cell.textLabel.adjustsFontSizeToFitWidth=YES;
        cell.backgroundColor = [UIColor colorWithRed:0.0f/255 green:125.0f/255 blue:150.0f/255 alpha:0.8f];
        cell.textLabel.text = outputString;
    }else if (indexPath.section == 1){
        product = kInAppPurchaseProfessionalOneYearKey;
        [self identifySelectedProduct:product];
        outputString = self.userSelectedProductLocalizedTitle;
        outputString = [outputString stringByAppendingString:@" Price: "];
        outputString = [outputString stringByAppendingString:self.userSelectedProductLocalizedPrice];
        NSString *subscriptionLength = [self identiySubscriptionLength:self.userSelectedProductLocalizedTitle];
        outputString = [outputString stringByAppendingString:@" Length: "];
        outputString = [outputString stringByAppendingString:subscriptionLength];
        cell.textLabel.font=[UIFont fontWithName:@"Arial" size:14];
        cell.textLabel.adjustsFontSizeToFitWidth=YES;
        cell.backgroundColor = [UIColor colorWithRed:0.0f/255 green:125.0f/255 blue:150.0f/255 alpha:0.8f];
        cell.textLabel.text = outputString;
    }else if (indexPath.section == 2){
        product = kInAppPurchaseProfessionalOneWeekKey;
        [self identifySelectedProduct:product];
        outputString = self.userSelectedProductLocalizedTitle;
        outputString = [outputString stringByAppendingString:@" Price: "];
        outputString = [outputString stringByAppendingString:self.userSelectedProductLocalizedPrice];
        NSString *subscriptionLength = [self identiySubscriptionLength:self.userSelectedProductLocalizedTitle];
        outputString = [outputString stringByAppendingString:@" Length: "];
        outputString = [outputString stringByAppendingString:subscriptionLength];
        cell.textLabel.font=[UIFont fontWithName:@"Arial" size:14];
        cell.textLabel.adjustsFontSizeToFitWidth=YES;
        cell.backgroundColor = [UIColor colorWithRed:0.0f/255 green:125.0f/255 blue:150.0f/255 alpha:0.8f];
        cell.textLabel.text = outputString;
    }else{
        
        //cell.textLabel.text = @"Description";
        outputString = @"";
        outputString = [outputString stringByAppendingString:@"Payment will be charged to iTunesAccount at confirmation of purchase. \nSubscription automatically renews unless auto-renew is turned off\n at least 24-hours before the end of the current period. \nAccount will be charged for renewal within 24-hours \nprior to the end of the current period. \n Renewal price is the same as the initial price.\nSubscriptions may be managed by the user and \nauto-renewal may be turned off\n by going to the user's Account Settings after purchase.\n Privacy policy is at:\n http://www.starpointsoftware.com/privacy-policy.html. \nTerms of Use at \n http://www.starpointsoftware.com/terms-of-use.html. \nAny unused portion of a free trial period, if offered, \nwill be forfeited \nwhen the user purchases a subscription to that publication."];
        // cell.textLabel.font=[UIFont fontWithName:@"Arial" size:16];
        //  cell.textLabel.adjustsFontSizeToFitWidth=YES;
        self.infoTextView = [[UITextView alloc]initWithFrame:CGRectMake(0.0, 0.0, 480.0, 200.0)];
        self.infoTextView.tag = 1000;
        self.infoTextView.font = [UIFont fontWithName:@"Arial" size:10];
       // infoTextView.backgroundColor = [UIColor colorWithRed:0.0f/255 green:125.0f/255 blue:150.0f/255 alpha:0.8f];
        self.infoTextView.scrollEnabled = NO;
        self.infoTextView.editable = NO;
        self.infoTextView.selectable = YES;
        self.infoTextView.dataDetectorTypes = UIDataDetectorTypeLink;
        self.infoTextView.text = outputString;
        
        cell.backgroundColor = [UIColor colorWithRed:0.0f/255 green:125.0f/255 blue:150.0f/255 alpha:0.8f];
        [cell.contentView addSubview:self.infoTextView];
    }
    return  cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 3) { //change 0 to whatever cell index you want taller
        return 200;
    }
    else {
        return 44;
    }   
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
    self.userSelectedProductIdentifier = kInAppPurchaseUnlimitedEmailsKey;
    }else if (indexPath.section == 1){
    self.userSelectedProductIdentifier = kInAppPurchaseProfessionalOneYearKey;
    }else if (indexPath.section == 2){
    self.userSelectedProductIdentifier = kInAppPurchaseProfessionalOneWeekKey;
    }
    [self buyProduct:self.userSelectedProductIdentifier];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
- (IBAction)finished:(id)sender {
    // [self  unlockFeature];
    NSLog(@"initiating unwind from purchase controller to initial controller");
    [self performSegueWithIdentifier:kSegueIdentifierStoreKitToTableView sender:self];
}

@end