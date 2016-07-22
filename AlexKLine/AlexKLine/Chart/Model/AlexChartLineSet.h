//
//  AlexChartLineSet.h
//  AlexKLine
//
//  Created by WSCN on 7/15/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlexChartLineSet : NSObject

@property (nonatomic, strong) UIColor *pointColor;      //点的颜色
@property (nonatomic, assign) CGFloat pointRadius;      //点的半径
@property (nonatomic, strong) UIColor *lineColor;       //线的颜色
@property (nonatomic, assign) CGFloat lineWidth;        //线的宽度
@property (nonatomic, strong) NSMutableArray *points;   //点的坐标
@property (nonatomic, strong) UIColor *fillColor;       //填充颜色
@property (nonatomic, strong) UIColor *startFillColor;  //填充颜色
@property (nonatomic, strong) UIColor *endFillColor;    //填充颜色
@property (nonatomic, strong) NSMutableArray *fillPoints;//填充点的坐标

@property (nonatomic, strong) UIColor *avgLineColor;    //均线的颜色
@property (nonatomic, assign) CGFloat avgLineWidth;     //均线的宽度
@property (nonatomic, strong) UIColor *avgPointColor;   //均线点的颜色
@property (nonatomic, assign) CGFloat avgPointRadius;   //均线点的半径
@property (nonatomic, strong) NSMutableArray *avgPoints;//均线点的坐标

@property (nonatomic, assign, getter=isDrawPoint) BOOL drawPoint;
@property (nonatomic, assign, getter=isDrawAvgPoint) BOOL drawAvgPoint;
@property (nonatomic, assign, getter=isFillEnabled) BOOL fillEnable;
@property (nonatomic, assign, getter=isDrawAvgLine) BOOL drawAvgLine;

@end
