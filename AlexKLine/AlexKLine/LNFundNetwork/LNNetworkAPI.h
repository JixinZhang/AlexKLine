//
//  LNNetworkAPI.h
//  Market
//
//  Created by vvusu on 4/20/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LNBaseUrlType) {
    LNBaseUrlTypeWSCN = 0,
    LNBaseUrlTypeHengSheng
};

//默认BaseURL
extern NSString *const kIBaseApi;
extern NSString *const kIBaseTestApi;

//A股行情URL
extern NSString *const KIAQuotelUrl;
//A股行情新闻URL
extern NSString *const KIAPostUrl;

//恒生BaseUrl
extern NSString *const KIHSBaseUrl;

//A股行情请求参数
extern NSString *const KIAStockFullFields;

//恒生AccessTokenUrl
extern NSString *const KIHSTokenUrl;

@interface LNNetworkAPI : NSObject
@end
