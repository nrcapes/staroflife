//
//  NRCAssessmentDisplayTableViewController.m
//  EMSTimers
//
//  Created by Nelson Capes on 2/2/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import "NRCAssessmentDisplayTableViewController.h"
#import "assessmentItem.h"
@interface NRCAssessmentDisplay
TableViewController ()

@end

@implementation NRCAssessmentDisplayTableViewController
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
};
-(BOOL)canBecomeFirstResponder{
    
    return YES;
}
- (IBAction)finishedEnteringData:(id)sender {
    [self performSegueWithIdentifier:@"unwindFromAssessmentDisplay" sender:self];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewStyleGrouped reuseIdentifier:nil];
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
    tf.textColor = [UIColor colorWithRed:56.0f/255 green:84.0f/255 blue:135.0f/255 alpha:1.0f];
    tf.textAlignment = NSTextAlignmentCenter;
    return  tf;
}
-(IBAction)textFieldFinished:(id)sender{
    NSDate *date = [NSDate date];
    self.assessmentItem.assessmentTime = date;
    [sender resignFirstResponder];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.sytolicBloodPressure){
        self.sytolicBloodPressure.text = textField.text;
        self.assessmentItem.sytolicBloodPressure = self.sytolicBloodPressure.text;
    }else if (textField == self.diastolicBloodPressure){
        self.diastolicBloodPressure.text =textField.text;
        self.assessmentItem.diastolicBloodPressure = self.diastolicBloodPressure.text;
    }else if (textField == self.pulse){
        self.pulse.text= textField.text;
        self.assessmentItem.pulse = self.pulse.text;
    }else if (textField == self.respirations){
        self.respirations.text = textField.text;
        self.assessmentItem.respirations = self.respirations.text;
    }else if (textField == self.spO2){
        self.spO2.text = textField.text;
        self.assessmentItem.spO2 = self.spO2.text;
        }
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
    // Return NO if you do not want the asssessmentItem to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
