//
//  SecondViewController.m
//  BatteryDoctor
//
//  Created by zhuang chaoxiao on 15/8/22.
//  Copyright (c) 2015年 zhuang chaoxiao. All rights reserved.
//

#import "SecondViewController.h"
#import "CommData.h"
#import "AppDelegate.h"
#import "SignViewController.h"

@import GoogleMobileAds;

@interface SecondViewController ()<UIScrollViewDelegate>
{
    GADBannerView * _bannerView;
    
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidhtConst;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    self.title = @"省电攻略";
    
    {
        UIColor *color = [UIColor whiteColor];
        UIFont * font = [UIFont systemFontOfSize:20];
        NSDictionary * dict = [NSDictionary dictionaryWithObjects:@[color,font] forKeys:@[NSForegroundColorAttributeName ,NSFontAttributeName]];
        self.navigationController.navigationBar.titleTextAttributes = dict;
    }
    
    //
    const CGFloat perW = [UIScreen mainScreen].bounds.size.width;
 
    for( int i = 1; i < 18;++ i )
    {
        UIImage * img =[UIImage imageNamed:[NSString stringWithFormat:@"b%d",i]];
        CGFloat imgW = img.size.width/2.1;
        CGFloat imgH = img.size.height/2.1;
        
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake((i-1)*perW+(perW-imgW)/2.0, 10, imgW, imgH)];
        imgView.image = img;
        [_contentView addSubview:imgView];
    }
    
    _contentViewWidhtConst.constant = 17*[UIScreen mainScreen].bounds.size.width;

       //
    [self layoutAdv];
}


-(NSString *)publisherId
{
    return BAIDU_APP_ID;
}

-(void)layoutAdv
{
    CGPoint pt ;
    
    pt = CGPointMake(0, [UIScreen mainScreen].bounds.size.height-60-50);
    _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeFullBanner origin:pt];
    
    _bannerView.adUnitID = @"ca-app-pub-3058205099381432/9692191545";//调用你的id
    _bannerView.rootViewController = self;
    [_bannerView loadRequest:[GADRequest request]];
    
    [self.view addSubview:_bannerView];
    
}

#pragma UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = [scrollView contentOffset].x;
    
    //NSLog(@"offset:%f frame.y:%f",offset,scrollView.frame.size.width);
    
    if( ((int)offset) % ((int)scrollView.frame.size.width) == 0 )
    {
        static BOOL bFlag = NO;
        
        if( bFlag)
        {
            //[self.view bringSubviewToFront:_baiduView];
               _bannerView.hidden = NO;
        }
        else
        {
            //[self.view bringSubviewToFront:_bannerView];
              _bannerView.hidden = YES;
        }
        
        bFlag = !bFlag;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
