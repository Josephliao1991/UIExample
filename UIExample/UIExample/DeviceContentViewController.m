//
//  DeviceContentViewController.m
//  UIExample
//
//  Created by 廖宗綸 on 2015/4/21.
//  Copyright (c) 2015年 Joseph Liao. All rights reserved.
//

#import "DeviceContentViewController.h"

@interface DeviceContentViewController ()

@end

@implementation DeviceContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"Now Is %d Device",self.device);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
