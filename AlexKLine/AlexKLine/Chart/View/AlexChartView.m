//
//  AlexChartView.m
//  AlexKLine
//
//  Created by WSCN on 7/14/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexChartView.h"

@interface AlexChartView()

@property (nonatomic, strong) CALayer *highlightLayer;

@property (nonatomic, assign) NSInteger numberOfItems;
@property (nonatomic, assign) NSInteger currentItemIndex;       //当前item的下标

@property (nonatomic, assign) CGFloat scrollSpeed;              //滑动速度
@property (nonatomic, assign) CGFloat startVelocity;            //开始的速度
@property (nonatomic, assign) CGFloat decelerationRate;         //减速的速率
@property (nonatomic, assign) CGFloat bounceDistance;           //回弹的距离

@property (nonatomic, assign) CGFloat scrollOffset;             //滑动的偏移量
@property (nonatomic, assign) CGFloat previousTranslation;      //位置信息
@property (nonatomic, assign) BOOL didDrag;//是否在拖动
@property (nonatomic, assign, getter = isDragging) BOOL dragging;           //是否在拖拽
@property (nonatomic, assign, getter = isScrolling) BOOL scrolling;         //是否在滑动
@property (nonatomic, assign, getter = isDecelerating) BOOL decelerating;   //是否在减速
@end

@implementation AlexChartView

- (void)setupChart {
    [super setupChart];
    self.backgroundColor = self.gridBackgroundColor;
    _leftAxis = [[AlexYAxis alloc] init];
    _rightAxis = [[AlexYAxis alloc] init];
    _rightAxis.yPosition = AxisDependencyRight;
    _dataRender = [AlexDataRender initWithHandler:self.viewHandler];
    
    _xAxisRender = [AlexXAxisRender initWithHandler:self.viewHandler xAxis:self.xAxis];
    _leftRender = [AlexYAxisRender initWithHandler:self.viewHandler yAxis:_leftAxis];
    _rightRender = [AlexYAxisRender initWithHandler:self.viewHandler yAxis:_rightAxis];
    
    _longPressEnabled = YES;
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    _longPressGestureRecognizer.minimumPressDuration = 0.5;
    [self addGestureRecognizer:_longPressGestureRecognizer];
    
    _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognized:)];
    [self addGestureRecognizer:_pinchGestureRecognizer];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    [self addGestureRecognizer:_panGestureRecognizer];
}

- (void)setupWithData:(NSMutableArray *)data {
    _dragEnabled = NO;
    _zoomEnabled = NO;
    
    _leftAxis.drawLabelsEnabled = YES;
    _leftAxis.drawGridLinesEnabled = YES;
    _rightAxis.drawLabelsEnabled = YES;
    
    NSInteger valCount = data.count;
    self.xAxis.labelSite = XAxisLabelSiteCenter;
    switch (self.chartViewType) {
        case ChartViewTypeNormal:
            break;
        case ChartViewTypeLine:
            valCount = 241;
            break;
        case ChartViewTypeFiveDayLine:
            self.xAxis.labelSite = XAxisLabelSiteRight;
            break;
        case ChartViewTypeColumnar:
//            valCount = 241;
            _rightAxis.drawLabelsEnabled = NO;
            _leftAxis.drawGridLinesEnabled = NO;
            self.data.highlighter.volumeChartType = YES;
            _leftAxis.drawLabelsEnabled = _leftAxis.labelPosition == YAxisLabelPositionOutsideChart;
            break;
        case ChartViewTypeFiveDayColumnar:
            
            break;
        case ChartViewTypeKLine:
            _rightAxis.drawLabelsEnabled = NO;
            valCount = self.viewHandler.contentWidth / self.data.candleSet.candleWith;
            _dragEnabled = _leftAxis.labelPosition == YAxisLabelPositionOutsideChart;
            _zoomEnabled = _dragEnabled;
            break;
        case ChartViewTypeKColumnar:
            
            break;
            
        default:
            break;
    }
    self.data.dataSets = data;
    self.data.valCount = valCount;
    [self.data computeLastStartAndLastEnd];
    [self setNeedsDisplay];
    
    _scrollSpeed = 1.0;
    _decelerationRate = 0.95;
    _numberOfItems = data.count;
    _bounceDistance = self.data.valCount/4;       //弹跳的距离
}

