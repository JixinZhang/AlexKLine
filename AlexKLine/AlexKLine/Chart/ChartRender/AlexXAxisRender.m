//
//  AlexXAxisRender.m
//  AlexKLine
//
//  Created by WSCN on 7/20/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexXAxisRender.h"

@implementation AlexXAxisRender

+ (instancetype)initWithHandler:(AlexChartHandler *)handler xAxis:(AlexXAxis *)xAxis {
    AlexXAxisRender *render = [[AlexXAxisRender alloc] init];
    render.xAxis = xAxis;
    render.viewHandler = handler;
    return render;
}

#pragma mark - 绘制X轴线

- (void)renderXAxis:(CGContextRef)context {
    if (_xAxis.isDrawAxisLineEnabled) {
        CGContextSaveGState(context);
        CGContextSetStrokeColorWithColor(context, _xAxis.axisLineColor.CGColor);
        CGContextSetLineWidth(context, _xAxis.axisLineWidth);
        
        CGPoint points[2] = {CGPointMake(self.viewHandler.contentLeft, self.viewHandler.contentBottom),CGPointMake(self.viewHandler.contentRight, self.viewHandler.contentBottom)};
        CGContextStrokeLineSegments(context, points, 2);
        CGContextRestoreGState(context);
    }
}

- (void)renderGridLines:(CGContextRef)context {
    if (_xAxis.isDrawGridLinesEnabled) {
        CGContextSaveGState(context);
        
        CGContextSetShouldAntialias(context, _xAxis.gridAntialiasEnabled);
        CGContextSetStrokeColorWithColor(context, _xAxis.gridColor.CGColor);
        CGContextSetLineWidth(context, _xAxis.gridLineWidth);
        CGContextSetLineDash(context, 0.0, nil, 0);
        CGContextSetLineCap(context, _xAxis.gridLineCap);
        
        CGPoint position = CGPointMake(0, self.viewHandler.contentTop);
        CGFloat xValue = 0;
        NSInteger lineCount = _xAxis.values.count;
        xValue = self.viewHandler.contentWidth / (_xAxis.values.count - 1);
        
        for (NSInteger i = 0; i < lineCount; i++) {
            if (i ==0 ||
                i == lineCount - 1) {
                continue;
            }
            position.x = i * xValue + self.viewHandler.contentLeft;
            gridLineSegmentsBuffer[0].x = position.x;
            gridLineSegmentsBuffer[0].y = self.viewHandler.contentTop;
            gridLineSegmentsBuffer[1].x = position.x;
            gridLineSegmentsBuffer[1].y = self.viewHandler.contentBottom;
            CGContextStrokeLineSegments(context, gridLineSegmentsBuffer, 2);
        }
        CGContextRestoreGState(context);
    }
}

- (void)renderAxisLabels:(CGContextRef)context {
    if (_xAxis.isDrawLabelsEnabled) {
        CGFloat yOffset = 2.0f;
        [self drawLabels:context pointY:self.viewHandler.contentBottom + yOffset];
    }
}

- (void)drawLabels:(CGContextRef)context pointY:(CGFloat)pointY {
    if (_xAxis.isDrawLabelsEnabled) {
        NSMutableParagraphStyle *paraStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paraStyle.alignment = NSTextAlignmentLeft;
        NSDictionary *labelAttrs = @{NSFontAttributeName:_xAxis.labelFont,
                                     NSForegroundColorAttributeName:_xAxis.labelTextColor,
                                     NSParagraphStyleAttributeName:paraStyle};
        CGPoint point = CGPointMake(0, pointY);
        
        CGFloat emptyW = self.viewHandler.contentWidth / (_xAxis.values.count - 1);
        for (NSInteger i = 0; i < _xAxis.values.count; i++) {
            point.x = self.viewHandler.contentLeft + i * emptyW;
            if (i > 0) {
                paraStyle.alignment = NSTextAlignmentCenter;
            }
            if (i == _xAxis.values.count - 1) {
                paraStyle.alignment = NSTextAlignmentRight;
            }
            [AlexChartUtils drawText:context text:_xAxis.values[i] point:point align:paraStyle.alignment attrs:labelAttrs];
        }
    }
}

@end
