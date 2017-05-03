//
//  DBBViewController.m
//  DropboxBrowser
//
//  Created by iRare Media on 12/26/12.
//  Copyright (c) 2014 iRare Media. All rights reserved.
//

#import "DBBViewController.h"

@interface DBBViewController ()

@end

@implementation DBBViewController
@synthesize clearDocsBtn, navBar;

typedef NS_ENUM(NSInteger, backup_restore){
    backup_to_dropbox = 1,
    restore_from_dropbox = 2,
    logout_of_dropbox = 3
};

//------------------------------------------------------------------------------------------------------------//
//------- View Lifecycle -------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.navigationItem setHidesBackButton:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [UIView animateWithDuration:0.45 animations:^{
        clearDocsBtn.alpha = 1.0;
    }];
}
#pragma clang diagnostic pop
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (IBAction)done {
    NSLog(@"DBBViewController: done");
   [self dismissViewControllerAnimated:YES completion:nil];
    //[self performSegueWithIdentifier:@"unwindSelfToTransmit" sender:self];
}

//------------------------------------------------------------------------------------------------------------//
//------- Dropbox --------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
#pragma mark - Dropbox

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"restoreFromDropbox"]) {
        // Get reference to the destination view controller
        UINavigationController *navigationController = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        DropboxBrowserViewController *dropboxBrowser = (DropboxBrowserViewController *)navigationController.topViewController;
        
         dropboxBrowser.allowedFileTypes = @[@"archive"]; // Uncomment to filter file types. Create an array of allowed types. To allow all file types simply don't set the property
        // dropboxBrowser.tableCellID = @"DropboxBrowserCell"; // Uncomment to use a custom UITableViewCell ID. This property is not required
        
        // When a file is downloaded (either successfully or unsuccessfully) you can have DBBrowser notify the user with Notification Center. Default property is NO.
        dropboxBrowser.deliverDownloadNotifications = YES;
        
        // Dropbox Browser can display a UISearchBar to allow the user to search their Dropbox for a file or folder. Default property is NO.
        dropboxBrowser.shouldDisplaySearchBar = YES;
        
        // Set the delegate property to recieve delegate method calls
        dropboxBrowser.rootViewDelegate = self;
        dropboxBrowser.backup_restore = restore_from_dropbox;
    }else{
        if ([[segue identifier] isEqualToString:@"backupToDropbox"]) {
        // backup to dropbox
        UINavigationController *navigationController = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        DropboxBrowserViewController *dropboxBrowser = (DropboxBrowserViewController *)navigationController.topViewController;
        // Set the delegate property to recieve delegate method calls
        dropboxBrowser.rootViewDelegate = self;
        dropboxBrowser.backup_restore = backup_to_dropbox;
        }
        else{// logout of Dropbox
            UINavigationController *navigationController = [segue destinationViewController];
            
            // Pass any objects to the view controller here, like...
            DropboxBrowserViewController *dropboxBrowser = (DropboxBrowserViewController *)navigationController.topViewController;
            // Set the delegate property to recieve delegate method calls
            dropboxBrowser.rootViewDelegate = self;
            dropboxBrowser.backup_restore = logout_of_dropbox;
        }
    }
}

