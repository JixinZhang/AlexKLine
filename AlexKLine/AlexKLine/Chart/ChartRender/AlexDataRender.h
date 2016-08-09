//
//  AlexDataRender.h
//  AlexKLine
//
//  Created by WSCN on 7/18/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexRenderBase.h"
#import "AlexChartData.h"

@interface AlexDataRender : AlexRenderBase

+ (instancetype)initWithHandler:(AlexChartHandler *)handler;
- (void)drawLineData:(CGContextRef)context data:(AlexChartData *)data;

#pragma mark - 绘制蜡烛图
- (void)DrawCandle:(CGContextRef)context data:(AlexChartData *)data;

#pragma mark - 绘制成交量
- (void)DrawVolume:(CGContextRef)context data:(AlexChartData *)data;

#pragma mark - 绘制十字线
/**
 *  绘制一般曲线的十字线
 *
 *  @param context 绘制上下文
 *  @param data    数据
 */
- (void)drawCrossLine:(CGContextRef)context data:(AlexChartData *)data;

/**
 *  绘制K线的十字线，十字交点位于蜡烛图的中间
 *
 *  @param context 上下文
 *  @param data    数据
 */
- (void)drawKCrossLine:(CGContextRef)context data:(AlexChartData *)data;
@end
