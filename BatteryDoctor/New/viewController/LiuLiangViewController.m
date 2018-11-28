//
//  LiuLiangViewController.m
//  BatteryDoctor
//
//  Created by zhuang chaoxiao on 2018/10/8.
//  Copyright © 2018年 zhuang chaoxiao. All rights reserved.
//

#import "LiuLiangViewController.h"
#import "XLWaveProgress.h"
#import "CommData.h"
#import "CommInfo.h"

@interface LiuLiangViewController ()

@property (strong, nonatomic) IBOutlet UIView *waterBgView;
@property (strong, nonatomic) IBOutlet UITextField *totalField;
@property (strong, nonatomic) IBOutlet UILabel *usedLab;


@property (strong, nonatomic) XLWaveProgress * waterView;

@property (assign,nonatomic) BOOL bInit;

@end

@implementation LiuLiangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"流量信息";
    
    self.usedLab.text = [self getNetMonthUse];
    self.totalField.text = [self getTotalStroe];
    
    [self.totalField addTarget:self action:@selector(totalFieldDone:) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if( !self.bInit )
    {
        self.bInit = YES;
        [self layoutViews];
    }
}

#pragma private

-(NSString*)getTotalStroe
{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    NSString * total = [def stringForKey:@"LiuLiangViewController"];
    if( !total )
        return @"1024";
    
    return total;
}

-(void)setTotalStore:(NSString*)total
{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    [def setObject:total forKey:@"LiuLiangViewController"];
    [def synchronize];
}

-(void)layoutViews{
    
    [self.waterBgView addSubview:self.waterView];
    [self.waterView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.waterBgView);
    }];
    
    [self.view layoutIfNeeded];
    
    [self.waterView buildLayout];
    
    NetUseInfo * useInfo = [self getNetFromStore];
    self.waterView.progress = (useInfo.lastByte/1048576*1.0)/[[self getTotalStroe] floatValue];
    
    NSLog(@"%f",useInfo.lastByte/1048576*1.0);
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

#pragma event
-(void)totalFieldDone:(UITextField*)text
{
    NetUseInfo * useInfo = [self getNetFromStore];
    self.waterView.progress = (useInfo.lastByte/1048576*1.0)/[self.totalField.text floatValue];
    
    NSLog(@"proc:%f",self.waterView.progress);
    
    [self setTotalStore:self.totalField.text];
    
}


#pragma setter & getter
-(XLWaveProgress*)waterView
{
    if(!_waterView )
    {
        _waterView = [XLWaveProgress new];
        _waterView.progress = 0.2;
    }
    
    return _waterView;
}


@end
