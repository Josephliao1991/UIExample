//
//  NDDiscovery.m
//  INDtest
//
//  Created by Kefan Jian on 2015/4/20.
//  Copyright (c) 2015年 kefanjian. All rights reserved.
//

#import "NDDiscovery.h"


@interface NDDiscovery () <CBCentralManagerDelegate, CBPeripheralDelegate> {
    BOOL				pendingInit;
}
@property CBCentralManager *centralManager;

@end


@implementation NDDiscovery


#pragma mark -
#pragma mark Init
/****************************************************************************/
/*									Init									*/
/****************************************************************************/

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        pendingInit = YES;
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
        
        _foundPeripherals = [[NSMutableArray alloc] init];
        _connectedServices = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark Restoring
/****************************************************************************/
/*								Settings									*/
/****************************************************************************/
/* Reload from file. */
- (void) loadSavedDevices
{
    NSArray	*storedDevices	= [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
    
    if (![storedDevices isKindOfClass:[NSArray class]]) {
        NSLog(@"No stored array to load");
        return;
    }
    
    NSMutableArray *uuidArray = [NSMutableArray new];
    
    for (id deviceUUIDString in storedDevices) {
        
        if (![deviceUUIDString isKindOfClass:[NSString class]])
            continue;
        
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:deviceUUIDString];
        [uuidArray addObject: uuid];
    }
    
    _memberPeripherals = [_centralManager retrievePeripheralsWithIdentifiers:uuidArray];
    [self connectMemberPeripherals:_memberPeripherals];
    
    [_discoveryDelegate discoveryDidRefresh];
}


- (void) addSavedDevice:(CBPeripheral*) peripheral
{
    NSArray			*storedDevices	= [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
    NSMutableArray	*newDevices		= nil;
    
//    if (![storedDevices isKindOfClass:[NSArray class]]) {
//        NSLog(@"Can't find/create an array to store the uuid");
//        return;
//    }
    
    newDevices = [NSMutableArray arrayWithArray:storedDevices];
    
    if (peripheral.identifier) {
        [newDevices addObject:peripheral.identifier.UUIDString];
    }
    /* Store */
    [[NSUserDefaults standardUserDefaults] setObject:newDevices forKey:@"StoredDevices"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void) removeSavedDevice:(CBPeripheral*) peripheral
{
    NSArray			*storedDevices	= [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
    NSMutableArray	*newDevices		= nil;
    
    if ([storedDevices isKindOfClass:[NSArray class]]) {
        newDevices = [NSMutableArray arrayWithArray:storedDevices];
        
        if (peripheral.identifier) {
            [newDevices removeObject:peripheral.identifier.UUIDString];
        }
        
        /* Store */
        [[NSUserDefaults standardUserDefaults] setObject:newDevices forKey:@"StoredDevices"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (void) centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    CBPeripheral	*peripheral;
    
    /* Add to list. */
    for (peripheral in peripherals) {
        [central connectPeripheral:peripheral options:nil];
    }
    [_discoveryDelegate discoveryDidRefresh];
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals {
    for (CBPeripheral* peripheral in peripherals) {
        [central connectPeripheral:peripheral options:nil];
        [_discoveryDelegate discoveryDidRefresh];
    }
}


#pragma mark -
#pragma mark Discovery
/****************************************************************************/
/*								Discovery                                   */
/****************************************************************************/
- (void) startScanningForUUIDString:(NSString *)uuidString
{
//    NSArray			*uuidArray	= [NSArray arrayWithObjects:[CBUUID UUIDWithString:uuidString], nil];
    NSDictionary	*options	= [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    
    [_centralManager scanForPeripheralsWithServices:nil options:options];
}


- (void) stopScanning
{
    [_centralManager stopScan];
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (![_foundPeripherals containsObject:peripheral]) {
        [_foundPeripherals addObject:peripheral];
        [_discoveryDelegate discoveryDidRefresh];
    }
}


#pragma mark -
#pragma mark Connection/Disconnection
/****************************************************************************/
/*						Connection/Disconnection                            */
/****************************************************************************/
- (void) connectPeripheral:(CBPeripheral*)peripheral
{
    if (peripheral.state != CBPeripheralStateConnected) {
        [_centralManager connectPeripheral:peripheral options:nil];
    }
}


- (void) disconnectPeripheral:(CBPeripheral*)peripheral
{
    [_centralManager cancelPeripheralConnection:peripheral];
}

- (void) connectMemberPeripherals:(NSArray *)peripherals {
    for (CBPeripheral *peripheral in peripherals) {
        [self connectPeripheral:peripheral];
    }
}

- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NDHeartRateService	*service	= nil;
    
    /* Create a service instance. */
    service = [[NDHeartRateService alloc] initWithPeripheral:peripheral controller:_peripheralDelegate];
    [service start];

    if (![_connectedServices containsObject:service])
        [_connectedServices addObject:service];

    if ([_foundPeripherals containsObject:peripheral])
        [_foundPeripherals removeObject:peripheral];

//    [_peripheralDelegate heartRateServiceDidChangeStatus:service];
    if (![_memberPeripherals containsObject:peripheral]) {
//        [self addSavedDevice:peripheral];
    }
    [_discoveryDelegate discoveryDidRefresh];
}


- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Attempted connection to peripheral %@ failed: %@", [peripheral name], [error localizedDescription]);
}


- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NDHeartRateService	*service	= nil;
    
    for (service in _connectedServices) {
        if ([service peripheral] == peripheral) {
            [_connectedServices removeObject:service];
//            [_peripheralDelegate heartRateServiceDidChangeStatus:service];
            break;
        }
    }
    
    [_discoveryDelegate discoveryDidRefresh];
}


- (void) clearDevices
{
    NDHeartRateService	*service;
    [_foundPeripherals removeAllObjects];
    
    for (service in _connectedServices) {
        [service reset];
    }
    [_connectedServices removeAllObjects];
}


- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    static CBCentralManagerState previousState = -1;
    
    switch ([central state]) {
        case CBCentralManagerStatePoweredOff:
        {
            [self clearDevices];
            [_discoveryDelegate discoveryDidRefresh];
            
            /* Tell user to power ON BT for functionality, but not on first run - the Framework will alert in that instance. */
            if (previousState != -1) {
                [_discoveryDelegate discoveryStatePoweredOff];
            }
            break;
        }
            
        case CBCentralManagerStateUnauthorized:
        {
            /* Tell user the app is not allowed. */
            break;
        }
            
        case CBCentralManagerStateUnknown:
        {
            /* Bad news, let's wait for another event. */
            break;
        }
            
        case CBCentralManagerStatePoweredOn:
        {
            NSArray	*storedDevices	= [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
            NSMutableArray *uuidArray = [NSMutableArray new];
            for (NSString *deviceUUIDString in storedDevices) {
                NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:deviceUUIDString];
                [uuidArray addObject: uuid];
            }
            pendingInit = NO;
            [self loadSavedDevices];
            [_centralManager retrievePeripheralsWithIdentifiers:uuidArray];
            [_centralManager scanForPeripheralsWithServices:nil options:nil];
            [_discoveryDelegate discoveryDidRefresh];
            break;
        }
            
        case CBCentralManagerStateResetting:
        {
            [self clearDevices];
            [_discoveryDelegate discoveryDidRefresh];
            [_peripheralDelegate heartRateServiceDidReset];
            
            pendingInit = YES;
            break;
        }
    }
    
    previousState = [_centralManager state];
}




@end
