//
//  VWWWaterView.m
//  Water Waves
//
//  Created by Veari_mac02 on 14-5-23.
//  Copyright (c) 2014年 Veari. All rights reserved.
//

#import "VWWWaterView.h"
#import "CommData.h"

@interface VWWWaterView ()
{
    UIColor *_currentWaterColor;
    
    float a;
    float b;
    
    BOOL jia;
    
    UILabel * labPercent;
    UILabel * labText;
}
@end


@implementation VWWWaterView


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.layer.cornerRadius = self.frame.size.width/2.0;
        self.layer.masksToBounds = YES;
        
        a = 1.5;
        b = 0;
        jia = NO;
        
        _currentWaterColor = RGB(49,213,9);//[UIColor colorWithRed:49/255.0f green:213/255.0f blue:9/255.0f alpha:1];
        
        [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
        
        
        [self initLabs];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:RGB(22,22,22)];
        
        a = 1.5;
        b = 0;
        jia = NO;
        
        _currentWaterColor = RGB(49,213,9);//[UIColor colorWithRed:49/255.0f green:213/255.0f blue:9/255.0f alpha:1];
        
        [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
        
        [self initLabs];
    }
    return self;
}

-(void)initLabs
{
    //NSLog(@"--%f--",[_waterDelegate getPercent]);
    
    labPercent = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, self.frame.size.width-20, 40)];
    //labPercent.text = [NSString stringWithFormat:@"%f%%",[_waterDelegate getPercent]];
    labPercent.font = [UIFont systemFontOfSize:50];
    labPercent.textAlignment = NSTextAlignmentCenter;
    labPercent.textColor = [UIColor blackColor];
    
    [self addSubview:labPercent];

    labText = [[UILabel alloc]initWithFrame:CGRectMake(10, 120, self.frame.size.width-20, 40)];
    labText.text = @"剩余电量";
    labText.textColor = [UIColor orangeColor];
    labText.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:labText];
}

-(void)animateWave
{
    if (jia)
    {
        a += 0.01;
    }
    else
    {
        a -= 0.01;
    }
    
    
    if (a<=1)
    {
        jia = YES;
    }
    
    if (a>=1.5)
    {
        jia = NO;
    }
    
    
    b+=0.1;
    
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    //画水
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [_currentWaterColor CGColor]);
    
    float y=[self getCurrPercent];
    CGPathMoveToPoint(path, NULL, 0, y);
    for(float x=0;x<=320;x++)
    {
        y= a * sin( x/180*M_PI + 4*b/M_PI ) * 5 + [self getCurrPercent];
        
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, 320, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, [self getCurrPercent]);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
}


-(CGFloat)getCurrPercent
{
    CGFloat percent = 0.5;
    
    if( [_waterDelegate respondsToSelector:@selector(getPercent)] )
    {
        percent = [_waterDelegate getPercent];
    }
    
    labPercent.text = [NSString stringWithFormat:@"%d%%",(int)(percent*100)];
    
    return self.frame.size.height * (1-percent);
}

@end
