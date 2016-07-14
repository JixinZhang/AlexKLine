//
//  AlexXAxis.m
//  AlexKLine
//
//  Created by WSCN on 7/13/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "AlexXAxis.h"

@implementation AlexXAxis

- (instancetype)init {
    if (self = [super init]) {
        _labelCount = 5;
    }
    return self;
}

- (void)setupValues:()data {
    _values = [@[@"09:30",@"10:30",@"11:30/13:00",@"14:00",@"15:00"] mutableCopy];
}
@end
