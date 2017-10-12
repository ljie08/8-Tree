//
//  KULocationManager.m
//  kkfarmuser
//
//  Created by Shendou on 2017/5/18.
//  Copyright © 2017年 Shendou. All rights reserved.
//

#import "KULocationManager.h"
#import <UIKit/UIKit.h>
#import <Corelocation/CoreLocation.h>
#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@interface KULocationManager()<CLLocationManagerDelegate>

@end

@implementation KULocationManager
{
	CLLocationManager * _locationMan;
	BOOL _locationFinish;
}

+ (KULocationManager *)sharedInstance
{
	static KULocationManager * _sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedInstance = [[KULocationManager alloc] init];
	});
	return _sharedInstance;
}

- (id)init
{
	self = [super init];
	if (self) {
		_locationMan = [[CLLocationManager alloc] init];
		_locationMan.delegate = self;
		_locationMan.distanceFilter = 200;
		_locationMan.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
		if (IOS8_OR_LATER)
			[_locationMan requestWhenInUseAuthorization];
	}
	return self;
}

- (void)startLocationWithCallback:(void(^)(NSError * error,float lat,float lon,NSString *address))callback
{
	self.callBack = callback;
	if(![self isLocationEnable]){
		self.callBack([NSError new],0.0,0.0,@"");
		self.callBack = nil;
		return;
	}
	self.callBack = callback;
	_locationFinish = NO;
	[_locationMan startUpdatingLocation];
}

- (void)startLocation
{
	if(![self isLocationEnable]){
		return;
	}
	_locationFinish = NO;
	[_locationMan startUpdatingLocation];
}

- (KULocationManagerStatus)locationStatus
{
	if([CLLocationManager locationServicesEnabled] == NO){
		return KULocationManagerStatusUnable;
	}
	if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
		return KULocationManagerStatusUnable;
	}
	if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
		return KULocationManagerStatusDeny;
	}
	if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
		return KULocationManagerStatusHaveNotDecide;
	}
	return KULocationManagerStatusAgree;
}

-(BOOL)isLocationEnable
{
	if([CLLocationManager locationServicesEnabled] == NO){
		NSLog(@"定位没打开");
		return NO;
	}
	if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
		NSLog(@"定位没打开");
		return NO;
	}
	if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
		NSLog(@"定位没打开");
		return NO;
	}
	NSLog(@"定位打开");
	return YES;
}

#pragma -mark CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	if (_locationFinish == YES) {
		return;
	}
	
	_locationFinish = YES;
	
	[_locationMan stopUpdatingLocation];
	
	// 获取当前所在的城市名
	CLGeocoder *geocoder = [[CLGeocoder alloc] init];
	//根据经纬度反向地理编译出地址信息
	WS(weakSelf);
	[geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
		if (array.count > 0)
		{
			NSLog(@"%f-%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
			
			CLPlacemark *place = [array firstObject];
			NSString * address = [NSString stringWithFormat:@"%@ ", place.locality];
//			NSString * address = [NSString stringWithFormat:@"%@ %@", place.locality,place.name];
			if (weakSelf.callBack) {
				weakSelf.callBack(nil,newLocation.coordinate.latitude,newLocation.coordinate.longitude,address);
				weakSelf.callBack = nil;
			}
			weakSelf.address = address;
			NSLog(@"%@->%@",[self class],address);
			
//			for (CLPlacemark *place in array) {
//				NSLog(@"name,%@",place.name);                       // 位置名
//				NSLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
//				NSLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
//				NSLog(@"locality,%@",place.locality);               // 市
//				NSLog(@"subLocality,%@",place.subLocality);         // 区
//				NSLog(@"country,%@",place.country);                 // 国家
//				
//			}
			
		}else if (error == nil && [array count] == 0){
			NSLog(@"No results were returned.");
		}
		else if (error != nil){
			NSLog(@"An error occurred = %@", error);
		}
	}];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
	switch (status) {
		case kCLAuthorizationStatusNotDetermined:{
			if ([_locationMan respondsToSelector:@selector(requestAlwaysAuthorization)])
			{
				[_locationMan requestAlwaysAuthorization];
			}
		}break;
		case kCLAuthorizationStatusDenied:{
			return;
		}break;break;
		default:{
			[self startLocation];
		}break;
	}
}

@end
