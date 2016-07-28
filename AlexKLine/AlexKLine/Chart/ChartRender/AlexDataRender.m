//
//  AlexDataRender.m
//  AlexKLine
//
//  Created by WSCN on 7/18/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexDataRender.h"

@implementation AlexDataRender

+ (instancetype)initWithHandler:(AlexChartHandler *)handler {
    AlexDataRender *dataRender = [[AlexDataRender alloc] init];
    dataRender.viewHandler = handler;
    return dataRender;
}

- (void)drawLineData:(CGContextRef)context data:(AlexChartData *)data {
    if (!data.dataSets) {
        return;
    }
    CGContextSaveGState(context);
    
    //绘制填充色
    if (data.lineSet.fillEnable) {
        [AlexChartUtils drawFilledPath:context startColor:data.lineSet.startFillColor endColor:data.lineSet.endFillColor points:data.lineSet.fillPoints alpha:0.5f];
    }
    
    //绘制折线（基金，分时线）
    [AlexChartUtils drawPolyline:context color:data.lineSet.lineColor points:data.lineSet.points width:data.lineSet.lineWidth];
    
    //绘制均线
    if (data.lineSet.drawAvgLine) {
        [AlexChartUtils drawPolyline:context color:data.lineSet.avgLineColor points:data.lineSet.avgPoints width:data.lineSet.avgLineWidth];
    }
    
    //绘制点
    if (data.lineSet.drawPoint || data.lineSet.drawAvgPoint) {
        if (data.lineSet.drawPoint) {
            [AlexChartUtils drawCircles:context fillColor:data.lineSet.pointColor points:data.lineSet.points radius:data.lineSet.pointRadius];
        }
    }
    CGContextRestoreGState(context);
}

#pragma mark - 绘制蜡烛图

- (void)DrawCandle:(CGContextRef)context data:(AlexChartData *)data {
    if (!data.dataSets) {
        return;
    }
    CGContextSaveGState(context);
    data.drawScale = self.viewHandler.contentHeight * data.sizeRatio / (data.yMax - data.yMin);
    CGFloat emptyHeight = (self.viewHandler.contentHeight * (1 - data.sizeRatio)) / 2.0;
    CGFloat candleWidth = data.candleSet.candleWith - data.candleSet.candleWith * data.gapRatio;
    UIColor *color = [UIColor redColor];
    
    for (NSInteger i = data.lastStart; i < data.lastEnd; i++) {
        AlexDataSet *dataSet = data.dataSets[i];
        
        if (!dataSet.open || !dataSet.close || !dataSet.high || !dataSet.low) {
            continue;
        }
        
        //今开 ＝ (最大值－今开) * 比例 + 图表的上部 + 空隙的高度
        CGFloat open = (data.yMax - dataSet.open) * data.drawScale + self.viewHandler.contentTop + emptyHeight;
        CGFloat close = (data.yMax - dataSet.close) * data.drawScale + self.viewHandler.contentTop + emptyHeight;
        CGFloat high = (data.yMax - dataSet.high) * data.drawScale + self.viewHandler.contentTop + emptyHeight;
        CGFloat low = (data.yMax - dataSet.low) * data.drawScale + self.viewHandler.contentTop + emptyHeight;
        
        //蜡烛的左边 ＝ 前一个蜡烛的右侧坐标 + 图表的左侧 + 蜡烛的宽 * 空隙比例
        CGFloat left = (data.candleSet.candleWith * (i - data.lastStart) + self.viewHandler.contentLeft) + data.candleSet.candleWith * data.gapRatio;
        //高开低收竖线的X坐标
        CGFloat startX = left + candleWidth / 2.0;
        
        CGRect candleRect = CGRectZero;
        if (open < close) {
            color = data.candleSet.candleFallColor;
            candleRect = CGRectMake(left, open, candleWidth, close - open);
        }else if (open == close) {
            if (i > 1) {
                AlexDataSet *lastDataSet = data.dataSets[i - 1];
                if (lastDataSet.close > dataSet.close) {
                    color = data.candleSet.candleEqualColor;
                }
            }
            candleRect = CGRectMake(left, open, candleWidth, 1.5);
            
        }else {
            color = data.candleSet.candleRiseColor;
            candleRect = CGRectMake(left, close, candleWidth, open - close);
        }
        
        [AlexChartUtils drawRect:context lineColor:color fillColor:color lineWidht:0 rect:candleRect];
        [AlexChartUtils drawLine:context color:color width:1 startPoint:CGPointMake(startX, high) endPoint:CGPointMake(startX, low)];
    }
    
    CGContextRestoreGState(context);
}

@end
