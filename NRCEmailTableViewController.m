//
//  NRCEmailTableViewController.m
//  EMSTimers
//
//  Created by Nelson Capes on 1/16/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//
// This controller is called by NRCTableViewController by segue "patientDataController". It creates a view with standard UITableViewCells by custom constructing the subviews
// in each cell. When the user enters data in a cell and hits RETURN, the corresponding patientItem
// receives the data.  This controller constructs the fullName field in the patientItem from the
// user-entered data, calls checkVisibleCells to find out which field was entered, and unwinds a segue  "unwind2ToTableView" to the NRCTableViewController.
//

#import "NRCEmailTableViewController.h"
#import "patientItem.h"
#import "patientItemStore.h"
#import "assessmentItem.h"
#import "iapstore.h"
#import "constants.h"
#import <MessageUI/MessageUI.h>
typedef NS_ENUM(int, row){
    first_name,
    middle_name,
    last_name,
    date_of_birth,
    gender,
    street_address,
    city,
    state,
    zipcode,
    phone,
    venue,
    name_of_event
    
};
@interface NRCEmailTableViewController ()
@property NSInteger prev;

@property NSMutableArray *taskCategories;
@property NSIndexPath *currentCategory;
@property NSNumber* numberIndicator;
@property assessmentItem *assessmentItem;
@end

