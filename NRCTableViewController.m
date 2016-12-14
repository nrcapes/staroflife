//
//  NRCTableViewController.m
//  EMSTimersPro 2.0
//
//
//  Created by Nelson Capes on 01/03/2016.
//  Version 6 07/12/2016.
//  Copyright © 2015, 2016 Nelson Capes. All rights reserved.
/*
// This is the initial view controller in the project. It consists of a tableView with tableViewCells in one section with the
// number of rows equal to the number of labels in the self.labels NSMutableArray. Each tableViewCell is a standard UITableViewCell and is
// dequeued as reusable. When the cell is dequeued,the textLabel.text is set to the string in self.labels at index indexPath. The cell
// is selected by touching it, and the indexPath.row returned by tableView didSelectRowAtIndexPath:(NSIndexPath *) is used to index into a
// switch statement that consists of a number of method calls.  Tne methods called generally make a timestamp of the time of the call and
// set cell.detailTextLabel.text to that timestamp.  The exceptions are:
// 1) -(void) enterDate, which starts a running timer
// 2) -(void)enter5minuteReassess which starts a 5 minutetimer;
// 3) -(void)enter15minuteReassess which starts a 15 minute timer; and 
// 4) - (void)enterContact which allows the user to enter patient data.
// When a timer expires, -(void)calculateTimer is called.  If the timer that expired was the enterDate timer, the method just updates the
// timer in the cell.  If the 5 minute or 15 minute timer expires, the method plays a sound that indicates the timer is running and
// counts the timer down. If the 5 minutes or 15 minutes are up, the method plays a fast beeping sound, kills the timer, and flashes
// thetimer cell.
// This is all that the EMS Timers Plus project does.
 
// EMS Timers Pro adds the following:
// when enterContact is called, if the user agrees, the enterPatientData method is called. This calls the patientItemStore to create a
// new patientItem. We then segue to the patient data table controller to allow patient biographic information to be entered.
 //
 // Toolbar buttons are: Display Data, Email, Upgrade.
 
 //
 // Display Data button will display Patient Contact Times, further clicking will show Assess, Assessments, then clicking on Assessment List will show each assessment, and clicking on
 // Medical History button will show detailed medical history for that assessment.
 
 // Upgrade button lets the user enter an in app purchase.
 
 // Email button creates an email with a body consisting of CSV fields according to the following:
 
 // Data structures:
 // NSMutableArray *patients is an array of patientItem
 
 // patientItem has the following structure:
 
 @property NSString *firstName;
 @property NSString *middleName;
 @property NSString *lastName;
 @property NSString *fullName;
 @property NSString *dateOfBirth;
 @property NSString *gender;
 @property NSString *streetAddress;
 @property NSString *cityAddress;
 @property NSString *stateAddress;
 @property NSString *zipCode;
 @property NSString *phoneNumber;
 @property NSDate *contactTime;
 @property NSString *venue;
 @property NSString *event;
 @property NSString *chiefComplaint;
 @property NSString *clinicalImpression;
 @property NSString *medicalHistory;
 @property NSString  *currentMedications;
 @property NSString *allergies;
 @property NSString *mechanismOfInjury;
 @property NSString *treatments;
 @property NSMutableArray *assessments;
 @property (nonatomic, copy) NSString *itemKey;
 
// assessments is an NSMutableArray of assessmentItem.
 
 // assessmentItem has the following structure:
 
 @property (nonatomic) NSDate *assessmentTime;
 @property (nonatomic) NSString *sytolicBloodPressure;
 @property (nonatomic) NSString *diastolicBloodPressure;
 @property (nonatomic) NSString *pulse;
 @property (nonatomic) NSString *respirations;
 @property (nonatomic) NSString *spO2;
 @property (nonatomic) NSString *chiefComplaint;
 @property (nonatomic) NSString *clinicalImpression;
 @property (nonatomic) NSString *medicalHistory;
 @property (nonatomic) NSString *allergies;
 @property (nonatomic) NSString *mechanismOfInjury;
 @property (nonatomic) NSString *currentMedications;
 @property (nonatomic) NSString *treatments;
 
 // This controller formats an email message with CSV fields in the message body of the following:
 
 // line 1: Provider ID.
 // line 2: Patient's full name, Contact data/time, Venue, Event.
 // line 3: Date of birth, gender, street address, city address, state address, zipcode, phone number.
 // lines 4 - n (where n = number of assessments for this patient):
 // assessment Time, systolic BP, diastolic BP, pulse, respirations, SPO2.
 //  for each assessment line, 2 medical history lines which are:
 // Chief complaint, Clinical Impression, Medical History, Current Medications, Allergies;
 // Mechanism of Injury/Nature of Illness, Treatments.
 // 
 // When the 'email' button on the toolbar is touched, the code asks for the email address
 // and then formats an email according to the above and sends it.
 // At the receiving end, an email client reads the email and saves it to a file.
 // Excel can then be used to import the CSV file and construct a worksheet.
 
*/

#import "NRCTableViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "NRCPatientDataTableViewController.h"
#import "NRCDisplayTableViewController.h"
#import "patientItemStore.h"
#import "NRCAssessmentViewControllerTableViewController.h"
#import "PatientListTableViewController.h"
#import "PurchaseViewController.h"
#import "jsonStore.h"
#import "NRCErrorStore.h"
#import "iapstore.h"
#import "NRCSelectDataTableViewController.h"
#import "EMSTimers-Swift.h"
#import "NRCEmailTableViewController.h"

@interface NRCTableViewController ()

@end

@implementation NRCTableViewController
#pragma mark Helpers

