//
//  NetSpyViewController.m
//  NewiPhoneADV
//
//  Created by zhuang chaoxiao on 15/8/18.
//  Copyright (c) 2015年 zhuang chaoxiao. All rights reserved.
//

#import "NetSpyViewController.h"
#import "CommInfo.h"

#import "SSNetworkInfo.h"
#import "AppDelegate.h"

#include <ifaddrs.h>
#include <arpa/inet.h>
#import  <CFNetwork/CFHost.h>
#import <netinet/in.h>
#import <netdb.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "SimplePingHelper.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import  <CFNetwork/CFHost.h>
#import <netinet/in.h>
#import <netdb.h>
#import <SystemConfiguration/SystemConfiguration.h>

#include <net/if.h>
#include <net/if_dl.h>
#include "if_types.h"
#include "route.h"
#include "if_ether.h"
#include <netinet/in.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include <arpa/inet.h>

#include <err.h>
#include <errno.h>
#include <netdb.h>

#include <paths.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <netdb.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#import "NetSpyTableViewCell.h"

@class BaiduMobAdView;

int ipIndex = 100;

@interface NetSpyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString * ipPix;
    
    NSMutableArray * deviceArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *resultLab;
@property (weak, nonatomic) IBOutlet UIView *advBgView;

@end

@implementation NetSpyViewController



-(NSString *)getSelfIpAddress
{
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

-(NSString*)ip2mac:(const char*) ip
{
#if TARGET_IPHONE_SIMULATOR
    
    return @"";
#else
    
    static int nflag;
    
    int flags, found_entry;
    
    NSString *mAddr = nil;
    u_long addr = inet_addr(ip);
    int mib[6];
    size_t needed;
    char *host, *lim, *buf, *next;
    struct rt_msghdr *rtm;
    struct sockaddr_inarp *sin;
    struct sockaddr_dl *sdl;
    extern int h_errno;
    struct hostent *hp;
    
    mib[0] = CTL_NET;
    mib[1] = PF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_INET;
    mib[4] = NET_RT_FLAGS;
    mib[5] = RTF_LLINFO;
    if (sysctl(mib, 6, NULL, &needed, NULL, 0) < 0)
        err(1, "route-sysctl-estimate");
    if ((buf = malloc(needed)) == NULL)
        err(1, "malloc");
    if (sysctl(mib, 6, buf, &needed, NULL, 0) < 0)
        err(1, "actual retrieval of routing table");
    
    
    lim = buf + needed;
    
    for (next = buf; next < lim; next += rtm->rtm_msglen)
    {
        rtm = (struct rt_msghdr *)next;
        sin = (struct sockaddr_inarp *)(rtm + 1);
        sdl = (struct sockaddr_dl *)(sin + 1);
        
        if (addr)
        {
            if (addr != sin->sin_addr.s_addr)
                continue;
            
            found_entry = 1;
        }
        
        if (nflag == 0)
        {
            hp = gethostbyaddr((caddr_t)&(sin->sin_addr),
                               sizeof sin->sin_addr, AF_INET);
        }
        else
        {
            hp = 0;
        }
        
        if (hp)
        {
            host = hp->h_name;
            
            NSLog(@"==%s",host);
        }
        else
        {
            host = "?";
            
            if (h_errno == TRY_AGAIN)
            {
                nflag = 1;
            }
        }
        
        if (sdl->sdl_alen)
        {
            u_char *cp = LLADDR(sdl);
            
            mAddr = [NSString stringWithFormat:@"%x:%x:%x:%x:%x:%x", cp[0], cp[1], cp[2], cp[3], cp[4], cp[5]];
        }
        else
        {
            mAddr = nil;
        }
    }
    
    if (found_entry == 0)
    {
        return nil;
    }
    else
    {
        return mAddr;
    }
#endif
    
}


- (void)pingResult:(NSNumber*)success withAddr:(SimplePing*)info
{
    NSLog(@"addrAddr:%@ name:%@  succ:%@",[[NSString alloc]initWithData:info.hostAddress encoding:NSUTF8StringEncoding],info.hostName,success);
    
    if(success.boolValue)
    {
        DeviceInfo * deviceInfo = [DeviceInfo new];
        deviceInfo.ipAddr = info.hostName;
        deviceInfo.macAddr = [self ip2mac:[deviceInfo.ipAddr cStringUsingEncoding:NSASCIIStringEncoding]];
        
        [deviceArray addObject:deviceInfo];
    }
    else
    {
    
    }
}


#pragma uitableview

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"NetSpyTableViewCell";
    
    NetSpyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if( !cell )
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil] lastObject];
    }
    
    [cell refreshCell:[deviceArray objectAtIndex:indexPath.row]];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [deviceArray count];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"网络监控";
    
    {
        UIColor *color = [UIColor whiteColor];
        UIFont * font = [UIFont systemFontOfSize:20];
        NSDictionary * dict = [NSDictionary dictionaryWithObjects:@[color,font] forKeys:@[NSForegroundColorAttributeName ,NSFontAttributeName]];
        self.navigationController.navigationBar.titleTextAttributes = dict;
    }
    
    //
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"NavBack"] style:UIBarButtonItemStyleDone target:self action:@selector(leftClicked)];
    [self.navigationItem setLeftBarButtonItem:leftBtn];

    //
    [self layoutAdv];
    
    //
    if (![SSNetworkInfo connectedToWiFi])
    {
        _resultLab.text = @"当前没有连接到WIFI";
        return;
    }
    
  
    deviceArray = [NSMutableArray new];
    
    NSString * ipSelf = [self getSelfIpAddress];
    ipPix =        [ipSelf substringToIndex:[ipSelf rangeOfString:@"." options:NSBackwardsSearch].location +1]     ;
    
    for( int i = 0; i < 255; ++ i )
    {
        NSString * strIp = [NSString stringWithFormat:@"%@%d",ipPix,i];
        
        [SimplePingHelper ping:strIp target:self sel:@selector(pingResult:withAddr:)];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(refreshTableView) userInfo:nil repeats:NO];
    
    _resultLab.text = @"扫描中....";
    
    
}

-(void)leftClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)refreshTableView
{
    [_tableView reloadData];
    
    //
    _resultLab.text = [NSString stringWithFormat:@"一共发现%d台设备连接到您的WIFI",deviceArray.count];
}

-(void)layoutAdv
{
    GADBannerView * banner = [[GADBannerView alloc]initWithAdSize:kGADAdSizeSmartBannerPortrait];
    banner.rootViewController = self;
    banner.adUnitID = @"ca-app-pub-3058205099381432/9692191545";
    
    GADRequest * req = [GADRequest request];
    req.testDevices = @[ @"02257fbde9fc053b183b97056fe93ff4" ];
    [banner loadRequest:req];
    
    [self.advBgView addSubview:banner];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
