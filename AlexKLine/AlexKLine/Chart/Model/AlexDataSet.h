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
@property (nonatomic, strong) NSDate *date;         //当前的时间
@property (nonatomic, assign) NSDate *startTime;    //开始的时间
@property (nonatomic, assign) NSDate *endTime;      //结束的时间

//KLine
@property (nonatomic, assign) CGFloat open;
@property (nonatomic, assign) CGFloat close;
@property (nonatomic, assign) CGFloat high;
@property (nonatomic, assign) CGFloat low;

@property (nonatomic, assign) CGFloat MA1;
@property (nonatomic, assign) CGFloat MA2;
@property (nonatomic, assign) CGFloat MA3;
@property (nonatomic, assign) CGFloat MA4;
@property (nonatomic, assign) CGFloat MA5;

@property (nonatomic, assign) CGFloat averagePrice;  //平均交易价格
@property (nonatomic, assign) CGFloat preClose;     //昨收价
@end
