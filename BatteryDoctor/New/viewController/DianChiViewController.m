//
//  DianChiViewController.m
//  BatteryDoctor
//
//  Created by zhuang chaoxiao on 2018/10/8.
//  Copyright © 2018年 zhuang chaoxiao. All rights reserved.
//

#import "DianChiViewController.h"
#import "CommData.h"
#import "DianChiPerView.h"
#import "Masonry.h"
#import "YCMenuView.h"
#import "JiBenViewController.h"
#import "YinPanViewController.h"
#import "LiuLiangViewController.h"
#import "NetworkSpeedViewController.h"
#import "NetSpyViewController.h"
#import "SignViewController.h"
#import "AdvertViewController.h"

@interface DianChiViewController ()

@property (strong, nonatomic) IBOutlet UIView *processView;
@property (strong, nonatomic) IBOutlet UILabel *percentLab;
@property (strong, nonatomic) IBOutlet UIView *timeBgView;
@property (strong, nonatomic) IBOutlet UIView *advBgView;

@property (assign,nonatomic) CGFloat percent;
@property (strong,nonatomic) NSArray * timeArray;

@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation DianChiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"电池信息";
    
    self.percent = [self getBatteryPercent];
    self.percentLab.text = [NSString stringWithFormat:@"%.0f",self.percent * 100];
    self.percentLab.text = [self.percentLab.text stringByAppendingString:@"%"];
    
    [self layoutNavs];
    
    [self layoutAdvs];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.interstitial.isReady)
        {
            [self.interstitial presentFromRootViewController:self];
        }
        
    });
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self layoutBatteryProcessView];
    [self layoutTimeView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma private

-(void)layoutAdvs
{
    GADBannerView * banner = [[GADBannerView alloc]initWithAdSize:kGADAdSizeSmartBannerPortrait];
    banner.rootViewController = self;
    banner.adUnitID = @"ca-app-pub-3058205099381432/9692191545";
    
    GADRequest * req = [GADRequest request];
    req.testDevices = @[ @"02257fbde9fc053b183b97056fe93ff4" ];
    [banner loadRequest:req];
    
    [self.advBgView addSubview:banner];
    
    //
    self.interstitial = [[GADInterstitial alloc]
                         initWithAdUnitID:@"ca-app-pub-3058205099381432/5728239831"];
    GADRequest * request = [GADRequest request];
    request.testDevices = @[ @"02257fbde9fc053b183b97056fe93ff4" ];
    [self.interstitial loadRequest:request];
}

-(void)layoutNavs
{
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(leftNavClicked)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    [leftBtn setTintColor:[UIColor whiteColor]];
    
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(rightNavClicked)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [rightBtn setTintColor:[UIColor whiteColor]];
}

-(void)layoutTimeView
{
    for( NSLayoutConstraint * con in self.timeBgView.constraints )
    {
        if ((con.firstItem == self.timeBgView)&&(con.firstAttribute == NSLayoutAttributeHeight ))
        {
            [self.timeBgView removeConstraint:con];
        }
    }
    
    UIView * lastView = nil;
    
    for( int i = 0; i < self.timeArray.count; ++ i )
    {
        NSLog(@"i:%d",i);
        
        DianChiPerView * view = [DianChiPerView view];
        [self.timeBgView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.timeBgView.mas_leading);
            make.trailing.mas_equalTo(self.timeBgView.mas_trailing);
            make.top.mas_equalTo( i == 0 ?  self.timeBgView.mas_top:lastView.mas_bottom);
            
            if( i == self.timeArray.count - 1 )
                make.bottom.mas_equalTo(self.timeBgView.mas_bottom);
            make.height.mas_equalTo(@60);
        }];
        
        [view refreshCell:self.timeArray[i] ];
        
        lastView = view;
    }
    
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

-(CGFloat)getBatteryPercent
{
    return [SystemSharedServices batteryLevel]/100.0;
}

