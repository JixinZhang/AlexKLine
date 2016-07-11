//
//  KLineDataModel.h
//  AlexKLine
//
//  Created by ZhangBob on 4/26/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLineDataModel : NSObject

@property (nonatomic, strong) NSString * start;     //开始日期
@property (nonatomic, strong) NSString * end;       //到期日期
@property (nonatomic, strong) NSString * open;      //开盘价
@property (nonatomic, strong) NSString * close;     //收盘价
@property (nonatomic, strong) NSString * high;      //最高价
@property (nonatomic, strong) NSString * low;       //最低价
@property (nonatomic, strong) NSString * price;     //价格
@property (nonatomic, strong) NSString * averagePrice;  //平均价
@property (nonatomic, strong) NSString * volume;    //成交量 = 返回数据中的business_amount


@end
