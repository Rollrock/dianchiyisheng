//
//  VWWWaterView.h
//  Water Waves
//
//  Created by Veari_mac02 on 14-5-23.
//  Copyright (c) 2014年 Veari. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WaterViewDelegate <NSObject>

-(CGFloat)getPercent;//

@end

@interface VWWWaterView : UIView


@property(weak) id<WaterViewDelegate> waterDelegate;

@end
