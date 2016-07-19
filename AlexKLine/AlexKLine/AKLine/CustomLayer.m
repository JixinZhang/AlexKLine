//
//  CustomLayer.m
//  AlexKLine
//
//  Created by WSCN on 7/19/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "CustomLayer.h"
#import "AlexChartUtils.h"

@implementation CustomLayer

- (void)drawInContext:(CGContextRef)ctx {
//    [AlexChartUtils drawRect:ctx color:[UIColor blueColor] rect:CGRectMake(150, 450, 36, 20)];
    [AlexChartUtils drawRoundedRect:ctx lineColor:[UIColor orangeColor] fillColor:[UIColor orangeColor] lineWidth:1.0f cornerRadius:5.0f rect:CGRectMake(150, 450, 36, 20)];
}

@end
