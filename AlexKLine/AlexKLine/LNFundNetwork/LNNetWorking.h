//
//  LNNetWorking.h
//  News
//
//  Created by vvusu on 3/29/16.
//  Copyright © 2016 wallstreetcn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNRequest.h"
#import "LNResponse.h"

typedef void(^LNResponseSuccess)(id response);
typedef void(^LNResponseFail)(NSError *error);

typedef void (^LNDownloadProgress)(int64_t bytesRead, int64_t totalBytesRead);
typedef LNDownloadProgress LNGetProgress;
typedef LNDownloadProgress LNPostProgress;

@class NSURLSessionTask;
typedef NSURLSessionTask LNURLSessionTask;

@interface LNNetWorking : NSObject

+ (void)cancelAllTasks;

+ (LNURLSessionTask *)getWithRequest:(LNRequest *)request
                             success:(LNResponseSuccess)success
                                fail:(LNResponseFail)fail;

+ (LNURLSessionTask *)postWithRequest:(LNRequest *)request
                              success:(LNResponseSuccess)success
                                 fail:(LNResponseFail)fail;
@end