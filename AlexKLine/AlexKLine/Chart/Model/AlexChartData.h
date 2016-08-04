//
//  AlexChartData.h
//  AlexKLine
//
//  Created by WSCN on 7/14/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AlexXAxis.h"
#import "AlexYAxis.h"
#import "AlexDataSet.h"
#import "AlexChartHandler.h"
#import "AlexChartLineSet.h"
#import "AlexChartCandleSet.h"

@interface AlexChartData : NSObject

@property (nonatomic, assign) CGFloat yMax;
@property (nonatomic, assign) CGFloat yMin;
@property (nonatomic, assign) CGFloat sizeRatio;            //图的比例
@property (nonatomic, assign) CGFloat gapRatio;             //图中内容距离边框的空隙的比例
@property (nonatomic, assign) CGFloat drawScale;            //绘制的均等比值
@property (nonatomic, assign) NSInteger valCount;           //dataSet的展示个数
@property (nonatomic, strong) NSMutableArray *xVals;        //x轴的数据
@property (nonatomic, strong) NSMutableArray *dataSets;     //点的数据
@property (nonatomic, strong) AlexChartHandler *viewHandler;//图的属性

@property (nonatomic, strong) AlexChartLineSet *lineSet;    //线的属性
@property (nonatomic, strong) AlexChartCandleSet *candleSet;//蜡烛图的属性
@property (nonatomic, assign) NSInteger lastEnd;            //结束下标
@property (nonatomic, assign) NSInteger lastStart;          //开始下标
@property (nonatomic, assign) NSInteger yAxisMax;           //当前屏幕最大值的下标
@property (nonatomic, assign) NSInteger yAxisMin;           //当前屏幕最小值的下标
@property (nonatomic, assign) NSInteger emptyStartNum;
@property (nonatomic, assign) NSInteger emptyEndNum;

+ (instancetype)initWithHandler:(AlexChartHandler *)handler;

- (void)computeMinMax;
- (void)computeLineMinMax;
- (void)computeKLineMinMax;
/**
 *  计算成交量的最大、最小值
 */
- (void)computeVolumeMinMax;
- (void)computeLastStartAndLastEnd;

- (BOOL)hasEmptyNum;
- (void)addXValue:(NSString *)string;
- (void)removeXValue:(NSInteger)index;
- (void)removeAllDataSet;
@end
