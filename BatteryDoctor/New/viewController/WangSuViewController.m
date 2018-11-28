//
//  WangSuViewController.m
//  BatteryDoctor
//
//  Created by zhuang chaoxiao on 2018/10/8.
//  Copyright © 2018年 zhuang chaoxiao. All rights reserved.
//

#import "WangSuViewController.h"

@interface WangSuViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *pointImgView;


@end

@implementation WangSuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"网速测试";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma event
-(void)showPointView
{
    [UIView animateWithDuration:0.5 animations:^{

        CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI/4);
        //[btn setTransform:transform];
        
    } completion:^(BOOL finished) {
        //btn.transform = CGAffineTransformIdentity;
    }];
}

@end
