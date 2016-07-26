//
//  AlexXAxis.h
//  AlexKLine
//
//  Created by WSCN on 7/13/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexAxisBase.h"

typedef NS_ENUM(NSUInteger, XAxisLabelPosition) {
    XAxisLabelPositionTop = 0,
    XAxisLabelPositionBottom = 1,
    XAxisLabelPositionBothSided = 2,
    XAxisLabelPositionTopInside = 3,
    XAxisLabelPositionBottomInside = 4
};

typedef NS_ENUM(NSUInteger, XAxisLabelSite) {
    XAxisLabelSiteCenter = 0,
    XAxisLabelSiteLeft,
    XAxisLabelSiteRight
};

@class AlexChartData;

@interface AlexXAxis : AlexAxisBase

@property (nonatomic, assign) NSInteger labelCount;
@property (nonatomic, strong) NSMutableArray *values;
@property (nonatomic, assign) XAxisLabelSite labelSite;
@property (nonatomic, assign) XAxisLabelPosition labelPosition;

- (void)setupValues:(AlexChartData *)data;
@end
