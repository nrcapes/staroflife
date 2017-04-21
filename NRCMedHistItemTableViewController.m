//
//  NRCMedHistItemTableViewController.m
//  EMSTimers
//
//  Created by Nelson Capes on 2/16/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//  This controller is called by segue from NRCMedicalHistoryDisplayTableViewController.  It shows an expanded view of the medical history item (cellToZoom) in a UITextView and lets the user add more text. When the user clicks the DONE button in the navigation bar it unwinds a segue "unwindToMedHistory" back to the NRCMedicalHistoryDisplayTableViewController.

#import "NRCMedHistItemTableViewController.h"
#import "NRCSelectDataTableViewController.h"
@interface NRCMedHistItemTableViewController ()

@end

@implementation NRCMedHistItemTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.textView = [self.cellToZoom viewWithTag:1];
    self.displayedText.text= self.textView.text;
    self.displayedText.delegate = self;
    [self.microphoneButton setEnabled:false];
    self.speechRecognizer.delegate = self;
    
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        _isButtonEnabled = false;
        switch(status){
            case SFSpeechRecognizerAuthorizationStatusAuthorized:{
                _isButtonEnabled = true;
                break;
            }
            case SFSpeechRecognizerAuthorizationStatusDenied:{
                _isButtonEnabled = false;
                break;
            }
            case SFSpeechRecognizerAuthorizationStatusRestricted:{
                _isButtonEnabled = false;
                NSLog(@"Speech recognition restricted on this device");
                break;
            }
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:{
                NSLog(@"Speech recognition not yet authorized");
                break;
            }
        }
    }
     ];
    operationQueue = [NSOperationQueue new];
    NSInvocationOperation *operation =[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(checkButtonEnabled) object:nil];
    [operationQueue addOperation:operation];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)checkButtonEnabled{
    if(_isButtonEnabled == true){
        [self.microphoneButton setEnabled:true];
    }else{
        [self.microphoneButton setEnabled:false];
    };
}
-(IBAction)finishedDisplaying:(id)sender{
    self.textView = [self.cellToZoom viewWithTag:1];
    self.textView.text = self.displayedText.text;
    [self.textView.text stringByReplacingOccurrencesOfString:@"," withString:@";"];
    [_textView resignFirstResponder];
    [self performSegueWithIdentifier:@"unwindToMedHistory" sender:self];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
   // this code is necessary to tell when the user hits RETURN because UITextView does not signal that.
    if([text isEqualToString:@"\n"]) {
        self.textView = [self.cellToZoom viewWithTag:1];
        self.textView.text = self.displayedText.text;
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)timeStamp:(id)sender{
    NSDate *date =[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSString *outputString = self.displayedText.text;
    outputString = [outputString stringByAppendingString:dateString];
    outputString = [outputString stringByAppendingString:@";"];
    self.displayedText.text = outputString;
}

- (IBAction)selectData:(id)sender {
    NSLog(@"Data Select button tapped");
    [self performSegueWithIdentifier:@"toSelectData" sender:self];
}
-(IBAction)microphoneTapped :(id)sender{
    if(_audioEngine.isRunning){
        [_audioEngine stop];
        [_recognitionRequest endAudio];
        [_microphoneButton setEnabled:false];
        _microphoneButton.title = @"Start Recording";
    }else{
        [self startRecording];
        _microphoneButton.title = @"Stop Recording";
    }
}
-(void)startRecording{
    if (_recognitionTask != nil){
        [_recognitionTask cancel];
        _recognitionTask = nil;
    }
    NSError *error;
    _audioSession = [AVAudioSession sharedInstance];
    [_audioSession setCategory:AVAudioSessionCategoryRecord error: &error];
    [_audioSession setMode:AVAudioSessionModeMeasurement error:&error];
    [_audioSession setActive:true withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    if(error){
        NSLog(@"audioSession properites weren't set because of an error");
    }
    _inputNode = _audioEngine.inputNode;
    _recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc]init];
    _recognitionRequest.shouldReportPartialResults = true;
    
    _recognitionRequest= [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    
    _recognitionRequest.shouldReportPartialResults = true;
    
    _recognitionTask = [_speechRecognizer recognitionTaskWithRequest:_recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        BOOL isFinal = false;
        if(result != nil){
            
        }
        if(error != nil || isFinal){
            [_audioEngine stop];
            [_inputNode removeTapOnBus:0];
            _recognitionRequest = nil;
            _recognitionTask = nil;
            [_microphoneButton setEnabled:false];
        }
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.row == 7) {
        return 400;
    }
    else {
        return 180;
    }
}
/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"toSelectData"]){
        NRCSelectDataTableViewController *destController =segue.destinationViewController;
        destController.medications = self.medications;
        destController.interventions = self.interventions;
    }
}

-(IBAction)unwindFromSelectData:(UIStoryboardSegue *)segue{
    NRCSelectDataTableViewController *sourceViewController = segue.sourceViewController;
    NSString *outputString = self.displayedText.text;
    
    outputString = [outputString stringByAppendingString:sourceViewController.selectedItem];
    outputString = [outputString stringByAppendingString:@";\n"];
    self.displayedText.text = outputString;

}

@end
