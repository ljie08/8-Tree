//
//  StepViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/9/18.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "StepViewController.h"
#import "StepChartCell.h"
#import "ConversionViewController.h"
#import "StepHeaderCell.h"
#import "HealthManager.h"
#import "TreeViewModel.h"

#import "JDWXViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "JDWeatherViewModel.h"
#import "StepWeatherCell.h"

@interface StepViewController ()<UITableViewDelegate, UITableViewDataSource, StepDelegate, CLLocationManagerDelegate, StepWeatherDelegate>

@property (weak, nonatomic) IBOutlet UITableView *stepTable;
@property (nonatomic, assign) int stepNum;//更新前的总步数
@property (nonatomic, assign) int currentStep;//更新后的总步数

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *localCity;//定位到的城市
@property (nonatomic, strong) JDWeatherViewModel *jdViewModel;
@property (nonatomic, assign) BOOL isAllowLocation;
@property (nonatomic, strong) NSString *hintStr;

@property (nonatomic, strong) TreeViewModel *viewmodel;

@end

@implementation StepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self startLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self startLocation];
}

#pragma mark - model
- (void)initViewModelBinding {
    self.viewmodel = [[TreeViewModel alloc] init];
    self.jdViewModel = [[JDWeatherViewModel alloc] init];
    [self getTreeData];
//    [self loadWeatherData];
}

- (void)getTreeData {
    @weakSelf(self);
    [self.viewmodel getTreeDataWithSuccess:^(BOOL result) {
        
    } failure:^(NSString *errorString) {
        [weakSelf showMassage:errorString];
    }];
}


#pragma mark - weather data
- (void)loadWeatherData {
    [self showWaiting];
    @weakSelf(self);
    [_jdViewModel getJDWeatherWithCity:self.localCity success:^(BOOL result) {
        [weakSelf hideWaiting];
        if (!result) {
            [weakSelf showMassage:_jdViewModel.status];
            [weakSelf setResetBtnWithShow:YES];
        }
        [weakSelf.stepTable reloadData];
        
    } failure:^(NSError *error) {
        [weakSelf hideWaiting];
        [weakSelf showMassage:[NSString stringWithFormat:@"%@", error.localizedDescription]];
    }];
}

//重新定位按钮
- (void)setResetBtnWithShow:(BOOL)isShow {
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetBtn setTitle:NSLocalizedString(@"reset", nil) forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(startLocation) forControlEvents:UIControlEventTouchUpInside];
    resetBtn.tag = 100;
    resetBtn.frame = CGRectMake(0, 50, Screen_Width, 100);
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [resetBtn setTitleColor:MyGrayColor forState:UIControlStateNormal];
    if (isShow) {
        [self.stepTable addSubview:resetBtn];
    } else {
        for (UIButton *button in self.stepTable.subviews) {
            if (button.tag == 100) {
                [button removeFromSuperview];
            }
        }
    }
}

#pragma mark - 事件
- (void)gotoConversionVC {
    ConversionViewController *conversion = [[ConversionViewController alloc] init];
    [self.navigationController pushViewController:conversion animated:YES];
}

- (void)goBack {
    @weakSelf(self);
    [self.viewmodel saveTreeDataWithSuccess:^(BOOL result) {
        [super goBack];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithInt:weakSelf.stepNum] forKey:@"oldnum"];
        
    } failure:^(NSString *errorString) {
        [weakSelf showMassage:errorString];
    }];
}

#pragma maek - step weather delegate
- (void)lookWeather {
    JDWXViewController *jdVc = [[JDWXViewController alloc] init];
    [self.navigationController pushViewController:jdVc animated:NO];
}

