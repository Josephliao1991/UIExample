//
//  DeviceContentViewController.m
//  UIExample
//
//  Created by 廖宗綸 on 2015/4/21.
//  Copyright (c) 2015年 Joseph Liao. All rights reserved.
//

#import "DeviceContentViewController.h"
#import "VOSegmentedControl.h"
#import "ModeSettingViewController.h"

@interface DeviceContentViewController ()

{
    NSArray *title;
    NSArray *imageName;
    UIImageView *imageView;
}

@property (weak, nonatomic) IBOutlet UILabel *theTitle;



@end

@implementation DeviceContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    title = @[@"Cat",@"Kid",@"Run",@"重訓",@"中控",@"開冰箱"];
    imageName = @[@"lada",@"kid",@"run",@"sport",@"server",@"door"];
    self.theTitle.text = title[self.device];
    NSLog(@"Now Is %d Device",self.device);
    
    VOSegmentedControl *segctrl1 = [[VOSegmentedControl alloc] initWithSegments:
                                    @[@{@"text": @"Cat",@"image": @"torah-32"},
                                      @{@"text": @"Kid",@"image": @"torah-32"},
                                      @{@"text": @"Run",@"image": @"torah-32"},
                                      @{@"text": @"重訓",@"image": @"torah-32"},
                                      @{@"text": @"中控",@"image": @"torah-32"},
                                      @{@"text": @"開冰箱",@"image": @"s_door.jpg"}]];
    
    segctrl1.contentStyle = VOContentStyleImageTop;
    segctrl1.indicatorStyle = VOSegCtrlIndicatorStyleBox;
    segctrl1.animationType = VOSegCtrlAnimationTypeSmooth;
    segctrl1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    segctrl1.allowNoSelection = NO;
    segctrl1.frame = CGRectMake(0, self.view.frame.size.height-self.view.frame.size.height/8,
                                self.view.frame.size.width, self.view.frame.size.height/8);
//    segctrl1.selectedTextFont = [UIFont systemFontOfSize:15];
    segctrl1.indicatorThickness = 1.5;
    segctrl1.indicatorCornerRadius = 6;
    segctrl1.selectedIndicatorColor = [UIColor blackColor];
    
    segctrl1.tag = 1;
    segctrl1.selectedSegmentIndex = self.device;
    [self.view addSubview:segctrl1];
    [segctrl1 setIndexChangeBlock:^(NSInteger index) {
        NSLog(@"1: block --> %@", @(index));
        
        
        
        
    }];
    [segctrl1 addTarget:self action:@selector(segmentCtrlValuechange:)
       forControlEvents:UIControlEventValueChanged];

    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*0.9,self.view.frame.size.width*0.9)];
    imageView.center = self.view.center;
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",imageName[self.device]]];
    [self.view addSubview:imageView];
    
    
}

- (void)segmentCtrlValuechange: (VOSegmentedControl *)segmentCtrl{
    NSLog(@"%@: value --> %@",@(segmentCtrl.tag), @(segmentCtrl.selectedSegmentIndex));
    self.theTitle.text = title[segmentCtrl.selectedSegmentIndex];
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",imageName[segmentCtrl.selectedSegmentIndex]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma -
#pragma - IBActioin
- (IBAction)editButton:(UIButton *)sender {
    
    ModeSettingViewController *modeSettingViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"ModeSetting"];
    [self presentViewController:modeSettingViewController animated:YES completion:^{
        //
    }];
    
}

- (IBAction)backButton:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
    
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
