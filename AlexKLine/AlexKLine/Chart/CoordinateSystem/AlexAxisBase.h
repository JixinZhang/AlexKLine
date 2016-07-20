//
//  AlexAxisBase.h
//  AlexKLine
//
//  Created by WSCN on 7/13/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AlexAxisBase : NSObject

@property (nonatomic, strong) UIFont *labelFont;
@property (nonatomic, strong) UIColor *labelTextColor;

@property (nonatomic, strong) UIColor *axisLineColor;
@property (nonatomic, assign) CGFloat axisLineWidth;

@property (nonatomic, strong) UIColor *gridColor;           //格子的颜色
@property (nonatomic, assign) CGFloat gridLineWidth;        //格子的宽度
@property (nonatomic, assign) CGLineCap gridLineCap;        //格子样式
@property (nonatomic, assign) CGFloat gridLineDashPhase;    //格子的虚线起始距离
@property (nonatomic, strong) NSArray *gridLineDashLengths; //格子的虚线的数组 {5.f,5.f}

@property (nonatomic, assign) CGFloat axisMinimun;
@property (nonatomic, assign) CGFloat axisMaximun;
@property (nonatomic, assign) CGFloat axisRange;

@property (nonatomic, assign, getter=isDrawAxisLineEnabled) BOOL drawAxisLineEnabled;
@property (nonatomic, assign, getter=isDrawLabelsEnabled) BOOL drawLabelsEnabled;
@property (nonatomic, assign, getter=isDrawGridLinesEnabled) BOOL drawGridLinesEnabled;     //是否画格子线
@property (nonatomic, assign, getter=isGridAntialiasEnabled) BOOL gridAntialiasEnabled;     //是否抗锯齿

@end
