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

@interface AlexChartUtils : NSObject

#pragma mark - 画圆

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

+ (void)drawRect:(nullable CGContextRef)context
       lineColor:(nullable UIColor *)lineColor
       fillColor:(nullable UIColor *)fillColor
       lineWidht:(CGFloat)lineWidth
            rect:(CGRect)rect;
@end
