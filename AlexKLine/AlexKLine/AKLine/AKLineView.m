//
//  AKLineView.m
//  AlexKLine
//
//  Created by ZhangBob on 4/15/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AKLineView.h"
#import "LNRequest.h"
#import "LNNetWorking.h"
#import "KLineDataModel.h"
#import "AlexChartUtils.h"

#define screenWidth self.frame.size.width
#define screenHeight self.frame.size.height

@interface AKLineView()
{
    UIView *kLineChartView;   //k线图view
    UIView *volumeChartView;  //成交量view
    NSThread *thread;
    CGContextRef ctx;
}

@end

@implementation AKLineView

- (void)startWith:(NSArray *)data {
    thread = [[NSThread alloc] initWithTarget:self selector:@selector(drawLineWithData:) object:nil];
    [thread start];
    [self drawChart];

}

#pragma mark - 画K线图的成交量的外框
- (void)drawChart {
    //画K线图的外框
    if (kLineChartView == nil) {
        kLineChartView = [[UIView alloc] initWithFrame:CGRectMake(screenWidth - self.xAxisWidth, 100, self.xAxisWidth, self.yAxisHeightOfKLine)];
        kLineChartView.backgroundColor = [UIColor clearColor];
        kLineChartView.layer.borderColor = [UIColor blackColor].CGColor;
        kLineChartView.layer.borderWidth = 1.0;
        kLineChartView.userInteractionEnabled = YES;
        [self addSubview:kLineChartView];
    }
    
    //画成交量的外框
    if (volumeChartView == nil) {
        volumeChartView = [[UIView alloc] initWithFrame:CGRectMake(screenWidth - self.xAxisWidth, kLineChartView.frame.origin.y + self.yAxisHeightOfKLine + 20, self.xAxisWidth, self.yAxisHeightOfVolume)];
        volumeChartView.backgroundColor = [UIColor clearColor];
        volumeChartView.layer.borderColor = [UIColor blackColor].CGColor;
        volumeChartView.layer.borderWidth = 1.0;
        volumeChartView.userInteractionEnabled = YES;
        [self addSubview:volumeChartView];
        
    }
}

- (void)drawRect:(CGRect)rect {
    [self drawChart];
    [self drawLineWithData:self.dataArr];
    [self drawVolumeWithData:self.dataArr];
    [self drawGraphic];
}

- (void)drawLineWithData:(NSArray *)dataArray {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 100, 16, 16, 1);
    CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1);
    CGContextSetLineWidth(context, 1.0);
    
    NSMutableArray *pointY = [NSMutableArray array];
    for (KLineDataModel *array in dataArray) {
        NSString *tempStr = [NSString stringWithFormat:@"%f",160 - (([array.volume floatValue])/10000.0)];
        [pointY addObject:tempStr];
    }
    NSMutableArray *points = [NSMutableArray array];

    int i = 12;
    for (id item in pointY) {
        CGPoint currentPoint;
        currentPoint.x = i;
        i += 4;
        currentPoint.y = [item doubleValue];
        if ([pointY indexOfObject:item] == 0) {
            CGContextMoveToPoint(context, currentPoint.x, currentPoint.y);
            continue;
        }
        CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
        CGContextStrokePath(context);
        if ([pointY indexOfObject:item] < pointY.count) {
            CGContextMoveToPoint(context, currentPoint.x, currentPoint.y);
        }
        [points addObject:[NSValue valueWithCGPoint:currentPoint]];
    }
    
    [AlexChartUtils drawCircles:context fillColor:[UIColor brownColor] points:points radius:2.0f];
    
    [self setNeedsDisplay];
    [self setNeedsLayout];
    
    
}

- (void)drawVolumeWithData:(NSArray *)dataArray {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    
    NSMutableArray *pointY = [NSMutableArray array];
    for (KLineDataModel *array in dataArray) {
        NSString *tempStr = [NSString stringWithFormat:@"%f",260 - (([array.volume floatValue])/10000.0)];
        [pointY addObject:tempStr];
    }
    CGFloat y = 0;
    int i = 10;
    for (id item in pointY) {
        CGPoint currentPoint;
        currentPoint.x = i;
        i += 4;
        currentPoint.y = [item doubleValue];
        if (currentPoint.y < y) {
            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
        }else {
            CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
        }
        y = currentPoint.y;
        CGContextFillRect(context, CGRectMake(i, currentPoint.y, 2, 290-currentPoint.y));
    }
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)drawGraphic {
    //圆
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint point = CGPointMake(150, 50);
    [AlexChartUtils drawCircle:context fillcolor:[UIColor greenColor] radius:20 point:point];
    
    //同心圆
    [AlexChartUtils drawConcentricCircle:context lineColor:[UIColor redColor] fillColor:[UIColor purpleColor] lineWidth:5 radius:10 point:CGPointMake(20, 30)];
    
    //矩形
    [AlexChartUtils drawRect:context lineColor:[UIColor brownColor] fillColor:[UIColor redColor] lineWidht:2.0 rect:CGRectMake(40, 30, 10, 20)];
    
    //直线
    [AlexChartUtils drawLine:context color:[UIColor redColor] width:2 startPoint:CGPointMake(45, 25) endPoint:CGPointMake(45, 55)];
    
    //文字
    [AlexChartUtils drawText:context text:@"7月12日" align:NSTextAlignmentCenter point:CGPointMake(60, 30) attrs:nil];
    
    //三角形
    [AlexChartUtils drawTriangle:context lineColor:[UIColor blackColor] fillColor:[UIColor blueColor] centerPoint:CGPointMake(30, 350) length:40 lineWidth:1.0 direction:TriangleDirectionUp];
    
    [AlexChartUtils drawTriangle:context lineColor:[UIColor blackColor] fillColor:[UIColor blueColor] centerPoint:CGPointMake(90, 350) length:60 lineWidth:1.0 direction:TriangleDirectionDown];
    
    [AlexChartUtils drawTriangle:context lineColor:[UIColor blackColor] fillColor:[UIColor blueColor] centerPoint:CGPointMake(150, 350) length:60 lineWidth:1.0 direction:TriangleDirectionLeft];
    
    [AlexChartUtils drawTriangle:context lineColor:[UIColor blackColor] fillColor:[UIColor blueColor] centerPoint:CGPointMake(220, 350) length:60 lineWidth:1.0 direction:TriangleDirectionRight];
    
    //任意三角形
    NSArray *pointArr = @[[NSValue valueWithCGPoint:CGPointMake(280, 350)],
                          [NSValue valueWithCGPoint:CGPointMake(300, 380)],
                          [NSValue valueWithCGPoint: CGPointMake(320, 330)]];
    [AlexChartUtils drawTriangle:context lineColor:[UIColor blueColor] fillColor:[UIColor blueColor] pointArr:pointArr lineWidth:1.0f];

    //圆角矩形
    [AlexChartUtils drawRoundedRect:context lineColor:[UIColor blackColor] fillColor:[UIColor brownColor] lineWidth:2.0f cornerRadius:10.0f rect:CGRectMake(30, 400, 100, 30)];
    //虚线
    [AlexChartUtils drawDashLine:context color:[UIColor grayColor] width:1.0f startPoint:CGPointMake(14, 160) endPoint:CGPointMake(320, 160)];
    
}

@end
