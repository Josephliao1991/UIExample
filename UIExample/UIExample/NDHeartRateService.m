//
//  NDHeartRateService.m
//  INDtest
//
//  Created by Kefan Jian on 2015/4/20.
//  Copyright (c) 2015年 kefanjian. All rights reserved.
//

#import "NDHeartRateService.h"

NSString *kHeartRateServiceUUIDString = @"180D";
NSString *kHeartRateCharacteristicUUIDString = @"2A37";



@interface NDHeartRateService () <CBPeripheralDelegate> {
@private
    CBPeripheral		*servicePeripheral;
    
    CBService			*heartRateService;
    
    CBCharacteristic    *heartRateCharacteristic;
    
    CBUUID *heartRateCharacteristicUUID;
    
    id<NDHeartRateServiceProtocol>	peripheralDelegate;

}

@end

@implementation NDHeartRateService

@synthesize peripheral = servicePeripheral;


- (id)initWithPeripheral:(CBPeripheral *)peripheral controller:(id<NDHeartRateServiceProtocol>)controller {
    self = [super init];
    if (self) {
        servicePeripheral = peripheral;
        servicePeripheral.delegate = self;
        peripheralDelegate = controller;
        
        heartRateCharacteristicUUID = [CBUUID UUIDWithString:kHeartRateCharacteristicUUIDString];
    }
    return self;
}

- (void)reset {
    if (servicePeripheral) {
        servicePeripheral = nil;
    }
}

#pragma mark -
#pragma mark Service interaction
/****************************************************************************/
/*							Service Interactions							*/
/****************************************************************************/
- (void) start
{
    CBUUID	*serviceUUID	= [CBUUID UUIDWithString:kHeartRateServiceUUIDString];
    NSArray	*serviceArray	= [NSArray arrayWithObjects:serviceUUID, nil];
    
    [servicePeripheral discoverServices:serviceArray];
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSArray		*services	= nil;
    NSArray		*uuids	= @[heartRateCharacteristicUUID];
    
    if (peripheral != servicePeripheral) {
        NSLog(@"Wrong Peripheral.\n");
        return ;
    }
    
    if (error != nil) {
        NSLog(@"Error %@\n", error);
        return ;
    }
    
    services = [peripheral services];
    NSLog(@"%@",[peripheral services]);
    if (!services || ![services count]) {
        return ;
    }
    
    heartRateService = nil;
    
    for (CBService *service in services) {
        if ([[service UUID] isEqual:[CBUUID UUIDWithString:kHeartRateServiceUUIDString]]) {
            heartRateService = service;
            break;
        }
    }
    
    if (heartRateService) {
        [peripheral discoverCharacteristics:uuids forService:heartRateService];
    }
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;
{
    NSArray		*characteristics	= [service characteristics];
    CBCharacteristic *characteristic;
    
    if (peripheral != servicePeripheral) {
        NSLog(@"Wrong Peripheral.\n");
        return ;
    }
    
    if (service != heartRateService) {
        NSLog(@"Wrong Service.\n");
        return ;
    }
    
    if (error != nil) {
        NSLog(@"Error %@\n", error);
        return ;
    }
    
    for (characteristic in characteristics) {
        NSLog(@"discovered characteristic %@", [characteristic UUID]);
        if ([characteristic.UUID isEqual:heartRateCharacteristicUUID]) {
            NSLog(@"discovered Heart Rate Characteristic");
            heartRateCharacteristic = characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
    
}

#pragma mark -
#pragma mark Characteristics interaction
/****************************************************************************/
/*						Characteristics Interactions						*/
/****************************************************************************/

- (void)enteredBackground
{
    // Find the fishtank service
    for (CBService *service in [servicePeripheral services]) {
        if ([[service UUID] isEqual:[CBUUID UUIDWithString:kHeartRateServiceUUIDString]]) {
            
            // Find the heartrate characteristic
            for (CBCharacteristic *characteristic in [service characteristics]) {
                if ( [[characteristic UUID] isEqual:[CBUUID UUIDWithString:kHeartRateCharacteristicUUIDString]] ) {
                    
                    // And STOP getting notifications from it
                    [servicePeripheral setNotifyValue:NO forCharacteristic:characteristic];
                }
            }
        }
    }
}

- (void)enteredForeground
{
    // Find the fishtank service
    for (CBService *service in [servicePeripheral services]) {
        if ([[service UUID] isEqual:[CBUUID UUIDWithString:kHeartRateServiceUUIDString]]) {
            
            // Find the temperature characteristic
            for (CBCharacteristic *characteristic in [service characteristics]) {
                if ( [[characteristic UUID] isEqual:[CBUUID UUIDWithString:kHeartRateCharacteristicUUIDString]] ) {
                    
                    // And START getting notifications from it
                    [servicePeripheral setNotifyValue:YES forCharacteristic:characteristic];
                }
            }
        }
    }
}

- (uint8_t)heartRate {
    
    if (heartRateCharacteristic) {
        uint16_t i;
        [[heartRateCharacteristic value]getBytes:&i length:sizeof(i)];
        uint8_t a = CFSwapInt16HostToBig(i);
        return a;
    }
    return -1;
}

- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{

    
    if (peripheral != servicePeripheral) {
        NSLog(@"Wrong peripheral\n");
        return ;
    }
    
    if ([error code] != 0) {
        NSLog(@"Error %@\n", error);
        return ;
    }
    
    if ([characteristic.UUID isEqual:heartRateCharacteristicUUID]) {
        [peripheralDelegate heartRateServiceDidReceivedNotify:self];
    }
}

@end
