//
//  LNResponse.h
//  News
//
//  Created by vvusu on 3/29/16.
//  Copyright © 2016 wallstreetcn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNResponse : NSObject
@property (strong, nonatomic) id resultModel;
@property (assign, nonatomic) BOOL isSucceed;
@property (copy, nonatomic) NSString *errorCode;
@property (copy, nonatomic) NSString *errorMsg;
@property (strong, nonatomic) NSData *resultData;
@property (strong, nonatomic) NSDictionary *resultDic;

@end
