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
    
    [AlexChartUtils drawPolyline:context color:data.lineSet.lineColor points:data.lineSet.points width:data.lineSet.lineWidth];
    
    CGContextRestoreGState(context);
}

@end
