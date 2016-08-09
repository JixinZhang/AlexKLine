//
//  AlexChartHighlight.h
//  AlexKLine
//
//  Created by WSCN on 8/9/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface AlexChartHighlight : NSObject

@property (nonatomic, assign) NSInteger index;              //高亮点的下标
@property (nonatomic, assign) CGPoint point;                //高亮点的坐标
@property (nonatomic, assign) CGPoint touchPoint;           //触摸点的坐标
@property (nonatomic, assign) CGFloat maxPriceRatio;        //最大的涨跌幅

@property (nonatomic, strong) UIColor *pointColor;          //高亮点的颜色
@property (nonatomic, strong) UIColor *pointLineColor;      //高亮点边框的颜色
@property (nonatomic, assign) CGFloat pointLineWidth;       //高亮点边框的宽度
@property (nonatomic, assign) CGFloat pointRadius;          //高亮点的半径

@property (nonatomic, strong) UIColor *levelLineColor;      //横线的颜色
@property (nonatomic, assign) CGFloat levelLineWidth;       //横线的宽度

@property (nonatomic, strong) UIColor *verticalLineColor;   //竖线的颜色
@property (nonatomic, assign) CGFloat verticalLineWidth;    //竖线的宽度

@property (nonatomic, strong) UIFont *labelFont;            //高亮提示框字体
@property (nonatomic, strong) UIColor *labelColor;          //高亮提示框颜色

@property (nonatomic, assign, getter=isHighlight) BOOL highlight;                       //是否显示高亮线
@property (nonatomic, assign, getter=isDrawLevelLine) BOOL drawLevelLine;               //是否绘制水平线
@property (nonatomic, assign, getter=isDrawVerticalLine) BOOL drawVerticalLine;         //是否绘制竖线
@property (nonatomic, assign, getter=isDrawHighlightPoint) BOOL drawHighlightPoint;     //是否绘制高亮点
@property (nonatomic, assign, getter=isDrawLabelWithinAxis) BOOL drawLabelWithinAxis;   //是否绘制在轴里面
@property (nonatomic, assign, getter=isVolumeChartType) BOOL volumeChartType;           //是否是成交量图

@end
