//
//  Model.h
//  com.rock.VideoGuide
//
//  Created by zhuang chaoxiao on 16/11/15.
//  Copyright © 2016年 zhuang chaoxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SOTRE_ADVERT @"SOTRE_ADVERT"


@interface AdvertModel : NSObject<NSCoding>

@property(copy,nonatomic)NSString * imgUrl;
@property(copy,nonatomic)NSString * title;
@property(copy,nonatomic)NSString * desc;
@property(copy,nonatomic)NSString * url;
@property(copy,nonatomic)NSString * openScore;
@property(copy,nonatomic)NSString * appid;
@property(copy,nonatomic)NSString * showApps;

+(id)modelFromDict:(NSDictionary*)dict;
+(NSArray*)getAdvert;
+(void)getAdvertReq;
+(BOOL)mustScore;
@end
