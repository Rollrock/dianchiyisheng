//
//  MainViewController.m
//  NewiPhoneADV
//
//  Created by zhuang chaoxiao on 15/8/12.
//  Copyright (c) 2015年 zhuang chaoxiao. All rights reserved.
//

#import "FourthViewController.h"
#import "SystemServices.h"
#import "SignViewController.h"
#import "UIScrollView+UITouch.h"
#import "commData.h"
#import "CommInfo.h"
#import "THProgressView.h"
#import "NetSpeedViewController.h"
#import "AppDelegate.h"
#import "NetSpyViewController.h"


@import GoogleMobileAds;

#define SystemSharedServices [SystemServices sharedServices]


#define ANIMATION_DUR 5.0

@interface FourthViewController ()<NSNetServiceDelegate,NSNetServiceBrowserDelegate>
{
    //
    UIView * faceView;
    
    ////
    CAShapeLayer *arcLayer;
    
    NSTimer * timer;
    UILabel * countLab;
    NSInteger count;
    
    //电池
    CGFloat firstBatteryLevel;
    NSDate * curBatteryTime;
    //

    //
}
@property (weak, nonatomic) IBOutlet UIView *advBgView;
@property (weak, nonatomic) IBOutlet UIView *advBgView2;

@property (weak, nonatomic) IBOutlet UIButton *healthBtn;

@property (weak, nonatomic) IBOutlet UILabel *batteryStateLab;
@property (weak, nonatomic) IBOutlet UILabel *batteryTimeLab;

@property (weak, nonatomic) IBOutlet UIView *waveView;
@property (weak, nonatomic) IBOutlet UIImageView *batteryImgView;


@property (weak, nonatomic) IBOutlet UILabel *NetMonthUse;
@property (weak, nonatomic) IBOutlet UILabel *netSpeedTestLab;
@property (weak, nonatomic) IBOutlet UILabel *netSpyLab;


@property (weak, nonatomic) IBOutlet UIView *signView;

//
@property (weak, nonatomic) IBOutlet UIView *storeView;

@property (weak, nonatomic) IBOutlet THProgressView *storeTotalView;
@property (weak, nonatomic) IBOutlet THProgressView *storeUsageView;
@property (weak, nonatomic) IBOutlet THProgressView *storeFreeView;


///
@property (weak, nonatomic) IBOutlet UILabel *totalMemLab;
@property (weak, nonatomic) IBOutlet UILabel *useAgeMemLab;

////
@property (weak, nonatomic) IBOutlet UILabel *phoneNameLab;

@property (weak, nonatomic) IBOutlet UILabel *systemLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneVerLab;
@property (weak, nonatomic) IBOutlet UILabel *runTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *brightLab;
@property (weak, nonatomic) IBOutlet UILabel *countryLab;
@property (weak, nonatomic) IBOutlet UILabel *languageLab;


///
- (IBAction)startCheck;


@end

@implementation FourthViewController

/////
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initNavView];
    //
    _waveView.layer.cornerRadius = _waveView.frame.size.width/2.0;
    
    //
    [self drawNetFlow];
    
    //
    [self drawStorage];
    
    //
    [self drawMemory];
    
    //
    
    [self drawCommonInfo];
    
    //
    
    [self layoutAdv];
}

-(void)initNavView
{
    self.title = @"手机综合信息";
    
    {
        UIColor *color = [UIColor whiteColor];
        UIFont * font = [UIFont systemFontOfSize:20];
        NSDictionary * dict = [NSDictionary dictionaryWithObjects:@[color,font] forKeys:@[NSForegroundColorAttributeName ,NSFontAttributeName]];
        self.navigationController.navigationBar.titleTextAttributes = dict;
    }
    
    }


-(void)leftClicked
{
    NSLog(@"leftClicked");
    
 }

