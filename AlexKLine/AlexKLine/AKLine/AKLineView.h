//
//  AKLineView.h
//  AlexKLine
//
//  Created by ZhangBob on 4/15/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKLineView : UIView

@property (nonatomic, assign) CGFloat xAxisWidth;  //K线图和成交量图的宽度
@property (nonatomic, assign) CGFloat yAxisHeightOfKLine;  //K线图的高度
@property (nonatomic, assign) CGFloat yAxisHeightOfVolume; //成交量图的高度
@property (nonatomic, copy) NSArray *dataArr;
//- (void)start;
- (void)startWith:(NSArray *)data;
- (void)drawLineWithData:(NSArray *)dataArray;

@end
