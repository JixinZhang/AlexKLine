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
    
    //绘制点
    if (data.lineSet.drawPoint || data.lineSet.drawAvgPoint) {
        if (data.lineSet.drawPoint) {
            [AlexChartUtils drawCircles:context fillColor:data.lineSet.pointColor points:data.lineSet.points radius:data.lineSet.pointRadius];
        }
    }
    
   
    CGContextRestoreGState(context);
}

@end
