//
//  AlexYAxis.m
//  AlexKLine
//
//  Created by WSCN on 7/14/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexYAxis.h"
#import "alexChartData.h"

@implementation AlexYAxis

- (instancetype)init {
    if (self = [super init]) {
        self.labelCount = 5;
        self.labelPosition = AxisDependencyLeft;
    }
    return self;
}

+ (instancetype)initWithType:(AxisDependency)position {
    AlexYAxis *yAxis = [[AlexYAxis alloc] init];
    yAxis.yPosition = position;
    return yAxis;
}

#pragma mark - 计算左右轴的labels

- (void)setupValues:(AlexChartData *)data {
    CGFloat avg = (data.yMax + data.yMin) / 2.0;
    CGFloat price = (data.yMax - data.yMin);
    price = price / data.sizeRatio / 2.0;
    
    self.axisMaximun = avg + price;
    
    if (_yPosition == AxisDependencyLeft) {
        self.axisMinimun = avg - price;
    }else {
        //计算涨跌幅
#warning 添加计算涨跌幅
    }
    [self setupValues];
}

- (void)setupValues {
    NSMutableArray  *valuesArr = [NSMutableArray array];
    CGFloat price = (self.axisMaximun - self.axisMinimun) / (_labelCount - 1);
    
    if (_labelPosition == YAxisLabelPositionInsideChart) {
        for (NSInteger i = 0; i < _labelCount; i ++) {
            if (i ==0 || i == _labelCount -1) {
                if (_yPosition == AxisDependencyLeft) {
                    [valuesArr addObject:[NSString stringWithFormat:@"%.2f",self.axisMaximun - (i * price)]];
                }else {
                    [valuesArr addObject:[NSString stringWithFormat:@"%.2f％",self.axisMaximun - (i * price)]];
                }
            }else {
                [valuesArr addObject:@""];
            }
        }
    }else {
        for (NSInteger i = 0; i < _labelCount; i++) {
            if (_yPosition == AxisDependencyLeft) {
                [valuesArr addObject:[NSString stringWithFormat:@"%.2f",self.axisMaximun - (i * price)]];
            }else {
                [valuesArr addObject:[NSString stringWithFormat:@"%.2f％",self.axisMaximun - (i * price)]];
            }
        }
    }
    _values = valuesArr;
}

- (void)setupKLineValues:(AlexChartData *)data {
    if (data.yAxisMax > data.dataSets.count) {
        return;
    }
    CGFloat max = ((AlexDataSet *)data.dataSets[data.yAxisMax]).high;
    CGFloat min = ((AlexDataSet *)data.dataSets[data.yAxisMin]).low;
    
    CGFloat avg = (max + min)/2;
    CGFloat price = max - min;
    price = price/data.sizeRatio/2;
    self.axisMaximun = avg + price;
    self.axisMinimun = avg - price;
    [self setupValues];
}

//- (void)setupVolumeValues:(AlexChartData *)data {
//    NSString *maxString = [NSString stringWithFormat:@"%@",data.yMax];
//    NSString *statusString =
//}

@end
