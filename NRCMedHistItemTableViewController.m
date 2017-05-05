//
//  NRCMedHistItemTableViewController.m
//  EMSTimers
//
//  Created by Nelson Capes on 2/16/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//  This controller is called by segue from NRCMedicalHistoryDisplayTableViewController.  It shows an expanded view of the medical history item (cellToZoom) in a UITextView and lets the user add more text. When the user clicks the DONE button in the navigation bar it unwinds a segue "unwindToMedHistory" back to the NRCMedicalHistoryDisplayTableViewController.

#import "NRCMedHistItemTableViewController.h"
#import "NRCSelectDataTableViewController.h"
#import "NRCMedicalHistoryTableViewCell.h"
#import "constants.h"
@interface NRCMedHistItemTableViewController ()

@end

@implementation NRCMedHistItemTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
 //   [self checkButtonEnabled];
    [self startSpeechSynthesis];
   // self.heldText.delegate = self;
    
    // Workaround to dismiss keyboard when Done/Return is tapped
    self.displayedText.delegate = self;
    self.heldText.delegate = self;
    
    // We want to handle textFieldDidEndEditing
  //  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
   // [self.cellToZoom addGestureRecognizer:tap];
   // [tap setCancelsTouchesInView:YES];
    
    
    
    
    
    switch(self.row){
        case 0:{
            if((self.patientItem.chiefComplaint != nil)){
                UIView *displayedText = [self.cellToZoom viewWithTag:1];
                displayedText.tintColor = [UIColor blackColor];
                self.displayedText.text = self.patientItem.chiefComplaint;
                self.heldText.text = self.patientItem.chiefComplaint;
            }
            break;
        }
        case 1:{
            if((![self.patientItem.clinicalImpression isEqualToString:@""]) || (self.patientItem.clinicalImpression != nil)){
                UIView *displayedText = [self.cellToZoom viewWithTag:1];
                displayedText.tintColor = [UIColor blackColor];
                self.displayedText.text = self.patientItem.clinicalImpression;
                self.heldText.text = self.patientItem.clinicalImpression;
                break;
            }
        }
        case 2:{
            if((![self.patientItem.chiefComplaint isEqualToString:@""]) || (self.patientItem.chiefComplaint != nil)){
                UIView *displayedText = [self.cellToZoom viewWithTag:1];
                displayedText.tintColor = [UIColor blackColor];
                self.displayedText.text = self.patientItem.medicalHistory;
                self.heldText.text = self.patientItem.medicalHistory;
                break;
            }
        }
        case 3:{
            if((![self.patientItem.chiefComplaint isEqualToString:@""]) || (self.patientItem.chiefComplaint != nil)){
                UIView *displayedText = [self.cellToZoom viewWithTag:1];
                displayedText.tintColor = [UIColor blackColor];
                self.displayedText.text = self.patientItem.currentMedications;
                self.heldText.text = self.patientItem.currentMedications;
                break;
            }
        }
        case 4:{
            if((![self.patientItem.chiefComplaint isEqualToString:@""]) || (self.patientItem.chiefComplaint != nil)){
                UIView *displayedText = [self.cellToZoom viewWithTag:1];
                displayedText.tintColor = [UIColor blackColor];
                self.displayedText.text = self.patientItem.allergies;
                self.heldText.text = self.patientItem.allergies;
                break;
            }}
            
        case 5:{
            if((![self.patientItem.chiefComplaint isEqualToString:@""]) || (self.patientItem.chiefComplaint != nil)){
                UIView *displayedText = [self.cellToZoom viewWithTag:1];
                displayedText.tintColor = [UIColor blackColor];
                self.displayedText.text = self.patientItem.mechanismOfInjury;
                self.heldText.text = self.patientItem.mechanismOfInjury;
            }
        }
        case 6:{
            if((![self.patientItem.chiefComplaint isEqualToString:@""]) || (self.patientItem.chiefComplaint != nil)){
                UIView *displayedText = [self.cellToZoom viewWithTag:1];
                displayedText.tintColor = [UIColor blackColor];
                self.displayedText.text = self.patientItem.treatments;
                self.heldText.text = self.patientItem.treatments;
            }
        }
        case 7:{
            if((![self.patientItem.chiefComplaint isEqualToString:@""]) || (self.patientItem.chiefComplaint != nil)){
                UIView *displayedText = [self.cellToZoom viewWithTag:1];
                displayedText.tintColor = [UIColor blackColor];
                self.displayedText.text = self.patientItem.narrative;
                self.heldText.text = self.patientItem.narrative;
            }
        }
            
    }
    }
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(IBAction)textFieldFinished:(id)sender{
    [sender resignFirstResponder];

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        self.textView = [self.cellToZoom viewWithTag:1];
        self.textView.text = self.displayedText.text;
        [textView resignFirstResponder];
        self.heldText.text = self.displayedText.text;
        return NO;
    }
    return YES;
}
-(UITextField *)makeTextField:(NSString *)text placeholder:(NSString *)placeholder{
    UITextField *tf = [[UITextField alloc]init];
    tf.placeholder = placeholder;
    tf.text = text;
    tf.autocorrectionType = UITextAutocorrectionTypeNo;
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tf.font = [tf.font fontWithSize:12];
    tf.adjustsFontSizeToFitWidth = YES;
    tf.backgroundColor = [UIColor colorWithRed:0.0f/255 green:125.0f/255 blue:150.0f/255 alpha:0.8f];
    //tf.textColor = [UIColor colorWithRed:56.0f/255 green:84.0f/255 blue:135.0f/255 alpha:1.0f];
    tf.textAlignment = NSTextAlignmentCenter;
    tf.tag =1;
    return  tf;
}

