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
@property (nonatomic, strong) AlexChartView *fundChartView;
@property (nonatomic, strong) AlexChartView *candleChartView;
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
    [self addSubview:self.fundChartView];
    [self requestChartDataForWeex];
    [self addSubview:self.candleChartView];
    [self requestChartDataForKLine];
}

- (AlexChartView *)chartView {
//    __weak typeof (self)wSelf = self;
    if (!_chartView) {
        _chartView = [[AlexChartView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 200)];
        _chartView.backgroundColor = [UIColor whiteColor];
        _chartView.borderColor = [UIColor blackColor];
        _chartView.gridBackgroundColor = [UIColor clearColor];
        _chartView.borderLineWidth = 1.0f;
        _chartView.chartViewType = ChartViewTypeLine;
        
        _chartView.data.sizeRatio = 0.8f;
        _chartView.data.lineSet.drawPoint = NO;
        _chartView.data.lineSet.pointColor = [UIColor redColor];
        _chartView.data.lineSet.lineWidth = 1.0f;
        _chartView.data.lineSet.lineColor = [UIColor magentaColor];
        _chartView.data.lineSet.fillEnable = YES;
        
        //均线
        _chartView.data.lineSet.drawAvgLine = YES;
        _chartView.data.lineSet.avgLineColor = [UIColor brownColor];
        _chartView.data.lineSet.avgLineWidth = 1.0f;
        
        _chartView.leftAxis.drawGridLinesEnabled = YES;
        _chartView.leftAxis.drawLabelsEnabled = YES;
        _chartView.leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
        _chartView.leftAxis.yPosition = AxisDependencyLeft;
        _chartView.rightAxis.drawGridLinesEnabled = YES;
        _chartView.rightAxis.drawLabelsEnabled = YES;
        
        _chartView.xAxis.drawGridLinesEnabled = YES;
        _chartView.xAxis.drawLabelsEnabled = YES;
        _chartView.xAxis.labelFont = [UIFont systemFontOfSize:7.0f];
        
        
        [_chartView.viewHandler restrainViewPortOffsetLeft:30 offsetTop:5 offsetRight:10 offsetBottom:20];
    }
    return _chartView;
}

- (AlexChartView *)fundChartView {
    if (!_fundChartView) {
        _fundChartView = [[AlexChartView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.chartView.frame), self.frame.size.width, 200)];
        _fundChartView.backgroundColor = [UIColor whiteColor];
        _fundChartView.borderColor = [UIColor blackColor];
        _fundChartView.gridBackgroundColor = [UIColor clearColor];
        _fundChartView.borderLineWidth = 1.0f;
        _fundChartView.data.sizeRatio = 0.8f;
        _fundChartView.data.lineSet.drawPoint = YES;
        _fundChartView.data.lineSet.pointColor = [UIColor redColor];
        _fundChartView.data.lineSet.lineWidth = 1.0f;
        _fundChartView.data.lineSet.lineColor = [UIColor magentaColor];
        _fundChartView.data.lineSet.fillEnable = NO;
        
        _fundChartView.leftAxis.drawGridLinesEnabled = YES;
        _fundChartView.leftAxis.drawLabelsEnabled = YES;
        _chartView.leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
        _fundChartView.leftAxis.yPosition = AxisDependencyLeft;
        _fundChartView.rightAxis.drawGridLinesEnabled = YES;
        _fundChartView.rightAxis.drawLabelsEnabled = YES;
        
        _fundChartView.xAxis.drawGridLinesEnabled = YES;
        _fundChartView.xAxis.drawLabelsEnabled = YES;
        _fundChartView.xAxis.labelFont = [UIFont systemFontOfSize:7.0f];
        
        
        [_fundChartView.viewHandler restrainViewPortOffsetLeft:30 offsetTop:5 offsetRight:10 offsetBottom:20];
    }
    return _fundChartView;
}

