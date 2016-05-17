//
//  NRCPatientDataTableViewController.m
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

#import "NRCPatientDataTableViewController.h"
#import "patientItem.h"
#import "patientItemStore.h"
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
@interface NRCPatientDataTableViewController ()

@end

@implementation NRCPatientDataTableViewController
- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Patient Data";
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
    self.cityAddress = @"";
    self.stateAddress = @"";
    self.zipCode = @"";
    self.phoneNumber = @"";
    self.venue =@"";
    self.event =@"";
    [self.navigationItem setHidesBackButton:YES animated:YES];
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"new item %@", self.item);
    [self setTitle:self.item.fullName];
    
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
    // if the first name is blank we must substitute "John" for it. Then we build the fullName
    // from the first, middle, and lastname fields.
    if(!self.item.firstName){
        self.item.firstName =@"John";
    }
    NSString *fullName = [NSString stringWithString:self.item.firstName];
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
    [self checkVisibleCells];
    
    [self performSegueWithIdentifier:@"unwind2ToTableView" sender:self];
}
#pragma mark - assessPatient
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
        [self performSegueWithIdentifier:@"assessmentController" sender:self];
    }
    
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
                                                  reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   // tableView.rowHeight = 30.0f;
    UITextField* tf = nil ;
    // Configure the cell...
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text =@"First Name";
                tf = self.firstNameField = [self makeTextField:self.item.firstName placeholder:@"John" type_of_text:(first_name)];
                [cell addSubview:self.firstNameField];
                break;
            case 1:
                tf = self.middleNameField = [self makeTextField:self.middleName placeholder:@"P" type_of_text:(middle_name)];
                cell.textLabel.font = [cell.textLabel.font fontWithSize:19];
                cell.textLabel.text = @"Mid. Name";
                [cell addSubview:self.middleNameField];
                break;
            case 2:
                cell.textLabel.text = @"Last Name";
                tf = self.lastNameField = [self makeTextField:self.item.lastName placeholder:@"Appleseed" type_of_text:(last_name)];
                [cell addSubview:self.lastNameField];
                break;
            case 3:
                cell.textLabel.text = @"Date of Birth";
                tf = self.dateofBirthField = [self makeTextField:self.item.dateOfBirth placeholder:@"10/27/1946" type_of_text:(date_of_birth)];
                [cell addSubview:self.dateofBirthField];
                break;
            case 4:
                cell.textLabel.text = @"Gender";
                tf = self.genderField = [self makeTextField:self.item.gender placeholder:@"M" type_of_text:(gender)];
                [cell addSubview:self.genderField];
                break;
            case 5:
                cell.textLabel.text = @"Address";
                tf = self.streetAddressField = [self makeTextField:self.item.streetAddress placeholder:@"2 Robbins Road" type_of_text:(street_address)];
                [cell addSubview:self.streetAddressField];
                break;
            case 6:
                cell.textLabel.text =@"City";
                tf = self.cityAddressField = [self makeTextField:self.item.cityAddress placeholder:@"Boston" type_of_text:(city)];
                [cell addSubview:self.cityAddressField];
                break;
            case 7:
                cell.textLabel.text = @"State";
                tf = self.stateAddressField = [self makeTextField:self.item.stateAddress placeholder:@"MA" type_of_text:(state)];
                [cell addSubview:self.stateAddressField];
                break;
            case 8:
                cell.textLabel.text =@"Zip Code";
                tf = self.zipCodeField = [self makeTextField:self.item.zipCode placeholder:@"02174" type_of_text:(zipcode)];
                [cell addSubview:self.zipCodeField];
                break;
            case 9:
                cell.textLabel.text = @"Phone #";
                tf = self.phoneNumberField = [self makeTextField:self.item.phoneNumber placeholder:@"617-000-000" type_of_text:(phone)];
                [cell addSubview:self.phoneNumberField];
                break;
            case 10:
                cell.textLabel.text =@"Venue";
                tf = self.venueField = [self makeTextField:self.item.venue placeholder:@"Venue" type_of_text:(venue)];
                [cell addSubview:self.venueField];
                break;
            case 11:
                cell.textLabel.text =@"Event";
                tf = self.eventField = [self makeTextField:self.item.event placeholder:@"Event" type_of_text:(name_of_event)];
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
#pragma mark makeTextField
-(UITextField *)makeTextField:(NSString *)text placeholder:(NSString *)placeholder type_of_text:(NSInteger)type_of_text{
    UITextField *tf = [[UITextField alloc]init];
    tf.placeholder = placeholder;
    tf.text = text;
    tf.autocorrectionType = UITextAutocorrectionTypeNo;
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tf.adjustsFontSizeToFitWidth = YES;
    tf.backgroundColor = [UIColor colorWithRed:0.0f/255 green:125.0f/255 blue:150.0f/255 alpha:0.8f];
    //tf.textColor = [UIColor colorWithRed:56.0f/255 green:84.0f/255 blue:135.0f/255 alpha:1.0f];
    tf.textAlignment = NSTextAlignmentCenter;
    
    if(type_of_text == first_name){
        [tf setKeyboardType:UIKeyboardTypeDefault];
    }else
    if(type_of_text == middle_name){
        [tf setKeyboardType:UIKeyboardTypeDefault];
    }else
    if(type_of_text == last_name){
        [tf setKeyboardType:UIKeyboardTypeDefault];
    }else
    if(type_of_text == date_of_birth){
        [tf setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    }else
    if(type_of_text == gender){
        [tf setKeyboardType:UIKeyboardTypeDefault];
    }else
    if(type_of_text == street_address){
        [tf setKeyboardType:UIKeyboardTypeDefault];
    }else
    if(type_of_text == city){
        [tf setKeyboardType:UIKeyboardTypeDefault];
    }else
    if(type_of_text == state){
        [tf setKeyboardType:UIKeyboardTypeDefault];
    }else
    if(type_of_text == zipcode){
        [tf setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    }else
    if(type_of_text == phone){
        [tf setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    }else
    if(type_of_text == venue){
        [tf setKeyboardType:UIKeyboardTypeDefault];
    }else
    if(type_of_text == name_of_event){
        [tf setKeyboardType:UIKeyboardTypeDefault];
    }
    return  tf;
}
-(IBAction)textFieldFinished:(id)sender{

    [sender resignFirstResponder];
}
#pragma mark - error checking
-(BOOL)isNumericOrDash:(NSString *)inputString{
    
    BOOL isValid = NO;
    
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789-"];
    for (int i = 0; i < [inputString length]; i++) {
        unichar c = [inputString characterAtIndex:i];
        if (![myCharSet characterIsMember:c]) {
            isValid = NO;
            break;
        }else{
            isValid = YES;
        }
    }
    return isValid;
}
-(BOOL)isNumericOrSlash:(NSString *)inputString{
    
    BOOL isValid = NO;
    
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789/"];
    for (int i = 0; i < [inputString length]; i++) {
        unichar c = [inputString characterAtIndex:i];
        if (![myCharSet characterIsMember:c]) {
            isValid = NO;
            break;
        }else{
            isValid = YES;
        }
    }
    return isValid;
}
-(BOOL)isNumeric:(NSString *)inputString{
    
    BOOL isValid = NO;
    
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [inputString length]; i++) {
        unichar c = [inputString characterAtIndex:i];
        if (![myCharSet characterIsMember:c]) {
            isValid = NO;
            break;
        }else{
            isValid = YES;
        }
    }
    return isValid;
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
        if([self isNumericOrSlash:textField.text] == NO && ![textField.text  isEqual:@""]){
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Invalid Input" message:@"Only acceptable format is numeric and /." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [av show];
        }else{
            self.dateofBirthField.text = textField.text;
            self.item.dateOfBirth = self.dateofBirthField.text;
        }
    }else if (textField == self.genderField){
        if([textField.text isEqualToString:@"M" ]  || ([textField.text isEqualToString:@"F"] && ![textField.text  isEqual:@""])){
        self.genderField.text = textField.text;
        self.item.gender = self.genderField.text;
        }else{
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Invalid Input" message:@"Only 'M', or 'F' is allowed." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [av show];
        }
    }else if (textField == self.streetAddressField) {
        self.streetAddressField.text = textField.text;
        self.item.streetAddress = self.streetAddressField.text;
    }else if (textField == self.cityAddressField){
        self.cityAddressField.text = textField.text;
        self.item.cityAddress = self.cityAddressField.text;
    }else if (textField == self.stateAddressField){
        self.stateAddressField.text = textField.text;
        self.item.stateAddress = self.stateAddressField.text;
    }else if (textField == self.zipCodeField){
        if([self isNumericOrDash:textField.text ] == NO && ![textField.text  isEqual:@""]){
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Invalid Input" message:@"Only acceptable format is numeric and dash." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [av show];}
        self.zipCodeField.text = textField.text;
        self.item.zipCode = self.zipCodeField.text;
    }else if (textField == self.phoneNumberField){
        if([self isNumericOrDash:textField.text] == NO && ![textField.text  isEqual:@""]){
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Invalid Input" message:@"Only acceptable format is numeric and dash." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [av show];}
        else{
        self.phoneNumberField.text = textField.text;
        self.item.phoneNumber = self.phoneNumberField.text;
        }
    }else if (textField == self.venueField){
        self.venueField.text = textField.text;
        self.item.venue = self.venueField.text;
    }else if (textField == self.eventField){
        self.eventField.text = textField.text;
        self.item.event = self.eventField.text;
    }
    }
-(void)checkVisibleCells{
    for(UITableViewCell *cell in [self.tableView visibleCells])
    {
        NSIndexPath *ip = [self.tableView indexPathForCell:cell];
        switch (ip.row) {
            case 0:{
                self.textView = [cell viewWithTag:1];
                self.firstName = self.textView.text;
                break;}
            case 1:{
                self.textView = [cell viewWithTag:1];
                self.middleName = self.textView.text;
                break;}
            case 2:{
                self.textView = [cell viewWithTag:1];
                self.lastName = self.textView.text;
                break;}
            case 3:{
                self.textView = [cell viewWithTag:1];
                self.dateOfBirth = self.textView.text;
                break;}
            case 4:{
                self.textView = [cell viewWithTag:1];
                self.gender = self.textView.text;
                break;}
            case 5:{
                self.textView = [cell viewWithTag:1];
                self.streetAddress = self.textView.text;
                break;}
            case 6:{
                self.textView = [cell viewWithTag:1];
                self.cityAddress = self.textView.text;
                break;}
            case 7:{
                self.textView = [cell viewWithTag:1];
                self.stateAddress = self.textView.text;
                break;}
            case 8:{
                self.textView = [cell viewWithTag:1];
                self.zipCode = self.textView.text;
                break;}
            case 9:{
                self.textView = [cell viewWithTag:1];
                self.phoneNumber = self.textView.text;
                break;}
            case 10:{
                self.textView = [cell viewWithTag:1];
                self.venue = self.textView.text;
                break;}
            case 11:{
                self.textView = [cell viewWithTag:1];
                self.event = self.textView.text;
                break;
            }
                
        }
    }

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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view contrller.
    
    if([segue.identifier isEqualToString:@"assessmentController"]){
        NRCAssessmentViewControllerTableViewController *destViewController = segue.destinationViewController;
        destViewController.patientItem = self.item;
    }
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
    self.item.narrative = self.assessmentItem.narrative;
}
@end
