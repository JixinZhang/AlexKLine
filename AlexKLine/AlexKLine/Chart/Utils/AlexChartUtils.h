//
//  AlexChartUtils.h
//  AlexDraw
//
//  Created by WSCN on 7/11/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TriangleDirection) {
    TriangleDirectionUp = 0,    //向上
    TriangleDirectionDown,      //向下
    TriangleDirectionLeft,      //向左
    TriangleDirectionRight      //向右
};

@interface AlexChartUtils : NSObject

#pragma mark - 绘制画圆

+ (void)drawCircle:(nullable CGContextRef)context
         fillcolor:(nullable UIColor *)fillColor
            radius:(CGFloat)radius
             point:(CGPoint)point;

+ (void)drawCircles:(nullable CGContextRef)context
          fillColor:(nullable UIColor *)fillColor
             points:(nullable NSArray *)points
             radius:(CGFloat)radius;

+ (void)drawConcentricCircle:(nullable CGContextRef)context
                   lineColor:(nullable UIColor *)lineColor
                   fillColor:(nullable UIColor *)fillColor
                   lineWidth:(CGFloat)lineWidth
                      radius:(CGFloat)radius
                       point:(CGPoint)point;

#pragma mark - 绘制矩形

+ (void)drawRect:(nullable CGContextRef)context
           color:(nullable UIColor*)color
            rect:(CGRect)rect;

+ (void)drawRect:(nullable CGContextRef)context
       lineColor:(nullable UIColor *)lineColor
       fillColor:(nullable UIColor *)fillColor
       lineWidht:(CGFloat)lineWidth
            rect:(CGRect)rect;

#pragma markd - 绘制圆角矩形

+ (void)drawRoundedRect:(nullable CGContextRef)context
              lineColor:(nullable UIColor *)lineColor
              fillColor:(nullable UIColor *)fillColor
              lineWidth:(CGFloat)lineWidth
           cornerRadius:(CGFloat)cornerRadius
                   rect:(CGRect)rect;

#pragma mark - 绘制单条线段

+ (void)drawLine:(nullable CGContextRef)context
           color:(nullable UIColor *)color
           width:(CGFloat)width
      startPoint:(CGPoint)startPoint
        endPoint:(CGPoint)endPoint;

#pragma mark - 绘制折线

+ (void)drawPolyline:(nullable CGContextRef)context
               color:(nullable UIColor *)color
              points:(nullable NSArray *)points
               width:(CGFloat)width;

#pragma mark - 绘制虚线

+ (void)drawDashLine:(nullable CGContextRef)context
               color:(nullable UIColor *)color
               width:(CGFloat)width
          startPoint:(CGPoint)startPoint
            endPoint:(CGPoint)endPoint;

#pragma mark - 绘制文字

+ (void)drawText:(nullable CGContextRef)context
            text:(nullable NSString *)text
           align:(NSTextAlignment)align
           point:(CGPoint)point
           attrs:(nullable NSDictionary<NSString *, id> *)attrs;

#pragma mark - 绘制三角形
//正三角形
+ (void)drawTriangle:(nullable CGContextRef)context
           lineColor:(nullable UIColor *)lineColor
           fillColor:(nullable UIColor *)fillColor
         centerPoint:(CGPoint)centerPoint
              length:(CGFloat)length
           lineWidth:(CGFloat)lineWidth
           direction:(TriangleDirection)direction;

//任意三角形
+ (void)drawTriangle:(nullable CGContextRef)context
           lineColor:(nullable UIColor *)lineColor
           fillColor:(nullable UIColor *)fillColor
            pointArr:(nullable NSArray *)pointArr
           lineWidth:(CGFloat)lineWidth;
@end
