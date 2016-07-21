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
    CGContextSetShouldAntialias(context, YES);
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
    CGContextSetShouldAntialias(context, YES);
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
    CGContextSetShouldAntialias(context, YES);
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
    CGContextSetShouldAntialias(context, YES);
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
    CGContextSaveGState(context);
    CGContextSetShouldAntialias(context, YES);
    //边框的宽度
    CGContextSetLineWidth(context, lineWidth);
    //边框的颜色
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    //矩形的填充色
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextRestoreGState(context);
}

#pragma markd - 绘制圆角矩形

+ (void)drawRoundedRect:(nullable CGContextRef)context
              lineColor:(nullable UIColor *)lineColor
              fillColor:(nullable UIColor *)fillColor
              lineWidth:(CGFloat)lineWidth
           cornerRadius:(CGFloat)cornerRadius
                   rect:(CGRect)rect {
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGContextSetShouldAntialias(context, YES);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    
    CGContextMoveToPoint(context, x + width, y + height - cornerRadius);    //从右下角开始画起
    CGContextAddArcToPoint(context, x + width, y + height, x + width - cornerRadius, y + height, cornerRadius); //右下角的圆角
    CGContextAddArcToPoint(context, x, y + height, x, y + height - cornerRadius, cornerRadius);                 //左下角的圆角
    CGContextAddArcToPoint(context, x, y, x + cornerRadius, y, cornerRadius);                                   //左上角的圆角
    CGContextAddArcToPoint(context, x + width, y, x + width, y + height - cornerRadius, cornerRadius);          //右上角的圆角
    CGContextClosePath(context);
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
    CGContextSetShouldAntialias(context, YES);
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextStrokePath(context);
}

#pragma mark - 绘制折线

+ (void)drawPolyline:(nullable CGContextRef)context
               color:(nullable UIColor *)color
              points:(nullable NSArray *)points
               width:(CGFloat)width {
    CGContextSetShouldAntialias(context, YES);
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
    }
    CGContextStrokePath(context);
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
           point:(CGPoint)point
           align:(NSTextAlignment)align
           attrs:(nullable NSDictionary<NSString *, id> *)attrs {
    if (align == NSTextAlignmentCenter) {
        point.x -= [text sizeWithAttributes:attrs].width / 2.0;
    }else if (align == NSTextAlignmentRight) {
        point.x -= [text sizeWithAttributes:attrs].width;
    }
    UIGraphicsPushContext(context);
    [text drawAtPoint:point withAttributes:attrs];
    UIGraphicsPopContext();
}

#pragma mark - 绘制三角形

+ (void)drawTriangle:(nullable CGContextRef)context
           lineColor:(nullable UIColor *)lineColor
           fillColor:(nullable UIColor *)fillColor
         centerPoint:(CGPoint)centerPoint
              length:(CGFloat)length
           lineWidth:(CGFloat)lineWidth
           direction:(TriangleDirection)direction {
    CGContextSetShouldAntialias(context, YES);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    //正三角形的外接圆半径
    CGFloat radius = length * sqrt(3) / 3.0;
    //正三角形的圆心距离底边的距离
    CGFloat distance = length * sqrt(3) / 6.0;
    CGFloat halfLength = length / 2.0;
    CGPoint points[3];
    switch (direction) {
        case TriangleDirectionUp:
            points[0] = CGPointMake(centerPoint.x, centerPoint.y - radius);
            points[1] = CGPointMake(centerPoint.x - halfLength, centerPoint.y + distance);
            points[2] = CGPointMake(centerPoint.x + halfLength, centerPoint.y + distance);
            break;
        case TriangleDirectionDown:
            points[0] = CGPointMake(centerPoint.x, centerPoint.y + radius);
            points[1] = CGPointMake(centerPoint.x - halfLength, centerPoint.y - distance);
            points[2] = CGPointMake(centerPoint.x + halfLength, centerPoint.y - distance);
            break;
        case TriangleDirectionLeft:
            points[0] = CGPointMake(centerPoint.x - radius, centerPoint.y);
            points[1] = CGPointMake(centerPoint.x + distance, centerPoint.y - halfLength);
            points[2] = CGPointMake(centerPoint.x + distance, centerPoint.y + halfLength);
            break;
        case TriangleDirectionRight:
            points[0] = CGPointMake(centerPoint.x + radius, centerPoint.y);
            points[1] = CGPointMake(centerPoint.x - distance, centerPoint.y - halfLength);
            points[2] = CGPointMake(centerPoint.x - distance, centerPoint.y + halfLength);
            break;
        default:
            break;
    }
    
    CGContextAddLines(context, points, 3);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, 0, M_PI * 2, 0);
    CGContextDrawPath(context, kCGPathStroke);
}

//任意三角形
+ (void)drawTriangle:(nullable CGContextRef)context
           lineColor:(nullable UIColor *)lineColor
           fillColor:(nullable UIColor *)fillColor
            pointArr:(nullable NSArray *)pointArr
           lineWidth:(CGFloat)lineWidth {
    CGContextSetShouldAntialias(context, YES);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    
    if (pointArr.count != 3) {
        return;
    }
    CGPoint points[3];
    points[0] = [pointArr[0] CGPointValue];
    points[1] = [pointArr[1] CGPointValue];
    points[2] = [pointArr[2] CGPointValue];
    
    CGContextAddLines(context, points, 3);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);

}
@end
