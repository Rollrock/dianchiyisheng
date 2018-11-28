//
//  NetWorkUikits.h
//  iphone-xiaoer
//
//  Created by sks on 16/2/16.
//  Copyright © 2016年 sks. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NetworkFetcherCompletionHandle)(id data);
typedef void(^NetworkFetcherErrorHandle)(NSError *error);

typedef void(^NetworkFetcherCompletionHandle2)(id data,NSString * errorMsg);

@interface NetWorkUikits : NSObject



+(NSURLSessionDataTask*)requestWithUrl:(NSString* )url uuid:(NSString*)uuid
                                 param:(NSDictionary*)param
                      completionHandle:(NetworkFetcherCompletionHandle)completion
                         failureHandle:(NetworkFetcherErrorHandle)failure;

/**
 *  根据接口请求网络数据
 *
 *  @param url        请求的接口
 *  @param param      请求需要的参数
 *  @param completion 请求成功的回调
 *  @param failure    请求失败的回调
 */
+(void)requestWithUrl:(NSString* )url param:(NSDictionary*)param completionHandle:(NetworkFetcherCompletionHandle)completion
        failureHandle:(NetworkFetcherErrorHandle)failure;

+(void)requestNoTipWithUrl:(NSString* )url
                     param:(NSDictionary*)param
          completionHandle:(NetworkFetcherCompletionHandle)completion
             failureHandle:(NetworkFetcherErrorHandle)failure;

+(void)requestWithUrl:(NSString* )url
                param:(NSDictionary*)param
             timerOut:(NSUInteger)timerout
     completionHandle:(NetworkFetcherCompletionHandle)completion
        failureHandle:(NetworkFetcherErrorHandle)failure;



+(NSOperation*)requestOperationWithUrl:(NSString* )url
                                 param:(NSDictionary*)param
                      completionHandle:(NetworkFetcherCompletionHandle2)completion
                         failureHandle:(NetworkFetcherErrorHandle)failure;
/**
 *  图片上传
 *
 *  @param url        上传地址
 *  @param param      参数
 *  @param data       图片数据 单图或多图
 *  @param filename   图片名称 多图filename_1,filename_2...
 *  @param completion 请求成功返回数据data
 *  @param failure    请求失败返回错误描述
 */
+(void)uploadImageWithUrl:(NSString*)url
                    Param:(NSDictionary*)param
                     Data:(id)data
                 filename:(NSString *)filename
         completionHandle:(NetworkFetcherCompletionHandle)completion
            failureHandle:(NetworkFetcherErrorHandle)failure;



+(void)uploadFileWithUrl:(NSString*)url Param:(NSDictionary*)param Data:(id)data
                filename:(NSString *)filename
        completionHandle:(NetworkFetcherCompletionHandle)completion
           failureHandle:(NetworkFetcherErrorHandle)failure;

/**
 *  检查地址是否可访问
 *
 *  @param url 访问地址
 *  @param completion 请求成功返回数据data
 *  @param failure    请求失败返回错误描述
 */
+(void)checkNetworkWith:(NSString*)url
       completionHandle:(NetworkFetcherCompletionHandle)completion
          failureHandle:(NetworkFetcherErrorHandle)failure;


/**
 *  下载文件
 *
 *  @param url        文件地址
 *  @param fileName   保存的文件名称
 *  @param completion 下载成功返回文件地址
 *  @param failure    下载失败返回错误描述
 */
+(void)downloadFileWithUrl:(NSString*)url
                  fileName:(NSString*)fileName
          completionHandle:(NetworkFetcherCompletionHandle)completion
             failureHandle:(NetworkFetcherErrorHandle)failure;

+(void)downloadFileWithUrl:(NSString*)url absoluteFilePath:(NSString*)absoluteFilePath completionHandle:(NetworkFetcherCompletionHandle)completion failureHandle:(NetworkFetcherErrorHandle)failure;
@end
