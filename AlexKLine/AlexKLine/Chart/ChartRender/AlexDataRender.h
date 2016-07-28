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
@end
