//
//  ViewController.m
//  UIExample
//
//  Created by 廖宗綸 on 2015/4/21.
//  Copyright (c) 2015年 Joseph Liao. All rights reserved.
//

#import "ViewController.h"
#import "ScanCollectionViewController.h"

@interface ViewController ()

@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)newDeviceButton:(UIButton *)sender {
    
    ScanCollectionViewController * scanCollectionViewController =
    [[self storyboard] instantiateViewControllerWithIdentifier:@"ScanCollectionViewController"];
    
    [self presentViewController:scanCollectionViewController animated:YES completion:^{
        //
    }];
}



@end
