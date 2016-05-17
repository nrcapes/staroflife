//
//  AssessmentListTableViewController.m
//  EMSTimers
//
//  Created by Nelson Capes on 2/3/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//
// This controller is called by segue from NRCDisplayTableViewController with a list of assessments in self.assessments. It displays a tableView of the assessments.  When one of the rows is clicked on, it segues to NRCAssessmentDisplayTableViewController with the destination's assessmentItem holding a pointer to the assessment. On return, it unwinds a segue "unwindToDisplay" to the DisplayTableViewController.
//

#import "AssessmentListTableViewController.h"
#import "NRCPatientDataTableViewCell.h"
#import "patientItem.h"
#import "patientItemStore.h"
#import "NRCPatientDataTableViewController.h"
#import "NRCAssessmentDisplayTableViewController.h"
//@class NRCAssessmentDisplayControllerTableViewController;
@interface AssessmentListTableViewController ()

@end

@implementation AssessmentListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    //[self.tableView registerClass:[UITableViewCell class]forCellReuseIdentifier:@"UITableViewCell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setTitle:self.patientItem.fullName];
}
- (IBAction)finishedListing:(id)sender {
    [self performSegueWithIdentifier:@"unwindToDisplay" sender:self];
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
#
    return [self.assessments count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"assessmentListCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.font = [cell.textLabel.font fontWithSize:19];
    cell.textLabel.text =@"Assessment";
    self.assessmentItem = self.assessments[indexPath.row];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateStyle = NSDateIntervalFormatterMediumStyle;
    df.timeStyle = NSDateIntervalFormatterShortStyle;
    NSString *dateString = [df stringFromDate:self.assessmentItem.assessmentTime];
    cell.detailTextLabel.font = [cell.detailTextLabel.font fontWithSize:19];
    cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    cell.detailTextLabel.text = dateString;
    return cell;
}

-(void)tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];{
        self.assessmentItem = self.assessments[indexPath.row];
        [self performSegueWithIdentifier:@"assessmentDisplay" sender:self];
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
        //patientItem *item = self.patients[indexPath.row]
        [self.assessments removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    if([segue.identifier isEqualToString:@"assessmentDisplay"]){
        NRCAssessmentDisplayTableViewController *destViewController = segue.destinationViewController;
        destViewController.assessmentItem = self.assessmentItem;
        destViewController.patients = self.patients;
        destViewController.patientItem = self.patientItem;
        destViewController.medications = self.medications;
        destViewController.interventions = self.interventions;
    }
}

-(IBAction)unwindFromAssessmentDisplay:(UIStoryboardSegue *)segue{
    
}

@end