- (BOOL)iCloudOn {
    NSLog(@"iCloudOn = %d", [[NSUserDefaults standardUserDefaults] boolForKey:@"iCloudEnabled"]);
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"iCloudEnabled"];
}
- (void)setiCloudOn:(BOOL)on {
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:@"iCloudEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"setiCloudOn = %d", [[NSUserDefaults standardUserDefaults] boolForKey:@"iCloudEnabled"]);
}
- (BOOL)iCloudWasOn {
    NSLog(@"iCloudWasOn = %d", [[NSUserDefaults standardUserDefaults] boolForKey:@"iCloudWasOn"]);
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"iCloudWasOn"];
}
- (void)setiCloudWasOn:(BOOL)on {
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:@"iCloudWasOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"setiCloudWasOn = %d", [[NSUserDefaults standardUserDefaults] boolForKey:@"iCloudWasOn"]);
}
-(BOOL)centralAdminOn{
    NSLog(@"centralAdminOn = %d", [[NSUserDefaults standardUserDefaults] boolForKey:@"centralAdmin_unlocked"]);
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"centralAdmin_unlocked"];
}
-(void)setCentralAdminOn:(BOOL)on{
    [[NSUserDefaults standardUserDefaults]setBool:on forKey:@"centralAdmin_unlocked"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"setCentralAdminOn = %d", [[NSUserDefaults standardUserDefaults] boolForKey:@"centralAdmin_unlocked"]);
}
-(BOOL)centralAdminWasOn{
    NSLog(@"centralAdminWasOn = %d", [[NSUserDefaults standardUserDefaults] boolForKey:@"centralAdminWasOn"]);
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"centralAdminWasOn"];
}
-(void)setCentralAdminWasOn:(BOOL)on{
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:@"centralAdminWasOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"centralAdminWasOn = %d", [[NSUserDefaults standardUserDefaults]boolForKey:@"centralAdminWasOn"]);
}

#pragma mark - iCloud and Central Admin buttons
-(IBAction)iCloudButtonIndicator:(id)sender{
    NSLog(@"iCloud Button pressed");
    /*
     // button should not do any action if pressd. It is just an indicator.
    */
}

-(IBAction)centralAdminButtonIndicator:(id)sender{
    NSLog(@"centralAdminButton pressed");
    // not implemented.
}

#pragma mark - refresh
-(void)refresh{
    // icloud setup
    // check for iCloud available
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.iCloudEnabled = [[defaults valueForKey:@"iCloudEnabled"]boolValue];
    // removed because of Apple policy against in-app purchase for iCloud.
   // self.iCloudActivated = ([[defaults valueForKey:@"iCloudSupport_unlocked"]boolValue] && self.iCloudEnabled);
    BOOL iCloudAlwaysAvailable = YES;
    self.iCloudActivated = (self.iCloudEnabled  && iCloudAlwaysAvailable);
    
    // if we are not using iCloud:
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
    if(self.iCloudActivated == NO){
        self.patients = [[patientItemStore sharedStore]allItems];
    }else{
        // if we are using icloud
        [self loadNotes];
    }
#pragma clang diagnostic pop
    BOOL iCloudAvailable;
    NSURL *ubiq = [[NSFileManager defaultManager]
                   URLForUbiquityContainerIdentifier:nil];
    if(ubiq){
      iCloudAvailable = YES;
    }else{
        iCloudAvailable = NO;
    }
    self.iCloudActivated = (self.iCloudActivated && iCloudAvailable);
   // [self setiCloudPrompted:NO];
    
    if (self.iCloudActivated == NO){
        
        // If iCloud isn't available, set prompted to no (so we can ask them next time it becomes available)
        
        
        // If iCloud was toggled on previously, warn user that the docs will be loaded locally
        if ([self iCloudWasOn] && self.iCloudActivated == NO) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You're Not Using iCloud" message:@"Your documents remain stored in iCloud." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok =[UIAlertAction actionWithTitle:@"Press any key" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                //[self setiCloudOn:NO];
                [self setiCloudWasOn:NO];
               // self.iCloudButton.tintColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f];
                self.iCloudButton.enabled = NO;
                [[NSUserDefaults standardUserDefaults] synchronize];
               // [self setiCloudPromptedON:NO];
               // [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alert addAction:ok];
            
            //[self setiCloudPromptedOFF:YES];
            [self presentViewController:alert animated:YES completion:nil];
        
        }
        
        
    }
    {
        // Ask user if want to turn on iCloud if it's available and we haven't asked already
        //if (iCloudActivated) {
            if(![self iCloudWasOn] && self.iCloudActivated == YES){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"iCloud is Available" message:@"Automatically store your documents in the cloud to keep them up-to-date across all your devices and the web?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok =[UIAlertAction actionWithTitle:@"use iCloud" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                [self setiCloudWasOn:YES];
                [self setiCloudOn:YES];
               // self.iCloudButton.tintColor = [UIColor colorWithRed:0.0f green:0.5f blue:0.5f alpha:1.0f];
                self.iCloudButton.enabled = YES;
                //[self setiCloudPromptedON:YES];
                //[self setiCloudPromptedOFF:NO];
                [[NSUserDefaults standardUserDefaults] synchronize];
               // [self dismissViewControllerAnimated:YES completion:nil];

            }];
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Later" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               // No matter what, refresh with current value of iCloudOn
                                                               [self setiCloudWasOn:YES];
                                                               [self setiCloudOn:NO];
                                                               //self.iCloudButton.tintColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f];
                                                               self.iCloudButton.enabled = NO;
                                                              // [[NSUserDefaults standardUserDefaults] synchronize];
                                                               //[self dismissViewControllerAnimated:YES completion:nil];

                                                           }];
            
            [alert addAction:ok];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        }
        
        // No matter what, refresh with current value of iCloudOn
        //[self setiCloudWasOn:[self iCloudOn]];
        
   //
    // check for central admin
   // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // check for central admin available
    self.centralAdminActivated = ([[defaults valueForKey:@"centralAdmin_unlocked"]boolValue]);
    self.centralAdmin = [[defaults valueForKey:@"centralAdmin"]boolValue];
    self.centralAdminAvailable = (self.centralAdminActivated && self.centralAdmin);
    
    // if central admin is not activated but it was on:
    if(self.centralAdminActivated == NO && [self centralAdminWasOn]){
            [self setCentralAdminWasOn:NO];
        if(!self.centralAdmin) {
            [self setCentralAdminOn:NO];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        iapstore *singleton = [iapstore getInstance];
        NSNumber *n1 = [[NSNumber alloc]initWithBool:self.centralAdminActivated];
        NSNumber *n2 = [[NSNumber alloc]initWithBool:self.centralAdmin];
        NSArray *array = [[NSArray alloc]initWithObjects:n1,n2, nil];
        [singleton saveData:array];
        
        
      // }
    }
        // if central admin IS activated and it was not on before:
    if(self.centralAdminActivated == YES && ![self centralAdminWasOn])
        {
              // turn it on in user defaults
        [self setCentralAdminWasOn:YES];
        [self setCentralAdminOn:YES];
            iapstore *singleton = [iapstore getInstance];
            NSNumber *n1 = [[NSNumber alloc]initWithBool:self.centralAdminActivated];
            NSNumber *n2 = [[NSNumber alloc]initWithBool:self.centralAdmin];
            NSArray *array = [[NSArray alloc]initWithObjects:n1,n2, nil];
            [singleton saveData:array];
                // and check for a valid provider id
       // [self checkProviderID];
        }
    // if central admin IS activated and it was on before
    if(self.centralAdminActivated == YES && [self centralAdminWasOn]){
        //
        iapstore *singleton = [iapstore getInstance];
        NSNumber *n1 = [[NSNumber alloc]initWithBool:self.centralAdminActivated];
        NSNumber *n2 = [[NSNumber alloc]initWithBool:self.centralAdmin];
        NSArray *array = [[NSArray alloc]initWithObjects:n1,n2, nil];
        [singleton saveData:array];
    }
    // if central admin is NOT activated and it wasn't on before
    if(self.centralAdminActivated == NO && ![self centralAdminWasOn]){
        //
        iapstore *singleton = [iapstore getInstance];
        NSNumber *n1 = [[NSNumber alloc]initWithBool:self.centralAdminActivated];
        NSNumber *n2 = [[NSNumber alloc]initWithBool:self.centralAdmin];
        NSArray *array = [[NSArray alloc]initWithObjects:n1,n2, nil];
        [singleton saveData:array];
    }
    }

    //    [self setCentralAdminWasOn:[self centralAdminOn]];
        
        
   // if(self.centralAdminActivated == YES){
    //    [self checkProviderID];}


