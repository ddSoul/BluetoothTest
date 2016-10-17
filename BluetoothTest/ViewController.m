//
//  ViewController.m
//  BluetoothTest
//
//  Created by 邓西亮 on 16/10/17.
//  Copyright © 2016年 dxl. All rights reserved.
//

#import "ViewController.h"
#import "PeripheralManager.h"
#import "CenterManager.h"
#import "CenterViewController.h"
#import "PeripheraViewController.h"

@interface ViewController ()
- (IBAction)centerButton:(UIButton *)sender;
- (IBAction)perButton:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 开启蓝牙, 收集周围RSSI值
    
//    [[PeripheralManager shareInstance] beginScanRSSI];
//    [[CenterManager shareInstance] createAndNotify];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)centerButton:(UIButton *)sender {
    
    CenterViewController *pre = [[CenterViewController alloc] init];
    [self presentViewController:pre animated:YES completion:nil];
}

- (IBAction)perButton:(UIButton *)sender {
    PeripheraViewController *pre = [[PeripheraViewController alloc] init];
    [self presentViewController:pre animated:YES completion:nil];
}
@end
