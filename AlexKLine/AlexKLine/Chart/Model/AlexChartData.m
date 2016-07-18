//
//  AlexChartData.m
//  AlexKLine
//
//  Created by WSCN on 7/14/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexChartData.h"
#import "AlexDataSet.h"

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
        _lineSet = [[AlexChartLineSet alloc]init];
        
    }
    return self;
}

- (void)setLastStart:(NSInteger)lastStart {
    _lastStart = lastStart;
    if (_lastStart < 0) {
        _lastStart = 0;
    }
}

- (void)setLastEnd:(NSInteger)lastEnd {
    _lastEnd = lastEnd;
    if (_lastEnd > _dataSets.count) {
        _lastEnd = _dataSets.count;
    }
}

- (void)addXValue:(NSString *)string {
    [self.xVals addObject:string];
}

- (void)removeXValue:(NSInteger)index {
    [self.xVals removeObjectAtIndex:index];
}

- (void)removeAllDataSet {
    [_dataSets removeAllObjects];
    _lastEnd = 0;
    _lastStart = 0;
    _valCount = 0;
    _emptyEndNum = 0;
    _emptyStartNum = 0;
}

#pragma mark - 

//初始化调用，计算偏移量 如果数量大于屏幕显示的最大数目，做偏移
- (void)computeLastStartAndLastEnd {
    _lastEnd = _dataSets.count;
    if (_dataSets.count >= _valCount) {
//        _lastEnd = _dataSets.count - _valCount;
    }else {
        _lastStart = 0;
    }
}

- (BOOL)hasEmptyNum {
    if (_emptyStartNum > 0 || _emptyEndNum > 0) {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark - 一般折线图计算

- (void)computeMinMax {
    _yMax = CGFLOAT_MIN;
    _yMin = CGFLOAT_MAX;
    for (NSInteger i = _lastStart; i < _lastEnd; i++) {
        AlexDataSet *entity = _dataSets[i];
        if (entity.price) {
            if (_yMin > entity.price) {
                _yMin = entity.price;
                _yAxisMin = i;
            }
            
            if (_yMax < entity.price) {
                _yMax = entity.price;
                _yAxisMax = i;
            }
        }
        
        if (entity.avergePrice) {
            if (_yMin > entity.avergePrice) {
                _yMin = entity.avergePrice;
                _yAxisMin = i;
            }
            
            if (_yMax < entity.avergePrice) {
                _yMax = entity.avergePrice;
                _yAxisMax = i;
            }
        }
    }
    
    if (_yMin == _yMax) {
        _yMin = 0;
    }
    
    [self computeLinePointsCoordinate];
}

- (void)computeLinePointsCoordinate {
    [_lineSet.points removeAllObjects];
    [_lineSet.avgPoints removeAllObjects];
    [_lineSet.fillPoints removeAllObjects];
    
    _drawScale = _viewHandler.contentHeight * _sizeRatio / (_yMax - _yMin);
    CGFloat emptyHeight = _viewHandler.contentHeight * (1 - _sizeRatio) / 2;
    CGFloat volumeWidth = _viewHandler.contentWidth / _valCount;
    
    for (NSInteger i = _lastStart; i < _lastEnd; i++) {
        AlexDataSet *dataSet = _dataSets[i];
        CGFloat left = (_viewHandler.contentLeft + volumeWidth * i) + volumeWidth * _gapRatio;
        CGFloat startX = left + (volumeWidth - volumeWidth * _gapRatio) / 2;
        CGFloat startY = (_yMax - dataSet.price) *_drawScale + _viewHandler.contentTop + emptyHeight;
        CGPoint StartPoint = CGPointMake(startX, startY);
        [_lineSet.points addObject:[NSValue valueWithCGPoint:StartPoint]];
        
        //
        if ((_lineSet.isDrawAvgLine)) {
            CGFloat avgStartY = (_yMax - dataSet.avergePrice) * _drawScale + _viewHandler.contentTop + emptyHeight;
            CGPoint avgPoint = CGPointMake(startX, avgStartY);
            [_lineSet.avgPoints addObject:[NSValue valueWithCGPoint:avgPoint]];
        }
    }
}
@end
