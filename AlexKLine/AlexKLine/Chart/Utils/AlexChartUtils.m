//
//  AlexChartUtils.m
//  AlexDraw
//
//  Created by WSCN on 7/11/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexChartUtils.h"

@implementation AlexChartUtils
/*
 *画圆
 */
+ (void)drawCircle:(CGContextRef)context
         fillcolor:(UIColor *)fillColor
            radius:(CGFloat)radius
             point:(CGPoint)point {
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextAddArc(context, point.x, point.y, radius, 0, M_PI * 2, 0);
    CGContextDrawPath(context, kCGPathFill);
    /*
     kCGPathFill,
     kCGPathEOFill,
     kCGPathStroke, //画圆的轮廓
     kCGPathFillStroke,
     kCGPathEOFillStroke
     */
}

+ (void)drawCircles:(nullable CGContextRef)context
          fillColor:(nullable UIColor *)fillColor
             points:(nullable NSArray *)points
             radius:(CGFloat)radius {
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    for (NSInteger i = 0; i < points.count; i++) {
        NSValue *value = points[i];
        CGPoint point = [value CGPointValue];
        CGContextAddArc(context, point.x, point.y, radius, 0, M_PI * 2, 0);
        CGContextDrawPath(context, kCGPathFill);
    }
}
/*
 *画同心圆
 */
+ (void)drawConcentricCircle:(nullable CGContextRef)context
                   lineColor:(nullable UIColor *)lineColor
                   fillColor:(nullable UIColor *)fillColor
                   lineWidth:(CGFloat)lineWidth
                      radius:(CGFloat)radius
                       point:(CGPoint)point {
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);   //线的填充色
    CGContextSetFillColorWithColor(context, fillColor.CGColor);     //圆的填充色
    
    //内圆
    CGContextAddArc(context, point.x, point.y, radius, 0, M_PI * 2, 0);
    CGContextDrawPath(context, kCGPathFill);
    
    //外圆
    CGContextAddArc(context, point.x, point.y, radius, 0, M_PI * 2, 0);
    CGContextDrawPath(context, kCGPathStroke);
}

/*
 ＊画矩形
 */
+ (void)drawRect:(nullable CGContextRef)context
           color:(nullable UIColor*)color
            rect:(CGRect)rect {
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathFill);
}
/*
 ＊画矩形，有边框
 */
+ (void)drawRect:(nullable CGContextRef)context
       lineColor:(nullable UIColor *)lineColor
       fillColor:(nullable UIColor *)fillColor
       lineWidht:(CGFloat)lineWidth
            rect:(CGRect)rect; {
    //边框的宽度
    CGContextSetLineWidth(context, lineWidth);
    //边框的颜色
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    //矩形的填充色
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathFillStroke);
}

#pragma mark - 绘制单条线段

/*
 ＊绘制单条线段
 */
+ (void)drawLine:(nullable CGContextRef)context
           color:(nullable UIColor *)color
           width:(CGFloat)width
      startPoint:(CGPoint)startPoint
        endPoint:(CGPoint)endPoint {
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextDrawPath(context, kCGPathStroke);
}

#pragma mark - 绘制折线

+ (void)drawPolyline:(nullable CGContextRef)context
               color:(nullable UIColor *)color
              points:(nullable NSArray *)points
               width:(CGFloat)width {
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    for (NSInteger i = 0; i < points.count; i++) {
        NSValue *value = points[i];
        CGPoint point = [value CGPointValue];
        if (i == 0) {
            CGContextMoveToPoint(context, point.x, point.y);
        }else {
            CGContextAddLineToPoint(context, point.x, point.y);
        }
        CGContextDrawPath(context, kCGPathStroke);
    }
}

#pragma mark - 绘制虚线

+ (void)drawDashLine:(nullable CGContextRef)context
               color:(nullable UIColor *)color
               width:(CGFloat)width
          startPoint:(CGPoint)startPoint
            endPoint:(CGPoint)endPoint {
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    //设置虚线排列的宽度间隔:下面的lengths中的数字表示先绘制5个点再绘制2个点
    CGFloat lengths[] = {5,2};
    //CGContextSetLineDash的最后一个参数为lengths.count
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextDrawPath(context, kCGPathStroke);
}

#pragma mark - 绘制文字

+ (void)drawText:(nullable CGContextRef)context
            text:(nullable NSString *)text
           align:(NSTextAlignment)align
           point:(CGPoint)point
           attrs:(nullable NSDictionary<NSString *, id> *)attrs {
    UIGraphicsPushContext(context);
    [text drawAtPoint:point withAttributes:attrs];
    UIGraphicsPopContext();
}
@end
