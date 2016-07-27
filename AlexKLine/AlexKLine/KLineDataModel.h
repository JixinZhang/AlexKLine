//
//  KLineDataModel.h
//  AlexKLine
//
//  Created by ZhangBob on 4/26/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLineDataModel : NSObject

@property (nonatomic, copy) NSString *start;     //开始日期
@property (nonatomic, copy) NSString *end;       //到期日期
@property (nonatomic, copy) NSString *open;      //开盘价
@property (nonatomic, copy) NSString *close;     //收盘价
@property (nonatomic, copy) NSString *high;      //最高价
@property (nonatomic, copy) NSString *low;       //最低价
@property (nonatomic, copy) NSString *price;     //价格
@property (nonatomic, copy) NSString *averagePrice;  //平均价
@property (nonatomic, copy) NSString *volume;    //成交量 = 返回数据中的business_amount
@property (nonatomic, copy) NSString *preClose;   //昨收

@end
