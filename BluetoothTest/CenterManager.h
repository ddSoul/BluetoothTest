//
//  CenterManager.h
//  BluetoothTest
//
//  Created by 邓西亮 on 16/10/17.
//  Copyright © 2016年 dxl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface CenterManager : NSObject

+ (id)shareInstance;

- (void)createAndNotify;

@end
