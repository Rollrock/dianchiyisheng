//
//  NetCleanViewController.m
//  NewiPhoneADV
//
//  Created by zhuang chaoxiao on 15/8/14.
//  Copyright (c) 2015年 zhuang chaoxiao. All rights reserved.
//

#import "NetCleanViewController.h"

@interface NetCleanViewController ()

@end

@implementation NetCleanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"NavBack"] style:UIBarButtonItemStyleDone target:self action:@selector(leftClicked)];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    
}

-(void)leftClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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