- (void)dropboxBrowser:(DropboxBrowserViewController *)browser didDownloadFile:(NSString *)fileName didOverwriteFile:(BOOL)isLocalFileOverwritten {
    if (isLocalFileOverwritten == YES) {
        NSLog(@"Downloaded %@ by overwriting local file", fileName);
    } else {
        NSLog(@"Downloaded %@ without overwriting", fileName);
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
   
    NSFileManager *fileMgr = [NSFileManager defaultManager];
   
    
    /// unarchive the downloadedfile
    NSData *data = [fileMgr contentsAtPath:filePath];
    self.patients = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    /*
    // loop through the old file and the new file; if a match is found
    // replace the old item with the new item.
    // otherwise, add the new item to the items array.
        patientItem *oldItem;
        patientItem *newItem;
        NSMutableArray *oldItems = [[patientItemStore sharedStore]allItemsActual];
        NSMutableArray *newItems = [[NSMutableArray alloc]init];;
        int i;
        int j;
    if([oldItems count]>0){
        for(i=0; i< [oldItems count];i++){
            NSLog(@"i:%d", i);
           // BOOL itemFound = NO;
            oldItem = oldItems[i];
            NSLog(@"oldItem:%@",oldItem);
            for(j=0; j< [self.patients count];j++){
                NSLog(@"j:%d",j);
                newItem = self.patients[j];
                NSLog(@"newItem:%@", newItem);
                NSLog(@"oldItem contact time =%@, newItem contact time=%@",oldItem.contactTime, newItem.contactTime);
            if([newItem.contactTime isEqualToDate:oldItem.contactTime]){
              //  itemFound = YES;
                [[patientItemStore sharedStore]itemReplace:oldItem with:newItem];
               // break;
            }else{
                if([newItem.contactTime timeIntervalSince1970] > [oldItem.contactTime timeIntervalSince1970]
                   && [newItem.itemKey isEqual:oldItem.itemKey])
                {
                    [[patientItemStore sharedStore]itemReplace:oldItem with:newItem];
                }else
                [newItems addObject:newItem];
            }
        }
        
     
        if(itemFound == NO){
            if(newItem){
            [[patientItemStore sharedStore]addItem:newItem];
            }
        }
     
    }
    }else{
        if(self.patients){
        newItems = self.patients;
        }
    }
*/
    BOOL result;
    result = [[patientItemStore sharedStore]saveChangedPrivateItems:self.patients];
    if (result == false){
        NSLog(@"DBBViewController:didDownloadFile: could not save newItems in patientItemStore");
    }
}

- (void)dropboxBrowser:(DropboxBrowserViewController *)browser didFailToDownloadFile:(NSString *)fileName {
    NSLog(@"Failed to download %@", fileName);
}

-(void)dropboxBrowser:(DropboxBrowserViewController *)browser
        didUploadFile:(NSString *)fileName{
    NSLog(@"DBBViewController:dropboxBrowser:didUploadFile:%@",fileName);
    
    
}
- (void)dropboxBrowser:(DropboxBrowserViewController *)browser fileConflictWithLocalFile:(NSURL *)localFileURL withDropboxFile:(DBMetadata *)dropboxFile withError:(NSError *)error {
    NSLog(@"File conflict between %@ and %@\n%@ last modified on %@\nError: %@", localFileURL.lastPathComponent, dropboxFile.filename, dropboxFile.filename, dropboxFile.lastModifiedDate, error);
}

- (void)dropboxBrowserDismissed:(DropboxBrowserViewController *)browser {
    // This method is called after Dropbox Browser is dismissed. Do NOT dismiss DropboxBrowser from this method
    // Perform any UI updates here to display any new data from Dropbox Browser
    // ex. Update a UITableView that shows downloaded files or get the name of the most recently selected file:
    
    
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)dropboxBrowser:(DropboxBrowserViewController *)browser deliveredFileDownloadNotification:(UILocalNotification *)notification {
    long badgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber]+1;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNumber];
}
#pragma clang diagnostic pop

//------------------------------------------------------------------------------------------------------------//
//------- Documents ------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//
#pragma mark - Documents

- (IBAction)clearDocs:(id)sender {
    // Clear all files from the local documents folder. This is helpful for testing purposes
    dispatch_queue_t delete = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(delete, ^{
        // Background Process;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = paths[0];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSArray *fileArray = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:nil];
        
        for (NSString *filename in fileArray)  {
            [fileMgr removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.45 animations:^{
                clearDocsBtn.titleLabel.text = @"Cleared Local Documents";
                clearDocsBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.45 animations:^{
                    clearDocsBtn.titleLabel.text = @"Clear Local Documents";
                }];
            }];
        });
    });
}

@end
