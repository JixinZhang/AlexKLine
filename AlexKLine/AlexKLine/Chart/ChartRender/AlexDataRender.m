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
    
        //计算十字线的数据
        if (data.highlighter.isHighlight) {
            if (i == data.highlighter.index) {
                data.highlighter.point = CGPointMake(startX, candleRect.origin.y);
            }
        }
    }
    
    
    CGContextRestoreGState(context);
}

#pragma mark - 绘制成交量
- (void)DrawVolume:(CGContextRef)context data:(AlexChartData *)data {
    if (!data.dataSets) {
        return;
    }
    CGContextSaveGState(context);
    data.drawScale = self.viewHandler.contentHeight *data.sizeRatio / data.yMax;
    CGFloat emptyHeight = (self.viewHandler.contentHeight * (1 - data.sizeRatio)) / 2.0;
    CGFloat volumeWidth = self.viewHandler.contentWidth / data.valCount;
    CGFloat candleWidth = volumeWidth - volumeWidth * data.gapRatio;
    UIColor *color;
    for (NSInteger i = data.lastStart; i < data.lastEnd; i++) {
        AlexDataSet *dataSet = data.dataSets[i];
        if (i > 0) {
            AlexDataSet *lastDataSet = data.dataSets[i - 1];
            if (dataSet.price > lastDataSet.price) {
                color = data.candleSet.candleRiseColor;
            }else {
                color = data.candleSet.candleFallColor;
            }
        }
        CGFloat endX = (self.viewHandler.contentLeft + volumeWidth * i) + volumeWidth * data.gapRatio;
        CGFloat volume = (dataSet.volume - 0) * data.drawScale;
        [AlexChartUtils drawRect:context color:color rect:CGRectMake(endX, self.viewHandler.contentBottom - volume - emptyHeight, candleWidth, volume)];
    }
    CGContextRestoreGState(context);
}

#pragma mark - 绘制十字线
/**
 *  绘制一般曲线的十字线
 *
 *  @param context 绘制上下文
 *  @param data    数据
 */
