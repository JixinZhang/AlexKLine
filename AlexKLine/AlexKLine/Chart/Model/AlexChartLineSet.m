//
//  AlexChartLineSet.m
//  AlexKLine
//
//  Created by WSCN on 7/15/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexChartLineSet.h"

@implementation AlexChartLineSet

- (instancetype)init {
    if (self = [super init]) {
        //点
        _drawPoint = NO;
        _pointRadius = 2.0f;
        _pointColor = [UIColor redColor];
        
        //均线的点
        _drawAvgPoint = NO;
        _avgPointRadius = 2.0f;
        _avgPointColor = [UIColor blueColor];
        
        //线
        _lineWidth = 1.0f;
        _lineColor = [UIColor redColor];
        _points = [NSMutableArray array];
        
        //均线
        _drawAvgLine = YES;
        _avgLineWidth = 1.0f;
        _avgLineColor = [UIColor blueColor];
        _avgPoints = [NSMutableArray array];
        
        _fillEnable = YES;
        _fillPoints = [NSMutableArray array];
        _fillColor = [UIColor brownColor];
    }
    return self;
}

@end