#pragma mark - StepCell delegate
- (void)getStepData {
    HealthManager *manager = [HealthManager shareInstance];
    [manager getStepCount:^(double value, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showMassage:NSLocalizedString(@"更新成功", nil)];
            NSString *tempStr = [NSString stringWithFormat:@"%.0f", value];
            //                    self.stepNum = self.currentStep;
            self.currentStep = [tempStr intValue];
            [self.stepTable reloadData];
            if (self.currentStep) {
                //                        [self btnCanClicked:YES];
            }
            
            self.viewmodel.normal.step = self.currentStep;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"step"]];
            if (dic == nil) {
                dic = [NSMutableDictionary dictionary];
            }
            
            NSString *today = [LJUtil getZeroWithTimeInterverl];
            NSString *stepValue = [NSString stringWithFormat:@"%.0f", value];
            
            [dic setObject:stepValue forKey:today];
            [defaults setObject:dic forKey:@"step"];
        });
    }];
}

- (void)updateCurrentStep {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *healthStr = [defaults objectForKey:@"isAllow"];
    //允许获取健康数据
    if ([healthStr isEqualToString:@"yes"]) {
        NSLog(@"success");
        [self getStepData];
    } else if ([healthStr isEqualToString:@"no"]) {
        //不允许获取健康数据
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *str = [defaults objectForKey:@"isSet"];
        if ([str isEqualToString:@"no"]) {
            //再次设置后还是不允许获取
            [self showAlert];
        } else {
            //再次设置过允许获取
            [self getStepData];
        }
    } else {
        [self showMassage:healthStr];
        NSLog(@"error ->->-> %@", healthStr);
    }
}

- (void)showAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"您已禁止该软件获取健康数据，是否要允许获取健康数据", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureaction = [UIAlertAction actionWithTitle:NSLocalizedString(@"允许", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        HealthManager *manager = [HealthManager shareInstance];
        [manager authorizeHealthKit:^(BOOL success, NSError *error) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"yes" forKey:@"isSet"];
            if (success) {
//                [defaults setObject:@"yes" forKey:@"isAllow"];
                [self getStepData];
            } else {
//                [defaults setObject:error.localizedDescription forKey:@"isAllow"];
                [self showMassage:error.localizedDescription];
            }
        }];
    }];
    UIAlertAction *cancleaction = [UIAlertAction actionWithTitle:@"不允许" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:@"no" forKey:@"isAllow"];
        [self showMassage:NSLocalizedString(@"您已禁止该软件获取健康数据", nil)];
    }];
    
    [alert addAction:sureaction];
    [alert addAction:cancleaction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)getWaterOrManureWithTitle:(NSString *)title currentBtn:(UIButton *)button {
    if (self.currentStep-self.stepNum) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"确定要领么", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *sureaction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.stepNum = self.currentStep;
//            [self btnCanClicked:NO];
            if (button.tag == 100) {
                self.viewmodel.normal.water += self.currentStep/10;
                [self showMassage:NSLocalizedString(@"您已成功领取水", nil)];
            } else {
                self.viewmodel.normal.manure += self.currentStep/20;
                [self showMassage:NSLocalizedString(@"您已成功领取肥料", nil)];
            }
        }];
        [alert addAction:cancelaction];
        [alert addAction:sureaction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self showMassage:NSLocalizedString(@"没有足够的步数可兑换,尝试走路或更新步数吧", nil)];
    }
    
}

//按钮是否可点击
- (void)btnCanClicked:(BOOL)canClicked {
    UIButton *but1 = [self.view viewWithTag:100];
    but1.enabled = canClicked;
    UIButton *but2 = [self.view viewWithTag:200];
    but2.enabled = canClicked;
}