-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"view will appear");
    [super viewWillAppear:animated];
    [self refresh];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults boolForKey:@"firstTimeDidAppear"] == YES){
    [self showLoginView];
    [defaults setBool:NO forKey:@"firstTimeDidAppear"];
    }
}

#pragma mark application became active
-(void)applicationBecameActive{
    
    self.isAuthenticated = NO;
   [self showLoginView];
    
    
 //  [self refresh];
    
}
#pragma mark showLoginView
-(void)showLoginView{
    if (self.isAuthenticated == NO){
        [self performSegueWithIdentifier:@"presentLogin" sender:self];
        //NRCLoginViewController *lvc = [[NRCLoginViewController alloc]init];
    }
}
-(IBAction)logoutAction :(id)sender{
    self.isAuthenticated = NO;
    [self performSegueWithIdentifier:@"presentLogin" sender:self];
}
AVAudioPlayer *_audioPlayer;
AVAudioPlayer *_audioPlayer1;
AVAudioPlayer *_audioPlayer2;
-(void)playBeep1{
    [_audioPlayer play];
}
-(void)playBeep2{
    [_audioPlayer1 play];
}
-(void)playCheckout{
    [_audioPlayer2 play];
}
#
- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    [nc addObserver:self selector:@selector(applicationBecameActive) name:UIApplicationDidBecomeActiveNotification  object:nil];
    
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        _checkedArray = [aDecoder decodeObjectForKey:@"checkedArray"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.checkedArray forKey:@"checkedArray"];
    
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.isAuthenticated = NO;
// to allow for in app purchase upgrade to unlimited emails, in the non-
    // upgraded object we count the number of emails sent.
    
    self.numberofEmailsSent = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:0 forKey:@"emailsSent"];
    
    [self splashScreen];
    
    
    
    if(!self.labels){
        self.labels = [[NSMutableArray alloc]init];}
    if(!self.types){
        self.types = [[NSMutableArray alloc]init];}
    if(!self.outputStrings){
        self.outputStrings = [[NSMutableArray alloc]init];}
    [_labels addObject:@"Elapsed Time"];
    [_types addObject:@0];
    [_outputStrings addObject:@"00:00:00"];
    [_labels addObject:@"Dispatch Time"];
    [_types addObject:@1];
    [_outputStrings addObject:@""];
    [_labels addObject:@"Patient Contact Time"];
    [_types addObject:@2];
    [_outputStrings addObject:@""];
    [_labels addObject:@"Transport Time"];
    [_types addObject:@3];
    [_outputStrings addObject:@""];
    [_labels addObject:@"At Hospital"];
    [_types addObject:@4];
    [_outputStrings addObject:@""];
    [_labels addObject:@"Cleared"];
    [_types addObject:@5];
    [_outputStrings addObject:@""];
    [_labels addObject:@"In Service"];
    [_types addObject:@6];
    [_outputStrings addObject:@""];
    [_labels addObject:@"5 minute re-assess"];
    [_types addObject:@7];
    [_outputStrings addObject:@"05:00"];
    [_labels addObject:@"15 minute re-assess"];
    [_types addObject:@8];
    [_outputStrings addObject:@"15:00"];
    
    
    self.taskCategories = [[NSMutableArray alloc]init];
    self.currentCategory =[[NSIndexPath alloc]init];
    
    // set up array to hold user selected patient items in email view Controller
    _checkedArray = [NSMutableArray arrayWithObjects:
                     [NSNumber numberWithBool:NO],
                     [NSNumber numberWithBool:NO],
                     [NSNumber numberWithBool:NO],
                     [NSNumber numberWithBool:NO],
                     [NSNumber numberWithBool:NO],
                     [NSNumber numberWithBool:NO],
                     [NSNumber numberWithBool:NO],
                     [NSNumber numberWithBool:NO],
                     [NSNumber numberWithBool:NO],
                     [NSNumber numberWithBool:NO],
                     [NSNumber numberWithBool:NO],
                     [NSNumber numberWithBool:NO], nil];
    
    
    // Construct URL to sound file
    NSString *path = [NSString stringWithFormat:@"%@/Beep-short.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    // Create audio player object and initialize with URL to sound
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    
    NSString *path1 = [NSString stringWithFormat:@"%@/Beeping-sound.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl1 = [NSURL fileURLWithPath:path1];
    
    // Create audio player object and initialize with URL to sound
    _audioPlayer1 = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl1 error:nil];
    
    NSString *path2 = [NSString stringWithFormat:@"%@/checkout scanner beep.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl2 = [NSURL fileURLWithPath:path2];
    
    // Create audio player object and initialize with URL to sound
    _audioPlayer2 = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl2 error:nil];
    
    // check central web site for in app purchases
    //
    
    //self.centralAdminActivated = NO;
    
    
    self.centralAdmin = [[defaults valueForKey:@"centralAdmin_unlocked"]boolValue];
    self.centralURL = [defaults valueForKey:@"centralURL"];

    // if user has chosen centralized administration, we need to download the JSON data
    // from the central web site
   //if(self.centralAdmin){
      //  [self getJSONData];
    //
    //}
   // [self setiCloudPrompted:NO];
    
   // [self refresh];

   // if self.centralURL is nil, get the central admin URL from the main settings bundle
    
    [self getJSONData];
    
    
    // add observer for application didbecomeactive
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationBecameActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // the following notification will be triggered when note.m gets new data from iCloud.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataReloaded:) name:@"noteModified" object:nil];
    
    [self setiCloudOn:NO];
    [self setiCloudWasOn:NO];
    [self setCentralAdminOn:NO];
    [self setCentralAdminWasOn:NO];
    self.centralAdminActivated = NO;
    self.centralAdmin = NO;
    
    iapstore *singleton = [iapstore getInstance];
    NSNumber *n1 = [[NSNumber alloc]initWithBool:self.centralAdminActivated];
    NSNumber *n2 = [[NSNumber alloc]initWithBool:self.centralAdmin];
    NSArray *array = [[NSArray alloc]initWithObjects:n1,n2, nil];
    [singleton saveData:array];
    
    
    self.providerID = [[NSUserDefaults standardUserDefaults]valueForKey:@"providerID"];
    
    
    UIImage *image = [UIImage imageNamed:@"cloud.png"];
    
    self.iCloudButton = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(iCloudButtonIndicator:)];
    
   
    self.iCloudButton.enabled = NO;
    
    /*
     // not implemented
    UIBarButtonItem *centralAdminButton = [[UIBarButtonItem alloc]initWithTitle:@"C" style:UIBarButtonItemStyleDone target:self action:@selector(centralAdminButtonIndicator:)];
    centralAdminButton.tintColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f];
     */
    UIBarButtonItem *resetButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(reset:)];
    resetButton.tintColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f];
    NSArray *myButtonsArray = [[NSArray alloc]initWithObjects:resetButton, self.iCloudButton, nil];
    
    self.navigationItem.rightBarButtonItems = myButtonsArray;
    
}
#pragma MARK In App Store Purchasing

