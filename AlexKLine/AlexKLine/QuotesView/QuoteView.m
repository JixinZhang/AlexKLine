//
//  QuoteView.m
//  AlexKLine
//
//  Created by WSCN on 7/18/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "QuoteView.h"
#import "AlexChartView.h"
#import "LNNetWorking.h"
#import "KLineDataModel.h"
#import "AlexDataSet.h"

@interface QuoteView()
@property (nonatomic, strong) AlexChartView *chartView;
@end

@implementation QuoteView

#pragma  mark - Init

- (instancetype)init {
    if (self = [super init]) {
        [self setupViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.chartView];
    [self requestChartData];
}

- (AlexChartView *)chartView {
//    __weak typeof (self)wSelf = self;
    if (!_chartView) {
        _chartView = [[AlexChartView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _chartView.backgroundColor = [UIColor whiteColor];
        _chartView.borderColor = [UIColor blackColor];
        _chartView.gridBackgroundColor = [UIColor clearColor];
        _chartView.borderLineWidth = 1.0f;
        _chartView.data.sizeRatio = 0.8f;
        _chartView.data.lineSet.drawAvgLine = YES;
        _chartView.data.lineSet.lineWidth = 1.0f;
        _chartView.data.lineSet.lineColor = [UIColor redColor];
        
        _chartView.leftAxis.drawGridLinesEnabled = YES;
        _chartView.leftAxis.drawLabelsEnabled = YES;
        
        _chartView.rightAxis.drawGridLinesEnabled = YES;
        _chartView.rightAxis.drawLabelsEnabled = YES;
        
        _chartView.xAxis.drawGridLinesEnabled = YES;
        _chartView.xAxis.drawLabelsEnabled = YES;
        
        
        [_chartView.viewHandler restrainViewPortOffsetLeft:10 offsetTop:5 offsetRight:10 offsetBottom:20];
    }
    return _chartView;
}

- (void)requestChartData {
    [self requestTrend:nil block:^(NSArray *result) {
        NSMutableArray *dataSets = [NSMutableArray array];
        for (KLineDataModel *model in result) {
            AlexDataSet *entity = [[AlexDataSet alloc] init];
            entity.volume = model.volume.floatValue;
            entity.price = model.price.floatValue;
            entity.avergePrice = model.averagePrice.floatValue;
            [dataSets addObject:entity];
        }
        [self refreshChartData:dataSets];
    }];
}

- (void)refreshChartData:(NSMutableArray *)dataArr {
    [self.chartView setupWithData:dataArr];
}

- (void)requestTrend:(NSString *)string block:(void(^)(NSArray*result))block {
    NSString *urlStr = [NSString stringWithFormat:@"http://test.xgb.io:3000/q/quote/v1/trend?prod_code=300264.SZ&fields=last_px,business_amount,avg_px"];
    LNRequest * request = [[LNRequest alloc] init];
    request.url = urlStr;
    [LNNetWorking getWithRequest:request success:^(LNResponse *response) {
        NSDictionary *dataDic = [response.resultDic valueForKey:@"data"];
        NSDictionary* trendInfo = [dataDic valueForKey:@"trend"];
        //得到的trendInfo包含三组key-value
        //"crc":        "300264.SZ"
        //"300264.SZ":  数组，里面包含K线图的数据
        //"fields":     {min_time,last_px,business_amount,avg_px}
        
        //        NSString* hsSymbol = [Util WSCNSymbolToHSSymbol:string];
        
        NSArray* fields = [trendInfo valueForKey:@"fields"];
        NSInteger lastPriceIndex = [fields indexOfObject:@"last_px"];
        NSInteger averagePriceIndex = [fields indexOfObject:@"avg_px"];
        NSInteger businessCountIndex = [fields indexOfObject:@"business_amount"];
        NSInteger minTimeIndex = [fields indexOfObject:@"min_time"];
        
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.dateFormat = @"yyyyMMddHHmm";
        NSArray* trendItems = [trendInfo valueForKey:@"300264.SZ"];
        NSUInteger previousBusinessCount = 0;
        NSMutableArray* kLineDataItems = [NSMutableArray array];
        for (NSArray* trendItem in trendItems){
            KLineDataModel* data = [[KLineDataModel alloc] init];
            data.open = @"";
            data.close = @"";
            data.high = @"";
            data.low = @"";
            
            NSUInteger businessCount = [[trendItem objectAtIndex:businessCountIndex] unsignedIntegerValue];
            data.volume = [NSString stringWithFormat:@"%ld", (long)businessCount - previousBusinessCount];
            data.averagePrice = [NSString stringWithFormat:@"%@", [trendItem objectAtIndex:averagePriceIndex]];
            data.price = [NSString stringWithFormat:@"%@", [trendItem objectAtIndex:lastPriceIndex]];
            
            NSString* dateString = [NSString stringWithFormat:@"%@", [trendItem objectAtIndex:minTimeIndex]];
            NSInteger hourValue = [[dateString substringWithRange:NSMakeRange(8, 2)]integerValue];
            if (hourValue < 12){
                NSDate* date = [dateFormat dateFromString:dateString];
                data.start = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
                data.close = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970] + 60];
            }
            else{
                NSDate* date = [dateFormat dateFromString:dateString];
                data.close = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
                data.start = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970] - 60];
            }
            
            [kLineDataItems addObject:data];
            
            previousBusinessCount = businessCount;
        }
        if (block){
            block(kLineDataItems);
        }
        
    } fail:^(NSError *error) {
        NSLog(@"request K line Data fail");
    }];
}

@end
