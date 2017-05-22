//
//  NRCMedicalHistoryDisplayTableViewController.m
//  EMSTimers
//
//  Created by Nelson Capes on 2/13/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//
// This controller is called by segue from NRCAssessmentDisplayTableViewController. It segues to NRCMedicalHistoryItemTableViewController by segue "toZoom" when the user clicks on a row, passing the tableViewCell to be zoomed in on in self.cellToZoom. On return, it puts the item field from celltoZoom into the corresponding assessmentItem field. When the DONE button in navigation bar is clicked, it performs an unwindsegue "unwindToAssessmentDisplay" back to the NRCAssessmentDisplayTableViewController.

#import "NRCMedicalHistoryDisplayTableViewController.h"
#import "NRCMedicalHistoryItemTableViewController.h"
@interface NRCMedicalHistoryDisplayTableViewController ()

@end

@implementation NRCMedicalHistoryDisplayTableViewController

- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Medical History Display";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.chiefComplaint.text = @"";
    self.clinicalImpression.text =@"";
    self.medicalHistory.text = @"";
    self.currentMedications.text = @"";
    self.allergies.text = @"";
    self.mechanismOfInjury.text = @"";
    self.treatments.text = @"";
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setTitle:self.patientItem.fullName];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
- (IBAction)finishedDisplayingData:(id)sender {
    [self performSegueWithIdentifier:@"unwindToAssessmentDisplay" sender:self];
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
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITextField* tf = nil ;
    // Configure the cell...
    if(indexPath.section == 0){
        switch (indexPath.row) {
            case 0:{
                cell.textLabel.font = [cell.textLabel.font fontWithSize:19];
                cell.textLabel.text =@"Chief Complaint";
                tf = self.chiefComplaint = [self makeTextField:self.item.chiefComplaint placeholder:@""];
                [cell addSubview:self.chiefComplaint];
            }
                break;
            case 1:{
                tf = self.clinicalImpression = [self makeTextField:self.item.clinicalImpression placeholder:@""];
                cell.textLabel.font = [cell.textLabel.font fontWithSize:19];
                cell.textLabel.text = @"Clin. Impression";
                [cell addSubview:self.clinicalImpression];
            }
                break;
            case 2:{
                cell.textLabel.font = [cell.textLabel.font fontWithSize:19];
                cell.textLabel.text = @"Med. History";
                tf = self.medicalHistory = [self makeTextField:self.item.medicalHistory placeholder:@""];
                [cell addSubview:self.medicalHistory];
            }
                break;
            case 3:{
                cell.textLabel.font = [cell.textLabel.font fontWithSize:19];
                cell.textLabel.text = @"Medications";
                tf = self.currentMedications = [self makeTextField:self.item.currentMedications placeholder:@""];
                [cell addSubview:self.currentMedications];
            }
                break;
            case 4:{
                cell.textLabel.font = [cell.textLabel.font fontWithSize:19];
                cell.textLabel.text = @"Allergies";
                tf = self.allergies = [self makeTextField:self.item.allergies placeholder:@""];
                [cell addSubview:self.allergies];
            }
                break;
            case 5:{
                cell.textLabel.font = [cell.textLabel.font fontWithSize:19];
                cell.textLabel.text = @"MOI/NOI";
                tf = self.mechanismOfInjury = [self makeTextField:self.item.mechanismOfInjury placeholder:@""];
                [cell addSubview:self.mechanismOfInjury];
            }
                break;
            case 6:{
                cell.textLabel.font = [cell.textLabel.font fontWithSize:19];
                cell.textLabel.text =@"Treatments";
                tf = self.treatments = [self makeTextField:self.item.treatments placeholder:@""];
                [cell addSubview:self.treatments];
            }
                break;
            case 7:{
                cell.textLabel.font = [cell.textLabel.font fontWithSize:19];
                cell.textLabel.text = @"Narrative";
                tf = self.narrative = [self makeTextField:self.item.narrative placeholder:@""];
                [cell addSubview:self.narrative];
            }
        }
    }
    // Textfield dimensions
    tf.frame = CGRectMake(160, 12, 170, 60);
    
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
    tf.font = [tf.font fontWithSize:12];
    tf.adjustsFontSizeToFitWidth = YES;
    tf.backgroundColor = [UIColor colorWithRed:0.0f/255 green:125.0f/255 blue:150.0f/255 alpha:0.8f];
    //tf.textColor = [UIColor colorWithRed:56.0f/255 green:84.0f/255 blue:135.0f/255 alpha:1.0f];
    tf.textAlignment = NSTextAlignmentCenter;
    tf.tag =1;
    return  tf;
}


