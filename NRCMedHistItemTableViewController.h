//
//  NRCMedHistItemTableViewController.h
//  EMSTimers
//
//  Created by Nelson Capes on 2/16/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Speech/Speech.h>
@interface NRCMedHistItemTableViewController : UITableViewController <UITextViewDelegate, SFSpeechRecognizerDelegate>{
    NSOperationQueue *operationQueue;
}
@property  UITableViewCell *cellToZoom;
@property (weak, nonatomic) IBOutlet UITextView *displayedText;
@property IBOutlet UITextView * textView;
@property NSMutableArray *medications;
@property NSMutableArray *interventions;
@property NSInteger row;
@property SFSpeechRecognizer *speechRecognizer;
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
