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

@interface AlexChartView : AlexChartBase

@property (nonatomic, strong) AlexYAxis *leftAxis;
@property (nonatomic, strong) AlexYAxis *rightAxis;

@property (nonatomic, strong) AlexDataRender *dataRender;

- (void)calcMinMax;
- (void)setupWithData:(NSMutableArray *)data;


@end
