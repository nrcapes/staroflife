//
//  NRCDropboxViewController.m
//  EMS Timers Professional
//
//  Created by Nelson Capes on 7/23/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import "NRCDropboxViewController.h"
#import <DropboxSDK/DropboxSDK.h>
@implementation NRCDropboxViewController 

- (IBAction)downloadFromDropbox {
    if(![[DBSession sharedSession]isLinked]) {
        NSLog(@"You are not connected to Dropbox");
    }else{
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"items.archive"];
        [self.restClient loadFile:@"items.archive" intoPath:filePath];
    }
    }

-(IBAction)uploadToDropbox{
    if(![[DBSession sharedSession]isLinked]) {
        NSLog(@"You are not connected to Dropbox");
    }else{
    NSString *filename = @"items.archive";
    NSString *destDir = @"/";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"items.archive"];
    self.srcPath = filePath;
    [self showProgressBar];
    [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:filePath];
    }
    
}
-(IBAction)finishedEnteringData:(id)sender{
    [self performSegueWithIdentifier:@"unwindFromDropbox" sender:self];
}
-(IBAction)connectToDropbox:(id)sender{
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
        _bbiConnect.title =@"Disconnect";
        NSLog(@"Connected");
    }else{
        [[DBSession sharedSession] unlinkAll];
        _bbiConnect.title =@"Connect";
        NSLog(@"Disconnected");
    }
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    self.destPath =@"/";
    [self showProgressBar];
}
-(void)showProgressBar{
    _progressBar.progress = 0.0;
    _progressBar.hidden = false;
}
-(void)restClient:(DBRestClient *)client uploadProgress:(CGFloat)progress forFile:(NSString *)destPath from:(NSString *)srcPath{
    _progressBar.progress = progress;
}
-(void)restClient:(DBRestClient *)client loadProgress:(CGFloat)progress forFile:(NSString *)destPath{
    _progressBar.progress = progress;
}



@end
