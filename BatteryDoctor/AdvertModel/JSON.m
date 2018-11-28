//
//  TMJson.m
//  TMJson
//
//  Created by 唐敏 on 15/1/25.
//  Copyright (c) 2015年 tangmin. All rights reserved.
//
#import "JSON.h"

@implementation JSON

+ (NSString *)JSONStringFromObject:(id)object{
    if (object == nil) {
        return @"";
    }
    __autoreleasing NSError *error = nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"Error: failed to convert data to jsonString, error=%@", error);
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (id)objectFromJSONString:(NSString*)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return object;
}

@end
