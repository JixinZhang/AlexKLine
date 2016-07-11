//
//  LNRequest.h
//  News
//
//  Created by vvusu on 3/29/16.
//  Copyright © 2016 wallstreetcn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , LNRequestMethod) {
    LNRequestMethodGet = 0, //查
    LNRequestMethodPost,    //改
};

@interface LNRequest : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *urlType;
@property (nonatomic, assign) LNRequestMethod requestMethod;
@property (nonatomic, strong) NSDictionary *httpHeaders;
@property (nonatomic, strong) NSMutableDictionary *parameters;

@end