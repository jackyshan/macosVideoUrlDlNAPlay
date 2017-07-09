//
//  InputVideoUrlPlayViewController.m
//  VideoUrlDlNAPlay
//
//  Created by jackyshan on 2017/7/9.
//  Copyright © 2017年 jackyshan. All rights reserved.
//

#import "InputVideoUrlPlayViewController.h"
#import "ZM_DMRControl.h"
#import "ZM_SingletonControlModel.h"

@interface InputVideoUrlPlayViewController ()

@property (weak) IBOutlet NSTextField *videoUrlFd;

@end

@implementation InputVideoUrlPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)playVideoAction:(id)sender {
    if ([[[ZM_SingletonControlModel sharedInstance] DMRControl] getCurrentRender]) {
        [[[ZM_SingletonControlModel sharedInstance] DMRControl] renderSetAVTransportWithURI:self.videoUrlFd.stringValue metaData:nil];
        [[[ZM_SingletonControlModel sharedInstance] DMRControl] renderPlay];
    }
}


@end
