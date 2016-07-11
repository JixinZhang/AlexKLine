//
//  LNRequest.m
//  News
//
//  Created by vvusu on 3/29/16.
//  Copyright © 2016 wallstreetcn. All rights reserved.
//

#import "LNRequest.h"
@implementation LNRequest

- (LNRequestMethod)requestMethod {
    if (!_requestMethod) {
        _requestMethod = LNRequestMethodGet;
    }
    return _requestMethod;
}

- (NSMutableDictionary *)parameters {
    if (!_parameters) {
        _parameters = [NSMutableDictionary dictionary];
    }
    return _parameters;
}

@end
