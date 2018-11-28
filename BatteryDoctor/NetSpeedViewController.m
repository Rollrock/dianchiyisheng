//
//  NetSpeedViewController.m
//  NewiPhoneADV
//
//  Created by zhuang chaoxiao on 15/8/15.
//  Copyright (c) 2015年 zhuang chaoxiao. All rights reserved.
//

#import "NetSpeedViewController.h"
#import "SpeedResultViewController.h"
#import "AppDelegate.h"

@import GoogleMobileAds;


@interface NetSpeedViewController ()
{
    CAShapeLayer *arcLayer;
    
    NSTimer * timer;
    UILabel * speedLab;
    NSInteger count;
    //
    
    NSURLConnection * connection;
    
    NSMutableData * downData;
    
    NSTimeInterval stateTime;
    
    CGFloat netSpeed;
}
@property (weak, nonatomic) IBOutlet UIView *speedBgView;
@property (weak, nonatomic) IBOutlet UILabel * startLab;
@property (weak, nonatomic) IBOutlet UIView *advBgView;

@end

@implementation NetSpeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.title = @"网速测试";
    
    {
        UIColor *color = [UIColor whiteColor];
        UIFont * font = [UIFont systemFontOfSize:20];
        NSDictionary * dict = [NSDictionary dictionaryWithObjects:@[color,font] forKeys:@[NSForegroundColorAttributeName ,NSFontAttributeName]];
        self.navigationController.navigationBar.titleTextAttributes = dict;
    }
    
    _speedBgView.layer.cornerRadius = _speedBgView.frame.size.width/2.0;
    _speedBgView.layer.masksToBounds = YES;
    
    [self layoutADV];
    
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"NavBack"] style:UIBarButtonItemStyleDone target:self action:@selector(leftClicked)];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    
}

-(void)leftClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * t = [touches anyObject];
    
    CGPoint pt = [t locationInView:_startLab];
    
    if( CGRectContainsPoint(_startLab.bounds, pt))
    {
        [self start];

        [self intiUIOfView];
        
        return;
    }
}

//体检动画
-(void)intiUIOfView
{
    UIBezierPath *path=[UIBezierPath bezierPath];
    
    [path addArcWithCenter:CGPointMake(_speedBgView.frame.size.width/2.0,_speedBgView.frame.size.height/2.0) radius:_speedBgView.frame.size.width/2.0 startAngle:0 endAngle:2*M_PI clockwise:NO];
    arcLayer=[CAShapeLayer layer];
    arcLayer.path=path.CGPath;
    arcLayer.fillColor=[UIColor colorWithRed:46.0/255.0 green:169.0/255.0 blue:230.0/255.0 alpha:1].CGColor;
    arcLayer.strokeColor=[UIColor orangeColor].CGColor;
    arcLayer.lineWidth=3;
    arcLayer.frame=CGRectMake(0, 0, _speedBgView.frame.size.width, _speedBgView.frame.size.height);
    [_speedBgView.layer addSublayer:arcLayer];
    [self drawLineAnimation:arcLayer];
    
    speedLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _speedBgView.frame.size.width, _speedBgView.frame.size.height)];
    speedLab.font = [UIFont systemFontOfSize:30];
    speedLab.textAlignment = NSTextAlignmentCenter;
    //speedLab.text = @"开始测试";
    speedLab.textColor = [UIColor orangeColor];
    
    [_speedBgView.layer addSublayer:speedLab.layer];
    
}
-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=2;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    
    [layer addAnimation:bas forKey:@"key"];
}


#pragma
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //[arcLayer removeFromSuperlayer];
    //[speedLab.layer removeFromSuperlayer];
    
    //
    [timer invalidate];
    //
    
    [connection cancel];
    
    //
    
    [self gotoResultVC];
}

-(void)gotoResultVC
{
    SpeedResultViewController * vc = [[SpeedResultViewController alloc]initWithNibName:@"SpeedResultViewController" bundle:nil];
    vc.speed = netSpeed;
    [self presentViewController:vc animated:YES completion:nil];
}
//

- (void)start
{
    
    [arcLayer removeFromSuperlayer];
    [speedLab.layer removeFromSuperlayer];
 
    
    stateTime = [[NSDate date] timeIntervalSince1970];
    
    //文件地址
    NSString *urlAsString = @"http://dlsw.baidu.com/sw-search-sp/soft/f0/29670/langpack64.1405392013.exe";
    
    NSURL    *url = [NSURL URLWithString:urlAsString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    downData = [[NSMutableData alloc] init];
    
    
    connection = [[NSURLConnection alloc]
                  initWithRequest:request
                  delegate:self
                  startImmediately:YES];
    
    if (connection != nil)
    {
        NSLog(@"Successfully created the connection");
    }
    else
    {
        NSLog(@"Could not create the connection");
    }
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"An error happened");
    NSLog(@"%@", error);
}
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Received data");
    
    [downData appendData:data];
    
    CGFloat speed = ([downData length] *1.0/([[NSDate date] timeIntervalSince1970] - stateTime));
 
    netSpeed = speed;
    
    if( speed/1048576>=1.0)
    {
        speedLab.text = [NSString stringWithFormat:@"%.2fM/s",speed/1048576];
        
        return;
    }
    
    if( speed/1024>=1.0)
    {
        speedLab.text = [NSString stringWithFormat:@"%.2fK/s",speed/1024];
        
        return;
    }
    
    
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"下载成功");
    
    
    /*
    if( [self showMe] )
    {
        UIAlertView * alert =[ [UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"你网速打败了全国%d%%用户,是否进行网速优化，体验飞一般的感觉？",(NSInteger)((_wendu.z)*100)] delegate:self cancelButtonTitle:@"现在体验" otherButtonTitles:@"不了", nil];
        
        alert.tag = ALERT_TAG_WANT_CLEAN;
        
        [alert show];
    }
    else
    {
        UIAlertView * alert =[ [UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"你网速打败了全国%d%%用户",(NSInteger)((_wendu.z)*100)] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        
        [alert show];
    }
     */
    
    /* do something with the data here */
}


-(void)layoutADV
{
    /*
    AppDelegate * appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    if( ![appDel showAdv] )
    {
        return;
    }
     */
    
    //中间的 ADV
    CGPoint pt ;
    
    pt = CGPointMake(0, 3);
    GADBannerView * _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeFullBanner origin:pt];
    
    _bannerView.adUnitID = @"ca-app-pub-3058205099381432/9692191545";//调用你的id
    _bannerView.rootViewController = self;
    [_bannerView loadRequest:[GADRequest request]];
    
    [_advBgView addSubview:_bannerView];
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
