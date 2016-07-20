//
//  AlexChartHandler.m
//  AlexKLine
//
//  Created by WSCN on 7/14/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexChartHandler.h"

@implementation AlexChartHandler

+ (instancetype)initWithWidth:(CGFloat)width
                       height:(CGFloat)height {
    AlexChartHandler *handler = [[AlexChartHandler alloc] init];
    [handler setChartDimensWidth:width height:height];
    return handler;
}

- (void)setChartDimensWidth:(CGFloat)width
                     height:(CGFloat)height {
    CGFloat offsetLeft = self.offsetLeft;
    CGFloat offsetTop = self.offsetTop;
    CGFloat offsetRight = self.offsetRight;
    CGFloat offsetBottom = self.offsetBottom;
    
    _chartWidth = width;
    _chartHeight = height;
    
    [self restrainViewPortOffsetLeft:offsetLeft offsetTop:offsetTop offsetRight:offsetRight offsetBottom:offsetBottom];
}

- (void)restrainViewPortOffsetLeft:(CGFloat)offsetLeft
                         offsetTop:(CGFloat)offsetTop
                       offsetRight:(CGFloat)offsetRight
                      offsetBottom:(CGFloat)offsetBottom {
    _contentRect.origin.x = offsetLeft;
    _contentRect.origin.y = offsetTop;
    _contentRect.size.width = _chartWidth - offsetLeft - offsetRight;
    _contentRect.size.height = _chartHeight - offsetTop - offsetBottom;
}

- (CGFloat)offsetTop {
    return _contentRect.origin.y;
}

- (CGFloat)offsetLeft {
    return _contentRect.origin.x;
}

- (CGFloat)offsetRight {
    return _chartWidth - _contentRect.size.width - _contentRect.origin.x;
}

- (CGFloat)offsetBottom {
    return _chartHeight - _contentRect.size.height - _contentRect.origin.y;
}

- (CGFloat)contentTop {
    return _contentRect.origin.y;
}

- (CGFloat)contentLeft {
    return _contentRect.origin.x;
}

- (CGFloat)contentRight {
    return _contentRect.origin.x + _contentRect.size.width;
}

- (CGFloat)contentBottom {
    return  _contentRect.origin.y + _contentRect.size.height;
}

- (CGFloat)contentWidth {
    return _contentRect.size.width;
}

- (CGFloat)contentHeight {
    return _contentRect.size.height;
}

- (CGPoint)contentCenter {
    return CGPointMake(_contentRect.origin.x + _contentRect.size.width / 2.0, _contentRect.origin.y + _contentRect.size.height / 2.0);
}
@end
