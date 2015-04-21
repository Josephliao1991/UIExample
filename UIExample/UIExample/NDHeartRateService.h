//
//  NDHeartRateService.h
//  INDtest
//
//  Created by Kefan Jian on 2015/4/20.
//  Copyright (c) 2015年 kefanjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class NDHeartRateService;

/****************************************************************************/
/*						Temperature Alarm service.                          */
/****************************************************************************/

@protocol NDHeartRateServiceProtocol <NSObject>
- (void)heartRateServiceDidChangeStatus:(NDHeartRateService*)service;
- (void)heartRateServiceDidReset;
- (void)heartRateServiceDidReceivedNotify:(NDHeartRateService*)service;

@end


@interface NDHeartRateService : NSObject

- (id) initWithPeripheral:(CBPeripheral *)peripheral controller:(id<NDHeartRateServiceProtocol>)controller;
- (void) reset;
- (void) start;

@property (readonly) uint8_t heartRate;


/* Behave properly when heading into and out of the background */
- (void)enteredBackground;
- (void)enteredForeground;

@property (readonly) CBPeripheral *peripheral;

@end
