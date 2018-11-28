//
//  NetWorkUikits.m
//  iphone-xiaoer
//
//  Created by sks on 16/2/16.
//  Copyright © 2016年 sks. All rights reserved.
//

#import "NetWorkUikits.h"
#import "AFNetworking.h"
#import "JSON.h"
#import "AFHTTPSessionOperation.h"

@implementation NetWorkUikits

#pragma mark - 网络请求
+(void)requestWithUrl:(NSString* )url
                param:(NSDictionary*)param
             timerOut:(NSUInteger)timerout
     completionHandle:(NetworkFetcherCompletionHandle)completion
        failureHandle:(NetworkFetcherErrorHandle)failure
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer.timeoutInterval = timerout;
    
    if (param != nil) { // 参数不为空的时候
        NSLog(@"%@",param);
        [session POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"data: %@",responseObject);
            if (completion) {
                completion(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                NSLog(@"%@",error);
                failure(error);
            }
        }];
    }else{ // 参数为空的时候
        [session POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (completion) {
                completion(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    }
}



+(void)requestWithUrl:(NSString* )url
                param:(NSDictionary*)param
     completionHandle:(NetworkFetcherCompletionHandle)completion
        failureHandle:(NetworkFetcherErrorHandle)failure
{

    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer.timeoutInterval = 90;
    
    
    if (param != nil) { // 参数不为空的时候
        NSLog(@"%@",param);
        [session POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            completion(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
                
                NSLog(@"===error:%@",error.description);
            }
        }];
    }else{ // 参数为空的时候
        [session POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (completion) {
                completion(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    }
}



+(NSURLSessionDataTask*)requestWithUrl:(NSString* )url uuid:(NSString*)uuid
                                 param:(NSDictionary*)param
                      completionHandle:(NetworkFetcherCompletionHandle)completion
                         failureHandle:(NetworkFetcherErrorHandle)failure
{
    NSLog(@"net----: %@",url);
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer.timeoutInterval = 60;// 请求超时时间是60秒
    
    NSURLSessionDataTask * task = nil;
    
    if (param != nil) { // 参数不为空的时候
        NSLog(@"%@",param);
        task = [session POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //NSLog(@"data: %@",responseObject);
            if (completion) {
                completion(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                NSLog(@"%@",error);
                failure(error);
            }
        }];
    }else{ // 参数为空的时候
        task = [session POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (completion) {
                completion(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    }
    
    return task;
}

#pragma mark - 上传图片
+(void)uploadImageWithUrl:(NSString*)url Param:(NSDictionary*)param Data:(id)data
                 filename:(NSString *)filename
         completionHandle:(NetworkFetcherCompletionHandle)completion
            failureHandle:(NetworkFetcherErrorHandle)failure
{
    NSLog(@"upload:%@", url);

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 120;
    
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if ([data isKindOfClass:[NSArray class]]) {
            for (int i=0; i<[data count]; i++) { // 这是一下上传几个的时候
                [formData appendPartWithFileData:data[i] name:[NSString stringWithFormat:@"%@_%d",filename,i] fileName:[NSString stringWithFormat:@"%@_%d",filename,i] mimeType:@"image/jpeg"];
            }
        }
        else{
            [formData appendPartWithFileData:data name:filename fileName:filename mimeType:@"image/jpeg"];
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            completion(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


#pragma mark - 上传文件

/*
+(void)uploadFileWithUrlEx:(NSString*)url Param:(NSDictionary*)param fileUrl:(id)fileUrl
                filename:(NSString *)filename
        completionHandle:(NetworkFetcherCompletionHandle)completion
           failureHandle:(NetworkFetcherErrorHandle)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    [manager.requestSerializer setValue:[Global getDeviceId] forHTTPHeaderField:@"uuid"];
    [manager.requestSerializer setValue:[Global getDeviceIdfa] forHTTPHeaderField:@"deviceId"];
    [manager.requestSerializer setValue:[Global getVerson] forHTTPHeaderField:@"ver"];
    [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"lat"];
    [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"lng"];
    [manager.requestSerializer setValue:[Global getDevicePlatform] forHTTPHeaderField:@"model"];
    
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileURL:fileUrl name:@"file" error:nil];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            completion(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
*/




+(void)uploadFileWithUrl:(NSString*)url Param:(NSDictionary*)param Data:(id)data
                 filename:(NSString *)filename
         completionHandle:(NetworkFetcherCompletionHandle)completion
            failureHandle:(NetworkFetcherErrorHandle)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:filename fileName:@"xiaoer.mp3" mimeType:@"audio/basic"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completion) {
            completion(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

#pragma mark - 检查地址是否可以访问
+(void)checkNetworkWith:(NSString*)url
       completionHandle:(NetworkFetcherCompletionHandle)completion
          failureHandle:(NetworkFetcherErrorHandle)failure
{
    NSLog(@"checknet:%@", url);
}

+(void)downloadFileWithUrl:(NSString*)url
                  fileName:(NSString*)fileName
          completionHandle:(NetworkFetcherCompletionHandle)completion
             failureHandle:(NetworkFetcherErrorHandle)failure
{
    
}

#pragma mark - 下载文件到指定路径
+(void)downloadFileWithUrl:(NSString*)url absoluteFilePath:(NSString*)absoluteFilePath completionHandle:(NetworkFetcherCompletionHandle)completion failureHandle:(NetworkFetcherErrorHandle)failure{
  
    NSLog(@"net: %@",url);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [NSURL fileURLWithPath:absoluteFilePath];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error==nil) {
            completion(absoluteFilePath);
        }
        else{
            failure(error);
        }
        
    }];
    [downloadTask resume];
}

@end
