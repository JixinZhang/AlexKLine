//
//  AlexChartView.m
//  AlexKLine
//
//  Created by WSCN on 7/14/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexChartView.h"

@implementation AlexChartView

- (void)setupChart {
    [super setupChart];
    self.backgroundColor = self.gridBackgroundColor;
    _leftAxis = [[AlexYAxis alloc] init];
    _rightAxis = [[AlexYAxis alloc] init];
    _dataRender = [AlexDataRender initWithHandler:self.viewHandler];
    
    _xAxisRender = [AlexXAxisRender initWithHandler:self.viewHandler xAxis:self.xAxis];
    _leftRender = [AlexYAxisRender initWithHandler:self.viewHandler yAxis:_leftAxis];
    _rightRender = [AlexYAxisRender initWithHandler:self.viewHandler yAxis:_rightAxis];
}

- (void)setupWithData:(NSMutableArray *)data {
    _dragEnabled = NO;
    _zoomEnabled = NO;
    
    _leftAxis.drawLabelsEnabled = YES;
    _leftAxis.drawGridLinesEnabled = YES;
    _rightAxis.drawLabelsEnabled = YES;
    
    NSInteger valCount = data.count;
    self.xAxis.labelSite = XAxisLabelSiteCenter;
    switch (self.chartViewType) {
        case ChartViewTypeNormal:
            break;
        case ChartViewTypeLine:
            valCount = 241;
            break;
        case ChartViewTypeFiveDayLine:
            self.xAxis.labelSite = XAxisLabelSiteRight;
            break;
        case ChartViewTypeColumnar:
            valCount = 241;
            _rightAxis.drawLabelsEnabled = NO;
            _leftAxis.drawGridLinesEnabled = NO;
//            self.data.hightlighter.volumeChartType = YES;
            _leftAxis.drawLabelsEnabled = _leftAxis.labelPosition == YAxisLabelPositionOutsideChart;
            break;
        case ChartViewTypeFiveDayColumnar:
            
            break;
        case ChartViewTypeKLine:
            
            break;
        case ChartViewTypeKColumnar:
            
            break;
            
        default:
            break;
    }
    self.data.dataSets = data;
    self.data.valCount = valCount;
    [self.data computeLastStartAndLastEnd];
    [self setNeedsDisplay];
}

#pragma mark -  绘制

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.data.dataSets.count == 0) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawGridBackground:context];
    [self calcMinMax];
    
    //绘制左边轴
    [_leftRender renderGridLines:context];
    [_leftRender renderYAxis:context];
    
    //绘制右边轴
    [_rightRender renderGridLines:context];
    
    
    //绘制X轴
    [_xAxisRender renderGridLines:context];
    [_xAxisRender renderXAxis:context];
    
    //绘制折线（基金）
    [self drawData:context];
    
    //绘制XY轴显示的Labels
    [_leftRender renderYAxisLabels:context];
    [_rightRender renderYAxisLabels:context];
    [_xAxisRender renderAxisLabels:context];
}

- (void)drawGridBackground:(CGContextRef)context {
    [AlexChartUtils drawRect:context
                   lineColor:self.borderColor
                   fillColor:self.gridBackgroundColor
                   lineWidht:self.borderLineWidth
                        rect:self.viewHandler.contentRect];
}

- (void)calcMinMax {
    if ([self.data hasEmptyNum]) {
        return;
    }
    switch (self.chartViewType) {
        case ChartViewTypeNormal:
            [self.data computeMinMax];
            [self.xAxis setupValues:self.data];
            [self.leftAxis setupValues:self.data];
            break;
        case ChartViewTypeLine:
            [self.data computeLineMinMax];
            [self.xAxis setupLineValues:self.data];
            [self.leftAxis setupValues:self.data];
            break;
        case ChartViewTypeFiveDayLine:
            
            break;
        case ChartViewTypeKLine:
            [self.data computeKLineMinMax];
            break;
        case ChartViewTypeColumnar:
        case ChartViewTypeKColumnar:
        case ChartViewTypeFiveDayColumnar:
            
            break;
        default:
            break;
    }
    [self.rightAxis setupValues:self.data];
}

- (void)drawData:(CGContextRef)context {
    switch (self.chartViewType) {
        case ChartViewTypeNormal:
        case ChartViewTypeLine:
            [_dataRender drawLineData:context data:self.data];
            break;
        case ChartViewTypeFiveDayLine:
        
            break;
        case ChartViewTypeKLine:
            [_dataRender DrawCandle:context data:self.data];
            break;
        case ChartViewTypeColumnar:
        case ChartViewTypeFiveDayColumnar:
            
            break;
        case ChartViewTypeKColumnar:
            break;
            
        default:
            break;
    }

}

@end
