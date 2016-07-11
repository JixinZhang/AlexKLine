//
//  LNNetworkAPI.m
//  Market
//
//  Created by vvusu on 4/20/16.
//  Copyright © 2016 vvusu. All rights reserved.
//

#import "LNNetworkAPI.h"

@implementation LNNetworkAPI

#pragma mark - 基本接口
NSString *const kIBaseApi = @"http://";             //正式服务器接口
NSString *const kIBaseTestApi = @"http://";         //测试服务器接口

NSString *const KIAQuotelUrl = @"http://test.xgb.io:3000";

NSString *const KIAPostUrl = @"http://api.buzz.wallstreetcn.com/v2/posts";

NSString *const KIHSBaseUrl = @"http://open.hs.net";

NSString *const KIAStockFullFields = @"fields=last_px,px_change,px_change_rate,open_px,preclose_px,business_amount,turnover_ratio,high_px,low_px,pe_rate,amplitude,business_amount_in,business_amount_out,market_value,circulation_value";

NSString *const KIHSTokenUrl = @"https://api.wallstreetcn.com/v2/itn/token/public";

@end
