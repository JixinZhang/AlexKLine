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
//    [self setupValues];
}
@end
