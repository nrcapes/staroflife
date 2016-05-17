//
//  SelectDataTableViewController.m
//  EMS Timers Professional
//
//  Created by Nelson Capes on 3/14/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import "NRCSelectDataTableViewController.h"
#import "jsonStore.h"
#import "iapstore.h"

@interface NRCSelectDataTableViewController ()

@end

@implementation NRCSelectDataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = NO;
   jsonStore *store = [jsonStore getInstance];
   self.jsonData = [store getData];
    self.medications = [self.jsonData objectForKey:@"medications"];
    self.medicationsSorted =[self.medications sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    self.medicationKeys = [[NSArray alloc]init];
    self.interventions = [self.jsonData objectForKey:@"interventions"];
    self.interventionsSorted =[self.interventions sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    self.interventionsKeys = [[NSArray alloc]init];
    self.chiefComplaint = [self.jsonData objectForKey:@"chief_complaint"];
    self.chiefComplaintSorted =[self.chiefComplaint sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    self.chiefComplaintKeys = [[NSArray alloc]init];
    self.clinicalImpression = [self.jsonData objectForKey:@"clinical_impression"];
    self.clinicalImpressionSorted =[self.clinicalImpression sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    self.clinicalImpressionKeys = [[NSArray alloc]init];
    self.medicalHistory = [self.jsonData objectForKey:@"medical_history"];
    self.medicalHistorySorted =[self.medicalHistory sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    self.medicalHistoryKeys = [[NSArray alloc]init];
    self.allergies = [self.jsonData objectForKey:@"allergies"];
    self.allergiesSorted =[self.allergies sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    self.allergiesKeys = [[NSArray alloc]init];
    self.moinoi = [self.jsonData objectForKey:@"moinoi"];
    self.moinoiSorted =[self.moinoi sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    self.moinoiKeys = [[NSArray alloc]init];
    /*
    // if central administration is not available, alert the user.
    
    iapstore *store1 = [iapstore getInstance];
    self.iapdata = [store1 getData];
    NSNumber *number = [self.iapdata objectForKey:@"central_admin_enabled"];
    NSLog(@"enablePurchase store data: %@", number);
    
    self.centralAdminActivated = [number boolValue];
     
    
   NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    
    self.centralAdminActivated = [storage boolForKey:@"centralAdmin_unlocked"];
    if(self.centralAdminActivated == NO){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Data Select is Unavailable" message:@"The Data Select feature is only available with the Central Administration Upgrade" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Press any key to continue." style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil// Email Subject
         ];
    }
*/
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)finishedDisplaying:(id)sender
{
    [self performSegueWithIdentifier:@"unwindToMedHistItem" sender:self];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //self.centralAdminActivated = [defaults boolForKey:@"centralAdmin_unlocked"];
    iapstore *store = [iapstore getInstance];
    self.iapdata = [store getData];
    NSNumber *n1 = [self.iapdata objectAtIndex:0];
    NSNumber *n2 = [self.iapdata objectAtIndex:1];
    self.centralAdminActivated = [n1 boolValue];
    self.centralAdminSelected = [n2 boolValue];
    
    // override to allow Central Admin for free
    self.centralAdminActivated = YES;
    
    if(self.centralAdminActivated == NO){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Central Administration Check" message:@"The data select feature is only available with the Central Administration Upgrade" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Press any key to continue." style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil// Email Subject
         ];
    }
    else{
    if([self.jsonData count] == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Central Administration Check" message:@"The Data Select feature is not available because the data from Central Administration is invalid." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Press any key to continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
           // self.centralAdminActivated = NO;
            //[self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }else
    {
        if(self.centralAdminSelected == NO){
          UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"Central Administration Check" message:@"The Data Select feature is not available because the central administration feature is not enabled in Settings." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok1 = [UIAlertAction actionWithTitle:@"Press any key to continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
               // self.centralAdminActivated = NO;
                //[self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert1 addAction:ok1];
            [self presentViewController:alert1 animated:YES completion:nil];
        }
    }
    }
    if(self.centralAdminSelected == YES && self.centralAdminActivated == YES){
        return [self.jsonData count];
    }else{
        return 0;
    }
    }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    /*
    if (section == 0)
    {
    return [self.medications count];
    }
    else{
        return [self.interventions count];
    }*/
    switch (section) {
        case 0:
        {
            self.chiefComplaintKeys = [self.jsonData objectForKey:@"chief_complaint"];
            return [self.chiefComplaintKeys count];
        }
            break;
        case 1:
        {
            self.clinicalImpressionKeys = [self.jsonData objectForKey:@"clinical_impression"];
            return [self.clinicalImpressionKeys count];
        }
            break;
        case 2:
        {
            self.medicalHistoryKeys = [self.jsonData objectForKey:@"medical_history"];
            return [self.medicalHistoryKeys count];
        }
            break;
        case 3:
        {
            self.medicationKeys = [self.jsonData objectForKey:@"medications"];
            return [self.medicationKeys count];
        }
            break;
        case 4:
        {
            self.allergiesKeys = [self.jsonData objectForKey:@"allergies"];
            return [self.allergiesKeys count];
        }
            break;
        case 5:
        {
            self.moinoiKeys = [self.jsonData objectForKey:@"moinoi"];
            return [self.moinoiKeys count];
        }
            break;
        case 6:
        {
            self.interventionsKeys = [self.jsonData objectForKey:@"interventions"];
            return [self.interventionsKeys count];
        }
            break;
        
        default:
            break;
    }
    return self.rowCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectDataCell" forIndexPath:indexPath];
    
    // Configure the cell...
    if(indexPath.section == 0){
        cell.textLabel.text =@"Chief Complaint";
        NSString *outputString = [self.chiefComplaintSorted objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = outputString;
    }
    else if(indexPath.section == 1){
        cell.textLabel.text =@"Clinical Impression";
        cell.detailTextLabel.text = [self.clinicalImpressionSorted objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 2){
        cell.textLabel.text =@"Medical History";
        cell.detailTextLabel.text = [self.medicalHistorySorted objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 3)
    {
        cell.textLabel.text =@"Medications";
        cell.detailTextLabel.text = [self.medicationsSorted objectAtIndex:indexPath.row];
    }
    else if (indexPath.section == 4)
             {
            cell.textLabel.text =@"Allergies";
            cell.detailTextLabel.text = [self.allergiesSorted objectAtIndex:indexPath.row];
             }
    else if (indexPath.section == 5)
    {
        cell.textLabel.text =@"MOI/NOI";
        cell.detailTextLabel.text = [self.moinoiSorted objectAtIndex:indexPath.row];
    }else if (indexPath.section == 6){
        cell.textLabel.text =@"Interventions";
        cell.detailTextLabel.text = [self.interventionsSorted objectAtIndex:indexPath.row];
    }
    
    // check for central admin purchased.
    if(self.centralAdminActivated){
    return cell;
    }else{
        cell.textLabel.text = @"";
        return cell;
    }
}
-(void)tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];{
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if(self.centralAdminActivated == YES){
        self.selectedItem = cell.detailTextLabel.text;
        }else{
            self.selectedItem = @"";
        }
        
        [self performSegueWithIdentifier:@"unwindToMedHistItem" sender:self];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
