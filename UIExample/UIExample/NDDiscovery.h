//
//  NDDiscovery.h
//  INDtest
//
//  Created by Kefan Jian on 2015/4/20.
//  Copyright (c) 2015年 kefanjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "NDHeartRateService.h"

/****************************************************************************/
/*							UI protocols									*/
/****************************************************************************/
@protocol NDDiscoveryDelegate <NSObject>
@optional
- (void)discoveryDidRefresh;
- (void)discoveryStatePoweredOff;
@end



/****************************************************************************/
/*							Discovery class									*/
/****************************************************************************/
@interface NDDiscovery : NSObject

+ (id) sharedInstance;


/****************************************************************************/
/*								UI controls									*/
/****************************************************************************/
@property (nonatomic, assign) id<NDDiscoveryDelegate>           discoveryDelegate;
@property (nonatomic, assign) id<NDHeartRateServiceProtocol>	peripheralDelegate;



/****************************************************************************/
/*								Actions										*/
/****************************************************************************/
- (void) startScanningForUUIDString:(NSString *)uuidString;
- (void) stopScanning;

- (void) connectPeripheral:(CBPeripheral*)peripheral;
- (void) disconnectPeripheral:(CBPeripheral*)peripheral;


/****************************************************************************/
/*							Access to the devices							*/
/****************************************************************************/
@property (retain, nonatomic) NSMutableArray    *foundPeripherals;
@property (retain, nonatomic) NSMutableArray	*connectedServices;
@property (retain, nonatomic) NSArray           *memberPeripherals;

@end
