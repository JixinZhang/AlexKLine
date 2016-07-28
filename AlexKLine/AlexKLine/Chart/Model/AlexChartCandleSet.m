//
//  AlexChartCandleSet.m
//  AlexKLine
//
//  Created by WSCN on 7/28/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexChartCandleSet.h"

@implementation AlexChartCandleSet

- (instancetype)init {
    if (self = [super init]) {
        _candleWith = 6;
        _candleMinW = 1;
        _candleMaxW = 30;
        _points = [NSMutableArray array];
        _candleEqualColor = [UIColor grayColor];
        _candleRiseColor = [UIColor colorWithRed:0.96 green:0.16 blue:0.16 alpha:1];
        _candleFallColor = [UIColor colorWithRed:0.25 green:0.85 blue:0.30 alpha:1];
//        _MA1Color = [UIColor colorWithRed:0.96 green:0.12 blue:0.49 alpha:1];
//        _MA2Color = [UIColor colorWithRed:0.94 green:0.67 blue:0.04 alpha:1];
//        _MA3Color = [UIColor colorWithRed:0.46 green:0.42 blue:0.97 alpha:1];
//        _MA4Color = [UIColor colorWithRed:0.96 green:0.12 blue:0.49 alpha:1];
//        _MA5Color = [UIColor colorWithRed:0.96 green:0.12 blue:0.49 alpha:1];
    }
    return self;
}

- (void)setCandleWith:(CGFloat)candleWith {
    _candleWith = candleWith;
    if (_candleWith > _candleMaxW) {
        _candleWith = _candleMaxW;
    }else if (_candleWith < _candleMinW) {
        _candleWith = _candleMinW;
    }
}

@end
