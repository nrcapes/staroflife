//
//  NRCTransmitTableViewController.m
//  EMS Timers Professional
//
//  Created by Nelson Capes on 7/20/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import "NRCTransmitTableViewController.h"
#import "constants.h"
@implementation NRCTransmitTableViewController
- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Transmit Controller";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"transmitCell"];
    if(indexPath.section == 0){
       cell.textLabel.text =@"Email Data";
    }else if (indexPath.section == 1){
        cell.textLabel.text = @"Backup/Restore to Dropbox";
    }
    cell.backgroundColor = [UIColor colorWithRed:0.0f/255 green:125.0f/255 blue:150.0f/255 alpha:0.8f];
    return  cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
        BOOL isEmailUnlocked = [storage boolForKey:kunlimitedEmailsUnlockedKey];
        BOOL isEmailTrialUnlocked = [storage boolForKey:kemails7DayTrialUnlockedKey];
        if(isEmailUnlocked == NO){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Upgrade is needed" message:@"You can try out emails by buying a one week trial." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Press to continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            [self performSegueWithIdentifier:@"toEmail" sender:self];
        }
    }else if(indexPath.section == 1){
        NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
        BOOL isProfessionalOneYearUnlocked = [storage boolForKey:kProfessionalOneYearUnlockedKey];
        BOOL isProfessionalOneWeekUnlocked = [storage boolForKey:kProfessionalOneWeekUnlockedKey];
        if(isProfessionalOneYearUnlocked == NO && isProfessionalOneWeekUnlocked == NO){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Upgrade is needed" message:@"You can try out backup/restore by buying a one week trial." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Press to continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            [self performSegueWithIdentifier:@"toDropbox" sender:self];
        }
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toEmail"]){
        NRCEmailTableViewController *destViewController = segue.destinationViewController;
        destViewController.patients = self.patients;
        destViewController.checkedArray = self.checkedArray;
    }else{
        DBBViewController *destViewController = segue.destinationViewController;
        destViewController.patients = self.patients;
    }
}
-(IBAction)unwindFromEmailViewController:(UIStoryboardSegue *)segue{
    NRCEmailTableViewController *sourceViewController = segue.sourceViewController;
    self.checkedArray = sourceViewController.checkedArray;
}
/*
-(IBAction)unwindFromDBB:(UIStoryboardSegue *)segue{
    NSLog(@"Transmit view controller: unwindFromDBBViewController");
    DBBViewController *sourceViewController = segue.sourceViewController;
    self.patients = sourceViewController.patients;
    
    
     }
 */
- (IBAction)finishedEnteringData:(id)sender {
    
    
    [self performSegueWithIdentifier:@"unwindFromTransmitViewController" sender:self];
}

@end