- (void)drawCrossLine:(CGContextRef)context data:(AlexChartData *)data {
    
    if (!data.highlighter.isHighlight ||
        !data.dataSets) {
        return;
    }
    
    if (data.highlighter.isDrawLevelLine) {
        if (data.highlighter.touchPoint.y > self.viewHandler.contentTop &&
            data.highlighter.touchPoint.y < self.viewHandler.contentBottom) {
            
            CGFloat price = data.yMax - (data.highlighter.touchPoint.y - self.viewHandler.contentTop) / data.drawScale;
            CGFloat priceRatio = 0;
            CGFloat ratio = data.highlighter.maxPriceRatio / (self.viewHandler.contentHeight/2);
            priceRatio = data.highlighter.maxPriceRatio - (data.highlighter.touchPoint.y - self.viewHandler.contentTop) * ratio;
            NSString *priceText = [NSString stringWithFormat:@"%.2f",price];
            NSString *priceRatioText = [NSString stringWithFormat:@"%.2f％",priceRatio];
            NSDictionary *attributes = @{NSFontAttributeName:data.highlighter.labelFont,
                                         NSBackgroundColorAttributeName:[UIColor grayColor],
                                         NSStrokeColorAttributeName:data.highlighter.labelColor};
            
            //坐标点
            CGFloat levelLineY = data.highlighter.touchPoint.y;
            CGFloat labelY = data.highlighter.touchPoint.y;
            CGSize priceLabelSize = [priceText sizeWithAttributes:attributes];
            CGSize priceRatioLabelSize = [priceRatioText sizeWithAttributes:attributes];
            
            labelY = levelLineY - priceLabelSize.height / 2.0;
            if (labelY < (self.viewHandler.contentTop)) {
                labelY = self.viewHandler.contentTop;
            }else if (labelY > self.viewHandler.contentBottom - priceLabelSize.height) {
                labelY = self.viewHandler.contentBottom - priceLabelSize.height;
            }
            
            CGPoint leftPoint = CGPointMake(self.viewHandler.contentLeft, labelY);
            CGPoint rightPoint = CGPointMake(self.viewHandler.contentRight, labelY);
            NSTextAlignment leftAlignment = NSTextAlignmentLeft;
            NSTextAlignment rightAlignment = NSTextAlignmentRight;
            
            //横屏状态显示不一样
            CGPoint startLevelLinePoint = CGPointMake(self.viewHandler.contentLeft + priceLabelSize.width, levelLineY);
            CGPoint endLevelLinePoint = CGPointMake(self.viewHandler.contentRight - priceRatioLabelSize.width, levelLineY);
            if (!data.highlighter.isDrawLabelWithinAxis) {
                leftAlignment = NSTextAlignmentRight;
                rightAlignment = NSTextAlignmentLeft;
                
                startLevelLinePoint = CGPointMake(self.viewHandler.contentLeft, levelLineY);
                endLevelLinePoint = CGPointMake(self.viewHandler.contentRight, levelLineY);
            }
            
            //绘制左边提示框
            [AlexChartUtils drawText:context
                                text:priceText
                               point:leftPoint
                               align:leftAlignment
                               attrs:attributes];
            //绘制右边提示框
            [AlexChartUtils drawText:context
                                text:priceRatioText
                               point:rightPoint
                               align:rightAlignment
                               attrs:attributes];
            
            //绘制水平线
            [AlexChartUtils drawLine:context
                               color:data.highlighter.levelLineColor
                               width:data.highlighter.levelLineWidth
                          startPoint:startLevelLinePoint
                            endPoint:endLevelLinePoint];
        }
    }
    
    //绘制竖线
    if (data.highlighter.drawVerticalLine) {
        CGPoint point = [data.lineSet.points[data.highlighter.index] CGPointValue];
        [AlexChartUtils drawLine:context
                           color:data.highlighter.verticalLineColor
                           width:data.highlighter.verticalLineWidth
                      startPoint:CGPointMake(point.x, self.viewHandler.contentTop)
                        endPoint:CGPointMake(point.x, self.viewHandler.contentBottom)];
    }
    
    //绘制高亮点
    if (data.highlighter.isDrawHighlightPoint) {
        CGPoint point = [data.lineSet.points[data.highlighter.index] CGPointValue];
        [AlexChartUtils drawConcentricCircle:context
                                   lineColor:data.highlighter.pointLineColor
                                   fillColor:data.highlighter.pointColor
                                   lineWidth:data.highlighter.pointLineWidth
                                      radius:data.highlighter.pointRadius
                                       point:point];
        
        if (data.lineSet.isDrawAvgLine) {
            CGPoint avgPoint = [data.lineSet.avgPoints[data.highlighter.index] CGPointValue];
            [AlexChartUtils drawConcentricCircle:context
                                       lineColor:data.highlighter.pointLineColor
                                       fillColor:data.highlighter.pointColor
                                       lineWidth:data.highlighter.pointLineWidth
                                          radius:data.highlighter.pointRadius
                                           point:avgPoint];
        }
    }
}

/**
 *  绘制K线的十字线，十字交点位于蜡烛图的中间
 *
 *  @param context 上下文
 *  @param data    数据
 */
