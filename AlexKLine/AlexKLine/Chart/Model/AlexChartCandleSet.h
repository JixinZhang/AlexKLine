//
//  AlexChartCandleSet.h
//  AlexKLine
//
//  Created by WSCN on 7/28/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlexChartCandleSet : NSObject

@property (nonatomic, assign) CGFloat candleWith;
@property (nonatomic, assign) CGFloat candleMaxW;
@property (nonatomic, assign) CGFloat candleMinW;
@property (nonatomic, strong) NSMutableArray *points;
@property (nonatomic, strong) NSMutableArray *pointColors;
@property (nonatomic, strong) NSMutableArray *candleRectS;

@property (nonatomic, strong) UIColor *candleRiseColor;  //上涨颜色
@property (nonatomic, strong) UIColor *candleFallColor;  //下跌颜色
@property (nonatomic, strong) UIColor *candleEqualColor; //等值的颜色

@end