- (AlexChartView *)candleChartView {
    if (!_candleChartView) {
        _candleChartView = [[AlexChartView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.fundChartView.frame), self.frame.size.width, 200)];
        _candleChartView.backgroundColor = [UIColor whiteColor];
        _candleChartView.borderColor = [UIColor blackColor];
        _candleChartView.gridBackgroundColor = [UIColor clearColor];
        _candleChartView.chartViewType = ChartViewTypeKLine;
        
        _candleChartView.borderLineWidth = 1.0f;
        _candleChartView.data.sizeRatio = 0.8f;
        _candleChartView.data.lineSet.drawPoint = YES;
        _candleChartView.data.lineSet.pointColor = [UIColor redColor];
        _candleChartView.data.lineSet.lineWidth = 1.0f;
        _candleChartView.data.lineSet.lineColor = [UIColor magentaColor];
        _candleChartView.data.lineSet.fillEnable = NO;
        
        _candleChartView.leftAxis.drawGridLinesEnabled = YES;
        _candleChartView.leftAxis.drawLabelsEnabled = YES;
        _candleChartView.leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
        _candleChartView.leftAxis.yPosition = AxisDependencyLeft;
        _candleChartView.rightAxis.drawGridLinesEnabled = YES;
        _candleChartView.rightAxis.drawLabelsEnabled = YES;
        
        _candleChartView.xAxis.drawGridLinesEnabled = YES;
        _candleChartView.xAxis.drawLabelsEnabled = YES;
        _candleChartView.xAxis.labelFont = [UIFont systemFontOfSize:7.0f];
        
        
        [_candleChartView.viewHandler restrainViewPortOffsetLeft:30 offsetTop:5 offsetRight:10 offsetBottom:20];
    }
    return _candleChartView;
}

- (void)requestChartData {
    [self requestTrend:nil block:^(NSArray *result) {
        NSMutableArray *dataSets = [NSMutableArray array];
        for (KLineDataModel *model in result) {
            AlexDataSet *entity = [[AlexDataSet alloc] init];
            entity.volume = model.volume.floatValue;
            entity.price = model.price.floatValue;
            entity.averagePrice = model.averagePrice.floatValue;
            entity.date = [NSDate dateWithTimeIntervalSince1970:model.start.integerValue];
            entity.preClose = [model.preClose floatValue];
            [dataSets addObject:entity];
        }
        [self refreshChartData:dataSets];
    }];
}

- (void)requestChartDataForWeex {
    [self getIncomeTrendChartDataWithProductCode:nil Block:^(BOOL isSucceed, id response) {
        if (isSucceed) {
            NSMutableArray *dataSets = [NSMutableArray array];
            for (NSDictionary *model in response) {
                AlexDataSet *entity = [[AlexDataSet alloc] init];
                entity.price = [[model valueForKey:@"value"] floatValue];
                entity.date = [model valueForKey:@"showedDate"];
                [dataSets addObject:entity];
            }
            [self refreshFundChartData:dataSets];

        }
    }];
}

- (void)requestChartDataForKLine {
    [self getAstockDataWithStockCode:nil Block:^(BOOL isSucceed, id response) {
        if (isSucceed) {
            NSMutableArray *dataSets = [NSMutableArray array];
            for (KLineDataModel *model in response) {
                AlexDataSet *entity = [[AlexDataSet alloc]init];
                entity.open = model.open.floatValue;
                entity.close = model.close.floatValue;
                entity.high = model.high.floatValue;
                entity.low = model.low.floatValue;
                entity.volume = model.volume.floatValue;
                entity.price = model.price.floatValue;
                entity.date = model.date;
                [dataSets addObject:entity];
            }
            [self refreshKLineChartData:dataSets];
        }else {
            NSLog(@"%@",response);
        }

    }];
}

- (void)refreshChartData:(NSMutableArray *)dataArr {
    [self.chartView setupWithData:dataArr];
}

- (void)refreshFundChartData:(NSMutableArray *)dataArr {
    [self.fundChartView setupWithData:dataArr];
}

- (void)refreshKLineChartData:(NSMutableArray *)dataArr {
    [self.candleChartView setupWithData:dataArr];
}

