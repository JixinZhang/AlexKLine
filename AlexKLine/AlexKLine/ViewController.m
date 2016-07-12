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
@interface ViewController ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecogizer;
@property (nonatomic, strong) AKLineView *kLineView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self)weakSelf = self;
    [self requestTrend:nil block:^(NSArray *dataArray) {
        self.view.backgroundColor = [UIColor whiteColor];
        weakSelf.kLineView = [[AKLineView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        weakSelf.kLineView.xAxisWidth = [UIScreen mainScreen].bounds.size.width - 10;
        weakSelf.kLineView.yAxisHeightOfKLine = 100;
        weakSelf.kLineView.yAxisHeightOfVolume = 70;
        weakSelf.kLineView.dataArr = dataArray;
        weakSelf.kLineView.backgroundColor = [UIColor whiteColor];
        [weakSelf.view addSubview:weakSelf.kLineView];
        
//        weakSelf.panGestureRecogizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
//        [weakSelf.kLineView addGestureRecognizer:weakSelf.panGestureRecogizer];
    }];
    
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

//- (void)panGestureAction:(UIPanGestureRecognizer *)sender {
//    CGPoint point = [sender translationInView:self.kLineView];
//    sender.view.center = CGPointMake(sender.view.center.x + point.x, sender.view.center.y + point.y);
//    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
//}

@end
