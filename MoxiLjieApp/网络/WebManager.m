
//
//  WebManager.m
//  MyWeather
//
//  Created by lijie on 2017/7/27.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "WebManager.h"

@implementation WebManager

+ (instancetype)sharedManager {
    static WebManager *manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://httpbin.org/"]];
    });
    return manager;
}

-(instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        // 请求超时设定
        self.requestSerializer.timeoutInterval = 5;
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    return self;
}

#pragma mark - request
- (void)requestWithMethod:(HTTPMethod)method
                 WithPath:(NSString *)path
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(requestSuccessBlock)success
          WithFailureBlock:(requestFailureBlock)failure {
    
    //YYWeather - @"http://api.yytianqi.com/接口名称?city=城市ID&key=用户key"
    //京东万象 - https://way.jd.com/he/freeweather?city=beijing&appkey=您申请的APPKEY
    NSString *url = [NSString stringWithFormat:@"%@", JDWX_PATH];
//    url = [NSString stringWithFormat:@"https://way.jd.com/he/freeweather?city=北京&appkey=7f9cb53ad13c812343786abe35a34a3e"];
    
//    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"url --> %@", url);
    
    switch (method) {
        case GET:{
            [self GET:url parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
                NSLog(@"JSON: %@ \n params = %@", responseObject,params);
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
                failure(error);
            }];
            break;
        }
        case POST:{
            [self POST:url parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
                NSLog(@"JSON: %@", responseObject);
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
                failure(error);
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - url
- (void)getMessagesSuccess:(void(^)(NSArray *messageArr))success failure:(void(^)(NSString *errorStr))failure {
    
}

@end
