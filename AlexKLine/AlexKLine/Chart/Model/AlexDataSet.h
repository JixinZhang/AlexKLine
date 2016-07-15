//
//  AlexDataSet.h
//  AlexKLine
//
//  Created by WSCN on 7/15/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlexDataSet : NSObject

@property (nonatomic, assign) CGFloat price;        //价格
@property (nonatomic, assign) CGFloat volume;       //成交量
@property (nonatomic, assign) CGFloat totalVolume;  //总交易量
@property (nonatomic, assign) NSDate *date;         //当前的时间
@property (nonatomic, assign) NSDate *startTime;    //开始的时间
@property (nonatomic, assign) NSDate *endTime;      //结束的时间

@property (nonatomic, assign) CGFloat avergePrice;  //平均交易价格
@end
