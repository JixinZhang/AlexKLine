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

@property (nonatomic, assign) CGFloat axisMinimun;
@property (nonatomic, assign) CGFloat axisMaximun;
@property (nonatomic, assign) CGFloat axisRange;

@end
