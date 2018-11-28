//
//  MainViewController.m
//  alarm
//
//  Created by zhuang chaoxiao on 15-6-15.
//  Copyright (c) 2015年 zhuang chaoxiao. All rights reserved.
//

#import "MainViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "SignViewController.h"
#import "AppDelegate.h"
#import "AdvertViewController.h"

@interface MainViewController ()<RockTabDelegate>
{
    RockTabView * tabView;
    
    UINavigationController * currNC;
    
    UINavigationController * naVC1;
    UINavigationController * naVC2;
    UINavigationController * naVC3;
    UINavigationController * naVC4;
    
    
    UINavigationController * signNav;
    
    NSMutableArray * navArray;
    
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    tabView = [[RockTabView alloc]init];
    tabView.delegate = self;
    [self.view addSubview:tabView];
    
    navArray = [NSMutableArray new];
    
    [self layoutVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)layoutVC
{
    FirstViewController * fVC = [[FirstViewController alloc]initWithNibName:@"FirstViewController" bundle:nil];
    naVC1 = [[UINavigationController alloc]initWithRootViewController:fVC];
    
    SecondViewController * sVC = [[SecondViewController alloc]initWithNibName:@"SecondViewController" bundle:nil];
    naVC2 = [[UINavigationController alloc]initWithRootViewController:sVC];
    
    //ThirdViewController * tVC = [[ThirdViewController alloc]initWithNibName:@"ThirdViewController" bundle:nil];
    //naVC3 = [[UINavigationController alloc]initWithRootViewController:tVC];

    FourthViewController * foVC = [[FourthViewController alloc]initWithNibName:@"FourthViewController" bundle:nil];
    naVC4 = [[UINavigationController alloc]initWithRootViewController:foVC];
    
    
   
    SignViewController * singVC = [[SignViewController alloc]initWithNibName:@"SignViewController" bundle:nil];
    signNav = [[UINavigationController alloc]initWithRootViewController:singVC];
    
    AdvertViewController * adverVC = [AdvertViewController new];
    naVC3 = [[UINavigationController alloc]initWithRootViewController:adverVC];
    naVC3.navigationBar.translucent = NO;
    
    [navArray addObject:naVC1];
    [navArray addObject:signNav];
    [navArray addObject:naVC4];
    [navArray addObject:naVC3];
    
    [self.view insertSubview:naVC1.view belowSubview:tabView];

    currNC = naVC1;
}



#pragma ROCKTabDelgate
-(void)tabClicked:(int)index
{
    if( currNC == [navArray objectAtIndex:index] )
    {
        return;
    }
    
    
    [currNC.view removeFromSuperview];
    
    currNC = [navArray objectAtIndex:index];
    [self.view insertSubview:currNC.view belowSubview:tabView];
    
}

@end
