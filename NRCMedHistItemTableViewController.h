//
//  NRCMedHistItemTableViewController.h
//  EMSTimers
//
//  Created by Nelson Capes on 2/16/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Speech/Speech.h>
#import "patientItem.h"

@interface NRCMedHistItemTableViewController : UITableViewController <UITextViewDelegate, SFSpeechRecognizerDelegate, SFSpeechRecognitionTaskDelegate, AVSpeechSynthesizerDelegate>{
}
@property (strong, nonatomic)patientItem *patientItem;
@property  UITableViewCell *cellToZoom;
@property (strong, nonatomic) IBOutlet UITextView *displayedText;
@property (strong, nonatomic) IBOutlet UITextView *heldText;

@property (nonatomic, strong) NSString *temp;
@property IBOutlet UITextView * textView;
@property NSMutableArray *medications;
@property NSMutableArray *interventions;
@property NSInteger row;
@property SFSpeechRecognizer *speechRecognizer;
@property AVSpeechSynthesizer * speechSynthesizer;
@property SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@property SFSpeechRecognitionTask *recognitionTask;
@property AVAudioEngine * audioEngine;
@property AVAudioSession *audioSession;
@property(readonly, nonatomic) AVAudioInputNode *inputNode;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *microphoneButton;
@property NSOperation *setButtonMicrophoneEnabled;
@property BOOL isButtonEnabled;
-(void)checkButtonEnabled;
@end
