//
//  CenterManager.m
//  BluetoothTest
//
//  Created by 邓西亮 on 16/10/17.
//  Copyright © 2016年 dxl. All rights reserved.
//

#import "CenterManager.h"

#define APPBLUEID @"YiKaiDemo_" // 每个APP的蓝牙ID
#define USERID @"yikai2" // 每个设备在APP上的用户名, 每个都不一样

static id instance = nil;

@interface CenterManager () <CBPeripheralManagerDelegate>

@end

@implementation CenterManager

{
    CBPeripheralManager * _peripheralManager;
    CBMutableService * _peripheralService;
    CBMutableCharacteristic * _peripheralCharacteristic;
}

+ (id)shareInstance{
    
    if (instance == nil){
        instance = [[CenterManager alloc] init];
    }
    return instance;
}

#pragma mark - create notity
// 创建外围设备管理器
- (void)createAndNotify{
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)]; // 在子线线程创建
}

#pragma mark - Peripheral delegate Action
//更新状态 ，只有状态可用的时候才能够进行创建服务，发布等等操作
//状态和CBCentralManager一样
// 代理方法 发送广播
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    if (peripheral.state != CBPeripheralManagerStatePoweredOn){
        return;
    }
    // 这里ID保证每个都不一样
    NSString * locId = @"test123";
    [_peripheralManager startAdvertising:@{
                                           CBAdvertisementDataLocalNameKey: [NSString stringWithFormat:@"meou_%@", locId],
                                           }];
}

-(void)peripheralManager:(CBPeripheralManager *)peripheral willRestoreState:(NSDictionary<NSString *,id> *)dict{
    NSLog(@"willRestoreState");
}

@end