-(IBAction)purchaseItem:(id)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"In App Purchase" message:@"Do Want to Purchase an Upgrade or Restore a Purchase?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok =[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self performSegueWithIdentifier:@"toPurchaseViewController" sender:self];
        
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                   }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}
    

-(void)enablePurchase{


    NSLog(@"Initial view controller:enablePurchase");
   // get data from singleton iapstore. PurchaseViewController puts a BOOL value into an array
    // in dictionary. The BOOL value is carried as an NSNumber because objective-C will not
    // allow an array to be initialized with a non-object, such as a BOOL.
    // self.centralAdminActivated controls all logic for Central Administration.
    // Note: this code is not used anymore. Instead, SelectData controller and sending email in this controller
    // directly check User Defaults for key showing central admin is unlocked.
    
    /*
    iapstore *store = [iapstore getInstance];
    self.iapdata = [store getData];
    NSNumber *number = [self.iapdata objectForKey:@"central_admin_enabled"];
    NSLog(@"enablePurchase store data: %@", number);
    self.centralAdminActivated = [number boolValue];
    NSNumber *number1 = [self.iapdata objectForKey:@"iCloud_support_enabled"];
    NSLog(@"enablePurchase store data: %@", number1);
    self.iCloudSupportActivated = [number1 boolValue];
    
    */
    
    
}
#pragma mark - legal notice

-(void)splashScreen{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Legal Notice"
                                  message:@"Your use of this application constitutes your acceptance of the following conditions: You agree that this application is only an aid to the performance of your duties to a patient as a competent provider. You take complete responsibility for all patient care, including the recording of times according to your service's standards and the observance of all timers, including patient re-assessment timers. You agree that you are not relying on this application for patient care. You understand that Protected Health Information, as defined by HIPAA, may be stored in or sent outside this device, and that the developer of this application is not making any assurance that the application is HIPAA-compliant. You agree to abide by all HIPAA regulations in using this application. If you accept all of these conditions, click on the following line."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    // if the user agrees, we query NSUserDefaults to find out whether the central administration enable switch is turned on. If so, we check the provider ID entered by the user against the list from central admin.
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"I agree to all of the above conditions." style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   
                                                   [self showLoginView];
                                                   
                                                   
                                                   [self dismissViewControllerAnimated:YES completion:nil];
                                               }];

    
[alert addAction:ok];
[self presentViewController:alert animated:YES completion:nil];
    
}

