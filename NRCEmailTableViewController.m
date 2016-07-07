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
@property NSMutableArray *checkedArray;
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
    
    self.taskCategories = [NSMutableArray arrayWithCapacity:12];
    self.currentCategory =[[NSIndexPath alloc]init];
    
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
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Prepare email" message:@"Checkmark the items you want to send" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
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
    
    [_taskCategories addObject:indexPath];
    
   // tableView.rowHeight = 30.0f;
    UITextField* tf = nil ;
    // Configure the cell...
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                
                cell.textLabel.text =@"First Name";
            
                break;
            case 1:
                cell.textLabel.text = @"Mid. Name";
                
                break;
            case 2:
                cell.textLabel.text = @"Last Name";
                                break;
            case 3:
                cell.textLabel.text = @"Date of Birth";
                
                break;
            case 4:
                cell.textLabel.text = @"Gender";
                
                break;
            case 5:
                cell.textLabel.text = @"Address";
                
                break;
            case 6:
                cell.textLabel.text =@"City";
                                break;
            case 7:
                cell.textLabel.text = @"State";
                
                break;
            case 8:
                cell.textLabel.text =@"Zip Code";
                
                break;
            case 9:
                cell.textLabel.text = @"Phone #";
                                break;
            case 10:
                cell.textLabel.text =@"Venue";
                
                break;
            case 11:
                cell.textLabel.text =@"Event";
                
                break;
        }
    }
    // Textfield dimensions
    tf.frame = CGRectMake(120, 12, 170, 30);
    
    // Workaround to dismiss keyboard when Done/Return is tapped
    [tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    // We want to handle textFieldDidEndEditing
    tf.delegate = self ;
    return cell;
}
-(IBAction)textFieldFinished:(id)sender{

    [sender resignFirstResponder];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
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
    
    NSNumber *number = [_checkedArray objectAtIndex:indexPath.row];
    
    if (number == [NSNumber numberWithBool:0]) {
        newCell.accessoryType =UITableViewCellAccessoryNone;
        self.myValue = false;
        number = [NSNumber numberWithBool: self.myValue];
        [_checkedArray replaceObjectAtIndex:indexPath.row withObject:number];
        
    }
    else{
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        BOOL myValue = 1;
        number = [NSNumber numberWithBool:myValue];
        [_checkedArray replaceObjectAtIndex:indexPath.row withObject:number];
        self.myValue = true;
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


#pragma  mark - emailData
- (IBAction)emailData:(id)sender {
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // self.centralAdminActivated = [defaults boolForKey:@"centralAdmin_unlocked"];
    self.centralAdminActivated = YES;
     self.centralAdmin = [[defaults valueForKey:@"centralAdmin"]boolValue];
    if(self.centralAdminActivated == NO){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Email Unavailable" message:@"The email feature is only available with the Central Administration Upgrade" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Press any key to continue." style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil// Email Subject
         ];
    }
    else{
        //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if(self.centralAdmin == NO){
            UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"Email Unavailable" message:@"Central Administration must be enabled in Settings" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok1 = [UIAlertAction actionWithTitle:@"Press any key to continue." style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            }];
            [alert1 addAction:ok1];
            [self presentViewController:alert1 animated:YES completion:nil// Email Subject
             ];
        }
        else
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
#pragma mark - buildEmail
-(void)buildEmail{
    
    self.patients = [[patientItemStore sharedStore]allItems];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateIntervalFormatterShortStyle;
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    _messageBody =@"";
    // loop through all patients, building CSV string
    for(patientItem *item in self.patients)
    {
        patientItem * localItem;
        _tempBody = [NSString stringWithFormat:@"\nProvider ID: %@\n",
                     item.providerID];
        _messageBody = [_messageBody stringByAppendingString:_tempBody];
        // first, put the patient's full name and contact time into the email message body.
        // replace any commas in contact time with semicolon to keep CSV from splitting date/time
        
        NSString *formattedDateString = [dateFormatter stringFromDate:_item.contactTime];
        
        // this method call checks the data that the user has selected to
        // send in the email. Any unselected data will be sent as "*".
       localItem = [self checkUserSelectedPatientData:item];
        
        formattedDateString = [formattedDateString stringByReplacingOccurrencesOfString:@"," withString:@";"];
        _tempBody = [NSString stringWithFormat:@"First name :%@, @Middle name :%@, @Last Name %@, Contact date/time: %@, Venue: %@, Event: %@\n",
                     localItem.firstName, localItem.middleName, localItem.lastName,
                     formattedDateString,
                     localItem.venue, localItem.event
                     ];
        _messageBody = [_messageBody stringByAppendingString:_tempBody];
        _tempBody = [NSString stringWithFormat:@"DOB: %@, Gender: %@, Address: %@, City: %@, State: %@, Zip: %@, Phone: %@,\n", localItem.dateOfBirth, localItem.gender, localItem.streetAddress, localItem.cityAddress, localItem.stateAddress, localItem.zipCode, localItem.phoneNumber];
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
-(patientItem *)checkUserSelectedPatientData:(patientItem *)item{
    BOOL myValue = 0;
    NSNumber *number;
    NSNumber *number1;
    number = [NSNumber numberWithBool: myValue];
    number1 = self.checkedArray[0];
    if(number1 == number){
        item.firstName = @"*";
    }
    return item;
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
