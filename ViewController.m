//
//  ViewController.m
//  EMSTimers 1.0 build5
//
//  Created by Nelson Capes on 11/2/15.
// last updated 12/2/15
//  Copyright © 2015 Nelson Capes. All rights reserved.
//

#import "ViewController.h"
#import "NRCButton.h"
#import <QuartzCore/QuartzCore.h>
@interface NRCViewController ()

@end

@implementation NRCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]forCellReuseIdentifier:@"UITableViewCell"];
    
    
    self.labels = [[NSMutableArray alloc]init];
    self.types = [[NSMutableArray alloc]init];
    
    [_labels addObject:@"Elapsed Time"];
    [_types addObject:@0];
    [_labels addObject:@"Patient Contact Time"];
    [_types addObject:@1];
    [_labels addObject:@"Dispatch Timer"];
    [_types addObject:@2];
    [_labels addObject:@"Transport Time"];
    [_types addObject:@3];
    [_labels addObject:@"At Hospital"];
    [_types addObject:@4];
    [_labels addObject:@"Cleared"];
    [_types addObject:@5];
    [_labels addObject:@"In Service"];
    [_types addObject:@6];
    
    self.taskCategories = [[NSMutableArray alloc]init];
    self.currentCategory =[[NSIndexPath alloc]init];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)enterDispatch:(id)sender {
    NSDate *date =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:date];
    self.dispatchTime = dateString;
}
- (void)enterDate:(id)sender {
    NSDate *date =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *dateString = [dateFormatter stringFromDate:date];
    self.startDate = dateString;
    self.dateStarted = date;
    NSTimeInterval timeInterval = 1.0;
    _elapsedTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(calculateTimer:) userInfo:_elapsedTimer repeats:YES];
    [_elapsedTimer fire];
}
- (void)enterContact:(id)sender {
    NSDate *date =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:date];
    self.contactTime = dateString;
    
}
- (void)enterTransport:(id)sender {
    NSDate *date =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:date];
    self.transportTime = dateString;
    
}
- (void)enterHospital:(id)sender {
    NSDate *date =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:date];
    self.hospitalTime = dateString;
    
}
- (void)enterCleared:(id)sender {
    NSDate *date =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:date];
    self.clearedTime = dateString;

}
- (IBAction)resetAll:(id)sender {
    self.startDate = @"";
    self.dispatchTime = @"";
    self.transportTime =@"";
    self.hospitalTime = @"";
    self.clearedTime = @"";
    self.contactTime =@"";
    [self.elapsedTimer invalidate];
}

-(void)calculateTimer:(NSTimer *)theTimer
{
    
    NSTimeInterval interval = [self.dateStarted timeIntervalSinceNow];
    interval = (-1 * interval);
    
    int time = round(interval);
    div_t h = div(time, 3600); //seconds total, divided by 3600 equals
    int hours = h.quot;         // hours, divided by 60 equals
    div_t m = div(h.rem, 60);   // minutes
    int minutes = m.quot;
    int seconds = m.rem;        // and remainder is seconds
    
    
    NSString *intervalString = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    self.elapsedTime = intervalString;
}
#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    
    // Configure the cell...
    
    [_taskCategories addObject:indexPath];
    
    cell.textLabel.text = [_labels objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView: (UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // ************** changed 9/30/05 ***********************
    NSInteger catIndex = [_taskCategories indexOfObject:self.currentCategory];
    if (catIndex == indexPath.row) {
        return;
    }
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:catIndex inSection:0];
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.currentCategory = [_taskCategories objectAtIndex:indexPath.row];
    }
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    // *****************************************************************
    //
    NSNumber *number = [self.types objectAtIndex:indexPath.row];
    NSInteger index = [number integerValue];
    self.timerType = index;
    
    
    
}
@end
