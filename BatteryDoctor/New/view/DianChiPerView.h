//
//  DianChiPerView.h
//  BatteryDoctor
//
//  Created by zhuang chaoxiao on 2018/10/9.
//  Copyright © 2018年 zhuang chaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommData.h"
#import "CommInfo.h"

@interface DianChiPerView : UIView

+(id)view;

-(void)refreshCell:(DianChiTimeModel*)model;

@end
