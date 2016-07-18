//
//  AlexRenderBase.h
//  AlexKLine
//
//  Created by WSCN on 7/18/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlexChartUtils.h"
#import "AlexChartHandler.h"

@interface AlexRenderBase : NSObject

@property (nonatomic, assign) NSInteger minX;
@property (nonatomic, assign) NSInteger maxX;
@property (nonatomic, strong) AlexChartHandler *viewHandler;

@end