-(void)checkPassword{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL passwordProtect = [[defaults valueForKey:@"password"]boolValue];
    if(passwordProtect){
        self.password = [defaults valueForKey:@"passwordValue"];
    
    NRCPasscodeViewController *passcodeController = [[NRCPasscodeViewController alloc]init];
    passcodeController.delegate = self;
    UINavigationController *passCodeNavigationController = [[UINavigationController alloc]initWithRootViewController:passcodeController];
    [self.navigationController presentViewController:passCodeNavigationController animated:YES completion:nil];
    }
}
-(void)passcodeController:(NRCPasscodeViewController *)controller passcodeEntered:(NSString *)passCode{
    if([passCode isEqualToString:self.password]){
        [controller dismissViewControllerAnimated:YES completion:nil];
    }else{
        [controller resetWithAnimation:NRCPasscodeAnimationStyleInvalid];
    }
}
-(void)getJSONData{
    NSLog(@"getJSONData");
    // set up a url session to get JSON data
    // Note: this will run a background thread to get the data,so we can't do anything to the UI.
    
    NSURLSessionConfiguration *config =
    [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
   // self.urlString =@"http://www.nelsoncapes.com/emstimerspro/jsondata.txt";
    if([self.centralURL  isEqual: @""]){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emstimerspro_jsondata" ofType:@"txt" inDirectory:@"jsondata"];
        //NSString *str=[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"emstimerspro_jsondata.txt"];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self getJSON:(NSURLRequest *)request];
    }else{
    NSURL *url = [NSURL URLWithString:self.centralURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self getJSON:(NSURLRequest *)request];
    };
}
-(void)getJSON:(NSURLRequest *)request{
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithRequest:request
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                        if(!data){
                            NRCErrorStore *singleton = [NRCErrorStore getInstance];
                            [singleton saveData:error];
                            return;
                        }
                       // NSString *json = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                       // NSLog(@"JSON data: %@", json);
                        NSDictionary *jsonObject = [[NSDictionary alloc]init];
                        NSError *jsonError;
                        BOOL ok = [NSJSONSerialization isValidJSONObject:jsonObject];
                        if(ok == YES){
                        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                        }
                        if (error) {
                            NSLog(@"dataTaskWithRequest error: %@", error);
                           NRCErrorStore *singleton = [NRCErrorStore getInstance];
                            [singleton saveData:error];
                            return;
                        }
                        
                        // handle HTTP errors here
                        
                        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                            
                            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                            
                            if (statusCode != 200) {
                                NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                                self.errorType= @"NRC002 - HTTP Error.";
                                NRCErrorStore *singleton = [NRCErrorStore getInstance];
                                [singleton saveData:self.errorType];
                                return;
                            }
                        }
                        // save the JSON data.
                        if(jsonObject){
                        
                            jsonStore *singleton = [jsonStore getInstance];
                            [singleton saveData:jsonObject];
                           
                        // get the JSON data, sort, and log.
                        self.values = [[NSMutableArray alloc]init];
                        self.values[0] = [jsonObject objectForKey:@"providers"];
                        self.values[1] = [jsonObject objectForKey:@"medications"];
                        self.values[2] = [jsonObject objectForKey:@"interventions"];
                        
                        NSEnumerator *enumerator = [self.values objectEnumerator];
                        id anObject;
                        while (anObject = [enumerator nextObject]) {
                         //   NSLog(@"Value: %@", anObject);
                        }
                        self.providers =
                        [self.values[0] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
                        
                        self.medications =
                        [self.values[1] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
                        
                        self.interventions =
                        [self.values[2] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
                        }
                        else{
                            self.errorType= @"NRC003 - no JSON Object";
                            NRCErrorStore *singleton = [NRCErrorStore getInstance];
                            [singleton saveData:self.errorType];

                            NSLog(@"JSON error");
                        }
                        }];
                    
    [dataTask resume];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)start:(id)sender {
    [self enterDate];
}
- (void)enterDate{
// start the running timer
    [_audioPlayer2 play];
    NSDate *date =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *dateString = [dateFormatter stringFromDate:date];
    self.startDate = dateString;
    self.dateStarted = date;
    NSTimeInterval timeInterval = 1.0;
    _elapsedTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(calculateTimer:) userInfo:_elapsedTimer repeats:YES];
    [_elapsedTimer fire];
}
// timestamp the dispatch time
- (void)enterDispatch{
    [_audioPlayer2 play];
    NSDate *date =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:date];
    self.dispatchTime = dateString;
    NSIndexPath *ip =[NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];
    cell.detailTextLabel.font = [cell.detailTextLabel.font fontWithSize:24];
    cell.detailTextLabel.text = dateString;
    self.outputStrings[ip.row] = dateString;
}
// timestamp the patient contact time
- (void)enterContact{
    [_audioPlayer2 play];
    NSDate *date =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSIndexPath *ip =[NSIndexPath indexPathForRow:2 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];
    cell.detailTextLabel.font = [cell.detailTextLabel.font fontWithSize:24];
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.text = dateString;
    self.outputStrings[ip.row] = dateString;
    [self enterPatientData];

}
// timestamp the transport time
- (void)enterTransport{
    [_audioPlayer2 play];
    NSDate *date =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:date];
    self.transportTime = dateString;
    NSIndexPath *ip =[NSIndexPath indexPathForRow:3 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];
    cell.detailTextLabel.font = [cell.detailTextLabel.font fontWithSize:24];
    cell.detailTextLabel.text = dateString;
    self.outputStrings[ip.row] = dateString;
    
}
// timestamp the arrived at hospital time
- (void)enterHospital{
    [_audioPlayer2 play];
    NSDate *date =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:date];
    self.hospitalTime = dateString;
    NSIndexPath *ip =[NSIndexPath indexPathForRow:4 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];
    cell.detailTextLabel.font = [cell.detailTextLabel.font fontWithSize:24];
    cell.detailTextLabel.text = dateString;
    self.outputStrings[ip.row] = dateString;
    
}
// timestamp the cleared from hospital time
- (void)enterCleared{
    [_audioPlayer2 play];
    NSDate *date =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:date];
    self.clearedTime = dateString;
    NSIndexPath *ip =[NSIndexPath indexPathForRow:5 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];
    cell.detailTextLabel.font = [cell.detailTextLabel.font fontWithSize:24];
    cell.detailTextLabel.text = dateString;
    self.outputStrings[ip.row] = dateString;
}
// timestamp the return to service time
- (void)enterReturnToService{
    [_audioPlayer2 play];
    NSDate *date =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:date];
    self.clearedTime = dateString;
    NSIndexPath *ip =[NSIndexPath indexPathForRow:6 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];
    cell.detailTextLabel.font = [cell.detailTextLabel.font fontWithSize:24];
    cell.detailTextLabel.text = dateString;
    self.outputStrings[ip.row] = dateString;
}
// start the 5 minute re-assess timer
-(void)check5minuteReassess{
    
    //check whether the timer is running.  If not, start it.
    if(!self.assess5Timer){
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"5 minute re-assess?"
                                  message:@"Do you want to start a 5 minute patient re-assess?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   //Do Some action here
                                                   [self.assess15Timer invalidate];
                                                   NSDate *date =[NSDate date];
                                                   NSTimeInterval interval = 5*60;
                                                   self.reassess5 = [date dateByAddingTimeInterval:interval];
                                                   
                                                   NSTimeInterval timeInterval = 1.0;
                                                   _assess5Timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(calculateTimer:) userInfo:_assess5Timer repeats:YES];
                                                   [_assess5Timer fire];
                                                   
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                   }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    
    
    [self presentViewController:alert animated:YES completion:nil];
    }else{// if the timer is running, stop it and clear it
        [self.assess5Timer invalidate];
        self.assess5Timer = nil;
        //stop sounds
        [_audioPlayer stop];
        [_audioPlayer1 stop];
    }

}
// start the 15 minute re-assess timer
-(void)check15minuteReassess{
    
    if(!self.assess15Timer)
    {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"15 minute re-assess?"
                                  message:@"Do you want to start a 15 minute patient re-assess?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   [self.assess5Timer invalidate];
                                                   //Do Some action here
                                                   NSDate *date = [NSDate date];
                                                   NSTimeInterval interval = 15*60;
                                                   self.reassess15 = [date dateByAddingTimeInterval:interval];
                                                   
                                                   NSTimeInterval timeInterval = 1.0;
                                                   _assess15Timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(calculateTimer:) userInfo:_assess15Timer repeats:YES];
                                                   [_assess15Timer fire];
                                                   
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                   }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    
    
    [self presentViewController:alert animated:YES completion:nil];
    }else{// if the timer is running, stop it and clear it
        [self.assess15Timer invalidate];
        self.assess15Timer = nil;
        //stop sounds
        [_audioPlayer stop];
        [_audioPlayer1 stop];
    }
    
}
// Controll comes here when the Cancel button on the nav bar is touched.
- (IBAction)reset:(id)sender {

    
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Finished with this patient?"
                                  message:@"Are you finished working with this patient? "
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   //Do Some action here
                                                   self.startDate = @"";
                                                   self.dispatchTime = @"";
                                                   self.transportTime =@"";
                                                   self.hospitalTime = @"";
                                                   self.clearedTime = @"";
                                                   self.contactTime =@"";
                                                   // indicate no patient data entered
                                                   self.patientItem = nil;
                                                   for(UITableViewCell *cell in [self.tableView visibleCells]){
                                                       cell.detailTextLabel.text = @"";
                                                       NSIndexPath *ip = [self.tableView indexPathForCell:cell];
                                                       if(ip.row == 0){
                                                           cell.detailTextLabel.text = @"00:00:00";
                                                       }
                                                       if(ip.row == 7){
                                                           cell.detailTextLabel.text = @"05:00";
                                                       }
                                                       if(ip.row == 8){
                                                           cell.detailTextLabel.text = @"15:00";
                                                       }
                                                   }
                                                   // stop all timers
                                                   [self.elapsedTimer invalidate];
                                                   [self.assess5Timer invalidate];
                                                   [self.assess15Timer invalidate];
                                                   
                                                   // stop sounds
                                                   [_audioPlayer stop];
                                                   [_audioPlayer1 stop];
                                               }];
                         
                                                   
                                               
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                                                    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self playCheckout];
    
    self.selectedPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self saveSelectedRow];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)saveSelectedRow{
    if(self.selectedPath){
        self.savedPath = [NSKeyedArchiver archivedDataWithRootObject: self.selectedPath];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.savedPath forKey:@"lastSelectedRow"];
    }}
