//
//  NRCAssessmentViewControllerTableViewController.m
//  EMSTimers
//
//  Created by Nelson Capes on 2/2/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//
// This controller is called from NRCTableViewController when the "Assess" button in the toolbar is clicked. It lets the user input the various fields in the assessmentItem. When the Medical History button in the toolbar is clicked, it segues to NRCMedicalHistoryTableViewController by segue "toMedicalHistory", passing it an assessmentItem and a patientItem. When the DONE button in the navigation bar is clicked, it unwinds a segue "unwind3ToTableView" to NRCTableViewController.

#import "NRCAssessmentViewControllerTableViewController.h"
#import "assessmentItem.h"
#import "NRCMedicalHistoryTableViewController.h"
typedef NS_ENUM(int, row){
    systolic_pressure,
    diastolic_pressure,
    pulse,
    respiration,
    pulseox
};
@interface NRCAssessmentViewControllerTableViewController ()

@end

@implementation NRCAssessmentViewControllerTableViewController
-(instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if(self){
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Assessment Data";
    }
    return  self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sytolicBloodPressure.delegate =self;
    self.diastolicBloodPressure.delegate =self;
    self.pulse.delegate = self;
    self.respirations.delegate = self;
    self.spO2.delegate = self;
    self.assessmentItem = [[assessmentItem alloc]init];
    [self.navigationItem setHidesBackButton:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setTitle:self.patientItem.fullName];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
};
-(BOOL)canBecomeFirstResponder{
    
    return YES;
}
- (IBAction)finishedEnteringData:(id)sender {
    
    
    
    
    
    [self performSegueWithIdentifier:@"unwind3ToTableView" sender:self];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (IBAction)toMedicalHistory:(id)sender {
    [self performSegueWithIdentifier:@"toMedicalHistory" sender:self];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}




- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 20; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    UITextField* tf = nil ;
    // Configure the cell...
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text =@"Systolic BP";
                tf = self.sytolicBloodPressure = [self makeTextField:self.assessmentItem.sytolicBloodPressure placeholder:@"120"];
                [cell addSubview:self.sytolicBloodPressure];
                break;
            case 1:
                cell.textLabel.text = @"Diastolic BP";
                tf = self.diastolicBloodPressure = [self makeTextField:self.assessmentItem.diastolicBloodPressure placeholder:@"80"];
                
                [cell addSubview:self.diastolicBloodPressure];
                break;
            case 2:
                cell.textLabel.text = @"Pulse";
                tf = self.pulse = [self makeTextField:self.assessmentItem.pulse placeholder:@"70"];
                [cell addSubview:self.pulse];
                break;
            case 3:
                cell.textLabel.text = @"Respiration";
                tf = self.respirations = [self makeTextField:self.assessmentItem.respirations placeholder:@"12"];
                [cell addSubview:self.respirations];
                break;
            case 4:
                cell.textLabel.text = @"SPO2";
                tf = self.spO2 = [self makeTextField:self.assessmentItem.spO2 placeholder:@"95"];
                [cell addSubview:self.spO2];
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
    tf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    return  tf;
}
-(IBAction)textFieldFinished:(id)sender{
    NSDate *date = [NSDate date];
    self.assessmentItem.assessmentTime = date;
    [sender resignFirstResponder];
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self animateTextField: textField up: NO];
    int value = [textField.text integerValue];
    if (textField == self.sytolicBloodPressure){
        BOOL isValid = [self verifyRange:0 highValue:300 value:value];
        if(isValid == YES || [textField.text  isEqual:@""]){
        self.sytolicBloodPressure.text = textField.text;
        self.assessmentItem.sytolicBloodPressure = self.sytolicBloodPressure.text;
        }else{
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Input invalid" message:@"Range: 0 to 300" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            [av show];
        }
    }else if (textField == self.diastolicBloodPressure){
        BOOL isValid = [self verifyRange:0 highValue:150 value:value];
        if(isValid == YES || [textField.text  isEqual:@""]){
        self.diastolicBloodPressure.text =textField.text;
        self.assessmentItem.diastolicBloodPressure = self.diastolicBloodPressure.text;
        }else{
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Input invalide" message:@"Range: 0 to 150" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            [av show];
        }
    }else if (textField == self.pulse){
        BOOL isValid = [self verifyRange:0 highValue:120 value:value];
        if(isValid == YES || [textField.text  isEqual:@""]){
        self.pulse.text= textField.text;
        self.assessmentItem.pulse = self.pulse.text;
        }else{
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Input invalid" message:@"Range: 0 to 120" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            [av show];
        }
    }else if (textField == self.respirations){
        BOOL isValid = [self verifyRange:0 highValue:100 value:value];
        if(isValid == YES || [textField.text  isEqual:@""]){
        self.respirations.text = textField.text;
        self.assessmentItem.respirations = self.respirations.text;
        }else{
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Input invalied" message:@"Range: 0 100" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            [av show];
        }
    }else if (textField == self.spO2){
        BOOL isValid = [self verifyRange:0 highValue:100 value:value];
        if(isValid == YES || [textField.text  isEqual:@""]){
        self.spO2.text = textField.text;
        self.assessmentItem.spO2 = self.spO2.text;
        }else{
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Input invalid" message:@"Please verify!" delegate:self cancelButtonTitle:@"Range: 0 to 100" otherButtonTitles: nil];
            [av show];
        }
        }
}
#pragma clang diagnostic pop

-(BOOL)verifyRange:(int)lowValue highValue:(int)highValue value:(int)value{
    if(value >= lowValue && value <=highValue){
        return YES;
    }
    return NO;
}

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
    if([segue.identifier isEqualToString:@"toMedicalHistory"])
    {
        NRCMedicalHistoryTableViewController *destViewController = segue.destinationViewController;
        destViewController.item = self.assessmentItem;
        destViewController.patientItem = self.patientItem;
     //   destViewController.medications = self.medications;
      //  destViewController.interventions = self.interventions;
    }
}
-(IBAction)unwindFromMedicalHistory:(UIStoryboardSegue *)segue{
    NSLog(@"unwind from medical history");
    NRCMedicalHistoryTableViewController *sourceController = segue.sourceViewController;
    self.assessmentItem = sourceController.item;
    self.patientItem = sourceController.patientItem;
}

@end
