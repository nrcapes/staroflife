//
//  NRCTableViewController.h
//  EMSTimers
//
//  Created by Nelson Capes on 12/21/15.
//  Copyright © 2015 Nelson Capes. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>
#import "patientItem.h"
#import "assessmentItem.h"
#import "NRCPasscodeViewController.h"
#import "NRCAssessmentViewControllerTableViewController.h"
#import <StoreKit/StoreKit.h>
#import "PurchaseViewController.h"
#import "Note.h"
#import "patientItemStore.h"
@class PurchaseViewController;
@class LoginViewController;
@interface NRCTableViewController : UITableViewController <MFMailComposeViewControllerDelegate, NRCPasscodeViewControllerDelegate, UIAlertViewDelegate>
@property (nonatomic) NSMutableArray *productIDS;
@property (strong, nonatomic) NSString *providerID;
@property (strong, nonatomic)NSString *emailAddress;
@property (strong, nonatomic) NSArray *toRecipients;
@property (strong,nonatomic) NSString *tempBody;
@property (strong, nonatomic) NSString *messageBody;
@property (strong, nonatomic) NSMutableArray *assessmentsForEmail;
@property NSString *centralURL;
@property NSString *centralURL1;
@property NSURLSession *session;
@property NSString *urlString;
@property NSUInteger dictionaryCount;
@property NSArray *providers;
@property NSMutableArray *values;
@property NSArray *subValues;
@property NSArray *medications;
@property NSArray *interventions;
@property BOOL centralAdminActivated;
@property BOOL centralAdmin;
@property BOOL centralAdminAvailable;
@property BOOL iCloudSupportActivated;
@property NSString *errorType;
@property NSDictionary *jsonData;
@property NSDictionary *iapdata;
@property (strong, nonatomic) NSString *elapsedTime;
@property (weak, nonatomic) NSString *startDate;
@property (weak, nonatomic) NSString *dispatchTime;
@property (weak, nonatomic) NSString *transportTime;
@property (weak, nonatomic) NSString *hospitalTime;
@property (weak, nonatomic) NSString *clearedTime;
@property (weak, nonatomic) NSString *contactTime;
@property NSTimer *elapsedTimer;
@property NSTimer *assess5Timer;
@property NSTimer *assess15Timer;
@property (strong, nonatomic) NSDate *dispatchDate;
@property (strong, nonatomic) NSDate *contactDate;
@property (strong, nonatomic) NSDate *transportDate;
@property (strong, nonatomic) NSDate *hospitalDate;
@property (strong, nonatomic)NSDate *clearedDate;
@property (strong, nonatomic) NSDate *dateStarted;
@property (strong, nonatomic) NSDate *reassess5;
@property (strong, nonatomic) NSDate * reassess15;
@property NSMutableArray *outputStrings;
@property NSInteger timerType;
@property NSMutableArray *labels;
@property NSMutableArray *types;
@property  NSMutableArray *cellTimers;
@property(strong, nonatomic) NSIndexPath *path;
@property (strong, nonatomic) NSString *password;
@property (nonatomic) BOOL passwordEntered;
// ********************changed 9/30/05
// these properties are needed for exclusive selection of timer type in didSelectRowForIndexPath
@property NSInteger prev;
@property NSMutableArray *taskCategories;
@property NSIndexPath *currentCategory;
@property (nonatomic, strong) patientItem *patientItem;
@property (nonatomic) NSString *itemKey;
@property (strong,nonatomic) NSMutableArray *patients;
@property assessmentItem *assessmentItem;
@property (nonatomic) NSMutableArray *assessments;
-(void)enterDate;

-(void)applicationBecameActive;
-(BOOL)savePassword;
-(BOOL)saveProviderID;
-(void)playBeep1;
-(void)playBeep2;
-(void)playCheckout;
-(void)splashScreen;
-(void)checkProviderID;
-(void)getinAppPurchases;
- (IBAction)purchaseItem:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *level2Button;
@property (strong, nonatomic) PurchaseViewController *purchaseController;
@property (nonatomic, strong) Note *doc;
@property (nonatomic, strong) NSMutableArray *notes;
@property (nonatomic) NSMetadataQuery *query;

-(void)enablePurchase;
@property BOOL iCloudEnabled;
@property BOOL iCloudActivated;
@property UIBarButtonItem *iCloudButton;
-(IBAction)iCloudButtonIndicator:(id)sender;
-(IBAction)centralAdminButtonIndicator:(id)sender;
@property BOOL isAuthenticated;
@property BOOL didReturnFromBackground;
@end