@implementation NRCEmailTableViewController
- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Email Controller";
    }
        return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    //here we set the maximum number of emails that a user may send without buying an upgrade.
    self.maxEmails = 1;
    /*
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    [storage setBool:YES forKey:kunlimitedEmailsUnlockedKey];
    [storage synchronize];
    */
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Prepare email" message:@"Checkmark the items you want to send" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    self.taskCategories = [NSMutableArray arrayWithCapacity:12];
    self.currentCategory =[[NSIndexPath alloc]init];
    
    
    
    
    _taskCategories = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:0],
                     [NSNumber numberWithInteger:0],
                     [NSNumber numberWithInteger:0],
                     [NSNumber numberWithInteger:0],
                     [NSNumber numberWithInteger:0],
                     [NSNumber numberWithInteger:0],
                     [NSNumber numberWithInteger:0],
                     [NSNumber numberWithInteger:0],
                     [NSNumber numberWithInteger:0],
                     [NSNumber numberWithInteger:0],
                     [NSNumber numberWithInteger:0],
                     [NSNumber numberWithInteger:0],
                     [NSNumber numberWithInteger:0],nil];
    
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"changed item %@", self.item);
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
- (IBAction)finishedEnteringData:(id)sender {
    
    
    [self performSegueWithIdentifier:@"unwindFromEmail" sender:self];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:@"emailSelectionCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithRed:0.0f/255 green:125.0f/255 blue:150.0f/255 alpha:0.6f];
    [_taskCategories addObject:indexPath];
   
    // Configure the cell...
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                
                cell.textLabel.text =@"First Name";
                if([self checkForSelectedUserData:indexPath] == YES){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                
                break;
            case 1:
                cell.textLabel.text = @"Mid. Name";
                if([self checkForSelectedUserData:indexPath] == YES){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                break;
            case 2:
                cell.textLabel.text = @"Last Name";
                if([self checkForSelectedUserData:indexPath] == YES){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                break;
            case 3:
                cell.textLabel.text = @"Date of Birth";
                if([self checkForSelectedUserData:indexPath] == YES){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                break;
            case 4:
                cell.textLabel.text = @"Gender";
                if([self checkForSelectedUserData:indexPath] == YES){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                break;
            case 5:
                cell.textLabel.text = @"Address";
                if([self checkForSelectedUserData:indexPath] == YES){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                break;
            case 6:
                cell.textLabel.text =@"City";
                if([self checkForSelectedUserData:indexPath] == YES){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                break;
            case 7:
                cell.textLabel.text = @"State";
                if([self checkForSelectedUserData:indexPath] == YES){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                break;
            case 8:
                cell.textLabel.text =@"Zip Code";
                if([self checkForSelectedUserData:indexPath] == YES){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                break;
            case 9:
                cell.textLabel.text = @"Phone #";
                if([self checkForSelectedUserData:indexPath] == YES){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                break;
            case 10:
                cell.textLabel.text =@"Venue";
                if([self checkForSelectedUserData:indexPath] == YES){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                break;
            case 11:
                cell.textLabel.text =@"Event";
                if([self checkForSelectedUserData:indexPath] == YES){
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                break;
        }
    }
    
    return cell;
}

    
-(void)tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.currentCategory = indexPath;
    NSInteger catIndex = [_taskCategories indexOfObject:self.currentCategory];
    /*
    if (catIndex == indexPath.row) {
        return;
    }
    */
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:catIndex inSection:0];
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    
    // can't look at the cell for deciding whether to
    // check, because the cell may have been used.
    // need to look at data model.
    
    NSNumber *number = [_checkedArray objectAtIndex:indexPath.row];// was this row previously selected?
    
    if (number == [NSNumber numberWithBool:1]) {// yes, it was previously selected
        newCell.accessoryType =UITableViewCellAccessoryNone;
        self.myValue = false;// so change it to unselected
        number = [NSNumber numberWithBool: self.myValue];
        [_checkedArray replaceObjectAtIndex:indexPath.row withObject:number];
        
    }
    else{ // it was not previously selected
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.myValue = true; // so change it to selected
        number = [NSNumber numberWithBool:self.myValue];
        [_checkedArray replaceObjectAtIndex:indexPath.row withObject:number];
    }
    
    
    
    
    self.currentCategory = [self.taskCategories objectAtIndex:indexPath.row];
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    
    if(oldIndexPath != indexPath){
        return;
    }
    
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        oldCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}
-(BOOL)checkForSelectedUserData:(NSIndexPath *)indexPath{
    
    // checks for whether a row in the tableView has been selected. Called by tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath.
    // if returns YES, then the cell will have its checkmark accessory turned on.
    BOOL decision;
    
    NSNumber *number = [_checkedArray objectAtIndex:indexPath.row];// was this row previously selected?
    
    if (number == [NSNumber numberWithBool:1]) {// yes, it was previously selected
        decision = YES;
    }
    else{ // it was not previously selected
        decision = NO;
    }
    
    return decision;;
}

#pragma  mark - emailData
// handles all emailing of data
- (IBAction)emailData:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.emailActivated = [defaults boolForKey:kunlimitedEmailsUnlockedKey];
    [self checkNumberOfEmailsSent];
   // self.emailActivated = YES;
     self.centralAdmin = [[defaults valueForKey:@"centralAdmin"]boolValue];
        if(self.centralAdmin == NO){
            UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"Email Unavailable" message:@"Central Administration must be enabled in Settings" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok1 = [UIAlertAction actionWithTitle:@"Press any key to continue." style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            }];
            [alert1 addAction:ok1];
            [self presentViewController:alert1 animated:YES completion:nil// Email Subject
             ];
        }
        else{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            BOOL stopEmails = [[defaults valueForKey:@"maximumEmailsExceeded"]boolValue];
            self.unlimitedEmailsUnlocked = [defaults boolForKey:kunlimitedEmailsUnlockedKey];
            if(stopEmails == YES && self.unlimitedEmailsUnlocked == NO){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Email Unavailable" message:@"Unlimited emails are only available with an upgrade" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Press any key to continue." style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                    
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil// Email Subject
                 ];
            }else
        {
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Email?"
                                          message:@"Do you want to email the data? CAUTION: Comply with HIPAA regulations."
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"YES -Enter the email address." style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           
                                                           UITextField *textField = alert.textFields[0];
                                                           NSString *text = textField.text;
                                                           
                                                           self.emailAddress = text;
                                                           NSLog(@"Email address = %@", self.emailAddress);
                                                           NSString *emailTitle = @"Patient Data (confidential)";
                                                           // Email Content
                                                           
                                                           
                                                           [self buildEmail];
                                                           
                                                           
                                                           // _messageBody = @"From EMS Timers Professional!";
                                                           // To address
                                                           _toRecipients = [NSArray arrayWithObject:self.emailAddress];
                                                           
                                                           MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
                                                           mc.mailComposeDelegate = self;
                                                           [mc setSubject:emailTitle];
                                                           [mc setMessageBody:_messageBody isHTML:NO];
                                                           [mc setToRecipients:_toRecipients];
                                                           
                                                           // Present mail view controller on screen
                                                           [self presentViewController:mc animated:YES completion:nil];
                                                           
                                                       }];
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               
                                                               
                                                           }];
            
            
            [alert addAction:ok];
            [alert addAction:cancel];
            
            
            
            
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"Email address?";
                textField.keyboardType = UIKeyboardTypeEmailAddress;
                NSLog(@"Textfield %@",textField);
            }];
            
            [self presentViewController:alert animated:YES completion:nil// Email Subject
             ];
        }
    }
}

