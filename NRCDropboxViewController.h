//
//  NRCDropboxViewController.h
//  EMS Timers Professional
//
//  Created by Nelson Capes on 7/23/16.
//  Copyright © 2016 Nelson Capes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  <DropboxSDK/DropboxSDK.h>
#import "DBBViewController.h"
@interface NRCDropboxViewController : UIViewController <DBRestClientDelegate, DropboxBrowserDelegate>
@property (nonatomic, strong) DBRestClient *restClient;
@property UIProgressView *progressBar;
@property UITableView *tblFiles;
@property IBOutlet UIBarButtonItem *bbiConnect;
@property NSString *srcPath;
@property NSString *destPath;
@property (nonatomic,strong)DBMetadata *dropboxMetaData;
@property (nonatomic,strong)  NSMutableArray *dropboxContents;
@property (nonatomic,strong)  NSMutableArray *dropboxFilenames;
@property (nonatomic, strong)  NSMutableArray *dropboxRevs;
@property (nonatomic, strong
           ) NSString* rev;
@end
