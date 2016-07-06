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
    
    _checkedArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:YES],
                     [NSNumber numberWithBool:YES],
                     [NSNumber numberWithBool:YES],
                     [NSNumber numberWithBool:YES],
                     [NSNumber numberWithBool:YES],
                     [NSNumber numberWithBool:YES],
                     [NSNumber numberWithBool:YES],
                     [NSNumber numberWithBool:YES],
                     [NSNumber numberWithBool:YES],
                     [NSNumber numberWithBool:YES],
                     [NSNumber numberWithBool:YES],
                     [NSNumber numberWithBool:YES], nil];
    
    
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
                     [NSNumber numberWithInteger:0], nil];
    
    
    
    
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
        BOOL myValue = 1;
        number = [NSNumber numberWithBool: myValue];
    }
    else{
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        BOOL myValue = 0;
        number = [NSNumber numberWithBool:myValue];
    }
    
    [_checkedArray replaceObjectAtIndex:indexPath.row withObject:number];
    
    
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