- (void)requestTrend:(NSString *)string block:(void(^)(NSArray*result))block {
    NSString *urlStr = [NSString stringWithFormat:@"http://test.xgb.io:3000/q/quote/v1/trend?prod_code=300264.SZ&fields=last_px,avg_px,business_amount,business_balance"];
    LNRequest * request = [[LNRequest alloc] init];
    request.url = urlStr;
    [LNNetWorking getWithRequest:request success:^(LNResponse *response) {
        NSDictionary *dataDic = [response.resultDic valueForKey:@"data"];
        NSDictionary* trendInfo = [dataDic valueForKey:@"trend"];
        //昨收
        NSDictionary *real = [dataDic valueForKey:@"real"];
        NSNumber *preClosePx = [NSNumber numberWithFloat:[[real valueForKey:@"pre_close_px"] floatValue]];
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
            data.preClose = [NSString stringWithFormat:@"%.2f",preClosePx.floatValue];
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

//基金数据
-(void)getIncomeTrendChartDataWithProductCode:(NSString *)productCode
                                        Block:(void(^)(BOOL isSucceed,id response))block {
    NSString *urlString = @"https://api.ifastps.com.cn/fe-oauth/rest/product/get-performance-by-product-code-and-period?period=month_1&productCode=519097";
    LNRequest *request = [[LNRequest alloc] init];
    request.url = urlString;
    request.requestMethod = LNRequestMethodPost;
    [LNNetWorking postWithRequest:request success:^(LNResponse *response) {
        NSLog(@"%@",response.resultDic);
        NSArray *data = [response.resultDic valueForKey:@"data"];
        if (data.count != 0) {
            NSMutableArray *returnData = [NSMutableArray array];
            for (NSDictionary *dic in data) {
                NSString *value = [dic valueForKey:@"value"];
                NSNumber *dateNum = [dic valueForKey:@"showedDate"];
                dateNum = [NSNumber numberWithLong:dateNum.doubleValue/1000];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateNum.intValue];
                NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:value,@"value",date,@"showedDate", nil];
                [returnData addObject:dataDic];
            }
            if (block) {
                block(YES,returnData);
            }
        }else {
            if (block) {
                block(NO,response.errorMsg);
            }
        }
    } fail:^(NSError *error) {
        if (block) {
            block(NO,error.localizedDescription);
        }
    }];
}

//K线数据
- (void)getAstockDataWithStockCode:(NSString *)code
                             Block:(void(^)(BOOL isSucceed,id response))block {
    NSString *urlSting = @"http://101.69.181.106:8000/kline?prod_code=300264.SZ&candle_period=6&data_count=100";
    LNRequest * request = [[LNRequest alloc] init];
    request.url = urlSting;
    request.httpHeaders = [NSDictionary dictionaryWithObjectsAndKeys:@"application/json",@"Accept", nil];
    
    [LNNetWorking getWithRequest:request success:^(LNResponse *response) {
        if (response.resultDic) {
            NSDictionary *dataDic = [response.resultDic valueForKey:@"data"];
            NSDictionary* candleInfo = [dataDic valueForKey:@"candle"];
            NSArray* fields = [candleInfo valueForKey:@"fields"];
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            dateFormat.dateFormat = @"yyyyMMdd";
            NSInteger minTimeIndex = [fields indexOfObject:@"min_time"];
            NSInteger openIndex = [fields indexOfObject:@"open_px"];
            NSInteger highIndex = [fields indexOfObject:@"high_px"];
            NSInteger lowIndex = [fields indexOfObject:@"low_px"];
            NSInteger closeIndex = [fields indexOfObject:@"close_px"];
            NSInteger businessAmountIndex = [fields indexOfObject:@"business_amount"];
            NSInteger businessBalanceIndex = [fields indexOfObject:@"business_balance"];
            NSArray* kLineItems = [candleInfo valueForKey:@"300264.SZ"];
            NSMutableArray* dataModels = [NSMutableArray array];
            for (NSArray* kLineItem in kLineItems){
                KLineDataModel* data = [[KLineDataModel alloc] init];
                data.open = kLineItem[openIndex];
                data.close = kLineItem[closeIndex];
                data.high = kLineItem[highIndex];
                data.low = kLineItem[lowIndex];
                NSNumber* businessBalance = kLineItem[businessBalanceIndex];
                NSNumber* businessAmount = kLineItem[businessAmountIndex];
                data.volume = [NSString stringWithFormat:@"%.2f",businessAmount.floatValue];
                data.price = [NSString stringWithFormat:@"%.2f",([businessBalance floatValue] / [businessAmount floatValue])];
                NSString* dateString = [NSString stringWithFormat:@"%@", kLineItem[minTimeIndex]];
                data.date = [dateFormat dateFromString:dateString];
                
                [dataModels addObject:data];
            }
            if (block){
                block(YES, dataModels);
            }
        }else {
            if (block) {
                block(NO,response.errorMsg);
            }
        }
        
    } fail:^(NSError *error) {
        if (block) {
            block(NO,error.localizedDescription);
        }
    }];
}


@end
