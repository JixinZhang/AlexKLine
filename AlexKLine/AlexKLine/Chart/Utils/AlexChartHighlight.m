//
//  AlexChartHighlight.m
//  AlexKLine
//
//  Created by WSCN on 8/9/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexChartHighlight.h"

@implementation AlexChartHighlight

- (instancetype)init {
    if (self = [super init]) {
        _index = 0;
        _highlight = NO;
        
        _pointRadius = 3.0f;
        _pointLineWidth = 2.0f;
        _drawHighlightPoint = YES;
        _pointColor = [UIColor whiteColor];
        _pointLineColor = [UIColor redColor];
        
        _drawLevelLine = YES;
        _levelLineWidth = 1.0f;
        _levelLineColor = [UIColor whiteColor];
        
        _drawVerticalLine = YES;
        _verticalLineWidth = 1.0f;
        _verticalLineColor = [UIColor whiteColor];
        
        _volumeChartType = NO;
        _labelFont = [UIFont systemFontOfSize:12.0f];
        _labelColor = [UIColor whiteColor];
    }
    return self;
}

@end
