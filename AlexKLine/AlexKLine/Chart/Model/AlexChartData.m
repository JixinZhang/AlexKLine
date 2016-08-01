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
        _candleSet = [[AlexChartCandleSet alloc] init];
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
        _lastStart = _dataSets.count - _valCount;
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
        
        if (entity.averagePrice) {
            if (_yMin > entity.averagePrice) {
                _yMin = entity.averagePrice;
                _yAxisMin = i;
            }
            
            if (_yMax < entity.averagePrice) {
                _yMax = entity.averagePrice;
                _yAxisMax = i;
            }
        }
    }
    
    if (_yMin == _yMax) {
        _yMin = 0;
    }
    
    [self computeLinePointsCoordinate];
}

#pragma mark - 分时计算

- (void)computeLineMinMax {
    _yMax = CGFLOAT_MIN;
    _yMin = CGFLOAT_MAX;
    
    CGFloat offsetMaxPrice = 0;
    for (NSInteger i = _lastStart; i < _lastEnd; i++) {
        AlexDataSet *entity = [_dataSets objectAtIndex:i];
        if (entity.price == -1) {
            continue;
        }
        offsetMaxPrice = offsetMaxPrice > fabs(entity.price - entity.preClose) ? offsetMaxPrice : fabs(entity.price - entity.preClose);
    }
    
    _yMax = ((AlexDataSet *)[_dataSets firstObject]).preClose + offsetMaxPrice;
    _yMin = ((AlexDataSet *)[_dataSets firstObject]).preClose - offsetMaxPrice;
    
    for (AlexDataSet *model in _dataSets) {
        model.averagePrice = model.averagePrice < _yMin ? _yMin : model.averagePrice;
        model.averagePrice = model.averagePrice > _yMax ? _yMax : model.averagePrice;
    }
    
    if (_yMax == _yMin) {
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
            CGFloat avgStartY = (_yMax - dataSet.averagePrice) * _drawScale + _viewHandler.contentTop + emptyHeight;
            CGPoint avgPoint = CGPointMake(startX, avgStartY);
            [_lineSet.avgPoints addObject:[NSValue valueWithCGPoint:avgPoint]];
        }
        
        //添加填充色路径
        if (_lineSet.isFillEnabled) {
            CGPoint fillPoint = CGPointMake(0, 0);
            if (i == _lastStart) {
                fillPoint = CGPointMake(startX, startY);
                CGPoint startPoint = CGPointMake(startX, _viewHandler.contentBottom);
                [_lineSet.fillPoints addObject:[NSValue valueWithCGPoint:startPoint]];
            }
            
            fillPoint = CGPointMake(startX, startY);
            [_lineSet.fillPoints addObject:[NSValue valueWithCGPoint:fillPoint]];
            
            if (i == _lastEnd - 1) {
                CGPoint endPoint = CGPointMake(startX, _viewHandler.contentBottom);
                [_lineSet.fillPoints addObject:[NSValue valueWithCGPoint:endPoint]];
            }
        }
    }
}

#pragma mark -KLine

- (void)computeKLineMinMax {
    _yMax = CGFLOAT_MIN;
    _yMin = CGFLOAT_MAX;
    
    for (NSInteger i = _lastStart; i < _lastEnd; i++) {
        AlexDataSet *entity = [_dataSets objectAtIndex:i];
        
        if (i == _lastStart) {
            if (entity.MA1 == 0) {
//                [self computeKLineMA];
            }
        }
        
        if (_yMin > entity.low) {
            _yMin = entity.low;
            _yAxisMin = i;
        }
        
        if (_yMax < entity.high) {
            _yMax = entity.high;
            _yAxisMax = i;
        }
        
        if (entity.MA1 >= 0) {
            _yMin = _yMin < entity.MA1 ? _yMin : entity.MA1;
            _yMax = _yMax > entity.MA1 ? _yMax : entity.MA1;
        }
        if (entity.MA2 >= 0) {
            _yMin = _yMin < entity.MA2 ? _yMin : entity.MA2;
            _yMax = _yMax > entity.MA2 ? _yMax : entity.MA2;
        }
        if (entity.MA3 >= 0) {
            _yMin = _yMin < entity.MA3 ? _yMin : entity.MA3;
            _yMax = _yMax > entity.MA3 ? _yMax : entity.MA3;
        }
    }
    
    if (_yMax == _yMin) {
        _yMin = 0;
    }
//    [self computeKlinePointsCoord];
}

@end
