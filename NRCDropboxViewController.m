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
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        self.rev = [defaults objectForKey:@"rev"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"items.archive"];
        NSLog(@"Download files: rev:%@,", self.rev);
        [self.restClient loadFile:@"items.archive" atRev:self.rev intoPath:filePath];
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
    NSString *currentRev;
        NSUInteger count = [self.dropboxRevs count];
        if(count > 0){
            currentRev = [self.dropboxRevs objectAtIndex:0];
            [self.restClient uploadFile:filename toPath:destDir withParentRev:currentRev fromPath:filename];
        }else{
            [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:filePath];
            
        }
    }
    
}
-(void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath{
    [self.restClient loadMetadata:@"/"];
}
-(void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error{
    NSLog(@"uploaded file failed with error:%@",error);
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
-(IBAction)refreshDropbox:(id)sender{
    [self.restClient loadMetadata:@"/"];
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
    self.dropboxContents = [[NSMutableArray alloc]init];
    self.dropboxFilenames = [[NSMutableArray alloc]init];
    self.dropboxRevs = [[NSMutableArray alloc]init];
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
- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    self.dropboxMetaData = metadata;
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:metadata.rev forKey:@"rev"];
   // self.rev = metadata.rev;
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        NSLog(@"metadata contents: %@", metadata.contents);
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"	%@", file.filename);
            //if([file.filename  isEqual: @"items.archive"]){
                [self.dropboxContents addObject:file];
                [self.dropboxFilenames addObject:file.filename];
                [self.dropboxRevs addObject:file.rev];
           // }
        }
        
    }
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    NSLog(@"Error loading metadata: %@", error);
}


@end
