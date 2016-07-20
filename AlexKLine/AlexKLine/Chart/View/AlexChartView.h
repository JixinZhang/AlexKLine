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

@interface AlexChartView : AlexChartBase

@property (nonatomic, strong) AlexYAxis *leftAxis;
@property (nonatomic, strong) AlexYAxis *rightAxis;

@property (nonatomic, strong) AlexDataRender *dataRender;
@property (nonatomic, strong) AlexXAxisRender *xAxisRender;
@property (nonatomic, strong) AlexYAxisRender *leftRender;
@property (nonatomic, strong) AlexYAxisRender *rightRender;
- (void)calcMinMax;
- (void)setupWithData:(NSMutableArray *)data;


@end
