//
//  JiBenViewController.m
//  BatteryDoctor
//
//  Created by zhuang chaoxiao on 2018/10/8.
//  Copyright © 2018年 zhuang chaoxiao. All rights reserved.
//

#import "JiBenViewController.h"
#import "CommData.h"
#import "DianChiTableViewCell.h"

@interface JiBenViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableDictionary * dict;

@property (strong,nonatomic) NSArray * nameArray;
@property (strong,nonatomic) NSArray * valueArray;

@end

@implementation JiBenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"基本信息";
    
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"DianChiTableViewCell";
    
    DianChiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if( !cell )
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    
    [cell refreshCell:self.nameArray[indexPath.row] value:self.valueArray[indexPath.row]];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nameArray.count;
}

#pragma private

-(void)initViews
{
    NSLog(@"%@",[SystemSharedServices deviceName]);
    NSLog(@"%@",[SystemSharedServices deviceModel]);
    NSLog(@"%@",[SystemSharedServices systemName]);
    NSLog(@"%@",[SystemSharedServices systemsVersion]);
    NSLog(@"%d",[SystemSharedServices screenWidth]);
    NSLog(@"%d",[SystemSharedServices screenHeight]);

    NSLog(@"%@",[SystemSharedServices systemsUptime]);
    NSLog(@"%f",[SystemSharedServices screenBrightness]);
    NSLog(@"%d",[SystemSharedServices numberProcessors]);//进程数
    NSLog(@"%d",[SystemSharedServices numberActiveProcessors]);//活动进程数
    NSLog(@"%d",[SystemSharedServices processorSpeed]);
    NSLog(@"%d",[SystemSharedServices processorBusSpeed]);
    NSLog(@"%@",[SystemSharedServices carrierName]);//运营商
    NSLog(@"%@",[SystemSharedServices carrierCountry]);//运营商
    NSLog(@"%f",[SystemSharedServices batteryLevel]);//电池等级
    NSLog(@"%@",[SystemSharedServices currentIPAddress]);//ip地址
    NSLog(@"%@",[SystemSharedServices currentMACAddress]);//mac 地址
    NSLog(@"%@",[SystemSharedServices wiFiIPAddress]);//wifi地址
    NSLog(@"%@",[SystemSharedServices wiFiMACAddress]); //wifi mac 地址
    NSLog(@"%d",[SystemSharedServices connectedToWiFi]);//是否连接wifi
    
    
}

-(NSArray*)nameArray
{
    if(!_nameArray )
    {
        _nameArray = @[@"手机名称",@"手机型号",@"系统版本",@"屏幕宽度",@"屏幕高度",@"运营商",@"电池电量",@"IP地址",@"MAC地址",@"WIFI地址",@"WIFIMAC地址",@"连接WIFI",@"所有进程数",@"活跃进程数"];
    }
    
    return _nameArray;
}


-(NSArray*)valueArray
{
    if(!_valueArray )
    {
        _valueArray = @[[SystemSharedServices deviceName],[SystemSharedServices deviceModel],[SystemSharedServices systemName],[NSString stringWithFormat:@"%d",[SystemSharedServices screenWidth]],[NSString stringWithFormat:@"%d",[SystemSharedServices screenHeight]],[SystemSharedServices carrierName],[NSString stringWithFormat:@"%.2f",[SystemSharedServices batteryLevel]],[SystemSharedServices currentIPAddress],[SystemSharedServices currentMACAddress],[SystemSharedServices wiFiIPAddress],[SystemSharedServices wiFiMACAddress],[SystemSharedServices connectedToWiFi]?@"已连接":@"未连接",[NSString stringWithFormat:@"%d",[SystemSharedServices numberProcessors]],[NSString stringWithFormat:@"%d",[SystemSharedServices numberActiveProcessors]]];
    }
    
    return _valueArray;
}

#pragma setter & getter
-(NSMutableDictionary*)dict
{
    if( !_dict )
    {
        _dict = [NSMutableDictionary new];
        /*
        [_dict setObject: forKey:];
        [_dict setObject: forKey:];
        [_dict setObject: forKey:];
        [_dict setObject: forKey:];
        [_dict setObject: forKey:];
        [_dict setObject: forKey:];
        [_dict setObject: forKey:];
        [_dict setObject: forKey:];
        [_dict setObject: forKey:];
        [_dict setObject: forKey:];
        [_dict setObject: forKey:];
        [_dict setObject: forKey:];
        
        [_dict setObject: forKey:];
        [_dict setObject: forKey:];
        */
    }
    
    return _dict;
}

@end
