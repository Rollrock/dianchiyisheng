//
//  DianChiPerView.m
//  BatteryDoctor
//
//  Created by zhuang chaoxiao on 2018/10/9.
//  Copyright © 2018年 zhuang chaoxiao. All rights reserved.
//

#import "DianChiPerView.h"

@interface DianChiPerView()

@property (strong, nonatomic) IBOutlet UILabel *procBgLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UILabel *itemLab;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DianChiPerView

+(id)view
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
}

-(void)refreshCell:(DianChiTimeModel*)model
{
    [self layoutIfNeeded];
    
    CGFloat procWidth = self.procBgLab.frame.size.width;
    CGFloat procHeight = self.procBgLab.frame.size.height;
    
    self.procBgLab.layer.cornerRadius = procHeight/2.0;
    self.procBgLab.layer.masksToBounds = YES;
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, procWidth*((model.percent/model.per)/(model.percent/model.minPer))  *0.95, procHeight)];
    view.backgroundColor = model.color;
    
    self.itemLab.text = model.itemName;
    self.imageView.image = [UIImage imageNamed:model.itemName];
    self.timeLab.text = [NSString stringWithFormat:@"%.2f小时",model.percent/model.per*100];
    
    [self.procBgLab addSubview:view];
}

@end
