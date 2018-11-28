//
//  ThirdViewController.m
//  BatteryDoctor
//
//  Created by zhuang chaoxiao on 15/8/22.
//  Copyright (c) 2015年 zhuang chaoxiao. All rights reserved.
//

#import "ThirdViewController.h"
#import "CommData.h"


@interface ThirdViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.title = @"手机使用技巧";
    
    {
        UIColor *color = [UIColor whiteColor];
        UIFont * font = [UIFont systemFontOfSize:20];
        NSDictionary * dict = [NSDictionary dictionaryWithObjects:@[color,font] forKeys:@[NSForegroundColorAttributeName ,NSFontAttributeName]];
        self.navigationController.navigationBar.titleTextAttributes = dict;
    }

    
    NSURL *   url = nil;
    
    url = [NSURL URLWithString:@"http://toutiao.com/m3890669865/"];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    //
    [self layoutAdv];
    
    //
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(15, [UIScreen mainScreen].bounds.size.height-50-60, 50, 50)];
    [btn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];

}


-(void)layoutAdv
{
    //顶部/
    {
        
    }

    //底部
    {
        
    }
}

-(void)backClicked
{
    [_webView goBack];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
