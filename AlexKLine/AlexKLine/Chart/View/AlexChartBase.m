//
//  AlexChartBase.m
//  AlexKLine
//
//  Created by WSCN on 7/14/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexChartBase.h"

@implementation AlexChartBase

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupChart];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupChart];
    }
    return self;
}

- (void)setupChart {
    _borderLineWidth = 0.5f;
    _borderColor = [UIColor blackColor];
    _gridBackgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    
    _dragInfoEnabled = YES;
    _noDataText = @"暂时没有数据";
    _infoTextColor = [UIColor grayColor];
    _infoFont = [UIFont systemFontOfSize:14];
    
    _descriptionTextColor = [UIColor blackColor];
    _descriptionFont = [UIFont systemFontOfSize:9.0];
    
    _xAxis = [[AlexXAxis alloc]init];
    _viewHandler = [AlexChartHandler initWithWidth:self.frame.size.width height:self.frame.size.height];
    [_viewHandler restrainViewPortOffsetLeft:45 offsetTop:0 offsetRight:45 offsetBottom:15];
    _data = [AlexChartData initWithHandler:_viewHandler];

}
- (void)setExtraOffsetsLeft:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom {
    [_viewHandler restrainViewPortOffsetLeft:left offsetTop:top offsetRight:right offsetBottom:bottom];
}

- (void)drawRect:(CGRect)rect {
    if (self.data.dataSets.count == 0) {
        if (_dragInfoEnabled) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            [AlexChartUtils drawText:context
                                text:_noDataText
                               point:CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0)
                               align:NSTextAlignmentCenter
                               attrs:@{NSFontAttributeName:_infoFont,NSForegroundColorAttributeName:_infoTextColor}];
        }
    }
}

@end