#pragma mark - table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (_jdViewModel.sugMutArr.count || self.isAllowLocation) {
            JDIndex *index = self.jdViewModel.sugMutArr[2];
            return [StepWeatherCell cellHeightWithString:index.txt];
        } else {
            return 180;
        }
    }
    return 190;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        StepWeatherCell *cell = [StepWeatherCell myCellWithTableview:tableView];
        cell.delegate = self;
        if (self.jdViewModel.sugMutArr.count || self.isAllowLocation) {
            [cell setDataWithNowModel:self.jdViewModel.now indexModel:self.jdViewModel.sugMutArr[2] city:self.localCity];
        } else {
            [cell setNodataWithHint:self.hintStr];
        }
        
        return cell;
    } else if (indexPath.section == 1) {
        StepChartCell *cell = [StepChartCell myCellWithTableview:tableView];
        return cell;
    } else {
        StepHeaderCell *cell = [StepHeaderCell myCellWithTableview:tableView];
        cell.delegate = self;
        [cell setDataWithStep:[NSString stringWithFormat:@"%@ %d %@", NSLocalizedString(@"今日已走", nil), self.currentStep, NSLocalizedString(@"步", nil)]];
        return cell;
    }
}

#pragma mark - 定位
//开始定位
- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled]){
        
        self.locationManager = [[CLLocationManager alloc] init] ;
        self.locationManager.delegate = self;
        //设置定位精度
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;//每隔多少米定位一次（这里的设置为每隔百米)
        if (IOS8_OR_LATER) {
            //使用应用程序期间允许访问位置数据
            [self.locationManager requestWhenInUseAuthorization];
        }
        // 开始定位
        [self.locationManager startUpdatingLocation];
    } else {
        self.hintStr = @"定位失败,请打开您的定位服务";
        [self.stepTable reloadData];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    self.isAllowLocation = NO;
    if ([error code] == kCLErrorDenied) {
        self.hintStr = @"用户无法访问位置";
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        self.hintStr = @"无法获取位置信息";
        NSLog(@"无法获取位置信息");
    }
    [self showMassage:self.hintStr];
    [self.stepTable reloadData];
}
//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *newLocation = locations[0];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            //获取城市
            self.localCity = placemark.locality;
            self.localCity = [self.localCity stringByReplacingOccurrencesOfString:@"市" withString:@""];
            
            if (!self.localCity) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                self.localCity = placemark.administrativeArea;
            }
            NSLog(@"city定位城市 %@", self.localCity);
            
            [self loadWeatherData];
            
        } else if (error == nil && [array count] == 0) {
            self.hintStr = @"获取结果失败";
            [self.stepTable reloadData];
            NSLog(@"No results were returned.");
        } else if (error != nil) {
            self.hintStr = @"获取结果失败";
            [self.stepTable reloadData];
            NSLog(@"An error occurred = %@", error);
        }
    }];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

//定位服务状态改变时调用/
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager requestAlwaysAuthorization];
            }
            NSLog(@"用户还未决定授权");
            break;
        }
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"访问受限");
            break;
        }
        case kCLAuthorizationStatusDenied:
        {
            // 类方法，判断是否开启定位服务
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"定位服务开启，被拒绝");
            } else {
                NSLog(@"定位服务关闭，不可用");
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            NSLog(@"获得前后台授权");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"获得前台授权");
            break;
        }
        default:
            break;
    }
}

#pragma mark - ui
- (void)initUIView {
    [self setBackButton:YES];
    
    self.navigationItem.title = NSLocalizedString(@"近一周行走记录", nil);
//    [self setNav];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.stepNum = [[defaults objectForKey:@"oldnum"] intValue];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"step"]];
    if (dic == nil) {
        dic = [NSMutableDictionary dictionary];
        self.currentStep = 0;
    } else {
        NSString *today = [LJUtil getZeroWithTimeInterverl];
        self.currentStep = [[dic objectForKey:today] intValue];
    }
    
}

- (void)setNav {
    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showBtn.frame = CGRectMake(0, 0, 70, 25);
    [showBtn setTitle:@"兑换记录" forState:UIControlStateNormal];
    [showBtn setTitleColor:MyGrayColor forState:UIControlStateNormal];
    [showBtn setTitleColor:MyGrayColor forState:UIControlStateSelected];
    showBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [showBtn addTarget:self action:@selector(gotoConversionVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:showBtn];
    [self addNavigationWithTitle:nil leftItem:nil rightItem:rightItem titleView:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
