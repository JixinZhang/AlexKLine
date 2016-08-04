//
//  ViewController.m
//  AlexKLine
//
//  Created by ZhangBob on 4/15/16.
//  Copyright © 2016 JixinZhang. All rights reserved.
//

#import "ViewController.h"
#import "AKLineView.h"
#import "LNRequest.h"
#import "LNNetWorking.h"
#import "KLineDataModel.h"
#import "QuoteView.h"
#import "RoundedRectView.h"
#import "AlexQuoteListCellModel.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenheight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic, strong) AKLineView *kLineView;
@property (nonatomic, strong) QuoteView *quoteView;
@property (nonatomic, strong) RoundedRectView *roundedRect;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor blackColor];
//    __weak typeof (self)weakSelf = self;
//    [self requestTrend:nil block:^(NSArray *dataArray) {
//        weakSelf.kLineView = [[AKLineView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 450)];
//        weakSelf.kLineView.backgroundColor = [UIColor grayColor];
//        weakSelf.kLineView.xAxisWidth = [UIScreen mainScreen].bounds.size.width - 10;
//        weakSelf.kLineView.yAxisHeightOfKLine = 100;
//        weakSelf.kLineView.yAxisHeightOfVolume = 70;
//        weakSelf.kLineView.dataArr = dataArray;
//        weakSelf.kLineView.backgroundColor = [UIColor whiteColor];
//        [weakSelf.view addSubview:weakSelf.kLineView];
//    }];
    
    self.quoteView = [[QuoteView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenheight)];
    [self.view addSubview:self.quoteView];
    
//    self.roundedRect = [[RoundedRectView alloc] initWithFrame:CGRectMake(150, 450, 38, 25)];
//    self.roundedRect.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:self.roundedRect];
    
    [self testRequst];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)requestTrend:(NSString *)string block:(void(^)(NSArray*))block {
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

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
  
}

- (void)testRequst {
    NSString *urlStr = [NSString stringWithFormat:@"http://mdc.wallstreetcn.com/sort?data_count=10&sort_type=1&start_pos=0&fields=prod_name,last_px,trade_status,px_change,px_change_rate"];
    LNRequest * request = [[LNRequest alloc] init];
    request.url = urlStr;
    [LNNetWorking getWithRequest:request success:^(LNResponse *response) {
        NSDictionary *data = [response.resultDic valueForKey:@"data"];
        NSDictionary *sort = [data valueForKey:@"sort"];
        NSArray *fields = [sort valueForKey:@"fields"];
        NSUInteger prodNameIndex = [fields indexOfObject:@"prod_name"];
        NSUInteger lastPxIndex = [fields indexOfObject:@"last_px"];
        NSUInteger tradeStatusIndex = [fields indexOfObject:@"trade_status"];
        NSUInteger pxChangeIndex = [fields indexOfObject:@"px_change"];
        NSUInteger pxChangeRateIndex = [fields indexOfObject:@"px_change_rate"];
        
        NSArray *allKeys = [sort allKeys];
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSInteger i = 0; i< allKeys.count; i++) {
            NSString *key = allKeys[i];
            if ([key isEqualToString:@"fields"]) {
                continue;
            }
            AlexQuoteListCellModel *cellModel = [[AlexQuoteListCellModel alloc] init];
            cellModel.prodCode = key;
            cellModel.prodName = [(NSArray *)[sort valueForKey:key] objectAtIndex:prodNameIndex];
            cellModel.lastPrice = [(NSArray *)[sort valueForKey:key] objectAtIndex:lastPxIndex];
            cellModel.tradeStatus = [(NSArray *)[sort valueForKey:key] objectAtIndex:tradeStatusIndex];
            cellModel.priceChange = [(NSArray *)[sort valueForKey:key] objectAtIndex:pxChangeIndex];
            cellModel.priceChangeRate = [(NSArray *)[sort valueForKey:key] objectAtIndex:pxChangeRateIndex];
            [array addObject:cellModel];
            
        }
        NSLog(@"%@",array);
        //ascending=YES,升序排列；ascending=NO，降序排列
        NSSortDescriptor *priceChangeRateDesc = [NSSortDescriptor sortDescriptorWithKey:@"priceChangeRate" ascending:NO];
        NSArray *descriptorArray = [NSArray arrayWithObjects:priceChangeRateDesc, nil];
        NSArray *sortedArray = [array sortedArrayUsingDescriptors:descriptorArray];
        for (NSInteger i = 0; i < sortedArray.count; i++) {
            AlexQuoteListCellModel *cellModel = (AlexQuoteListCellModel*)sortedArray[i];
            NSLog(@"%@,涨跌额＝%@",cellModel.prodName,cellModel.priceChangeRate);
        }
    } fail:^(NSError *error) {
        NSLog(@"request K line Data fail");
    }];
}
@end
