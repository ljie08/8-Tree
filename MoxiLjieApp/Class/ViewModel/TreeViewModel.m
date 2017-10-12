//
//  TreeViewModel.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/9/21.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "TreeViewModel.h"

@implementation TreeViewModel

- (instancetype)init {
    if (self = [super init]) {
        _normal = [[Normal alloc] init];
    }
    return self;
}

//获取树苗相关数据
- (void)getTreeDataWithSuccess:(void (^)(BOOL result))success failure:(void (^)(NSString *errorString))failure {
    NSString *file = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [file stringByAppendingPathComponent:@"tree.data"];
    self.normal = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (self.normal == nil) {
        self.normal = [[Normal alloc] init];
    }
    success(YES);
}

//保存树苗相关数据
- (void)saveTreeDataWithSuccess:(void (^)(BOOL result))success failure:(void (^)(NSString *errorString))failure {
    NSString *file = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [file stringByAppendingPathComponent:@"tree.data"];
    
    //将添加了model的数组归档 存到本地
    [NSKeyedArchiver archiveRootObject:self.normal toFile:path];
    success(YES);
}


@end
