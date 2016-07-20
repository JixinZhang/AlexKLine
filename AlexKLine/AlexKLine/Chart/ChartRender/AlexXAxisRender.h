//
//  AlexXAxisRender.h
//  AlexKLine
//
//  Created by WSCN on 7/20/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexRenderBase.h"
#import "AlexXAxis.h"

@interface AlexXAxisRender : AlexRenderBase{

@private CGPoint gridLineSegmentsBuffer[2];

}

@property (nonatomic, strong) AlexXAxis *xAxis;

+ (instancetype)initWithHandler:(AlexChartHandler *)handler
                          xAxis:(AlexXAxis *)xAxis;
- (void)renderXAxis:(CGContextRef)context;
- (void)renderGridLines:(CGContextRef)context;
- (void)renderAxisLabels:(CGContextRef)context;
@end
