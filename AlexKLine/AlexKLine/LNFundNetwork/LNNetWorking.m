//
//  LNNetWorking.m
//  News
//
//  Created by vvusu on 3/29/16.
//  Copyright © 2016 wallstreetcn. All rights reserved.
//

#import "LNNetWorking.h"

@implementation LNNetWorking

+ (NSURLSession *)sharedEphemeralSession {
    static dispatch_once_t onceToken;
    static NSURLSession *session;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        config.HTTPMaximumConnectionsPerHost = 3;
        session = [NSURLSession sessionWithConfiguration:config];
    });
    return session;
}

+ (void)cancelAllTasks {
    NSURLSession *session = [self sharedEphemeralSession];
    [session getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
        for (NSURLSessionDataTask *task in dataTasks) {
            [task cancel];
        }
    }];
}

#pragma mark - HTTPRequest
+ (LNURLSessionTask *)getWithRequest:(LNRequest *)request
                             success:(LNResponseSuccess)success
                                fail:(LNResponseFail)fail {
    
    request.requestMethod = LNRequestMethodGet;
    return [self request:request progress:nil success:success fail:fail];
    
}

+ (LNURLSessionTask *)postWithRequest:(LNRequest *)request
                              success:(LNResponseSuccess)success
                                 fail:(LNResponseFail)fail {
    
    request.requestMethod = LNRequestMethodPost;
    return [self request:request progress:nil success:success fail:fail];
}

+ (LNURLSessionTask *)request:(LNRequest *)request
                     progress:(LNDownloadProgress)progress
                      success:(LNResponseSuccess)success
                         fail:(LNResponseFail)fail {
    
    if ([NSURL URLWithString:request.url] == nil) {
        return nil;
    }
    
    if (request.requestMethod == LNRequestMethodGet) {
        request.url = [NSString stringWithFormat:@"%@%@",request.url,[LNNetWorking parseParams:request.parameters]];
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:request.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    
    if (urlRequest == nil) {
        return nil;
    }
    if (request.httpHeaders) {
        [urlRequest setAllHTTPHeaderFields:request.httpHeaders];
    }
    
    NSURLSession * session = [self sharedEphemeralSession];
    switch (request.requestMethod) {
        case LNRequestMethodGet: {
            [urlRequest setHTTPMethod:@"GET"];
        }
            break;
        case LNRequestMethodPost: {
            [urlRequest setHTTPMethod:@"POST"];
            [urlRequest setHTTPBody:[self praseParamsPostData:request.parameters]];
        }
            break;
    }
    
    NSURLSessionDataTask *task = nil;
    __block NSURLSessionTask *wtask = task;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            wtask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!error) {
                        if (success) {
                            success([self parseData:data]);
                        }
                    } else {
                        if (fail) {
                            fail(error);
                        }
                    }
            });
        }];
        [wtask resume];
    });
    return task;
}

#pragma mark - OTher
+ (NSString *)parseParams:(NSDictionary *)params{
    NSString *keyValueFormat;
    NSMutableString *result = [NSMutableString new];
    NSMutableArray *array = [NSMutableArray new];
    //实例化一个key枚举器用来存放dictionary的key
    NSEnumerator *keyEnum = [params keyEnumerator];
    id key;
    while (key = [keyEnum nextObject]) {
        keyValueFormat = [NSString stringWithFormat:@"%@=%@&",key,[params valueForKey:key]];
        NSLog(@"%@",keyValueFormat);
        [result appendString:keyValueFormat];
        [array addObject:keyValueFormat];
    }
    return result;
}

+ (NSData *)praseParamsPostData:(NSDictionary *)params {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonSring = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData *data = [jsonSring dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

+ (id)parseData:(id)responseData {
    LNResponse *reponseModel = [[LNResponse alloc] init];
    reponseModel.isSucceed = NO;
    reponseModel.errorCode = @"xxx";
    if ([responseData isKindOfClass:[NSData class]]) {
        reponseModel.resultData = responseData;
        if (responseData == nil) {
            reponseModel.errorMsg = @"返回数据Data为空";
            return reponseModel;
        } else {
            NSError *error = nil;
            NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseData
                                                                    options:NSJSONReadingAllowFragments
                                                                      error:&error];
            if (error) {
                reponseModel.errorMsg = @"utf8解析错误";
                return reponseModel;
            } else {
                //如果解析为NSArray，转化为字典
                if ([jsonDic isKindOfClass:[NSArray class]]) {
                    NSDictionary *resultDic = @{@"data":jsonDic};
                    reponseModel.resultDic = resultDic;
                } else {
                    reponseModel.resultDic = jsonDic;
                }
                
                //IFast 专用
                NSString *errorStr = [reponseModel.resultDic valueForKey:@"error"];
                if (errorStr) {
                    if ([errorStr isEqualToString:@"invalid_token"]) {
                        //token 失效
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"IFastRefreshUserToken" object:self userInfo:nil];
                    }
                }
                return reponseModel;
            }
        }
    } else {
        return reponseModel;
    }
}

//暂时不用
+ (LNResponse *)parserJSON:(NSDictionary *)resultDic with:(LNResponse *)reponseModel{
    reponseModel.resultDic = resultDic;
    NSString *rs = [resultDic valueForKey:@"retcode"];
    if (rs.integerValue == 0) {
        reponseModel.isSucceed = YES;
    } else {
        reponseModel.errorCode = rs;
        reponseModel.errorMsg = [resultDic valueForKey:@"retmsg"];
    }
    return reponseModel;
}

@end
