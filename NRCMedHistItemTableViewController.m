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
    
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    self.textView = [self.cellToZoom viewWithTag:1];
    self.displayedText.text= self.textView.text;
    self.displayedText.delegate = self;
    [self.microphoneButton setEnabled:false];
    
    _speechRecognizer = [[SFSpeechRecognizer alloc]init];
    [_speechRecognizer setDelegate:self];
    
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        _isButtonEnabled = false;
        switch(status){
            case SFSpeechRecognizerAuthorizationStatusAuthorized:{
                _isButtonEnabled = true;
                [storage setBool:_isButtonEnabled forKey:@"isButtonEnabled"];
                [storage synchronize];
                break;
            }
            case SFSpeechRecognizerAuthorizationStatusDenied:{
                _isButtonEnabled = false;
                [storage setBool:_isButtonEnabled forKey:@"isButtonEnabled"];
                [storage synchronize];
                break;
            }
            case SFSpeechRecognizerAuthorizationStatusRestricted:{
                _isButtonEnabled = false;
                [storage setBool:_isButtonEnabled forKey:@"isButtonEnabled"];
                [storage synchronize];
                NSLog(@"Speech recognition restricted on this device");
                break;
            }
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:{
                _isButtonEnabled = false;
                [storage setBool:_isButtonEnabled forKey:@"isButtonEnabled"];
                [storage synchronize];
                NSLog(@"Speech recognition not yet authorized");
                break;
            }
        }
    }
     ];
    
    _audioEngine = [[AVAudioEngine alloc] init];
    _speechSynthesizer  = [[AVSpeechSynthesizer alloc] init];
    [_speechSynthesizer setDelegate:self];

    [self checkButtonEnabled];
    /*
    NSOperationQueue *operationQueue = NSOperationQueue.mainQueue;
    [operationQueue addOperationWithBlock:^(void){
        NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
        _isButtonEnabled = [storage boolForKey:@"isButtonEnabled"];
        if(_isButtonEnabled == true){
            [_microphoneButton setEnabled:true];
        }
    }];
     
    
    
    NSInvocationOperation *operation =[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(checkButtonEnabled) object:nil];
    [operationQueue addOperation:operation];
    */
    
}
-(void)checkButtonEnabled{
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    _isButtonEnabled = [storage boolForKey:@"isButtonEnabled"];
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
    if(self.audioEngine.isRunning){
        [self.audioEngine stop];
        [_recognitionRequest endAudio];
        [_microphoneButton setEnabled:false];
        _microphoneButton.title = @"Start Recording";
    }else{
        [self startRecording];
        _microphoneButton.title = @"Stop Recording";
    }
}

-(void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available{
    if (available){
        [_microphoneButton setEnabled:true];
    }else{
        [_microphoneButton setEnabled:false];
    }
}

-(void)startRecording{
    /*
     if (_recognitionTask != nil){
     [_recognitionTask cancel];
     _recognitionTask = nil;
     }
     */
    NSError *error;
    _audioSession = [AVAudioSession sharedInstance];
    [_audioSession setCategory:AVAudioSessionCategoryRecord error: &error];
    if(error){
        NSLog(@"audioSession properites weren't set because of an error");
    }
    [_audioSession setMode:AVAudioSessionModeMeasurement error:&error];
    if(error){
        NSLog(@"audioSession properites weren't set because of an error");
    }
    [_audioSession setActive:true withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    if(error){
        NSLog(@"audioSession properites weren't set because of an error");
    }
    // self.audioEngine = [[AVAudioEngine alloc]init];
    _inputNode = self.audioEngine.inputNode;
    _recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc]init];
    if(_recognitionRequest == nil){
        NSLog(@"Unable to create a SFSpeechAudioBufferRecognitionRequest");
    }
    _recognitionRequest.shouldReportPartialResults = true;
    _recognitionTask = [_speechRecognizer recognitionTaskWithRequest:_recognitionRequest delegate:self];
    /*
     _recognitionTask = [_speechRecognizer recognitionTaskWithRequest:_recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
     BOOL isFinal = false;
     if(result != nil){
     self.textView.text = result.bestTranscription.formattedString;
     
     }
     if(error != nil || isFinal){
     [_audioEngine stop];
     [_inputNode removeTapOnBus:0];
     _recognitionRequest = nil;
     _recognitionTask = nil;
     [_microphoneButton setEnabled:true];
     }
     }];
     */
    AVAudioFormat *recordingFormat = [_inputNode outputFormatForBus:0];
    [_inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [_recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    
    [_audioEngine prepare];
    [_audioEngine startAndReturnError:&error];
    if(error){
        NSLog(@"audio engine couldn't start because of error %@", error);
    }
    self.displayedText.text = @"Recording...";
}
-(void)speechRecognitionDidDetectSpeech:(SFSpeechRecognitionTask *)task{
    NSLog(@"speechRecognitionTask didDetectSpeech");
    
}
// Called for all recognitions, including non-final hypothesis -
-(void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didHypothesizeTranscription:(SFTranscription *)transcription {
    NSString * translatedString = [transcription formattedString];
    NSLog(@"%@", translatedString);
    
    self.displayedText.text = translatedString;
    
    [self.speechSynthesizer speakUtterance:[AVSpeechUtterance speechUtteranceWithString:translatedString]];
}
-(void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishRecognition:(SFSpeechRecognitionResult *)result{
    NSLog(@"speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishRecogntion");
    NSString *translatedString = [[[result bestTranscription]formattedString]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"translated string: %@", translatedString);
    
    self.displayedText.text = translatedString;
    
    if([result isFinal]){
        [_audioEngine stop];
        [_inputNode removeTapOnBus:0];
        _recognitionTask = nil;
        _recognitionRequest = nil;
    }
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
