//
//  CommInfo.h
//  NewiPhoneADV
//
//  Created by zhuang chaoxiao on 15/8/13.
//  Copyright (c) 2015年 zhuang chaoxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommInfo : NSObject

@end


@interface NetUseInfo : NSObject<NSCoding>
@property(assign) NSInteger lastByte;
@property(strong) NSDate * lastDate;
@end


@interface SignInfo : NSObject<NSCoding>
@property(assign) NSInteger score;
@property(strong) NSDate * lastDate;
@end


@interface DeviceInfo : NSObject
@property(strong) NSString * ipAddr;
@property(strong) NSString * macAddr;

@end


@interface DianChiTimeModel:NSObject

//@property(copy,nonatomic) NSString * imageName;//图片名字
@property(copy,nonatomic) NSString * itemName;//名字
@property(assign,nonatomic) CGFloat  per;//每小时消耗百分之几：比如看电影，没消失消耗 5% 那100%就可以看20个小时
@property(assign,nonatomic) CGFloat  percent;//电池百分比
@property(assign,nonatomic) CGFloat minPer;//最小值
@property(strong,nonatomic) UIColor * color;//颜色

@end





