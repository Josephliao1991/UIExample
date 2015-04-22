//
//  ScanCollectionViewController.m
//  UIExample
//
//  Created by Kefan Jian on 2015/4/21.
//  Copyright (c) 2015年 Joseph Liao. All rights reserved.
//

#import "ScanCollectionViewController.h"
#import "ModeSettingViewController.h"

@interface ScanCollectionViewController () <NDDiscoveryDelegate,NDHeartRateServiceProtocol>

@end

@implementation ScanCollectionViewController {
    NSUInteger cellCount;
    NSArray* reversedArray;
    NSIndexPath* saveIndexPath;
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [[NDDiscovery sharedInstance] setDiscoveryDelegate:self];
    [[NDDiscovery sharedInstance] setPeripheralDelegate:self];
    
    
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.collectionView addGestureRecognizer:tapRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint initialPinchPoint = [sender locationInView:self.collectionView];
        NSIndexPath* tappedCellPath = [self.collectionView indexPathForItemAtPoint:initialPinchPoint];
        saveIndexPath = tappedCellPath;
        if (tappedCellPath!=nil)
        {
            CBPeripheral *peripheral = reversedArray[tappedCellPath.row];
            [[NDDiscovery sharedInstance] connectPeripheral:peripheral];
        }
        else
        {
            
        }
    }
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return cellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    CBPeripheral *peripheral = [reversedArray objectAtIndex:indexPath.row];
    cell.label.text = peripheral.name;
    
    return cell;
}

- (void)discoveryDidRefresh {
    
    NSArray *foundPeripherals = [[NDDiscovery sharedInstance] foundPeripherals];
    
    CBPeripheral *didConnectPeripheral;
    
    for (CBPeripheral *peripheral in foundPeripherals) {
        if (![reversedArray containsObject:peripheral]) {
            didConnectPeripheral = peripheral;
        }
    }
    
    reversedArray = [[NSArray alloc] initWithArray:[[foundPeripherals reverseObjectEnumerator] allObjects]];

    
    
    if (cellCount < [[[NDDiscovery sharedInstance] foundPeripherals] count]) {
        cellCount = [[[NDDiscovery sharedInstance] foundPeripherals] count];
        [self.collectionView performBatchUpdates:^{
            [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:0 inSection:0]]];
            
        } completion:^(BOOL finished) {
            [self.collectionView reloadData];

        }];

    } else if (cellCount > [[[NDDiscovery sharedInstance] foundPeripherals] count]) {
        cellCount = [[[NDDiscovery sharedInstance] foundPeripherals] count];
        
        
        
        [self.collectionView performBatchUpdates:^{
            if (saveIndexPath) {
                [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:saveIndexPath]];
            }
        } completion:^(BOOL finished) {
            //
            ModeSettingViewController *msvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ModeSetting"];
            [self presentViewController:msvc animated:YES completion:^{
                [[NDDiscovery sharedInstance] stopScanning];
            }];
            
        }];

        
    }
    
}



- (void)heartRateServiceDidReceivedNotify:(NDHeartRateService *)service {
    
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
