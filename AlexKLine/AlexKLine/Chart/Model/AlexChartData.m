//
//  AlexChartData.m
//  AlexKLine
//
//  Created by WSCN on 7/14/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexChartData.h"

@implementation AlexChartData

+ (instancetype)initWithHandler:(AlexChartHandler *)handler {
    AlexChartData *data = [[AlexChartData alloc] init];
    data.viewHandler = handler;
    return data;
}

- (instancetype)init {
    if (self = [super init]) {
        _yAxisMax = 0;
        _yAxisMin = 0;
        _sizeRatio = 1.0;
        _gapRatio = 0.17;
        _xVals = [NSMutableArray array];
        _dataSets = [NSMutableArray array];
        
    }
    return self;
}

@end