// the main method for handling all timer expirations.
-(void)calculateTimer:(NSTimer *)theTimer
{
    // here we look at which timer expired. If the elapsedTimer expired, we just update the timer in the cell.
    
    NSTimeInterval interval;
    if(theTimer == self.elapsedTimer){
        interval = [self.dateStarted timeIntervalSinceNow];
        interval = (-1 * interval);
        int time = round(interval);
        div_t h = div(time, 3600); //seconds total, divided by 3600 equals
        int hours = h.quot;         // hours, divided by 60 equals
        div_t m = div(h.rem, 60);   // minutes
        int minutes = m.quot;
        int seconds = m.rem;        // and remainder is seconds
        //NSIndexPath *ip =[NSIndexPath indexPathForRow:0 inSection:0];
        // UITableViewCell *cell =[self.tableView cellForRowAtIndexPath:ip];
        NSString *intervalString = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
        for(UITableViewCell *cell in [self.tableView visibleCells]){
            NSIndexPath *ip = [self.tableView indexPathForCell:cell];
            if ((ip.row == 0)){
                cell.detailTextLabel.font = [cell.detailTextLabel.font fontWithSize:24];
                cell.detailTextLabel.text = self.outputStrings[ip.row];
                self.outputStrings[ip.row] = intervalString;
            }
            }// end for loop
    }
    // if the 5 minute re-assess timer expired, we play a sound and update the timer in the cell. If the 5 minutes are up,
    // we play a warning sound and flash the cell in the view.
    
    else if (theTimer == self.assess5Timer){
        interval = [self.reassess5 timeIntervalSinceNow];
    int time = round(interval);
    div_t h = div(time, 3600); //seconds total, divided by 3600 equals
    int hours = h.quot;         // hours, divided by 60 equals
    div_t m = div(h.rem, 60);   // minutes
    int minutes = m.quot;
    int seconds = m.rem;        // and remainder is seconds
        // play a sound (beep-short) if the 5 minutes have not expired
        if(time > 0){
            [_audioPlayer play];}
        
        // otherwise, play the beeping-sound and kill the timer
        else{
            [self.assess5Timer invalidate];
            [_audioPlayer1 play];
            
        }
   // the next code flashes the 5 minute timer in the view
        
    NSString *intervalString = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    for(UITableViewCell *cell in [self.tableView visibleCells]){
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];
        if (ip.row == 7){
            if(time > 0){
                cell.detailTextLabel.font = [cell.textLabel.font fontWithSize:24];
                cell.detailTextLabel.text = intervalString;}
            else{
                
                //cell.detailTextLabel.font = [cell.detailTextLabel.font fontWithSize:24];
                cell.detailTextLabel.text = @"00:05:00";
                [UIView animateWithDuration:0.1f delay:0 options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction) animations:^{
                    [UIView setAnimationRepeatCount:10];
                    cell.alpha = 0;
                } completion: ^(BOOL finished) {
                    cell.hidden = NO;
                    
                    [UIView animateWithDuration:0.1 animations:^{
                        cell.alpha = 1;
                    } completion: ^(BOOL finished) {
                        cell.hidden = NO;
                    }];
                    
                }];
                
            }
        }
    }// end for loop
    }
    // the 15 minute timer has expired.
    else{
        interval = [self.reassess15 timeIntervalSinceNow];
        int time = round(interval);
        div_t h = div(time, 3600); //seconds total, divided by 3600 equals
        int hours = h.quot;         // hours, divided by 60 equals
        div_t m = div(h.rem, 60);   // minutes
        int minutes = m.quot;
        int seconds = m.rem;        // and remainder is seconds
        
        // If the 15 minutes are not up, play the beep-short sound and update the timer in the cell.
        if(time > 0){
            [_audioPlayer play];}
        // otherwise, play the beeping-sound and kill the timer.
        else{
            [self. assess15Timer invalidate];
            [_audioPlayer1 play];
        }
        
        // the next code flashes the 15 minute timer in the view
        
        NSString *intervalString = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
        for(UITableViewCell *cell in [self.tableView visibleCells]){
            NSIndexPath *ip = [self.tableView indexPathForCell:cell];
            if (ip.row == 8){
                if(time >0){
                   // cell.detailTextLabel.font = [cell.detailTextLabel.font fontWithSize:24];
                 cell.detailTextLabel.text = intervalString;
                }
                else{
                    cell.detailTextLabel.font = [cell.detailTextLabel.font fontWithSize:24];
                  cell.detailTextLabel.text = @"00:15:00";
                    [UIView animateWithDuration:0.1f delay:0 options:(UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat) animations:^{
                        [UIView setAnimationRepeatCount:10];
                        cell.alpha = 0;
                    } completion: ^(BOOL finished) {
                        cell.hidden = YES;
                        
                        [UIView animateWithDuration:0.1 animations:^{
                            cell.alpha = 1;
                        } completion: ^(BOOL finished) {
                            cell.hidden = NO;
                        }];
                        
                    }];
                }
            }
        }// end for loop
    }
}
// end of calculateTimer:

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.labels count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Configure the cell
    
    [_taskCategories addObject:indexPath];
    
    cell.textLabel.text = [_labels objectAtIndex:indexPath.row];
    cell.textLabel.font = [cell.textLabel.font fontWithSize:24];
    if(self.outputStrings[indexPath.row]){
        cell.detailTextLabel.text = self.outputStrings[indexPath.row];}
        else{
            cell.detailTextLabel.text = @"";}
    
    // we return the cell with the textLabel.text.  We will set the detailTextLabel.text when a row is clicked on.
    return cell;
}
// Here, we decide what to do based on the indexPath.row of the cell selected
-(void)tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    NSNumber *number = [self.types objectAtIndex:indexPath.row];
    NSInteger index = [number integerValue];
    self.timerType = index;
    
    switch (index) {
        case 0:
        {
            [self enterDate];
        }
            break;
        case 1:
        {
            [self enterDispatch];
        }
            break;
        case 2:
        {
            [self enterContact];
        }
            break;
        case 3:
        {
            [self enterTransport];
        }
            break;
        case 4:
        {
            [self enterHospital];
        }
            break;
        case 5:
        {
            [self enterCleared];
        }
            break;
        case 6:
        {
            [self enterReturnToService];
        }
            break;
        case 7:
        {
            [self check5minuteReassess];
        }
            break;
        case 8:
        {
            [self check15minuteReassess];
        }
            break;
    }
}
#pragma - MARK archive all the data
//save the entered password.
-(BOOL)savePassword
{
    NSString *path = [self passwordArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:self.password toFile:path];
}

