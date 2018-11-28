//
//  UIScrollView+UITouch.m
//  NewiPhoneADV
//
//  Created by zhuang chaoxiao on 15/8/13.
//  Copyright (c) 2015年 zhuang chaoxiao. All rights reserved.
//

#import "UIScrollView+UITouch.h"

@implementation UIScrollView (UITouch)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self nextResponder] touchesBegan:touches withEvent:event];    
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self nextResponder] touchesMoved:touches withEvent:event];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self nextResponder] touchesEnded:touches withEvent:event];
}

@end
