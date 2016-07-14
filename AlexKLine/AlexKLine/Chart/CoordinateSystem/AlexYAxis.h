//
//  AlexYAxis.h
//  AlexKLine
//
//  Created by WSCN on 7/14/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexAxisBase.h"

@interface AlexYAxis : AlexAxisBase

@property (nonatomic, assign) NSInteger labelCount;
@property (nonatomic, strong) NSMutableArray *values;

@end
