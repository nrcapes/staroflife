//
//  NRCDisplayDataTableViewController.m
//  EMSTimers
//
//  Created by Nelson Capes on 1/16/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//
// This controller is called by segue from the PatientListTableViewController. It displays a patient data table that consists of cells
// with patient data. It segues to the AssessmentListTableViewController to display this patient's assessments. On return, it unwinds a segue "unwindToListView" back to the PatientListTableViewController.

#import "NRCDisplayTableViewController.h"
#import "patientItem.h"
#import "patientItemStore.h"


#import "AssessmentListTableViewController.h"
@class NRCAssessmentViewControllerTableViewController;
@interface NRCDisplayTableViewController ()

@end

@implementation NRCDisplayTableViewController
- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Display Data";
    }
        return self;
    }
- (void)viewDidLoad {
    [super viewDidLoad];
    self.firstName = @"";
    self.middleName =@"";
    self.lastName = @"";
    self.dateOfBirth = @"";
    self.gender = @"";
    self.streetAddress = @"";
    self.streetAddress2 = @"";
    self.cityAddress = @"";
    self.stateAddress = @"";
    self.zipCode = @"";
    self.phoneNumber = @"";
    self.venue = @"";
    self.event = @"";
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!self.item.fullName){
        [self buildFullName];
    }
    [self setTitle:self.item.fullName];
}
-(void)buildFullName{
    NSString *fullName = [NSString stringWithString:self.item.firstName];
    if(!self.item.firstName){
        self.item.firstName =@"John";
    }
    fullName = [fullName stringByAppendingString:@" "];
    if(!self.item.middleName){
        self.item.middleName =@" ";
    }
    fullName = [fullName stringByAppendingString:self.item.middleName];
    fullName = [fullName stringByAppendingString:@" "];
    if(!self.item.lastName){
        self.item.lastName =@" ";
    }
    fullName = [fullName stringByAppendingString:self.item.lastName];
    self.item.fullName = fullName;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    

}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
- (IBAction)finishedDisplayingData:(id)sender {
    [self performSegueWithIdentifier:@"unwindToListView" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)showAssessments:(id)sender
{
    [self performSegueWithIdentifier:@"assessmentList" sender:self];
}


- (IBAction)assessPatient:(id)sender {
    
    // if the patientItem is nil, then we can't allow the user to enter patient data until they create a patientItem.
    if(!self.item){
        NSLog(@"no patient item");
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"No patient contact data!"
                                      message:@"You must first enter a patient contact time. Press OK to do that."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       
                                                   }];
        
        [alert addAction:ok];
        
        
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        
        // if the patientItem is not nil, we segue to the assessment Controller.
        [self performSegueWithIdentifier:@"assess" sender:self];
    }

}


#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UITextField* tf = nil ;
    // Configure the cell...
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text =@"First Name";
                tf = self.firstNameField = [self makeTextField:self.item.firstName placeholder:@""];
                [cell addSubview:self.firstNameField];
                break;
            case 1:
                tf = self.middleNameField = [self makeTextField:self.item.middleName placeholder:@""];
                cell.textLabel.text = @"Mid. Name";
                [cell addSubview:self.middleNameField];
                break;
            case 2:
                cell.textLabel.text = @"Last Name";
                tf = self.lastNameField = [self makeTextField:self.item.lastName placeholder:@""];
                [cell addSubview:self.lastNameField];
                break;
            case 3:
                cell.textLabel.text = @"Date of Birth";
                tf = self.dateofBirthField = [self makeTextField:self.item.dateOfBirth placeholder:@""];
                [cell addSubview:self.dateofBirthField];
                break;
            case 4:
                cell.textLabel.text = @"Gender";
                tf = self.genderField = [self makeTextField:self.item.gender placeholder:@""];
                [cell addSubview:self.genderField];
                break;
            case 5:
                cell.textLabel.text = @"Address";
                tf = self.streetAddressField = [self makeTextField:self.item.streetAddress placeholder:@""];
                [cell addSubview:self.streetAddressField];
                break;
            case 6:
                cell.textLabel.text = @"Address2";
                tf = self.streetAddress2Field = [self makeTextField:self.item.streetAddress2 placeholder:@"Apt. 25"];
                [cell addSubview:self.streetAddress2Field];
                break;
            case 7:
                cell.textLabel.text =@"City";
                tf = self.cityAddressField = [self makeTextField:self.item.cityAddress placeholder:@""];
                [cell addSubview:self.cityAddressField];
                break;
            case 8:
                cell.textLabel.text = @"State";
                tf = self.stateAddressField = [self makeTextField:self.item.stateAddress placeholder:@""];
                [cell addSubview:self.stateAddressField];
                break;
            case 9:
                cell.textLabel.text =@"Zip Code";
                tf = self.zipCodeField = [self makeTextField:self.item.zipCode placeholder:@""];
                [cell addSubview:self.zipCodeField];
                break;
            case 10:
                cell.textLabel.text = @"Phone #";
                tf = self.phoneNumberField = [self makeTextField:self.item.phoneNumber placeholder:@""];
                [cell addSubview:self.phoneNumberField];
                break;
            case 11:
                cell.textLabel.text =@"Venue";
                tf = self.venueField = [self makeTextField:self.item.venue placeholder:@""];
                [cell addSubview:self.venueField];
                break;
            case 12:
                cell.textLabel.text =@"Event";
                tf = self.eventField = [self makeTextField:self.item.event placeholder:@""];
                [cell addSubview:self.eventField];
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
-(UITextField *)makeTextField:(NSString *)text placeholder:(NSString *)placeholder{
    UITextField *tf = [[UITextField alloc]init];
    tf.placeholder = placeholder;
    tf.text = text;
    tf.autocorrectionType = UITextAutocorrectionTypeNo;
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tf.adjustsFontSizeToFitWidth = YES;
    tf.backgroundColor = [UIColor colorWithRed:0.0f/255 green:125.0f/255 blue:150.0f/255 alpha:0.8f];
    //tf.textColor = [UIColor colorWithRed:56.0f/255 green:84.0f/255 blue:135.0f/255 alpha:1.0f];
    tf.textAlignment = NSTextAlignmentCenter;
    return  tf;
}


