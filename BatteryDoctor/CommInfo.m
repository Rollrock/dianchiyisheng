//
//  CommInfo.m
//  NewiPhoneADV
//
//  Created by zhuang chaoxiao on 15/8/13.
//  Copyright (c) 2015年 zhuang chaoxiao. All rights reserved.
//

#import "CommInfo.h"

@implementation CommInfo

@end


@implementation NetUseInfo
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if( self )
    {
        self.lastByte = [aDecoder decodeIntegerForKey:@"lastByte"];
        self.lastDate = [aDecoder decodeObjectForKey:@"lastDate"];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.lastByte forKey:@"lastByte"];
    [aCoder encodeObject:self.lastDate forKey:@"lastDate"];
}

@end



@implementation SignInfo
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if( self )
    {
        self.score = [aDecoder decodeIntForKey:@"score"];
        self.lastDate = [aDecoder decodeObjectForKey:@"lastDate"];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.score forKey:@"score"];
    [aCoder encodeObject:self.lastDate forKey:@"lastDate"];
}

@end


@implementation DeviceInfo


@end


@implementation DianChiTimeModel
@end