-(IBAction)textFieldFinished:(id)sender{
    
    [sender resignFirstResponder];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *temp = [textField.text stringByReplacingOccurrencesOfString:@"," withString:@";"];
    textField.text = temp;
    if (textField == self.chiefComplaint){
        self.chiefComplaint.text = textField.text;
        self.item.chiefComplaint = self.chiefComplaint.text;
    }else if (textField == self.clinicalImpression){
        self.clinicalImpression.text =textField.text;
        self.item.clinicalImpression = self.clinicalImpression.text;
    }else if (textField == self.medicalHistory){
        
        self.medicalHistory.text= textField.text;
        self.item.medicalHistory = self.medicalHistory.text;
    }else if (textField == self.currentMedications){
        
        self.currentMedications.text = textField.text;
        self.item.currentMedications = self.currentMedications.text;
    }else if (textField == self.allergies){
        [textField.text stringByReplacingOccurrencesOfString:@"," withString:@"*"];
        self.allergies.text = textField.text;
        self.item.allergies = self.allergies.text;
    }else if (textField == self.mechanismOfInjury) {
        
        self.mechanismOfInjury.text = textField.text;
        self.item.mechanismOfInjury = self.mechanismOfInjury.text;
    }else if (textField == self.treatments){
        self.treatments.text = textField.text;
        self.item.treatments = self.treatments.text;
    }else if (textField == self.narrative){
        self.narrative.text = textField.text;
        self.item.narrative = self.narrative.text;
    };
}

-(void)tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];{
        // self.patients = [[patientItemStore sharedStore]allItems];
        self.cellToZoom =[tableView cellForRowAtIndexPath:indexPath];
         [self performSegueWithIdentifier:@"toZoom" sender:self];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"toZoom"]){
        NRCMedicalHistoryItemTableViewController *destController =segue.destinationViewController;
        destController.cellToZoom = self.cellToZoom;
        destController.patientItem = self.patientItem;
     //   destController.medications = self.medications;
      //  destController.interventions = self.interventions;
    }
}
-(IBAction)unwindFromZoom:(UIStoryboardSegue *)segue{
    NSLog(@"unwind from Zoom");
    NRCMedicalHistoryItemTableViewController *sourceController = segue.sourceViewController;
    self.cellToZoom = sourceController.cellToZoom;
    NSIndexPath *indexPath =[self.tableView indexPathForCell:self.cellToZoom];
    NSInteger row = indexPath.row;
    //UITextView *textView = [self.cellToZoom viewWithTag:1];
    
switch (row) {
    case 0:
    {
        self.chiefComplaint.text = sourceController.textView.text;
        self.item.chiefComplaint = sourceController.textView.text;
        NSString *temp = [self.item.chiefComplaint stringByReplacingOccurrencesOfString:@"," withString:@";"];
        self.item.chiefComplaint = temp;
        
        break;
    }
    case 1:
    {
        self.clinicalImpression.text = sourceController.textView.text;
        self.item.clinicalImpression = sourceController.textView.text;
        NSString *temp = [self.item.clinicalImpression stringByReplacingOccurrencesOfString:@"," withString:@";"];
        self.item.clinicalImpression = temp;
        break;
    }
    case 2:
    {
        self.medicalHistory.text = sourceController.textView.text;
        self.item.medicalHistory = sourceController.textView.text;
        NSString *temp = [self.item.medicalHistory stringByReplacingOccurrencesOfString:@"," withString:@";"];
        self.item.medicalHistory = temp;
        break;
    }
    case 3:
    {
        self.currentMedications.text = sourceController.textView.text;
        self.item.currentMedications = sourceController.textView.text;
        NSString *temp = [self.item.currentMedications stringByReplacingOccurrencesOfString:@"," withString:@";"];
        self.item.currentMedications = temp;
        break;
    }
    case 4:
    {
        self.allergies.text = sourceController.textView.text;
        self.item.allergies = sourceController.textView.text;
        NSString *temp = [self.item.allergies stringByReplacingOccurrencesOfString:@"," withString:@";"];
        self.item.allergies = temp;
        break;
    }
    case 5:
    {
        self.mechanismOfInjury.text = sourceController.textView.text;
        self.item.mechanismOfInjury = sourceController.textView.text;
        NSString *temp = [self.item.mechanismOfInjury stringByReplacingOccurrencesOfString:@"," withString:@";"];
        self.item.mechanismOfInjury = temp;
        break;
    }
    case 6:
    {
        self.treatments.text = sourceController.textView.text;
        self.item.treatments = sourceController.textView.text;
        NSString *temp = [self.item.treatments stringByReplacingOccurrencesOfString:@"," withString:@";"];
        self.item.treatments = temp;
        break;
    }
    case 7:{
        self.narrative.text = sourceController.textView.text;
        self.item.narrative = sourceController.textView.text;
        NSString *temp = [self.item.narrative stringByReplacingOccurrencesOfString:@"," withString:@";"];
        self.item.narrative = temp;
        break;
    }
}
}

@end
