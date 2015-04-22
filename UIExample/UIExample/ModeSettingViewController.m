//
//  ModeSettingViewController.m
//  UIExample
//
//  Created by Kefan Jian on 2015/4/22.
//  Copyright (c) 2015年 Joseph Liao. All rights reserved.
//

#import "ModeSettingViewController.h"
#import "JT3DScrollView.h"

@interface ModeSettingViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet JT3DScrollView *modeScrollView;

@end

@implementation ModeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.modeScrollView.delegate = self;
    self.modeScrollView.effect = JT3DScrollViewEffectCarousel;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self createCardWithColor];
    [self createCardWithColor];
    [self createCardWithColor];
    [self createCardWithColor];
    
    

}

- (void)createCardWithColor
{
    CGFloat width = CGRectGetWidth(self.modeScrollView.frame);
    CGFloat height = CGRectGetHeight(self.modeScrollView.frame);

    
    CGFloat x = self.modeScrollView.subviews.count * width;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, width, height)];
    imageView.backgroundColor = [UIColor orangeColor];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    imageView.image = [UIImage imageNamed:@"sport.png"];
    imageView.layer.cornerRadius = 0.8;
    
    [self.modeScrollView addSubview:imageView];
    self.modeScrollView.contentSize = CGSizeMake(x + width, height);
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