#pragma mark - mailComposeController
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            [self checkNumberOfEmailsSent];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
-(void)checkNumberOfEmailsSent{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.numberOfEmailsSent = [defaults integerForKey:@"emailsSent"];
    int value = (int)self.numberOfEmailsSent;
    value += 1;
    self.numberOfEmailsSent = (NSInteger)value;
    [defaults setInteger:self.numberOfEmailsSent forKey:@"emailsSent"];
    NSLog(@"Emails sent = %ld", (long)self.numberOfEmailsSent);
    self.unlimitedEmailsUnlocked = [defaults boolForKey:kunlimitedEmailsUnlockedKey];
    if(self.unlimitedEmailsUnlocked == NO){
        if(self.numberOfEmailsSent >= self.maxEmails){
            NSLog(@"number of emails sent = maxEmails");
            [defaults setBool:YES forKey:@"maximumEmailsExceeded"];
        }
    }
    [defaults synchronize];
}
#pragma mark - buildEmail
-(void)buildEmail{
    #pragma clang diagnostic push
    self.patients = [[patientItemStore sharedStore]allItems];
#pragma clang diagnostic pop
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateIntervalFormatterShortStyle;
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    _messageBody =@"";
    // loop through all patients, building CSV string
    // first, we have to do "deep copying" on the patients array. If we just do: NSMutableArray * localPatients = self.patients,
    // the two arrays will be identical with identical memory addresssesm
    // so any changes we make to localPatients will also change self.patients. We don't want this.
    //
    // we also can't do: NSMutableArray * localPatients = [self.patients copy].
    // Then the two arrays would be at different addresses but the items in the array would point to the same addresses, so again anything we do
    // to the localPatients properties will change those of self.patients.
    // The following technique implements "deep copying" so that each of the
    // properties of localPatients, i.e. patientItem's, will be at completely different memory addresses, so we can change localItems
    // without making any changes to self.patients.
    
    NSMutableArray *localPatients;
    NSData *buffer;
    buffer = [NSKeyedArchiver archivedDataWithRootObject: self.patients];
    localPatients = [NSKeyedUnarchiver unarchiveObjectWithData: buffer];
    
    
    
    
    for(patientItem *item in localPatients)
    {
        self.localItem = item;
        
        // this method call checks the data that the user has selected to
        // send in the email. Any unselected data will be sent as "*".
        [self checkUserSelectedPatientData:self.localItem];
        
        _tempBody = [NSString stringWithFormat:@"\nProvider ID: %@\n",
                     self.localItem.providerID];
        _messageBody = [_messageBody stringByAppendingString:_tempBody];
        // first, put the patient's full name and contact time into the email message body.
        // replace any commas in contact time with semicolon to keep CSV from splitting date/time
        
        NSString *formattedDateString = [dateFormatter stringFromDate:self.localItem.contactTime];
        
        
        
        formattedDateString = [formattedDateString stringByReplacingOccurrencesOfString:@"," withString:@";"];
        _tempBody = [NSString stringWithFormat:@"First name :%@, @Middle name :%@, @Last Name %@, Contact date/time: %@, Venue: %@, Event: %@\n",
                     self.localItem.firstName, self.localItem.middleName, self.localItem.lastName,
                     formattedDateString,
                     self.localItem.venue, self.localItem.event
                     ];
        _messageBody = [_messageBody stringByAppendingString:_tempBody];
        _tempBody = [NSString stringWithFormat:@"DOB: %@, Gender: %@, Address: %@, City: %@, State: %@, Zip: %@, Phone: %@,\n", self.localItem.dateOfBirth, self.localItem.gender, self.localItem.streetAddress, self.localItem.cityAddress, self.localItem.stateAddress, self.localItem.zipCode, self.localItem.phoneNumber];
        _messageBody = [_messageBody stringByAppendingString:_tempBody];
        
        
        // then loop through the assessments and add them.
        self.assessmentsForEmail = item.assessments;
        for(assessmentItem *aItem in self.assessmentsForEmail){
            NSString *assessmentTime = [dateFormatter stringFromDate:aItem.assessmentTime];
            _tempBody = [NSString stringWithFormat:@"Assessment: %@, Systolic BP: %@, Diastolic BP: %@, Pulse: %@, Respirations: %@, SPO2: %@,\n", assessmentTime, aItem.sytolicBloodPressure, aItem.diastolicBloodPressure, aItem.pulse, aItem.respirations, aItem.spO2];
            _messageBody = [_messageBody stringByAppendingString:_tempBody];
            _tempBody = [NSString stringWithFormat:@"Chief compl: %@, Clin. Impr: %@, Med. Hist:%@, Curr. Meds: %@, Allergies: %@,",
                         aItem.chiefComplaint, aItem.clinicalImpression, aItem.medicalHistory, aItem.currentMedications, aItem.allergies];
            _messageBody = [_messageBody stringByAppendingString:_tempBody];
            _tempBody = [NSString stringWithFormat:@"MOI/NOI: %@, Treatments: %@\n\n",aItem. mechanismOfInjury, aItem.treatments];
            _messageBody = [_messageBody stringByAppendingString:_tempBody];
            _tempBody = [NSString stringWithFormat:@"Narrative: %@, \n\n", aItem.narrative];
            _messageBody = [_messageBody stringByAppendingString:_tempBody];
        }
    }
}
-(void)checkUserSelectedPatientData:(patientItem *)item{
    BOOL myValue = 0;
    NSNumber *number;
    NSNumber *number1;
    number = [NSNumber numberWithBool: myValue];
    number1 = self.checkedArray[first_name];
    if(number1 == number){
        item.firstName = @"******";
    }
    number1 = self.checkedArray[middle_name];
    if(number1 == number){
        item.middleName = @"*****";
    }
    number1 = self.checkedArray[last_name];
    if(number1 == number){
        item.lastName = @"*******";
    }
    number1 = self.checkedArray[date_of_birth];
    if(number1 == number){
        item.dateOfBirth = @"********";
    }
    number1 = self.checkedArray[gender];
    if(number1 == number){
        item.gender = @"**";
    }
    number1 = self.checkedArray[street_address];
    if(number1 == number){
        item.streetAddress = @"***********************";
    }
    number1 = self.checkedArray[city];
    if(number1 == number){
        item.cityAddress = @"******************";
    }
    number1 = self.checkedArray[state];
    if(number1 == number){
        item.stateAddress = @"**";
    }
    number1 = self.checkedArray[zipcode];
    if(number1 == number){
        item.zipCode = @"*****";
    }
    number1 = self.checkedArray[phone];
    if(number1 == number){
        item.phoneNumber = @"**********";
    }
    number1 = self.checkedArray[venue];
    if(number1 == number){
        item.venue = @"*******";
    }
    number1 = self.checkedArray[name_of_event];
    if(number1 == number){
        item.event = @"********";
    }
   // return item;
}
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

    
@end
