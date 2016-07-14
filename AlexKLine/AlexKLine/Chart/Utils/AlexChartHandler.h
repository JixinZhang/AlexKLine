//
//  AlexChartHandler.h
//  AlexKLine
//
//  Created by WSCN on 7/14/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlexChartHandler : NSObject

@property (nonatomic, assign) CGFloat chartWidth;
@property (nonatomic, assign) CGFloat chartHeight;

@property (nonatomic, assign) CGFloat minScaleX;
@property (nonatomic, assign) CGFloat maxScaleX;

@property (nonatomic, assign) CGFloat minScaleY;
@property (nonatomic, assign) CGFloat maxScaleY;

@property (nonatomic, assign) CGFloat scaleX;
@property (nonatomic, assign) CGFloat scaleY;

@property (nonatomic, assign) CGFloat transX;
@property (nonatomic, assign) CGFloat transY;

@property (nonatomic, assign) CGFloat transOffsetX;
@property (nonatomic, assign) CGFloat transOffsetY;

@property (nonatomic, assign) CGRect contentRect;

- (CGFloat)offsetTop;
- (CGFloat)offsetLeft;
- (CGFloat)offsetRight;
- (CGFloat)offsetBottom;

- (CGFloat)contentTop;
- (CGFloat)contentLeft;
- (CGFloat)contentRight;
- (CGFloat)contentBotom;
- (CGFloat)contentWidth;
- (CGFloat)contentHeight;

+ (instancetype)initWithWidth:(CGFloat)width
                       height:(CGFloat)height;

- (void)setChartDimensWidth:(CGFloat)width
                     height:(CGFloat)height;

- (void)restrainViewPortOffsetLeft:(CGFloat)offsetLeft
                         offsetTop:(CGFloat)offsetTop
                       offsetRight:(CGFloat)offsetRight
                      offsetBottom:(CGFloat)offsetBottom;
@end
