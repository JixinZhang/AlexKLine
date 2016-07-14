//
//  AlexChartData.h
//  AlexKLine
//
//  Created by WSCN on 7/14/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AlexChartHandler.h"

@interface AlexChartData : NSObject

@property (nonatomic, assign) CGFloat yMax;
@property (nonatomic, assign) CGFloat yMin;
@property (nonatomic, assign) CGFloat sizeRatio;
@property (nonatomic, assign) CGFloat gapRatio;
@property (nonatomic, assign) CGFloat drawScale;
@property (nonatomic, assign) NSInteger valCount;
@property (nonatomic, strong) NSMutableArray *xVals;
@property (nonatomic, strong) NSMutableArray *dataSets;
@property (nonatomic, strong) AlexChartHandler *viewHandler;

@property (nonatomic, assign) NSInteger lastEnd;
@property (nonatomic, assign) NSInteger lastStart;
@property (nonatomic, assign) NSInteger yAxisMax;
@property (nonatomic, assign) NSInteger yAxisMin;
@property (nonatomic, assign) NSInteger emptyStartNum;
@property (nonatomic, assign) NSInteger emptyEndNum;

+ (instancetype)initWithHandler:(AlexChartHandler *)handler;
@end