- (void)drawKCrossLine:(CGContextRef)context data:(AlexChartData *)data {
    if (!data.dataSets) {
        return;
    }
    
    if (!data.highlighter.isHighlight) {
        return;
    }
    
    NSDictionary *attributes = @{NSFontAttributeName:data.highlighter.labelFont,
                                 NSBackgroundColorAttributeName:[UIColor grayColor],
                                 NSStrokeColorAttributeName:data.highlighter.labelColor};
    if (data.highlighter.isDrawLevelLine) {
        if (data.highlighter.touchPoint.y > self.viewHandler.contentTop &&
            data.highlighter.touchPoint.y < self.viewHandler.contentBottom) {
            
            CGFloat price = data.yMax - (data.highlighter.touchPoint.y - self.viewHandler.contentTop) / data.drawScale;
            NSString *labelText = [NSString stringWithFormat:@"%.2f",price];
            if (data.highlighter.isVolumeChartType) {
                labelText = [NSString stringWithFormat:@"%lf",price];
            }
            
            CGFloat levelLineY = data.highlighter.touchPoint.y;
            CGFloat labelX = data.highlighter.touchPoint.x;
            CGFloat labelY = data.highlighter.touchPoint.y;
            CGSize labelSize = [labelText sizeWithAttributes:attributes];
            labelY = levelLineY - labelSize.height / 2.0;
            if (labelY < self.viewHandler.contentTop) {
                labelY = self.viewHandler.contentTop;
            }else if (labelY > self.viewHandler.contentBottom) {
                labelY = self.viewHandler.contentBottom - labelSize.height;
            }
            NSTextAlignment textAlignment = NSTextAlignmentLeft;
            CGFloat labelA = labelSize.width;
            CGFloat labelB = labelSize.width;
            if (labelX < self.viewHandler.contentLeft + self.viewHandler.contentWidth/2) {
                labelX = self.viewHandler.contentRight;
                labelA = 0;
                textAlignment = NSTextAlignmentRight;
            } else {
                labelX = self.viewHandler.contentLeft;
                labelB = 0;
            }
            
            //横屏状态显示不一样
            CGPoint labelPoint = CGPointMake(labelX, labelY);
            CGPoint startLevelLinePoint = CGPointMake(self.viewHandler.contentLeft + labelA, levelLineY);
            CGPoint endLevelLinePoint = CGPointMake(self.viewHandler.contentRight - labelB, levelLineY);
            if (!data.highlighter.isDrawLabelWithinAxis) {
                startLevelLinePoint = CGPointMake(self.viewHandler.contentLeft, levelLineY);
                endLevelLinePoint = CGPointMake(self.viewHandler.contentRight, levelLineY);
                labelPoint =  CGPointMake(self.viewHandler.contentLeft, labelY);
                textAlignment = NSTextAlignmentRight;
            }
            
            //绘制左边提示框
            [AlexChartUtils drawText:context
                                text:labelText
                               point:labelPoint
                               align:textAlignment
                               attrs:attributes];
            //绘制水平线
            [AlexChartUtils drawLine:context
                               color:data.highlighter.levelLineColor
                               width:data.highlighter.levelLineWidth
                          startPoint:startLevelLinePoint
                            endPoint:endLevelLinePoint];
        }
    }
    
    //绘制X轴线显示的日期label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    AlexDataSet *dataSet = data.dataSets[data.highlighter.index];
    NSString *dateString = [dateFormatter stringFromDate:dataSet.date];
    CGSize dateLabelSize = [dateString sizeWithAttributes:attributes];
    CGFloat dateX = data.highlighter.touchPoint.x;
    if ((data.highlighter.touchPoint.x + dateLabelSize.width / 2.0) > self.viewHandler.contentRight) {
        dateX = self.viewHandler.contentRight - dateLabelSize.width / 2.0;
    }else if ((data.highlighter.touchPoint.x - dateLabelSize.width / 2.0) < self.viewHandler.contentLeft) {
        dateX = self.viewHandler.contentLeft + dateLabelSize.width / 2.0;
    }
    CGPoint dateLabelPoint = CGPointMake(dateX, self.viewHandler.contentBottom);
    [AlexChartUtils drawText:context
                        text:dateString
                       point:dateLabelPoint
                       align:NSTextAlignmentCenter
                       attrs:attributes];
    
    //绘制竖线
    if (data.highlighter.drawVerticalLine) {
        [AlexChartUtils drawLine:context
                           color:data.highlighter.verticalLineColor
                           width:data.highlighter.verticalLineWidth
                      startPoint:CGPointMake(data.highlighter.touchPoint.x, self.viewHandler.contentTop)
                        endPoint:CGPointMake(data.highlighter.touchPoint.x, self.viewHandler.contentBottom)];
    }
}

@end