#pragma event
-(void)rightNavClicked
{
    AdvertViewController * vc = [AdvertViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)leftNavClicked
{
    YCMenuAction *action = [YCMenuAction actionWithTitle:@"基本信息" image:nil handler:^(YCMenuAction *action) {
        NSLog(@"点击了%@",action.title);
        
        JiBenViewController * vc = [JiBenViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    YCMenuAction *action1 = [YCMenuAction actionWithTitle:@"内存信息" image:nil handler:^(YCMenuAction *action) {
        NSLog(@"点击了%@",action.title);
        
        YinPanViewController * vc = [YinPanViewController new];
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    YCMenuAction *action2 = [YCMenuAction actionWithTitle:@"硬盘信息" image:nil handler:^(YCMenuAction *action) {
        NSLog(@"点击了%@",action.title);
        
        YinPanViewController * vc = [YinPanViewController new];
        vc.type = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }];
   
    YCMenuAction *action4 = [YCMenuAction actionWithTitle:@"流量信息" image:nil handler:^(YCMenuAction *action) {
        NSLog(@"点击了%@",action.title);
        
        LiuLiangViewController * vc = [LiuLiangViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    YCMenuAction *action5 = [YCMenuAction actionWithTitle:@"网速测试" image:nil handler:^(YCMenuAction *action) {
        NSLog(@"点击了%@",action.title);
        
        NetworkSpeedViewController * vc = [NetworkSpeedViewController new];
        [self presentViewController:vc animated:YES completion:nil];
        
    }];
    
    YCMenuAction *action6 = [YCMenuAction actionWithTitle:@"设备监控" image:nil handler:^(YCMenuAction *action) {
        NSLog(@"点击了%@",action.title);
        
        NetSpyViewController * vc = [NetSpyViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    YCMenuAction *action7 = [YCMenuAction actionWithTitle:@"签到惊喜" image:nil handler:^(YCMenuAction *action) {
        NSLog(@"点击了%@",action.title);
        
        SignViewController * vc = [SignViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    YCMenuView *view = [YCMenuView menuWithActions:@[action,action1,action2,action4,action5,action6,action7] width:140 relyonView:self.navigationItem.leftBarButtonItem];
    [view show];
}

#pragma setter & getter
-(NSArray*)timeArray
{
    if( !_timeArray )
    {
        NSMutableArray * array = [NSMutableArray new];
        CGFloat minPer = 3.0;
        DianChiTimeModel * model =nil;
        
        model = [DianChiTimeModel new];
        model.color = COLOR_FROM_HEX(0x0bbbbb);
        model.per = 3;
        model.minPer = minPer;
        model.percent = self.percent;
        model.itemName = @"待机";
        [array addObject:model];
        
        model = [DianChiTimeModel new];
        model.color = COLOR_FROM_HEX(0xce1d1d);
        model.per = 15;
        model.minPer = minPer;
        model.percent = self.percent;
        model.itemName = @"看视频";
        [array addObject:model];
        
        model = [DianChiTimeModel new];
        model.color = COLOR_FROM_HEX(0xdfae23);
        model.per = 5;
        model.minPer = minPer;
        model.percent = self.percent;
        model.itemName = @"看网页";
        [array addObject:model];
        
        model = [DianChiTimeModel new];
        model.color = COLOR_FROM_HEX(0x23a8df);
        model.per = 10;
        model.minPer = minPer;
        model.percent = self.percent;
        model.itemName = @"听音乐";
        [array addObject:model];
        
        model = [DianChiTimeModel new];
        model.color = COLOR_FROM_HEX(0xdf23b5);
        model.per = 10;
        model.minPer = minPer;
        model.percent = self.percent;
        model.itemName = @"玩游戏";
        [array addObject:model];
        
        model = [DianChiTimeModel new];
        model.color = COLOR_FROM_HEX(0x5fc315);
        model.per = 5;
        model.minPer = minPer;
        model.percent = self.percent;
        model.itemName = @"聊微信";
        [array addObject:model];
        
        model = [DianChiTimeModel new];
        model.color = COLOR_FROM_HEX(0x9223df);
        model.per = 8;
        model.minPer = minPer;
        model.percent = self.percent;
        model.itemName = @"打电话";
        [array addObject:model];
        
        _timeArray = [NSArray arrayWithArray:array];
    }
    
    return _timeArray;
}

@end
