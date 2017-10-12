//
//  KULocationManager.h
//  kkfarmuser
//
//  Created by Shendou on 2017/5/18.
//  Copyright © 2017年 Shendou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KULocationManagerStatus) {
	KULocationManagerStatusUnable  = 0,
	KULocationManagerStatusHaveNotDecide = 1,
	KULocationManagerStatusAgree = 2,
	KULocationManagerStatusDeny = 3
};

@interface KULocationManager : NSObject

@property(nonatomic,assign)KULocationManagerStatus locationStatus;
@property(nonatomic,copy)NSString * address;
@property(copy,nonatomic)void (^callBack)(NSError * error,float lat,float lon,NSString *address);
+ (KULocationManager *)sharedInstance;
- (BOOL)isLocationEnable;

- (void)startLocation;
- (void)startLocationWithCallback:(void(^)(NSError * error,float lat,float lon,NSString *address))callback;

@end
