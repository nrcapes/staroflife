//
//  NRCTransmitTableViewController.m
//  EMS Timers Professional
//
//  Created by Nelson Capes on 7/20/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import "NRCTransmitTableViewController.h"

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
    return  cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        [self performSegueWithIdentifier:@"toEmail" sender:self];
    }else if(indexPath.section == 1){
        [self performSegueWithIdentifier:@"toDropbox" sender:self];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"toEmail"]){
        NRCEmailTableViewController *destViewController = segue.destinationViewController;
        destViewController.patients = self.patients;
        destViewController.checkedArray = self.checkedArray;
    }
}
-(IBAction)unwindFromEmailViewController:(UIStoryboardSegue *)segue{
    NRCEmailTableViewController *sourceViewController = segue.sourceViewController;
    self.checkedArray = sourceViewController.checkedArray;
}
-(IBAction)unwindFromDropboxViewController:(UIStoryboardSegue *)segue{
     }
- (IBAction)finishedEnteringData:(id)sender {
    
    
    [self performSegueWithIdentifier:@"unwindFromTransmitViewController" sender:self];
}
@end
