//
//  TreeViewModel.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/9/21.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeViewModel : NSObject

@property (nonatomic, strong) Normal *normal;

//获取树苗相关数据
- (void)getTreeDataWithSuccess:(void (^)(BOOL result))success failure:(void (^)(NSString *errorString))failure;

//保存树苗相关数据
- (void)saveTreeDataWithSuccess:(void (^)(BOOL result))success failure:(void (^)(NSString *errorString))failure;

@end
