//
//  ViewController.m
//  UIExample
//
//  Created by 廖宗綸 on 2015/4/21.
//  Copyright (c) 2015年 Joseph Liao. All rights reserved.
//

#import "ViewController.h"
#import "ScanCollectionViewController.h"
#import "DeviceContentViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIVisualEffectView *theLeftSideView;

@property (weak, nonatomic) IBOutlet UIButton *cat;
@property (weak, nonatomic) IBOutlet UIButton *kid;
@property (weak, nonatomic) IBOutlet UIButton *run;
@property (weak, nonatomic) IBOutlet UIButton *add;
@property (weak, nonatomic) IBOutlet UIButton *ooo;
@property (weak, nonatomic) IBOutlet UIButton *server;
@property (weak, nonatomic) IBOutlet UIButton *opendoor;


@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.kid setBackgroundImage:[UIImage imageNamed:@"kid.jpg"] forState:UIControlStateNormal];
    [self.add setBackgroundImage:[UIImage imageNamed:@"add.jpg"] forState:UIControlStateNormal];
    [self.cat setBackgroundImage:[UIImage imageNamed:@"lada.jpg"] forState:UIControlStateNormal];
    [self.run setBackgroundImage:[UIImage imageNamed:@"run.jpg"] forState:UIControlStateNormal];
    [self.server setBackgroundImage:[UIImage imageNamed:@"server.jpg"] forState:UIControlStateNormal];
    [self.ooo setBackgroundImage:[UIImage imageNamed:@"sport.jpg"] forState:UIControlStateNormal];
    [self.opendoor setBackgroundImage:[UIImage imageNamed:@"door.jpg"] forState:UIControlStateNormal];
    

    
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

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.theLeftSideView.frame = CGRectMake(-self.view.frame.size.width/2, 0, self.view.frame.size.width/2, self.view.frame.size.height);
    
//    self.cat.layer.cornerRadius = 15;
//    self.kid.layer.cornerRadius = 15;
//    self.run.layer.cornerRadius = 15;
//    self.ooo.layer.cornerRadius = 15;
//    self.opendoor.layer.cornerRadius = 15;
//    self.server.layer.cornerRadius = 15;
//    self.add.layer.cornerRadius = 15;
}

#pragma -
#pragma -mark IBAction Setting

-(void)goToDeviceContentView_device:(int)device{
    
    DeviceContentViewController *deviceContentViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"DeviceContentViewController"];
    
    deviceContentViewController.device = device;
    
    [self presentViewController:deviceContentViewController animated:YES completion:^{
        //
    }];
    
}

- (IBAction)cat:(UIButton *)sender {
    
    [self goToDeviceContentView_device:0];
}

- (IBAction)kid:(UIButton *)sender {
    
    [self goToDeviceContentView_device:1];
}

- (IBAction)run:(UIButton *)sender {
    
    [self goToDeviceContentView_device:2];
}

- (IBAction)ooo:(UIButton *)sender {
    
    [self goToDeviceContentView_device:3];
}

- (IBAction)server:(UIButton *)sender {
    
    [self goToDeviceContentView_device:4];
}

- (IBAction)opendoor:(UIButton *)sender {
    
    [self goToDeviceContentView_device:5];
}

- (IBAction)thePanGesture:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        
    CGPoint velocity = [sender velocityInView:self.view];
//    CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
//    CGFloat slideMult = magnitude / 200;
//    NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
//    
//    float slideFactor = 0.1 * slideMult; // Increase for more of a slide
//    CGPoint finalPoint = CGPointMake(sender.view.center.x + (velocity.x * slideFactor),
//                                     sender.view.center.y + (velocity.y * slideFactor));
//        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.view.bounds.size.width);
//        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.view.bounds.size.height);
//        
//        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            sender.view.center = finalPoint;
//        } completion:nil];
        
        if (velocity.x>0) {
            
            [UIView animateWithDuration:0.3 animations:^{
                self.theLeftSideView.frame = CGRectMake(0, 0,
                                                        self.theLeftSideView.frame.size.width,
                                                        self.theLeftSideView.frame.size.height);
                
            } completion:^(BOOL finished) {
                //
            }];
            
        }else{
            
            [UIView animateWithDuration:0.3 animations:^{
                self.theLeftSideView.frame = CGRectMake(-self.theLeftSideView.frame.size.width, 0,
                                                        self.theLeftSideView.frame.size.width,
                                                        self.theLeftSideView.frame.size.height);
                
            } completion:^(BOOL finished) {
                //
            }];
            
        }
    }
}



@end
