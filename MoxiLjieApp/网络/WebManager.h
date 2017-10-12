//
//  WebManager.h
//  MyWeather
//
//  Created by lijie on 2017/7/27.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

//请求成功回调block
typedef void (^requestSuccessBlock)(NSDictionary *dic);

//请求失败回调block
typedef void (^requestFailureBlock)(NSError *error);

//请求方法define
typedef enum {
    GET,
    POST,
    PUT,
    DELETE,
    HEAD
} HTTPMethod;


@interface WebManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

- (void)requestWithMethod:(HTTPMethod)method
                 WithPath:(NSString *)path
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(requestSuccessBlock)success
          WithFailureBlock:(requestFailureBlock)failure;

@end
