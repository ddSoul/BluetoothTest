//
//  PeripheralManager.h
//  BluetoothTest
//
//  Created by 邓西亮 on 16/10/17.
//  Copyright © 2016年 dxl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface PeripheralManager : NSObject

@property (nonatomic, strong) CBCentralManager *manager; // 设备管理中心
+ (id)shareInstance;

// 开始收集外围蓝牙设备
- (void)beginScanRSSI;
// 停止扫描周围设备,返回搜集到的同款APP发出的蓝牙设备
- (NSArray *)stopScanForPeripherals;

@end
