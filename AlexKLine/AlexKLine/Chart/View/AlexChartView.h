//
//  AlexChartView.h
//  AlexKLine
//
//  Created by WSCN on 7/14/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexChartBase.h"
#import "AlexYAxis.h"
#import "AlexDataRender.h"
#import "AlexXAxisRender.h"
#import "AlexYAxisRender.h"

typedef NS_ENUM(NSUInteger, ChartViewType) {
    ChartViewTypeNormal = 0,        //一般折线（不限制点数）
    ChartViewTypeLine,              //折线（限制点数）
    ChartViewTypeFiveDayLine,       //五日线
    ChartViewTypeKLine,             //K线
    ChartViewTypeColumnar,          //成交量柱状图
    ChartViewTypeFiveDayColumnar,   //五日成交量柱状图
    ChartViewTypeKColumnar          //K线成交量柱状图
};

typedef NS_ENUM(NSUInteger, DirectionType) {
    DirectionTypeNULL = 0,
    DirectionTypeLeft,
    DirectionTypeRight
};

typedef void (^AlexChartViewPinchRecognizerBlock)(AlexChartData *data);
typedef void (^AlexChartViewPanRecognizerBlock)(BOOL isEnded, AlexChartData *data);

@interface AlexChartView : AlexChartBase

@property (nonatomic, strong) AlexYAxis *leftAxis;          //左边Y轴
@property (nonatomic, strong) AlexYAxis *rightAxis;         //右边Y轴
@property (nonatomic, assign) ChartViewType chartViewType;  //类型

@property (nonatomic, strong) AlexDataRender *dataRender;   //绘制数据
@property (nonatomic, strong) AlexXAxisRender *xAxisRender; //绘制X轴
@property (nonatomic, strong) AlexYAxisRender *leftRender;  //绘制Y轴
@property (nonatomic, strong) AlexYAxisRender *rightRender; //绘制Y轴

@property (nonatomic, assign, getter=isDragEnabled) BOOL dragEnabled;
@property (nonatomic, assign, getter=isZoomEnabled) BOOL zoomEnabled;
@property (nonatomic, assign, getter=isLongPressEnabled) BOOL longPressEnabled;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

- (void)calcMinMax;
- (void)setupWithData:(NSMutableArray *)data;


@end
