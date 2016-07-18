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
}

- (void)setupWithData:(NSMutableArray *)data {
    NSInteger valCount = data.count;
    self.data.dataSets = data;
    self.data.valCount = valCount;
    [self.data computeLastStartAndLastEnd];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.data.dataSets.count == 0) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawGridBackground:context];
    [self calcMinMax];

    [self drawData:context];
}

- (void)drawGridBackground:(CGContextRef)context {
    CGContextSaveGState(context);
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
    
    [self.data computeMinMax];
    [self.xAxis setupValues:self.data];
//    [self.leftAxis setupValues:self.data];
}

- (void)drawData:(CGContextRef)context {
    [_dataRender drawLineData:context data:self.data];
}

@end
