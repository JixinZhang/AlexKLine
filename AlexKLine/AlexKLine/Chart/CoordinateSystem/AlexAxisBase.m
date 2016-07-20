//
//  AlexAxisBase.m
//  AlexKLine
//
//  Created by WSCN on 7/13/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexAxisBase.h"

@implementation AlexAxisBase

- (instancetype)init {
    if (self = [super init]) {
        _axisLineColor = [UIColor blackColor];
        _axisLineWidth = 0.5f;
        
        _labelFont = [UIFont systemFontOfSize:10.0f];
        _labelTextColor = [UIColor blackColor];
        
        _gridLineWidth = 0.5f;
        _gridLineCap = kCGLineCapButt;
        _gridColor = [UIColor colorWithRed:0.04 green:0.04 blue:0.04 alpha:1.0];
        
        _drawAxisLineEnabled = NO;
        _drawLabelsEnabled = YES;
    }
    
    return self;
}

@end
