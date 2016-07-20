//
//  AlexYAxisRender.h
//  AlexKLine
//
//  Created by WSCN on 7/20/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexRenderBase.h"
#include "AlexYAxis.h"

@interface AlexYAxisRender : AlexRenderBase{
@private CGPoint gridLineBuffer[2];
}

@property (nonatomic, strong) AlexYAxis *yAxis;

+ (instancetype)initWithHandler:(AlexChartHandler *)handler yAxis:(AlexYAxis *)yAxis;
- (void)renderYAxis:(CGContextRef)context;
- (void)renderGridLines:(CGContextRef)context;
- (void)renderYAxisLabels:(CGContextRef)context;

@end