-(NSString *)passwordArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"password.archive"];
}

-(BOOL)saveProviderID
{
    NSString *path = [self providerIDArchivePath];
    return [NSKeyedArchiver archiveRootObject:self.providerID toFile:path];
}

-(NSString *)providerIDArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"providerID.archive"];
}

-(BOOL)saveUserSelectedPatientData{
    NSString *path = [self checkedArrayArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:self.checkedArray toFile:path];
}
-(NSString *)checkedArrayArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"checkedArray.archive"];
}

#pragma mark prepareForeSegues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    

    if([segue.identifier isEqualToString:@"patientDataController"]){
        NRCPatientDataTableViewController *destViewController = segue.destinationViewController;
        destViewController.item = self.patientItem;
    }
    if([segue.identifier isEqualToString:@"patientListController"]){
        PatientListTableViewController *destViewController = segue.destinationViewController;
        [[patientItemStore sharedStore]sortByDate:YES];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
        self.patients = [[patientItemStore sharedStore]allItems];
#pragma clang diagnostic pop
        destViewController.patients = self.patients;
        destViewController.medications = [self.medications mutableCopy];
        destViewController.interventions = [self.interventions mutableCopy];
        
    }
    if([segue.identifier isEqualToString:@"assessmentController"]){
        NRCAssessmentViewControllerTableViewController *destViewController = segue.destinationViewController;
        destViewController.patientItem = self.patientItem;
        
       // destViewController.medications = [self.medications mutableCopy];
       // destViewController.interventions = [self.interventions mutableCopy];
    }
    if([segue.identifier isEqualToString:@"toPurchaseViewController"]){
        
    }
    if([segue.identifier isEqualToString:@"presentLogin"]){
        NSLog(@"segue presentLogin");
    }
    if([segue.identifier isEqualToString:@"toTransmit"]){
        NRCEmailTableViewController *destViewController = segue.destinationViewController;
        destViewController.patients = self.patients;
        destViewController.checkedArray = self.checkedArray;
    }
}
# pragma mark unwind segues
-(IBAction)unwindFromLoginViewController:(UIStoryboardSegue *)seque{
    self.isAuthenticated = YES;
}
-(IBAction)unwindFrompatientDataController:(UIStoryboardSegue *)segue{
    NSLog(@"unwind from patientDataController");
    [self playCheckout];
    NRCPatientDataTableViewController *sourceViewController = segue.sourceViewController;
    
    
    self.patientItem = sourceViewController.item;
    // make sure new item gets archived
    BOOL result;
    result = [[patientItemStore sharedStore]saveChanges];
    if(result == false){
        NSLog(@"unwindFrompatientDataController: could not update items.archive");
    }
    // item was added.  Go check to see whether it needs to be written to iCloud
    [self itemAdded];
}
-(IBAction)unwindFromTransmitViewController:(UIStoryboardSegue *)segue{
    NRCEmailTableViewController *sourceViewController = segue.sourceViewController;
    self.checkedArray = sourceViewController.checkedArray;
}

-(IBAction)unwindFromListController:(UIStoryboardSegue *)segue{
    NSLog(@"unwind from List Controller");
    PatientListTableViewController *sourceViewController = segue.sourceViewController;
    self.patientItem = sourceViewController.patientItem;
    // make sure changes get archived
    BOOL result;
    result = [[patientItemStore sharedStore]saveChanges];
    if(result == false){
        NSLog(@"unwindFromListController: could not update items.archive");
    }
    // check for iCloud
    [self itemModified];
}

