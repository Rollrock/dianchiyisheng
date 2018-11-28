//
//  RockTabView.m
//  alarm
//
//  Created by zhuang chaoxiao on 15-6-15.
//  Copyright (c) 2015年 zhuang chaoxiao. All rights reserved.
//

#import "RockTabView.h"

@interface RockTabView()
{
    NSArray * imgName;
    NSArray * hImgName;
    NSMutableArray * tabViewArray;
    int curIndex;
}
@end


@implementation RockTabView


-(id)init
{
    self = [super initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TAB_HEIGHT, SCREEN_WIDTH, TAB_HEIGHT)];
    
    if( self )
    {
        self.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
        
        
        imgName = @[@"tab_1",@"tab_2",@"tab_3",@"tab_4"];
        hImgName = @[@"tab_1_h",@"tab_2_h",@"tab_3_h",@"tab_4_h"];
        
        tabViewArray = [NSMutableArray new];
        //
        [self layoutTab];
    }
    
    return self;
    
    
}


-(void)layoutTab
{
    CGFloat w = TAB_ICON_W;
    CGFloat h = TAB_ICON_H;
    CGFloat xDis = (SCREEN_WIDTH - TAB_NUM*TAB_ICON_W ) / (TAB_NUM+1);
    
    
    for( int i = 0; i < TAB_NUM; ++ i )
    {
        UIImageView * view = [[UIImageView alloc]initWithFrame:CGRectMake(xDis+((w+xDis)*i), (TAB_HEIGHT-TAB_ICON_H)/2, w, h)];
        view.image = [UIImage imageNamed:[imgName objectAtIndex:i]];
        view.tag = i;
        [self addSubview:view];
        
        [tabViewArray addObject:view];
        
        UITapGestureRecognizer * g = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeTab:)];
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:g];
    }
    
    ((UIImageView*)[tabViewArray objectAtIndex:0]).image = [UIImage imageNamed:[hImgName objectAtIndex:0]];
    
}

-(void)changeTab:(UITapGestureRecognizer*)g
{
    int tag = g.view.tag;
    
    if( curIndex == tag )
    {
        return;
    }
    
    curIndex = tag;
    
    for( int i = 0; i < TAB_NUM; ++ i )
    {
        UIImageView * imgView = [tabViewArray objectAtIndex:i];
        imgView.image = [UIImage imageNamed:[imgName objectAtIndex:i]];
    }
    
    UIImageView * imgView = [tabViewArray objectAtIndex:tag];
    imgView.image = [UIImage imageNamed:[hImgName objectAtIndex:tag]];
    
    
    if( [_delegate respondsToSelector:@selector(tabClicked:)])
    {
        [_delegate tabClicked:tag];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end














