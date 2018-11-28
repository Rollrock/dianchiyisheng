//
//  YinPanViewController.m
//  BatteryDoctor
//
//  Created by zhuang chaoxiao on 2018/10/8.
//  Copyright © 2018年 zhuang chaoxiao. All rights reserved.
//

#import "YinPanViewController.h"
#import "CommData.h"
#import "CommInfo.h"

@interface YinPanViewController ()

@property (strong, nonatomic) IBOutlet UIView *processView;
@property (assign,nonatomic) CGFloat percent;
@property (strong, nonatomic) IBOutlet UILabel *percentLab;

@property (strong, nonatomic) IBOutlet UILabel *totalLab;
@property (strong, nonatomic) IBOutlet UILabel *usedLab;


@end

@implementation YinPanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if( self.type == 0 )
        self.title = @"硬盘信息";
    else
        self.title = @"内存信息";
    
    CGFloat usedPer  = 0;
    NSString * totalStr = nil;
    
    if( self.type == 0 )
    {
        usedPer = [[SystemSharedServices usedDiskSpaceinPercent] floatValue];
        totalStr = [SystemSharedServices diskSpace];
        self.percent = usedPer/100.0;
        self.totalLab.text = totalStr;
        self.usedLab.text = [NSString stringWithFormat:@"%0.2fG",[totalStr floatValue]*usedPer/100];
        self.percentLab.text = [NSString stringWithFormat:@"%0.0f%%",usedPer];
    }
    else
    {
        usedPer = [SystemSharedServices usedMemoryinPercent];
        totalStr = [NSString stringWithFormat:@"%0.0fM",[SystemSharedServices totalMemory]];
        self.percent = usedPer/100.0;
        self.totalLab.text = totalStr;
        self.usedLab.text = [NSString stringWithFormat:@"%0.0fM",[totalStr floatValue]*usedPer/100];
        self.percentLab.text = [NSString stringWithFormat:@"%0.0f%%",usedPer];
    }
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self layoutBatteryProcessView];
}

-(void)layoutBatteryProcessView
{
    NSLog(@"=========layoutBatteryProcessView=========");
    
    [self.processView layoutIfNeeded];
    
    CGFloat viewWidth = self.processView.frame.size.width;
    CGFloat viewHeight = self.processView.frame.size.height;
    
    CGFloat lineWidth = 30.0f;
    //
    
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = lineWidth;
    layer.strokeColor = COLOR_FROM_HEX(0x28AEB1).CGColor;
    layer.lineCap = kCALineCapRound;
    
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(viewWidth/2.0, viewHeight/2.0) radius:viewHeight/2.0-lineWidth/2.0 startAngle:ZZCircleDegreeToRadian(0) endAngle:ZZCircleDegreeToRadian(360*self.percent) clockwise:YES];
    layer.path = path.CGPath;
    
    CAShapeLayer * backLayer = [CAShapeLayer layer];
    backLayer.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    backLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    backLayer.fillColor = [UIColor clearColor].CGColor;
    backLayer.lineWidth = lineWidth;
    backLayer.strokeColor = RGB(38, 38, 38).CGColor;
    backLayer.lineCap = kCALineCapRound;
    
    UIBezierPath * backPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(viewWidth/2.0, viewHeight/2.0) radius:viewHeight/2.0-lineWidth/2.0 startAngle:ZZCircleDegreeToRadian(0) endAngle:ZZCircleDegreeToRadian(361) clockwise:YES];
    backLayer.path = backPath.CGPath;
    
    [self.processView.layer addSublayer:backLayer];
    [self.processView.layer addSublayer:layer];
    
    //
    
}
@end
