//
//  FirstViewController.m
//  BatteryDoctor
//
//  Created by zhuang chaoxiao on 15/8/22.
//  Copyright (c) 2015年 zhuang chaoxiao. All rights reserved.
//

#import "FirstViewController.h"
#import "VWWWaterView.h"
#import "SignViewController.h"
#import "SystemServices.h"
#import "CommData.h"


@import GoogleMobileAds;


#define SystemSharedServices [SystemServices sharedServices]

@interface FirstViewController ()<WaterViewDelegate>
{
    //电池
    CGFloat firstBatteryLevel;
    NSDate * curBatteryTime;
    //
}

@property (weak, nonatomic) IBOutlet UILabel *chargeCountLab;
@property (weak, nonatomic) IBOutlet UILabel *batteryCapLab;
@property (weak, nonatomic) IBOutlet UILabel *batteryHealthLab;
@property (weak, nonatomic) IBOutlet UILabel *batteryTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *batteryStateLab;
@property (weak, nonatomic) IBOutlet UIView *signView;
@property (weak, nonatomic) IBOutlet VWWWaterView *batteryView;

@property (strong,nonatomic ) GADInterstitial * interstitial;
@property (strong,nonatomic) NSTimer * timer;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _batteryView.waterDelegate  = self;

    
    //
    self.interstitial = [[GADInterstitial alloc]initWithAdUnitID:@"ca-app-pub-3058205099381432/2168924745"];
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID,@"2440bd529647afc62d632f9d424f0679"];
    
    [self.interstitial loadRequest:request];
    [self timer];
    //
    self.title = @"电池状态";
    
    {
        UIColor *color = [UIColor whiteColor];
        UIFont * font = [UIFont systemFontOfSize:20];
        NSDictionary * dict = [NSDictionary dictionaryWithObjects:@[color,font] forKeys:@[NSForegroundColorAttributeName ,NSFontAttributeName]];
        self.navigationController.navigationBar.titleTextAttributes = dict;
    }
    
    [self layoutAdv];
    
    //
    [self getBatteryTime];
    
    //
    [self setChargeCount];
    
    //
    _batteryHealthLab.text = [NSString stringWithFormat:@"%d分",80+ (int)([SystemSharedServices batteryLevel]/5.1)];
    _chargeCountLab.text = [NSString stringWithFormat:@"%d次", [self getChargeCount] +20];
}

-(void)showInter
{
    if( self.interstitial.isReady )
    {
        [self.timer invalidate];
        self.timer = nil;
        
        [self.interstitial presentFromRootViewController:self];
    }
}

-(void)setChargeCount
{
    if( [self getBatteryPercent] > 0.98 )
    {
        NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
        NSInteger count = [def integerForKey:STORE_CHARGE_COUNT];
        count+= 1;
        
        [def setInteger:count forKey:STORE_CHARGE_COUNT];
        [def synchronize];
    }
}

-(NSInteger)getChargeCount
{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    return [def integerForKey:STORE_CHARGE_COUNT];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//电池百分比
-(CGFloat)getBatteryPercent
{
    return [SystemSharedServices batteryLevel]/100.0;
}

-(void)getBatteryTime
{
    firstBatteryLevel = [SystemSharedServices batteryLevel];
    curBatteryTime = [NSDate date];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(batteryCharged:)
     name:UIDeviceBatteryLevelDidChangeNotification
     object:nil
     ];
    
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(notiBattery) userInfo:nil repeats:NO];
}

-(void)notiBattery
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceBatteryLevelDidChangeNotification object:nil];
}

- (void)batteryCharged:(NSNotification *)note
{
    float currBatteryLev = [SystemSharedServices batteryLevel];
    
    if( [SystemSharedServices fullyCharged] )
    {
        _batteryTimeLab.text = @"已充满";
        _batteryStateLab.text = @"充电中:";
    }
    else if( [SystemSharedServices charging] )
    {
        float avgChgSpeed = (firstBatteryLevel - currBatteryLev)*1.0 / [curBatteryTime timeIntervalSinceNow];
        
        float remBatteryLev = 100 - currBatteryLev;
        
        NSInteger remSeconds = remBatteryLev / avgChgSpeed;
        
        _batteryTimeLab.text = [NSString stringWithFormat:@"%02ld:%02ld",(remSeconds)/3600,((remSeconds)%3600)/60];
        
        if( ((remSeconds)/3600== 0) && ((remSeconds)%3600/60 == 0))
        {
            _batteryTimeLab.text = @"已充满";
        }
        else if( avgChgSpeed == 0 )
        {
            NSInteger chagreTime = ((100-currBatteryLev)/100.0)*100;
            _batteryTimeLab.text = [NSString stringWithFormat:@"%02d:%02d",chagreTime/60,chagreTime%60];
            //_batteryTimeLab.text = @"计算中...";
        }
        
        _batteryStateLab.text = @"充电中:";
    }
    //放电
    else
    {
        float avgChgSpeed = fabs((firstBatteryLevel - currBatteryLev)*1.0 / [curBatteryTime timeIntervalSinceNow]);
        
        NSInteger remSeconds = currBatteryLev / avgChgSpeed;
        
        _batteryTimeLab.text = [NSString stringWithFormat:@"%02ld:%02ld",(remSeconds)/3600,((remSeconds)%3600)/60];
        
        if( firstBatteryLevel - currBatteryLev == 0 )
        {
            NSInteger time =  (100-currBatteryLev)/100.0*680;
            
            _batteryTimeLab.text = [NSString stringWithFormat:@"%02d:%02d",time/60,time%60];
        }
        
        _batteryStateLab.text = @"可使用:";
    }
}


- (NSString *)publisherId
{
    return BAIDU_APP_ID;
}


-(void)layoutAdv
{
    
    if( arc4random() % 5 != 0 )
    {
       
    }
    else
    {
        CGPoint pt ;
        
        pt = CGPointMake(0, [UIScreen mainScreen].bounds.size.height-60-50);
        GADBannerView * _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeFullBanner origin:pt];
        
        _bannerView.adUnitID = @"ca-app-pub-3058205099381432/9692191545";//调用你的id
        _bannerView.rootViewController = self;
        [_bannerView loadRequest:[GADRequest request]];
        
        [self.view addSubview:_bannerView];
    }
}

#pragma arguments
-(CGFloat)getPercent
{
    return [SystemSharedServices batteryLevel]/100;
}

//
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * t = [touches anyObject];
    CGPoint pt;
    
    pt = [t locationInView:_signView];
    
    if( CGRectContainsPoint(_signView.bounds, pt) )
    {
        SignViewController * vc = [[SignViewController alloc]initWithNibName:@"SignViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
    /*
    pt = [t locationInView:_netSpeedTestLab];
    if( CGRectContainsPoint(_netSpeedTestLab.bounds,pt))
    {
        NetSpeedViewController * vc = [[NetSpeedViewController alloc]initWithNibName:@"NetSpeedViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
    pt = [t locationInView:_netSpyLab];
    if( CGRectContainsPoint(_netSpyLab.bounds,pt))
    {
        NetSpyViewController * vc = [[NetSpyViewController alloc]initWithNibName:@"NetSpyViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
     */
}

-(NSTimer*)timer
{
    if( !_timer )
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showInter) userInfo:nil repeats:YES];
    }
    
    return _timer;
}
@end
