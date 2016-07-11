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
@end