-(IBAction)textFieldFinished:(id)sender{

    [sender resignFirstResponder];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.firstNameField){
        self.firstNameField.text = textField.text;
        self.item.firstName = self.firstNameField.text;
    }else if (textField == self.middleNameField){
        self.middleNameField.text =textField.text;
        self.item.middleName = self.middleNameField.text;
    }else if (textField == self.lastNameField){
        self.lastNameField.text= textField.text;
        self.item.lastName = self.lastNameField.text;
    }else if (textField == self.dateofBirthField){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *myLocale = [NSLocale currentLocale];
        NSString *myLocaleID = [myLocale localeIdentifier];
        if([myLocaleID isEqualToString:@"en_US"]){
            dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"MMddyyyy" options:0 locale:myLocale];
            }else{
                if([myLocaleID isEqualToString:@"en_GB"]){
                dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"ddMMyyyy" options:0 locale:myLocale];
                }
                }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSDate * dateFromString = [dateFormatter dateFromString:self.dateofBirthField.text];
        if(!dateFromString){
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Invalid Input" message:@"Only acceptable formats are: MM/dd/yyyy and dd/MM/YYYY." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [av show];
        }else{
        self.dateofBirthField.text = textField.text;
        self.item.dateOfBirth = self.dateofBirthField.text;
        }
    }else if (textField == self.genderField){
        self.genderField.text = textField.text;
        self.item.gender = self.genderField.text;
    }else if (textField == self.streetAddressField) {
        self.streetAddressField.text = textField.text;
        self.item.streetAddress = self.streetAddressField.text;
    }else if (textField == self.streetAddress2Field) {
        self.streetAddress2Field.text = textField.text;
        self.item.streetAddress2 = self.streetAddressField.text;
    }else if (textField == self.streetAddress2Field) {
        self.streetAddress2Field.text = textField.text;
        self.item.streetAddress2 = self.streetAddress2Field.text;
    }else if (textField == self.cityAddressField){
        self.cityAddressField.text = textField.text;
        self.item.cityAddress = self.cityAddressField.text;
    }else if (textField == self.stateAddressField){
        self.stateAddressField.text = textField.text;
        self.item.stateAddress = self.stateAddressField.text;
    }else if (textField == self.zipCodeField){
        self.zipCodeField.text = textField.text;
        self.item.zipCode = self.zipCodeField.text;
    }else if (textField == self.phoneNumberField){
        self.phoneNumberField.text = textField.text;
        self.item.phoneNumber = self.phoneNumberField.text;
    }else if (textField == self.venueField){
        self.venueField.text = textField.text;
        self.item.venue = self.venueField.text;
    }else if (textField == self.eventField){
        self.eventField.text = textField.text;
        self.item.event = self.eventField.text;
    }
}
#pragma clank diagnostic pop

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
        NSArray *items = [[patientItemStore sharedStore] allItems];
        
        patientItem *item = items[indexPath.row];
        
        [[patientItemStore sharedStore] removeItem:item];
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
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"assessmentList"]){
        AssessmentListTableViewController *destViewController = segue.destinationViewController;
        destViewController.assessments = self.item.assessments;
        destViewController.patients = self.patients;
        destViewController.patientItem = self.item;
      //  destViewController.medications = self.medications;
      //  destViewController.interventions = self.interventions;
    }else if ([segue.identifier isEqualToString:@"assess"]){
        NRCAssessmentViewControllerTableViewController *destViewController = segue.destinationViewController;
        destViewController.patientItem = self.item;
    }
}


-(IBAction)unwindFromAssessmentListController:(UIStoryboardSegue *)segue{
    
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
    if(!self.item){
        self.item = [[patientItem alloc]init];
    }
    [self.item.assessments addObject:self.assessmentItem];
}

@end