-(IBAction)unwindFromAssessmentController:(UIStoryboardSegue *)segue{
    NSLog(@"unwind from assessment controller");
    NRCAssessmentViewControllerTableViewController *sourceViewController = segue.sourceViewController;
    self.assessmentItem = sourceViewController.assessmentItem;
    if(!self.assessments){
        self.assessments = [[NSMutableArray alloc]init];
    }
    NSDate *assessmentTime = [NSDate date];
    self.assessmentItem.assessmentTime = assessmentTime;
    [self.assessments addObject:self.assessmentItem];
    if(!self.patientItem){
        self.patientItem = [[patientItem alloc]init];
    }
    [self.patientItem.assessments addObject:self.assessmentItem];
    
    // check for iCloud
    [self itemModified];
}

-(IBAction)unwindFromPurchase:(UIStoryboardSegue*)segue{
    [self enablePurchase];
}
-(IBAction)unwindFromLogin:(UIStoryboardSegue *)segue{
    self.isAuthenticated = true;
}
// this method lets the user enter patient data.
// an alert is displayed asking the user whether they want to enter patient data.  If they touch on "OK" the block calls addNewItem to create a new patient item and then segues to the patient datatable view controller.

-(void)enterPatientData{
    
    // check for iCloud and Central Administration.
    [self refresh];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Enter Patient Data?"
                                  message:@"Do you want to enter patient data? CAUTION: see HIPAA regulations."
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   //Do Some action here
                                                   self.providerID = [[NSUserDefaults standardUserDefaults]valueForKey:@"providerID"];
                                                   [self addNewItem];
                                                
                                                   [self performSegueWithIdentifier:@"patientDataController" sender:self];

                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       self.patientItem = nil;
                                                       
                                                   }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)displayData:(id)sender {
    // check for iCloud, and if on, reload any new notes.
    /*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL iCloudEnabled = [[defaults valueForKey:@"iCloudEnabled"]boolValue];
     */
    [self refresh];
    if(self.iCloudActivated == YES){
    [self loadNotes];
    }
    
    [self performSegueWithIdentifier:@"patientListController" sender:self];

}

// create a new patient item
-(void)addNewItem{
    self.patientItem = [[patientItemStore sharedStore]createItem];
    self.patientItem.contactTime = [NSDate date];
    // must save provider ID in the patient Item because we demand it to be re-entered when stop working with this patient.
    self.patientItem.providerID = self.providerID;
    if(!self.patientItem.assessments){
        self.patientItem.assessments = [[NSMutableArray alloc]init];
    }
    if(!self.patientItem.itemKey){
        NSUUID *uuid = [[NSUUID alloc]init];
        NSString *key = [uuid UUIDString];
        self.patientItem.itemKey = key;
    }
    
}
#pragma mark - patient item added. 
-(void)itemAdded{
    
    // CHECK FOR ICLOUD IN SETTINGS BUNDLE
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL iCloudEnabled = [[defaults valueForKey:@"iCloudEnabled"]boolValue];
    if(iCloudEnabled ==YES){
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyMMdd_hhmmss"];
    
    NSString *fileName = [NSString stringWithFormat:@"Note_%@",
                          [formatter stringFromDate:[NSDate date]]];
    
    NSURL *ubiq = [[NSFileManager defaultManager]
                   URLForUbiquityContainerIdentifier:nil];
    NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:@"Documents"]
                                URLByAppendingPathComponent:fileName];
        if(ubiq){
    Note *doc = [[Note alloc]initWithFileURL:ubiquitousPackage];
    self.doc = doc;
    doc.patient = self.patientItem;
    [doc saveToURL:[doc fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
        if (success){
            [self.notes addObject:doc];
        }
    }];
        }
    }
}
-(void)itemModified{
    
    // using iCloud, we must signal iCloud that the patient item has been modified
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL iCloudEnabled = [[defaults valueForKey:@"iCloudEnabled"]boolValue];
    if(iCloudEnabled == YES){
    self.doc.patient = self.patientItem;
        [self.doc updateChangeCount:UIDocumentChangeDone];}
}
#pragma mark- iCloud implementation
-(void)queryDidFinishGathering:(NSNotification *)notification{
    
    NSMetadataQuery *query = [notification object];
    [query disableUpdates];
    [query stopQuery];
    
    [self loadData:query];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSMetadataQueryDidFinishGatheringNotification object:query];
    
    self.query = nil;
}

// load any new notes from iCloud
-(void)loadNotes{
    
    NSURL *ubiq = [[NSFileManager defaultManager]
                   URLForUbiquityContainerIdentifier:nil];
    
    if(ubiq){
        self.query = [[NSMetadataQuery alloc]init];
        [self.query setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K like 'Note_*'", NSMetadataItemFSNameKey];
        [self.query setPredicate:pred];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryDidFinishGathering:) name:NSMetadataQueryDidFinishGatheringNotification object:self.query];
        
        [self.query startQuery];
    }else{
        NSLog(@"No iCloud access");
    }
}
-(void)loadData:(NSMetadataQuery *)query{
    
    [self.notes removeAllObjects];
    
    if(!self.notes){
        self.notes = [[NSMutableArray alloc]init];
    }
    
    
    for(NSMetadataItem *item in [query results]){
       
        NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
        Note *doc = [[Note alloc]initWithFileURL:url];
        
        [doc openWithCompletionHandler:^(BOOL success){
            if(success){
                
                [self.notes addObject:doc];
            }else{
                NSLog(@"Failed to open from iCloud");
            }
        }];
    }
}
// control comes here when notification "noteModified" is received.
-(void)dataReloaded:(NSNotification *)notification{
    // get the note doc that was received
    self.doc = notification.object;
    // get patient item from the note doc
    self.patientItem = self.doc.patient;
   // NSLog(@"dataReloaded patientItem:%@",self.patientItem);
    // look for the patient item in patientItemStore. If found, call itemReplace to replace it. If not found, call addItem to add it to patient item store.
    if(self.patientItem){
        patientItem *item;
        BOOL itemFound = NO;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
        NSMutableArray *items = [[patientItemStore sharedStore]allItems];
#pragma clang diagnostic pop
        for(item in items){
           // NSLog(@"item contact time =%@, self.patientItem contact time=%@",item.contactTime, self.patientItem.contactTime);
            if([item.contactTime isEqualToDate:self.patientItem.contactTime]){
                itemFound = YES;
                [[patientItemStore sharedStore]itemReplace:item with:self.patientItem];
                break;
            }
        }
        if(itemFound == NO){
            [[patientItemStore sharedStore]addItem:self.patientItem];
        }
    }
    
}
@end