-(void)checkButtonEnabled{
    if (NSClassFromString(@"SFSpeechRecognizer")) {
        // Do something
        NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
        _isButtonEnabled = [storage boolForKey:kspeechRecognitionUnlockedKey];
        if(_isButtonEnabled == true){
            {
                [self.microphoneButton setEnabled:true];
            }
        }else{
            [self.microphoneButton setEnabled:false];
        };
    }
}

-(void)startSpeechSynthesis{
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    _speechRecognizer = [[SFSpeechRecognizer alloc]init];
    [_speechRecognizer setDelegate:self];
    
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        _isButtonEnabled = false;
        switch(status){
            case SFSpeechRecognizerAuthorizationStatusAuthorized:{
                NSLog(@"speech recognizer authorized");
                break;
            }
            case SFSpeechRecognizerAuthorizationStatusDenied:{
                NSLog(@"speech recognizer status denied");
                break;
            }
            case SFSpeechRecognizerAuthorizationStatusRestricted:{
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
    
    _audioEngine = [[AVAudioEngine alloc] init];
    _speechSynthesizer  = [[AVSpeechSynthesizer alloc] init];
    [_speechSynthesizer setDelegate:self];
}
-(IBAction)finishedDisplaying:(id)sender{
    self.textView = [self.cellToZoom viewWithTag:1];
    NSString *triggeringText = self.cellToZoom.textLabel.text;
    NSString *inputText = self.displayedText.text;
    if([triggeringText isEqualToString:@"Chief Complaint"]){
        self.patientItem.chiefComplaint = inputText;
    }else{
        if([triggeringText isEqualToString:@"Clin. Impression"]){
            self.patientItem.clinicalImpression = inputText;
        }else{
            if([triggeringText isEqualToString:@"Med. History"]){
                self.patientItem.medicalHistory = inputText;
            }else{
                if([triggeringText isEqualToString:@"Curr. Medications"]){
                    self.patientItem.currentMedications = inputText;
                }else{
                    if([triggeringText isEqualToString:@"Allergies"]){
                        self.patientItem.allergies = inputText;
                    }else{
                        if([triggeringText isEqualToString:@"MOI/NOI"]){
                            self.patientItem.mechanismOfInjury = inputText;
                        }else{
                            if([triggeringText isEqualToString:@"Treatments"]){
                                self.patientItem.treatments = inputText;
                            }else{
                                if([triggeringText isEqualToString:@"Narrative"]){
                                    self.patientItem.narrative = inputText;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    self.textView.text = self.displayedText.text;
    [self.textView.text stringByReplacingOccurrencesOfString:@"," withString:@";"];
    [_textView resignFirstResponder];
    self.heldText.text = @"";
    [self performSegueWithIdentifier:@"unwindToMedHistory" sender:self];
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
        NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
        BOOL speechRecognitionUnlocked = [storage boolForKey:kspeechRecognitionUnlockedKey];
        if(speechRecognitionUnlocked == NO){
            self.numberOfSpeechRecognitionRequests = [storage integerForKey:kNumberOfSpeechRecognitonRequests];
            if(self.numberOfSpeechRecognitionRequests < kNumberOfSpeechRecognitionRequestsWithoutUpgrade){
                self.numberOfSpeechRecognitionRequests += 1;
                [storage setInteger:self.numberOfSpeechRecognitionRequests forKey:kNumberOfSpeechRecognitonRequests];
                [storage synchronize];
                [self startRecording];
                _microphoneButton.title = @"Stop Recording";
            }else{
                NSLog(@"max speech recognition requests reached");
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You have reached the maximum # of dictation requests" message:@"return to the first screen and touch Upgrade" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Touch here to continue" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            };
        }else{
            [self startRecording];
            _microphoneButton.title = @"Stop Recording";
        }
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
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    
    BOOL hasSpeechRecognitionBeenDone = [storage boolForKey:@"speechRecognitionHasBeenDone"];
    if(hasSpeechRecognitionBeenDone == YES){
        self.displayedText.text = [storage objectForKey:@"displayedText"];
     
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Speech recognition has been done" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Clear text before continuing" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            self.displayedText.text = @"";
            [storage setBool:NO forKey:@"speechRecognitionHasBeenDone"];
            [storage synchronize];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
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
    
}
-(void)speechRecognitionDidDetectSpeech:(SFSpeechRecognitionTask *)task{
    NSLog(@"speechRecognitionTask didDetectSpeech");
    
}
// Called for all recognitions, including non-final hypothesis -
-(void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didHypothesizeTranscription:(SFTranscription *)transcription {
    NSString * translatedString = [transcription formattedString];
    self.heldText.text = translatedString;
    
    
    [self.speechSynthesizer speakUtterance:[AVSpeechUtterance speechUtteranceWithString:translatedString]];
}
-(void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishRecognition:(SFSpeechRecognitionResult *)result{
    NSString *translatedString = [[[result bestTranscription]formattedString]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
        NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
        [storage setBool:YES forKey:@"speechRecognitionHasBeenDone"];
        self.heldText.text = @";";
        self.heldText.text = [ self.heldText.text stringByAppendingString:translatedString];
        self.displayedText.text = [self.displayedText.text stringByAppendingString:self.heldText.text];
        self.heldText.text = @"";
       // [storage setObject:self.displayedText.text forKey:@"displayedText"];
       // [storage synchronize];
        self.temp = self.displayedText.text;
        if([result isFinal]){
        [_audioEngine stop];
        [_inputNode removeTapOnBus:0];
        _recognitionTask = nil;
        _recognitionRequest = nil;
        [self startSpeechSynthesis];
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
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"medHistItemCell" forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NRCMedicalHistoryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor colorWithRed:0.0f/255 green:125.0f/255 blue:150.0f/255 alpha:0.8f]];
    [cell setNeedsDisplay];
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
    self.heldText.text = outputString;
}

@end
