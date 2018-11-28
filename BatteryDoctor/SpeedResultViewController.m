//
//  SpeedResultViewController.m
//  NewiPhoneADV
//
//  Created by zhuang chaoxiao on 15/8/15.
//  Copyright (c) 2015年 zhuang chaoxiao. All rights reserved.
//

#import "SpeedResultViewController.h"
#import "commData.h"

@interface SpeedResultViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgBgView;
- (IBAction)backClicked;
- (IBAction)shareClicked;

@end

@implementation SpeedResultViewController


-(NSString*)tranSpeed
{
    CGFloat per = _speed/(1048576/2);//全国平均 512K
    
    per = (per>0.99? 0.99:per);
    
    return [NSString stringWithFormat:@"%0.0f%%",per*100];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString * strSpeed = nil;
    
    if( _speed/1048576>=1.0)
    {
        strSpeed = [NSString stringWithFormat:@"%.2fM/s",_speed/1048576];
    }
    else if( _speed/1024>=1.0)
    {
        strSpeed = [NSString stringWithFormat:@"%.2fK/s",_speed/1024];
    }
    else
    {
        strSpeed = [NSString stringWithFormat:@"%dB/s",(int)_speed];
    }
   
    
    UILabel * speedLab1 = [[UILabel alloc]initWithFrame:CGRectMake(100, 160, 120, 25)];
    speedLab1.text = strSpeed;
    speedLab1.textAlignment = NSTextAlignmentCenter;
    speedLab1.font = [UIFont systemFontOfSize:26];
    [_imgBgView addSubview:speedLab1];
    
    
    UILabel * speedLab3 = [[UILabel alloc]initWithFrame:CGRectMake(170, 340, 100, 25)];
    speedLab3.text = [self tranSpeed];
    speedLab3.font = [UIFont systemFontOfSize:20];
    [_imgBgView addSubview:speedLab3];

//
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"NavBack"] style:UIBarButtonItemStyleDone target:self action:@selector(leftClicked)];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    
}

-(void)leftClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareClicked
{
    
}
@end
