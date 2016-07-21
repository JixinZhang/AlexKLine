//
//  AlexYAxis.h
//  AlexKLine
//
//  Created by WSCN on 7/14/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexAxisBase.h"

typedef NS_ENUM(NSUInteger, YAxisLabelPosition) {
    YAxisLabelPositionOutsideChart = 0,
    YAxisLabelPositionInsideChart
};

typedef NS_ENUM(NSUInteger, AxisDependency) {
    AxisDependencyLeft = 0,
    AxisDependencyRight
};
@class AlexChartData;
@interface AlexYAxis : AlexAxisBase

@property (nonatomic, assign) NSInteger labelCount;
@property (nonatomic, strong) NSMutableArray *values;
@property (nonatomic, assign) AxisDependency yPosition;
@property (nonatomic, assign) YAxisLabelPosition labelPosition;

+ (instancetype)initWithType:(AxisDependency)position;

- (void)setupValues:(AlexChartData *)data;
- (void)setupKLineValues:(AlexChartData *)data;
- (void)setupVolumeValues:(AlexChartData *)data;

@end
