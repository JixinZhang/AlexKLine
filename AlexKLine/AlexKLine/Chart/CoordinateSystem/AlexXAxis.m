//
//  AlexXAxis.m
//  AlexKLine
//
//  Created by WSCN on 7/13/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexXAxis.h"
#import "AlexChartData.h"

@implementation AlexXAxis

- (instancetype)init {
    if (self = [super init]) {
        _labelCount = 5;
        _labelSite = XAxisLabelSiteCenter;
        _labelPosition = XAxisLabelPositionBottom;
    }
    return self;
}

- (void)setupValues:(AlexChartData *)data {
    if (_labelCount > data.dataSets.count) {
        _labelCount = data.dataSets.count;
    }
    NSMutableArray *values = [NSMutableArray array];
    for (NSInteger i = 0; i < _labelCount; i++) {
        AlexDataSet *dataSet = [[AlexDataSet alloc] init];
        if (i == 0) {
            dataSet = data.dataSets.firstObject;
        }else if (i == data.dataSets.count - 1) {
            dataSet = data.dataSets.lastObject;
        }else {
            NSInteger index = floorf((data.dataSets.count - 1) / (_labelCount -1) * i / 1.0);
            dataSet = data.dataSets[index];
        }
        
        if (dataSet.date) {
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            dateFormat.dateFormat = @"HH:mm";
            NSString *dataString = [dateFormat stringFromDate:dataSet.date];
            [values addObject:dataString];
        }else {
            if (data.lastStart) {
                [values addObject:dataSet.startTime];
            }
        }
    }
    _values = values;
}

- (void)setupLineValues:(AlexChartData *)data {
    NSMutableArray *xValues = [NSMutableArray array];
    switch (_labelSite) {
        case XAxisLabelSiteCenter:
            _labelCount = 5;
            xValues = [@[@"09:30",@"10:30",@"11:30/13:00",@"14:00",@"15:00"] mutableCopy];
            break;
            
        default:
            break;
    }
    _values = xValues;
}
@end
