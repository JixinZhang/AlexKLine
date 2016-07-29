//
//  AlexQuoteListCellModel.h
//  AlexKLine
//
//  Created by WSCN on 7/29/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlexQuoteListCellModel : NSObject

@property (nonatomic, copy) NSString *prodCode;         //股票代码
@property (nonatomic, copy) NSString *prodName;         //股票名称
@property (nonatomic, copy) NSString *tradeStatus;      //交易状态
@property (nonatomic, strong) NSNumber *lastPrice;      //最新价
@property (nonatomic, strong) NSNumber *priceChange;    //涨跌额
@property (nonatomic, strong) NSNumber *priceChangeRate;//涨跌额

@end
