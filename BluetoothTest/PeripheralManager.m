//
//  PeripheralManager.m
//  BluetoothTest
//
//  Created by 邓西亮 on 16/10/17.
//  Copyright © 2016年 dxl. All rights reserved.
//

#import "PeripheralManager.h"

static id instance = nil;

@interface PeripheralManager ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic, strong) NSMutableArray *peripheralMarr; // 接收 外设 的数组
@property (nonatomic, strong) CBPeripheral *perip; // 外围设备
@property (nonatomic, strong) NSTimer * scanPeripheralTimer; //搜索周边设备的定时器


@end

@implementation PeripheralManager

+ (id)shareInstance{
    
    if (instance == nil){
        instance = [[PeripheralManager alloc] init];
    }
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        //串行队列
        dispatch_queue_t centralQueue = dispatch_queue_create("YiKai_ScanRSSI", DISPATCH_QUEUE_SERIAL);
        self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:centralQueue];
    }
    return self;
}

- (NSMutableArray *)peripheralMarr{
    if (_peripheralMarr == nil) {
        _peripheralMarr = [NSMutableArray array];
    }
    return _peripheralMarr;
}

// 外围蓝牙设备
- (void)beginScanRSSI{
    [self.peripheralMarr removeAllObjects];
    if (!_scanPeripheralTimer) {
        //计时器设定1秒扫描一次
        _scanPeripheralTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(scanForPeripherals) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_scanPeripheralTimer forMode:NSDefaultRunLoopMode];
    }
    if (_scanPeripheralTimer && !_scanPeripheralTimer.valid) {
        [_scanPeripheralTimer fire];
    }
}

// 设备成功打开的委托方法，并在此委托方法中扫描设备
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"CBCentralManagerStatePoweredOn");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStateUnknown:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CBCentralManagerStateUnsupported");
            break;
        default:
            break;
    }
}

// 搜索周边设备
- (void)scanForPeripherals{
//    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
//        if (self.manager.state == CBCentralManagerStateUnsupported) {
//            // 如果设备不支持蓝牙
//            NSLog(@"设备不支持蓝牙");
//        }else { // 如果设备支持蓝牙连接
            if (self.manager.state == CBCentralManagerStatePoweredOn) {
                // 蓝牙开启状态时 搜索周边设备
                [self.manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:[NSNumber numberWithBool:NO]}];
            }
//        }
        // 成功连接蓝牙后开始获取 rssi 值
        [self.perip readRSSI];
    }
//}

// 扫描到设备会进入方法 RSSI == 信号强度值  advertisementData == 外设广播的数据
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    // 如果搜索到的外设有值 则挑选出同APP发出的广播 用 model 来接取外设和RSSI值
    NSString *name = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if ([name hasPrefix:@"meou_"]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"UserId"] = [name substringFromIndex:5];
        dict[@"RSSI"] = RSSI;
        
        // 如果外设数组里没值,直接将该 model 添加到外设数组中
        if (_peripheralMarr.count == 0) {
            [_peripheralMarr addObject:dict];
        }else{
            BOOL isYes = NO;
            // 如果外设数组有值则遍历数组 利用名称判断该设备是否已经存在数组中
            for (NSMutableDictionary *childDict in _peripheralMarr) {
                //如果 外设名称相同  则 只修改 该外设 所对应的 rssi
                if ([childDict[@"UserId"] isEqualToString:dict[@"UserId"]]) {
                    childDict[@"RSSI"] = dict[@"RSSI"];
                    isYes = YES;
                    break;
                }
            }
            if (!isYes) {
                [_peripheralMarr addObject:dict];
            }
        }
    }
}

// 停止扫描周围设备, 返回扫描到的设备信息
- (NSArray *)stopScanForPeripherals{
    [_scanPeripheralTimer invalidate];
    _scanPeripheralTimer = nil;
    return [self.peripheralMarr copy];
}

@end
