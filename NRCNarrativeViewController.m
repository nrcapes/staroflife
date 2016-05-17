//
//  NRCNarrativeViewController.m
//  EMS Timers Professional
//
//  Created by Nelson Capes on 4/14/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import "NRCNarrativeViewController.h"

@interface NRCNarrativeViewController ()

@end

@implementation NRCNarrativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.textView = [self.cellToZoom viewWithTag:1];
    self.displayedText.text= self.textView.text;
    self.displayedText.delegate = self;
    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setTitle:self.patientItem.fullName];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)finishedDisplaying:(id)sender{
    self.textView = [self.cellToZoom viewWithTag:1];
    self.textView.text = self.displayedText.text;
    [self.textView.text stringByReplacingOccurrencesOfString:@"," withString:@";"];
    [_textView resignFirstResponder];
    [self performSegueWithIdentifier:@"unwindToMedHistory" sender:self];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    
    if([text isEqualToString:@"\n"]) {
        self.textView = [self.cellToZoom viewWithTag:1];
        self.textView.text = self.displayedText.text;
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
