//
//  AlexChartBase.h
//  AlexKLine
//
//  Created by WSCN on 7/14/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlexChartData.h"
#import "AlexChartUtils.h"
#import "AlexChartHandler.h"

@interface AlexChartBase : UIView

@property (nonatomic, strong) AlexXAxis *xAxis;
@property (nonatomic, strong) AlexChartData *data;
@property (nonatomic, strong) AlexChartHandler *viewHandler;

@property (nonatomic, assign) BOOL drawMakers;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderLineWidth;
@property (nonatomic, strong) UIColor *gridBackgroundColor;

@property (nonatomic, strong) UIFont *descriptionFont;
@property (nonatomic, strong) UIColor *descriptionTextColor;
@property (nonatomic, assign) CGPoint descriptionTextPosition;
@property (nonatomic, assign) NSTextAlignment descriptionTextAlig;

@property (nonatomic, strong) UIFont *infoFont;
@property (nonatomic, strong) UIColor *infoTextColor;
@property (nonatomic, copy) NSString *noDataText;
@property (nonatomic, assign, getter=isDragInfoEnabled) BOOL dragInfoEnabled;

- (void)setupChart;
- (void)setExtraOffsetsLeft:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom;
@end
