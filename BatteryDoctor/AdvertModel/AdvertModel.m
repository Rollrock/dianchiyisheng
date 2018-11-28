//
//  Model.m
//  com.rock.VideoGuide
//
//  Created by zhuang chaoxiao on 16/11/15.
//  Copyright © 2016年 zhuang chaoxiao. All rights reserved.
//

#import "AdvertModel.h"
#import "NetWorkUikits.h"

@implementation AdvertModel

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.imgUrl forKey:@"imgUrl"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.openScore forKey:@"openScore"];
    [aCoder encodeObject:self.appid forKey:@"appid"];
    [aCoder encodeObject:self.showApps forKey:@"showApps"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.imgUrl = [aDecoder decodeObjectForKey:@"imgUrl"];
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.desc = [aDecoder decodeObjectForKey:@"desc"];
    self.url = [aDecoder decodeObjectForKey:@"url"];
    self.openScore = [aDecoder decodeObjectForKey:@"openScore"];
    self.appid = [aDecoder decodeObjectForKey:@"appid"];
    self.showApps = [aDecoder decodeObjectForKey:@"showApps"];
    
    return self;
}

+(id)modelFromDict:(NSDictionary*)dict
{
    AdvertModel * m = [AdvertModel new];
    
    m.imgUrl = dict[@"imgUrl"];
    m.title = dict[@"title"];
    m.desc = dict[@"descp"];
    m.url = dict[@"url"];
    m.openScore = dict[@"openScore"];
    m.appid = dict[@"appid"];
    m.showApps = dict[@"showApps"];
    if ([m.showApps isEqual:[NSNull null]])
    {
        m.showApps = @"";
    }
    
    return m;
}


+(void)getAdvertReq
{
    NSString *urlstring = [NSString stringWithFormat:@"http://www.hushup.com.cn/rockweb/Advert/advertindex.php?appid=%@",[[NSBundle mainBundle] bundleIdentifier]];
    
    [NetWorkUikits requestWithUrl:urlstring param:nil completionHandle:^(id data) {
        NSLog(@"%@", data);
        
        if( [data[@"success"] boolValue] != 1 ) return;
        
        NSMutableArray * array = [NSMutableArray new];
        for( NSDictionary * dict in data[@"data"])
        {
            AdvertModel * m = [AdvertModel modelFromDict:dict];
            m.imgUrl = [@"http://www.hushup.com.cn/rockweb" stringByAppendingString:m.imgUrl];
            [array addObject:m];
        }
        
        [AdvertModel store:array];
        //
        
    } failureHandle:^(NSError *error) {
        
        
    }];
}

+(void)store:(NSArray*)array
{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:array];
    [def setObject:data forKey:SOTRE_ADVERT];
    [def synchronize];
}

+(NSArray*)getAdvert
{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    NSData * data = [def objectForKey:SOTRE_ADVERT];
    NSArray * array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return array;
}

+(BOOL)mustScore
{
    for( AdvertModel * m in [AdvertModel getAdvert] )
    {
        if( [m.appid isEqualToString:[[NSBundle mainBundle] bundleIdentifier]] )
        {
            return NO;
        }
    }
    
    
    
    return NO;
}

@end
