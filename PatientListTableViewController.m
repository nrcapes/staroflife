//
//  PatientListTableViewController.m
//  EMSTimers
//
//  Created by Nelson Capes on 2/3/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//
// This controller is called by segue from the displayData method in the NRCTableViewController. On viewDidLoad it checks the
// Settings Bundle to see if the passcode enable switch is turned ON.  If so, it calls NRCPasscodeController2ViewController to
// validate the password. If the passcode is validated, this controller displays a tableView of patient contact times.  When the user
// selects a row, this controller calls NRCDisplayDataTableViewController by segue. On return, it unwinds a segue to NRCTableViewController.

#import "PatientListTableViewController.h"
#import "NRCPatientDataTableViewCell.h"
#import "patientItem.h"
#import "patientItemStore.h"
#import "NRCPatientDataTableViewController.h"
#import "NRCDisplayTableViewController.h"
#import "NRCPasscodeController2ViewController.h"
#import "NRCSelectDataTableViewController.h"
@interface PatientListTableViewController ()

@end

@implementation PatientListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    
    BOOL passwordProtect = [[defaults valueForKey:@"password"]boolValue];
    if(passwordProtect)
    {
        self.password = [defaults valueForKey:@"passwordValue"];
        
        NRCPasscodeViewController *passcodeController = [[NRCPasscodeViewController alloc]init];
        passcodeController.delegate = self;
        UINavigationController *passCodeNavigationController = [[UINavigationController alloc]initWithRootViewController:passcodeController];
        [self.navigationController presentViewController:passCodeNavigationController animated:YES completion:nil];
        
       // [self performSegueWithIdentifier:@"passcode2Controller" sender:self];
    }
    
}
-(void)passcodeController:(NRCPasscodeViewController *)controller passcodeEntered:(NSString *)passCode{
    if([passCode isEqualToString:self.password]){
        [controller dismissViewControllerAnimated:YES completion:nil];
    }else{
        [controller resetWithAnimation:NRCPasscodeAnimationStyleInvalid];
    }
}
- (IBAction)finishedListing:(id)sender {
    [self performSegueWithIdentifier:@"unwind4ToTableView" sender:self];
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

    return [[[patientItemStore sharedStore]allItems]count];
    //return [self.patients count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"patientListCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.font = [cell.textLabel.font fontWithSize:19];
    cell.textLabel.text =@"Patient Contact time";
    self.patientItem = self.patients[indexPath.row];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateStyle = NSDateIntervalFormatterMediumStyle;
    df.timeStyle = NSDateIntervalFormatterShortStyle;
    NSString *dateString = [df stringFromDate:self.patientItem.contactTime];
    cell.detailTextLabel.font = [cell.detailTextLabel.font fontWithSize:24];
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.text = dateString;
    return cell;
}

-(void)tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];{
       // self.patients = [[patientItemStore sharedStore]allItems];
        self.patientItem = [self.patients objectAtIndex:indexPath.row];
        [
         self performSegueWithIdentifier:@"displayDataController" sender:self];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        // removed in-app support for iCloud.
       // BOOL iCloudEnabled = [[defaults valueForKey:@"iCloudSupport_unlocked"]boolValue];
        BOOL iCloudEnabled = [[defaults valueForKey:@"iCloudEnabled"]boolValue];
        if(iCloudEnabled) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"iCloud is ON! Your data is being synched to all of your devices." message:@"The item can't be deleted here. To delete it, turn off iCloud Backup in Settings." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok =[UIAlertAction actionWithTitle:@"Press any key to continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [self dismissViewControllerAnimated:YES completion:nil];

        }];
        /*
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           
                                                           [self dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        */
        [alert addAction:ok];
        //[alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        }else{
            NSArray *items = [[patientItemStore sharedStore] allItems];
            
            patientItem *item = items[indexPath.row];
            
            
            [[patientItemStore sharedStore] removeItem:item];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    
    
            } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


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
    if([segue.identifier isEqualToString:@"displayDataController"]){
        NRCDisplayTableViewController *destViewController = segue.destinationViewController;
        destViewController.item = self.patientItem;
        destViewController.patients = self.patients;
        destViewController.medications = self.medications;
        destViewController.interventions = self.interventions;
    }
    
    if([segue.identifier isEqualToString:@"passcode2Controller"]){
        NRCPasscode2ControllerViewController *destViewController = segue.destinationViewController;
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            
        NSString *passwordValue = [defaults valueForKey:@"passwordValue"];
            
        destViewController.password = passwordValue;
        destViewController.passwordWasEntered = YES
            ;

}
}
-(IBAction)unwindToListView:(UIStoryboardSegue *)segue{
    NSLog(@"unwind to list view");
}
/*
-(IBAction)unwindFromPasscode2Controller:(UIStoryboardSegue*)segue{
    NSLog(@"Unwound from passcode2 controller");
}
*/
@end
