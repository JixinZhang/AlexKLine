//
//  AlexXAxis.h
//  AlexKLine
//
//  Created by WSCN on 7/13/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexAxisBase.h"
@class AlexChartData;

@interface AlexXAxis : AlexAxisBase

@property (nonatomic, assign) NSInteger labelCount;
@property (nonatomic, strong) NSMutableArray *values;

- (void)setupValues:(AlexChartData *)data;
@end