-(void)rightClicked
{
    NSLog(@"rightClicked");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////
//开始体检
- (IBAction)startCheck
{
    [self intiUIOfView];
    
    _healthBtn.enabled = NO;
}

//体检动画
-(void)intiUIOfView
{
    UIBezierPath *path=[UIBezierPath bezierPath];
    
    [path addArcWithCenter:CGPointMake(_waveView.frame.size.width/2.0,_waveView.frame.size.height/2.0) radius:_waveView.frame.size.width/2.0 startAngle:0 endAngle:2*M_PI clockwise:NO];
    arcLayer=[CAShapeLayer layer];
    arcLayer.path=path.CGPath;
    arcLayer.fillColor=[UIColor colorWithRed:46.0/255.0 green:169.0/255.0 blue:230.0/255.0 alpha:1].CGColor;
    arcLayer.strokeColor=[UIColor orangeColor].CGColor;//[UIColor colorWithWhite:1 alpha:0.7].CGColor;
    arcLayer.lineWidth=3;
    arcLayer.frame=CGRectMake(0, 0, _waveView.frame.size.width, _waveView.frame.size.height);
    [_waveView.layer addSublayer:arcLayer];
    [self drawLineAnimation:arcLayer];
    
    countLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _waveView.frame.size.width, _waveView.frame.size.height)];
    countLab.font = [UIFont systemFontOfSize:50];
    countLab.textAlignment = NSTextAlignmentCenter;
    
    [_waveView.layer addSublayer:countLab.layer];
    
    count = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerCount) userInfo:nil repeats:YES];
}
-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=ANIMATION_DUR;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    
    [layer addAnimation:bas forKey:@"key"];
}

-(void)timerCount
{
    count ++;
    countLab.text = [NSString stringWithFormat:@"%ld%%",2*count];
}

#pragma
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [arcLayer removeFromSuperlayer];
    [countLab.layer removeFromSuperlayer];
    
    //
    _healthBtn.enabled = YES;
    //
    [timer invalidate];
    //
    
    [self gotoCleanVC];
}

-(void)gotoCleanVC
{
    //CleanViewController * vc = [[CleanViewController /alloc]initWithNibName:@"CleanViewController" bundle:nil];
    //[self.navigationController pushViewController:vc animated:YES];
}


//////////////////////////////////体检---end//////////////////////////////////////////////////
//////////////////////////////////电池电量---begin//////////////////////////////////////////////////

-(UIImage*)scaleImage:(UIImage *)image toSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}
/////////////////////////////////电池电量---end///////////////////////////////////////////////////


/////////////////////////////////网络流量-----begin///////////////////////////////////////////////////

-(void)drawNetFlow
{
    _NetMonthUse.text =  [self getNetMonthUse];
}

-(BOOL)twoDateSameMonth:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSMonthCalendarUnit ;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    
    return [comp1 month] == [comp2 month];
}

-(BOOL)twoDateSameTime:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    
    return ([comp1 year] == [comp2 year]) && ([comp1 year] == [comp2 year]) && ([comp1 day] == [comp2 day])&&([comp1 hour] == [comp2 hour])&&([comp1 minute] == [comp2 minute]);
}

-(NSString*)getNetMonthUse
{
    NetUseInfo * useInfo = [self getNetFromStore];
    if( !useInfo )
    {
        useInfo = [NetUseInfo new];
    }
    
    NSUInteger totalByte = 0;
    NSDate * powerDate = [SystemSharedServices getSystemPowerDate];
    NSDate * curDate = [NSDate date];
    NSDictionary * dataDict = [SystemSharedServices getDataCounters];
    
    if( [useInfo.lastDate isEqualToDate:powerDate] )
    {
        NSLog(@"equal");
    }

    //两次开机时间不同，且3个时间都在同一个月内，
    if( (![self twoDateSameTime:useInfo.lastDate date2:powerDate]) && [self twoDateSameMonth:curDate date2:powerDate ] &&  [self twoDateSameMonth:curDate date2:useInfo.lastDate ] )
    {
        totalByte = useInfo.lastByte + [dataDict[DataCounterKeyWWANSent] unsignedIntegerValue] +[dataDict[DataCounterKeyWWANReceived] unsignedIntegerValue];
        useInfo.lastDate = powerDate;
        useInfo.lastByte = totalByte;
    }
    else
    {
        totalByte = [dataDict[DataCounterKeyWWANSent] unsignedIntegerValue] +[dataDict[DataCounterKeyWWANReceived] unsignedIntegerValue];
        useInfo.lastDate = powerDate;
        useInfo.lastByte = totalByte;
    }
    
    [self setNetToStore:useInfo];
    
    //
    return [self tranByte:useInfo.lastByte];
}

-(NetUseInfo*)getNetFromStore
{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    NSData * data = [def objectForKey:STORE_NET_INFO];
    
    NetUseInfo * useInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return useInfo;
}

