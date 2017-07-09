//
//  ViewController.m
//  VideoUrlDlNAPlay
//
//  Created by jackyshan on 2017/7/9.
//  Copyright © 2017年 jackyshan. All rights reserved.
//

#import "ViewController.h"
#import "ZM_DMRControl.h"
#import "ZM_SingletonControlModel.h"
#import "MBProgressHUD.h"
#import "InputVideoUrlPlayViewController.h"

@interface ViewController()<ZM_DMRProtocolDelegate, NSTableViewDataSource, NSTabViewDelegate>

@property (nonatomic) NSMutableArray<ZM_RenderDeviceModel *> *devices;

@property (nonatomic, weak) IBOutlet NSTableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"搜索盒子";

    // Do any additional setup after loading the view.
    [[[ZM_SingletonControlModel sharedInstance] DMRControl] setDelegate:self];
    //启动DMC去搜索设备
    if (![[[ZM_SingletonControlModel sharedInstance] DMRControl] isRunning]) {
        [[[ZM_SingletonControlModel sharedInstance] DMRControl] start];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)reSearching:(id)sender {
    if (![[[ZM_SingletonControlModel sharedInstance] DMRControl] isRunning]) {
        self.devices = @[];
        [self.tableView reloadData];
        [[[ZM_SingletonControlModel sharedInstance] DMRControl] start];
    }
}

#pragma mark - ZM_DMRProtocolDelegate
- (void)onDMRAdded {
    NSLog(@"%s",__FUNCTION__);
    
    self.devices = [[NSMutableArray alloc] initWithArray:[[[ZM_SingletonControlModel sharedInstance] DMRControl] getActiveRenders]];
    [self.tableView reloadData];
    [self.devices enumerateObjectsUsingBlock:^(ZM_RenderDeviceModel  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"搜索到设备%@", obj.name);
    }];
    
    if (self.devices.count <= 0) {
        return;
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.devices.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
{
    return self.devices[row].name;
}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return NO;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSLog(@"tableViewSelectionDidChange - %ld", self.tableView.selectedRow);
    
    if (self.tableView.selectedRow >= 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        ZM_RenderDeviceModel *device = self.devices[self.tableView.selectedRow];
        NSLog(@"开始连接设备");

        [[[ZM_SingletonControlModel sharedInstance] DMRControl] chooseRenderWithUUID:[device uuid]];

        self.title = [NSString stringWithFormat:@"已连接盒子%@", device.name];
        NSLog(@"连接设备设备名%@，设备地址%@", device.name, device.descriptionURL);
        
        InputVideoUrlPlayViewController *vc = [[InputVideoUrlPlayViewController alloc] init];
        vc.title = device.name;
        [self presentViewControllerAsModalWindow:vc];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}


@end
