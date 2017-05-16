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
#define APP_STORE_ID 1076129873
#define stopsBeforeReview 4
static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d";
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
    return 3;
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
    }else if (indexPath.section == 2){
        cell.textLabel.text = @"Write a Review";
    }
    cell.backgroundColor = [UIColor colorWithRed:0.0f/255 green:125.0f/255 blue:150.0f/255 alpha:0.8f];
    return  cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
    /*
        NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
        BOOL isEmailUnlocked = [storage boolForKey:kunlimitedEmailsUnlockedKey];
        if(isEmailUnlocked == NO){
        
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Emails are not available without upgrading" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Press to continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
            [self performSegueWithIdentifier:@"toEmail" sender:self];
    */
    [self performSegueWithIdentifier:@"toEmail" sender:self];
    }else if(indexPath.section == 1){
        NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
        BOOL isProfessionalOneYearUnlocked = [storage boolForKey:kProfessionalOneYearUnlockedKey];
        BOOL isProfessionalOneWeekUnlocked = [storage boolForKey:kProfessionalOneWeekUnlockedKey];
        if(isProfessionalOneYearUnlocked == NO && isProfessionalOneWeekUnlocked == NO){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"These features are not available without upgrading" message:@"You can try out backup/restore by buying a one week trial." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Press to continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            [self performSegueWithIdentifier:@"toDropbox" sender:self];
        }
    }else if (indexPath.section == 2){
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"We would really appreciate your review! Your review will help us continue to produce great software!" message:@"Do you want to write a review?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok =[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            NSURL *appStoreURL = [NSURL URLWithString:[NSString stringWithFormat:iOSAppStoreURLFormat, APP_STORE_ID]];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            if ([[UIApplication sharedApplication] canOpenURL:appStoreURL]) {
                [[UIApplication sharedApplication] openURL:appStoreURL];
            }
        }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                                                                                  }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
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