-(void)setNetToStore:(NetUseInfo*)info
{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:info];
    [def setObject:data forKey:STORE_NET_INFO];
    
    [def synchronize];
}

-(NSString *)tranByte:(NSUInteger)byte
{
    if( byte*1.0 / 1073741824 >= 1 )
    {
        return [NSString stringWithFormat:@"%.2fG",byte*1.0 / 1073741824];
    }
    else if( byte*1.0 / 1048576 >= 1 )
    {
        return [NSString stringWithFormat:@"%.2fM",byte*1.0 / 1048576];
    }
    else if( byte*1.0 / 1024 >= 1 )
    {
        return [NSString stringWithFormat:@"%.2fK",byte*1.0 / 1024];
    }
    
    return @"";
}

/////////////////////////////////网络流量-----end///////////////////////////////////////////////////

/////////////////////////////////存储容量-----begin///////////////////////////////////////////////////

-(void)drawStorage
{
    _storeTotalView.borderTintColor = [UIColor orangeColor];
    _storeTotalView.progressTintColor = [UIColor orangeColor];
    _storeTotalView.progress = 1;
    
    //
    _storeUsageView.borderTintColor = [UIColor colorWithRed:46.0/255.0 green:169.0/255.0 blue:230.0/255.0 alpha:1];//COLOR_FROM_HEX(0x10D05A);//[UIColor cyanColor];
    _storeUsageView.progressTintColor = [UIColor colorWithRed:46.0/255.0 green:169.0/255.0 blue:230.0/255.0 alpha:1];//COLOR_FROM_HEX(0x10D05A);//[UIColor cyanColor];
    _storeUsageView.progress = 1;
    
    //
    _storeFreeView.borderTintColor = COLOR_FROM_HEX(0xFFAE57);//[UIColor purpleColor];
    _storeFreeView.progressTintColor = COLOR_FROM_HEX(0xFFAE57);//UIColor purpleColor];
    _storeFreeView.progress = 1;
    
    [_storeView layoutIfNeeded];
  
}


- (void)viewDidLayoutSubviews
{
    // VC just laid off its views

    _storeUsageView.frame = CGRectMake(_storeUsageView.frame.origin.x, _storeUsageView.frame.origin.y, _storeTotalView.frame.size.width*[[SystemSharedServices usedDiskSpaceinPercent] floatValue]/100.0, _storeTotalView.frame.size.height);
    
    _storeFreeView.frame = CGRectMake(_storeFreeView.frame.origin.x, _storeFreeView.frame.origin.y, _storeTotalView.frame.size.width*(1-[[SystemSharedServices usedDiskSpaceinPercent] floatValue]/100.0), _storeTotalView.frame.size.height);
    
}
/////////////////////////////////存储容量-----end///////////////////////////////////////////////////

/////////////////////////////////内存-----begin///////////////////////////////////////////////////

-(void)drawMemory
{
    _totalMemLab.text = [NSString stringWithFormat:@"%.0f MB",[SystemSharedServices totalMemory]];
    _useAgeMemLab.text = [NSString stringWithFormat:@"%.2f MB(%.0f%%)", [SystemSharedServices usedMemoryinRaw], [SystemSharedServices usedMemoryinPercent]];
}

/////////////////////////////////内存-----end///////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)drawCommonInfo
{
    NSArray *uptimeFormat = [[SystemSharedServices systemsUptime] componentsSeparatedByString:@" "];
    
    _runTimeLab.text = [NSString stringWithFormat:@"%@天%@小时%@分", [uptimeFormat objectAtIndex:0], [uptimeFormat objectAtIndex:1], [uptimeFormat objectAtIndex:2]];
    _phoneNameLab.text = [NSString stringWithFormat:@"%@", [SystemSharedServices deviceName]];
    _systemLab.text = [NSString stringWithFormat:@"%@", [SystemSharedServices systemsVersion]];
    _phoneVerLab.text = [NSString stringWithFormat:@"%@", [SystemSharedServices systemDeviceTypeFormatted]];
    _brightLab.text = [NSString stringWithFormat:@"%.0f%%", [SystemSharedServices screenBrightness]];
    _countryLab.text = [NSString stringWithFormat:@"%@", [SystemSharedServices country]];
    _languageLab.text = [NSString stringWithFormat:@"%@", [SystemSharedServices language]];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
}
////


-(void)layoutAdv
{
}

@end
























