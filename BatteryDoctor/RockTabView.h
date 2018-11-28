//
//  RockTabView.h
//  alarm
//
//  Created by zhuang chaoxiao on 15-6-15.
//  Copyright (c) 2015年 zhuang chaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommData.h"

@protocol RockTabDelegate <NSObject>

-(void)tabClicked:(int)index;

@end


@interface RockTabView : UIView

@property(weak) id<RockTabDelegate> delegate;

@end
