//
//  RoundedRectView.m
//  AlexKLine
//
//  Created by WSCN on 7/19/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "RoundedRectView.h"
#import "AlexChartUtils.h"

@implementation RoundedRectView

- (void)setupView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(4, 2, 30, 16)];
    label.text = @"1折";
    [self addSubview:label];
}

- (void)drawRect:(CGRect)rect {
    [self setupView];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [AlexChartUtils drawRoundedRect:ctx lineColor:[UIColor orangeColor] fillColor:[UIColor orangeColor] lineWidth:1.0f cornerRadius:3.0f rect:CGRectMake(0, 0, 38, 20)];
    NSArray *points = @[[NSValue valueWithCGPoint:CGPointMake(7, 20)],
                        [NSValue valueWithCGPoint:CGPointMake(7, 25)],
                        [NSValue valueWithCGPoint:CGPointMake(12, 20)]];
    [AlexChartUtils drawTriangle:ctx lineColor:[UIColor orangeColor] fillColor:[UIColor orangeColor] pointArr:points lineWidth:1.0f];
}

@end
