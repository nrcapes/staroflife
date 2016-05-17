//
//  NRCZoomViewController.m
//  EMSTimers
//
//  Created by Nelson Capes on 2/14/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import "NRCZoomViewController.h"

@interface NRCZoomViewController ()

@end

@implementation NRCZoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINavigationItem *navItem = [[UINavigationItem alloc]init];
    UIBarButtonItem *lbbi = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishedDisplay)];
    navItem.leftBarButtonItem = lbbi;
     
    self.textView = [self.cellToZoom viewWithTag:1];
    self.displayedText.text= self.textView.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (void)finishedDisplay{
    [self performSegueWithIdentifier:@"unwindToMedicalHistoryDisplay" sender:self];
}

@end