- (CALayer *)highlightLayer {
    if (!_highlightLayer) {
        _highlightLayer = [CALayer layer];
        _highlightLayer.frame = self.bounds;
        _highlightLayer.backgroundColor = [UIColor clearColor].CGColor;
    }
    return _highlightLayer;
}

#pragma mark -  绘制

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.data.dataSets.count == 0) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawGridBackground:context];
    [self calcMinMax];
    
    //绘制左边轴
    [_leftRender renderGridLines:context];
    [_leftRender renderYAxis:context];
    
    //绘制右边轴
    [_rightRender renderGridLines:context];
    
    
    //绘制X轴
    [_xAxisRender renderGridLines:context];
    [_xAxisRender renderXAxis:context];
    
    //绘制折线（基金）
    [self drawData:context];
    
    //绘制XY轴显示的Labels
    [_leftRender renderYAxisLabels:context];
    [_rightRender renderYAxisLabels:context];
    [_xAxisRender renderAxisLabels:context];
    
    //绘制高亮十字线
    switch (self.chartViewType) {
        case ChartViewTypeNormal:
        case ChartViewTypeLine:
        case ChartViewTypeFiveDayLine:{
            [_dataRender drawCrossLine:context data:self.data];
        }
            break;
        case ChartViewTypeKLine:
        case ChartViewTypeColumnar:
        case ChartViewTypeKColumnar:
        case ChartViewTypeFiveDayColumnar:{
            [_dataRender drawKCrossLine:context data:self.data];
        }
            break;
        default:
            break;
    }
    
}

- (void)drawGridBackground:(CGContextRef)context {
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
    switch (self.chartViewType) {
        case ChartViewTypeNormal:
            [self.data computeMinMax];
            [self.xAxis setupValues:self.data];
            [self.leftAxis setupValues:self.data];
            break;
        case ChartViewTypeLine:
            [self.data computeLineMinMax];
            [self.xAxis setupLineValues:self.data];
            [self.leftAxis setupValues:self.data];
            break;
        case ChartViewTypeFiveDayLine:
            
            break;
        case ChartViewTypeKLine:
            [self.data computeKLineMinMax];
            [self.xAxis setupKLineValues:self.data];
            [self.leftAxis setupKLineValues:self.data];
            break;
        case ChartViewTypeColumnar:
        case ChartViewTypeKColumnar:
        case ChartViewTypeFiveDayColumnar:
            [self.data computeVolumeMinMax];
            [self.xAxis setupVolumeValues:self.data];
            [self.leftAxis setupVolumeValues:self.data];
            break;
        default:
            break;
    }
    [self.rightAxis setupValues:self.data];
}

- (void)drawData:(CGContextRef)context {
    switch (self.chartViewType) {
        case ChartViewTypeNormal:
        case ChartViewTypeLine:
            [_dataRender drawLineData:context data:self.data];
            break;
        case ChartViewTypeFiveDayLine:
        
            break;
        case ChartViewTypeKLine:
            [_dataRender DrawCandle:context data:self.data];
            break;
        case ChartViewTypeColumnar:
        case ChartViewTypeFiveDayColumnar:
            [_dataRender DrawVolume:context data:self.data];
            break;
        case ChartViewTypeKColumnar:
            break;
            
        default:
            break;
    }

}

- (void)computeHighlightPoint:(CGPoint)point {
    if (point.x < self.viewHandler.contentLeft ||
        point.x > self.viewHandler.contentRight) {
        return;
    }
    switch (self.chartViewType) {
        case ChartViewTypeNormal:
        case ChartViewTypeLine:
        case ChartViewTypeFiveDayLine:
        case ChartViewTypeColumnar:
        case ChartViewTypeFiveDayColumnar:{
            CGFloat volumeWidth = self.viewHandler.contentWidth / self.data.valCount;
            self.data.highlighter.index = (NSInteger)((point.x - self.viewHandler.contentLeft) / volumeWidth);
        }
            break;
        case ChartViewTypeKLine:
        case ChartViewTypeKColumnar:{
            self.data.highlighter.index = (NSInteger)((point.x - self.viewHandler.contentLeft) / self.data.candleSet.candleWith);
        }
        default:
            break;
    }
    self.data.highlighter.touchPoint = point;
    self.data.highlighter.index += self.data.lastStart;
    if (self.data.highlighter.index > self.data.dataSets.count - 1) {
        self.data.highlighter.index = self.data.dataSets.count -1;
    }
}

#pragma mark - 长按手势

- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *)longPress {
    if (!self.longPressEnabled ||
        self.data.dataSets.count == 0) {
        return;
    }
    CGPoint point = [longPress locationInView:self];
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            self.data.highlighter.highlight = YES;
            [self computeHighlightPoint:point];
            [self.layer addSublayer:self.highlightLayer];
            break;
        case UIGestureRecognizerStateChanged:
            [self computeHighlightPoint:point];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            self.data.highlighter.highlight = NO;
            self.data.highlighter.touchPoint = point;
            [self.highlightLayer removeFromSuperlayer];
            break;
        default:
            break;
    }
    if (self.highlightBlock) {
        self.highlightBlock(self.data.highlighter, longPress);
    }
    [self setNeedsDisplay];
}

#pragma mark - 捏合手势

static NSInteger lastYValCount;
static NSInteger temp;

- (void)pinchGestureRecognized:(UIPinchGestureRecognizer *)pinch {
    if (!self.isZoomEnabled ||
        self.data.dataSets.count == 0) {
        return;
    }
    
    if (pinch.state == UIGestureRecognizerStateBegan) {
        lastYValCount = self.data.valCount;
        temp = 0;
    }
    
    CGFloat candleW = self.data.candleSet.candleWith * pinch.scale;
    if (candleW > self.data.candleSet.candleMaxW ||
        candleW < self.data.candleSet.candleMinW) {
        return;
    }
    self.data.candleSet.candleWith = candleW;
    CGFloat valCount = self.viewHandler.contentWidth / self.data.candleSet.candleWith;
    NSInteger offset = floor(valCount) - lastYValCount;
    self.data.valCount = floor(valCount);
    
    if (offset % 2 != 0) {
        if (temp % 2 == 0) {
            NSInteger num = 1;
            if (offset < 0) {
                num = -1;
            }
            self.data.lastStart -= num;
        }
        temp++;
    }
    
    if (self.data.valCount < self.data.dataSets.count) {
        self.data.lastStart -= offset / 2.0;
        self.data.lastEnd = self.data.lastStart + self.data.valCount;
    }else {
        self.data.lastStart = 0;
        self.data.lastEnd = self.data.dataSets.count;
    }
    lastYValCount = self.data.valCount;
    if (self.pinchRecognizerBlock) {
        self.pinchRecognizerBlock(self.data);
    }
    pinch.scale = 1.0f;
    [self setNeedsDisplay];
}

- (void)zoomPage:(AlexChartData *)data {
    self.data.lastEnd = data.lastEnd;
    self.data.lastStart = data.lastStart;
    self.data.valCount = data.valCount;
    self.data.candleSet.candleWith = data.candleSet.candleWith;
    [self setNeedsDisplay];
}

#pragma mark - 拖曳手势

- (void)panGestureRecognized:(UIPanGestureRecognizer *)pan {
    if (!self.isDragEnabled || self.data.dataSets.count == 0) {
        return;
    }
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            _dragging = YES;
            _scrolling = NO;
            _decelerating = NO;
            _previousTranslation = [pan translationInView:self].x;
        }
            break;
        case UIGestureRecognizerStateChanged: {
            //拖曳手势的速率，坐标系中X的值 向左 为 负 向右为 正
            CGFloat velocity = [pan velocityInView:self].x;
            //坐标系中移动的像素
            CGFloat translation = [pan translationInView:self].x;
            NSLog(@"\n velocity = %f,\n translation = %f", velocity, translation);
            //因子
            CGFloat factor = 0.3;
            //开始的速率
            _startVelocity = -velocity * factor * _scrollSpeed / self.data.candleSet.candleWith;
            //偏移量
            _scrollOffset -= (translation - _previousTranslation) / self.data.candleSet.candleWith;
            _previousTranslation = translation;
            
            [self setNeedsDisplay];
        }
            break;
        
        default:
            break;
    }
}

- (void)didScroll {
    CGFloat min = _bounceDistance;
    CGFloat max = 0;
    if (_numberOfItems > self.data.valCount) {
        max = MAX(_numberOfItems - self.data.valCount, 0.0) + _bounceDistance;
    }else {
        max = MAX(0, 0.0) + _bounceDistance;
    }
    
    if (_scrollOffset < min) {
        _scrollOffset = min;
        _startVelocity = 0.0;
    }else if (_scrollOffset > max) {
        _scrollOffset = max;
        _startVelocity = 0.0;
    }
    
//    NSInteger difference =
}

@end
