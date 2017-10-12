//
//  JDWXViewController.m
//  MyWeather
//
//  Created by ljie on 2017/8/7.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "JDWXViewController.h"
#import "JJRefreshTabView.h"
#import "JDWeatherViewModel.h"
#import "MyCityTableViewController.h"
#import "LeftView.h"
#import "WeatherHeaderView.h"
#import "WeatherHoursCell.h"
#import "Forecast7dCell.h"
#import "WeatherIndexCell.h"
#import "WeatherFooter.h"
#import <CoreLocation/CoreLocation.h>

@interface JDWXViewController ()<UITableViewDelegate, UITableViewDataSource, MyCityDelegate, LeftDelegate, RefreshTableViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate> {
    LeftView *_left;
    UIVisualEffectView *_eBgView;
    JDWeatherViewModel *_jdViewModel;
    BOOL _hasData;
}

@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet JJRefreshTabView *jdTable;
@property (nonatomic, strong) NSMutableArray *cityArr;
@property (nonatomic, strong) NSString *cityNameStr;//当前城市

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *localCity;//定位到的城市

@end

@implementation JDWXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    [self.jdTable addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self startLocation];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setResetBtnWithShow:self.cityNameStr == nil ? YES : NO];
}

- (NSMutableArray *)cityArr {
    if (_cityArr == nil) {
        _cityArr = [[NSMutableArray alloc] init];
    }
    return _cityArr;
}

#pragma mark - data
- (void)initViewModelBinding {
    _jdViewModel = [[JDWeatherViewModel alloc] init];
    [self loadWeatherData];
}

- (void)loadWeatherData {
    [self showWaiting];
    @weakSelf(self);
    [_jdViewModel getJDWeatherWithCity:self.cityNameStr success:^(BOOL result) {
        [weakSelf hideWaiting];
        if (result) {
            _hasData = YES;
            [weakSelf setHeaderAndFooter];
            [weakSelf getDateStr];
            [weakSelf setResetBtnWithShow:NO];
        } else {
            _hasData = NO;
//            [weakSelf showMassage:_jdViewModel.status];
            [weakSelf setResetBtnWithShow:YES];
        }
        [weakSelf setNavTitle];
        [weakSelf.jdTable reloadData];
        
    } failure:^(NSError *error) {
        [weakSelf hideWaiting];
        _hasData = NO;
        [weakSelf showMassage:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        [self setNodataViewWithShow:YES];
    }];
}

//获取当前城市
//选择过的数据中的第一个或者定位到的城市
- (void)getCurrentCityWithName:(NSString *)name {
    name = [name stringByReplacingOccurrencesOfString:@"市" withString:@""];
    //第一次VC出现
    /*
     先判断本地数组是否有值，有的话显示第一个，没有的话显示定位
    */
    if (name) {
        self.cityNameStr = name;
    } else {
        [self startLocation];
    }
}

//显示周几
- (void)getDateStr {
    //2017-08-02 周三
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd EEE";
    formatter.locale = [NSLocale currentLocale];
    NSDate *date = [NSDate new];
    
    NSString *timeStr = [formatter stringFromDate:date];
    self.dateLab.text = timeStr;
}

#pragma mark - 事件

//添加左视图
- (void)showLeftVC {
    [self setLeftView];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _left.cityList = [defaults objectForKey:@"City"];
    [CurrentKeyWindow addSubview:_left];
    [_left appearLeftviewWithAnimation];
    [_left.leftTable reloadData];
}

#pragma mark - leftview
//初始化左侧视图
- (void)setLeftView {
    if (_left == nil) {
        _left = [[NSBundle mainBundle] loadNibNamed:@"LeftView" owner:nil options:nil].firstObject;
//        _left.frame = ScreenBounds;//初始化给了frame，第一次显示的时候没有动画，第二次之后才会有
        _left.delegate = self;
    }
}

//显示城市选择VC
- (void)showCityVC {
    MyCityTableViewController *cityVC = [[MyCityTableViewController alloc] init];
    cityVC.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cityVC];
    [self presentViewController:nav animated:YES completion:nil];
}

//隐藏左视图
//0 点击cell
//1 点击空白
//2 点击添加按钮
- (void)dismissCityViewWithType:(NSInteger)type name:(NSString *)name {
    if (type == 0) {
        //选中的城市传给首页显示 并根据此城市刷新数据
        self.cityNameStr = name;
//        _jdViewModel.cityName = name;
        [self setNavTitle];
        [self getCurrentCityWithName:name];
        [self loadWeatherData];
    } else if (type == 1) {
        //删除了城市后或直接点击空白 根据当前城市重新加载数据
        if (_left.cityList.count) {
            [self getCurrentCityWithName:_left.cityList[0]];
        } else {
            [self startLocation];
        }
        [self loadWeatherData];
        
    } else {
        //点击添加按钮
        //会走viewWillAppear方法，调用getCurrentCity，所以这里不必调用此方法
//        [self getCurrentCity];
    }
    self.cityArr = _left.cityList;//修改了left的列表，及时更新VC的数组
}

#pragma mark - UI
- (void)initUIView {
    [self setThemeImgWithPicture:@"weatherBg"];
    
    [self setBackButton:YES];
    //table相关
    self.jdTable.refreshDelegate = self;
    self.jdTable.CanRefresh = YES;
    self.jdTable.lastUpdateKey = NSStringFromClass([self class]);
    self.jdTable.isShowMore = NO;
    
    //毛玻璃背景图
    _eBgView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    _eBgView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    _eBgView.alpha = 0.8;
//    [self.view addSubview:_eBgView];
//    [self.view insertSubview:_eBgView belowSubview:self.dateLab];
    
    //左滑手势
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showLeftVC)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    swipe.delegate = self;
//    [swipe ]
    [self.view addGestureRecognizer:swipe];
    
    //设置导航栏和title
    [self setNav];
}

//导航栏按钮
- (void)setNav {
    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showBtn.frame = CGRectMake(0, 0, 30, 30);
    [showBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [showBtn addTarget:self action:@selector(showLeftVC) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark - 2.7.5
//    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    addBtn.frame = CGRectMake(0, 0, 30, 30);
//    [addBtn setImage:[UIImage imageNamed:@"bell"] forState:UIControlStateNormal];
//    [addBtn addTarget:self action:@selector(showRemindVC) forControlEvents:UIControlEventTouchUpInside];
    
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:showBtn];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:showBtn];
    [self addNavigationWithTitle:NSLocalizedString(@"nodata", nil) leftItem:nil rightItem:rightItem titleView:nil];
}

//头视图
- (void)setHeaderAndFooter {
    WeatherHeaderView *headerview = [[NSBundle mainBundle] loadNibNamed:@"WeatherHeaderView" owner:nil options:nil].firstObject;
    headerview.frame = CGRectMake(0, 0, Screen_Width, 260);
    [headerview setDataWithModel:_jdViewModel.now];
    self.jdTable.tableHeaderView = headerview;
}

- (void)setNodataViewWithShow:(BOOL)isShow {
    [self.jdTable setDefaultHeaderViewIsShow:isShow withTitle:nil];
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
        [self.jdTable addSubview:resetBtn];
    } else {
        for (UIButton *button in self.jdTable.subviews) {
            if (button.tag == 100) {
                [button removeFromSuperview];
            }
        }
    }
}

//重新设置title
- (void)setNavTitle {
    self.navigationItem.title = self.cityNameStr == nil ? NSLocalizedString(@"nodata", nil) : self.cityNameStr;
}

#pragma mark - 刷新
- (void)refreshTableViewHeader {
    [self loadWeatherData];
}

#pragma mark - City
//选择VC中选中的城市，传过来
- (void)cityPickerController:(MyCityTableViewController *)chooseCityController didSelectCity:(MyCity *)city {
    
    NSMutableArray *newCityArr = [NSMutableArray arrayWithArray:self.cityArr];
    NSString *cityName = [LJUtil currentLanguageWithMyChooseCity:city];
    //定位的城市 shortName带有“市”字
    cityName = [cityName stringByReplacingOccurrencesOfString:@"市" withString:@""];
    
    if (newCityArr.count) {
        //本来有北京、天津。又选了一次天津。天津和天津相同，先将天津移除掉，将新选中的天津插入到第一个的位置，以免重复
        
        //选择的城市，数组中存在
        //遍历数组，将相同的元素移除，并将选中的插入第一个
        //选择的城市，数组中不存在
        //将选中的城市插入第一个
        //如果有定位城市，则将选中的插入到第二个，定位的永远在第一个。否则就插入到第一个位置
        NSInteger index = self.localCity == nil ? 0 : 1;
        if ([self.cityArr containsObject:cityName]) {
            //选择的城市，数组中存在
            //遍历数组，将相同的元素移除，并将选中的插入第一个
            for (NSString *myCity in self.cityArr) {
                if ([city.shortName isEqualToString:myCity]) {
                    [newCityArr removeObject:myCity];
                    [newCityArr insertObject:cityName atIndex:index];
                    break;
                }
            }
        } else {
            //选择的城市，数组中不存在
            //将选中的城市插入第一个
            [newCityArr insertObject:cityName atIndex:index];
            
        }
    } else {//数组没元素时直接添加
        [newCityArr addObject:cityName];
    }
    
    [self getCurrentCityWithName:cityName];
    [self loadWeatherData];
    
    //重新保存修改后的数组
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:newCityArr forKey:@"City"];
    
    
    [chooseCityController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cityPickerControllerDidCancel:(MyCityTableViewController *)chooseCityController {
    [chooseCityController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_hasData) {
        if (section == 0) {//7日预报
            return _jdViewModel.dailyArr.count+1;
        } else {//天气指数
            return [_jdViewModel.sugMutDic allKeys].count;
        }
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (_jdViewModel.hoursArr.count) {
                return 100;
            }
            return CGFLOAT_MIN;
        } else {
            if (_jdViewModel.dailyArr.count) {
                return 80;
            }
            return CGFLOAT_MIN;
        }
    } else {
        if (_jdViewModel.sugMutArr.count) {
            JDIndex *index = _jdViewModel.sugMutArr[indexPath.row];
            return [WeatherIndexCell boundingRectWithText:index.txt maxSize:CGSizeMake(Screen_Width-30, CGFLOAT_MAX) font:[UIFont systemFontOfSize:15]].height+48;
        } else {
            return CGFLOAT_MIN;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_jdViewModel.dailyArr) {
        return 40;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_jdViewModel.dailyArr.count) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 20)];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = MyGrayColor;
        if (section == 0) {
            label.text = NSLocalizedString(@"forecast7d", nil);
        } else {
            label.text = NSLocalizedString(@"weatherIndex", nil);
        }
        
        return label;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//小时预报
            if (_jdViewModel.hoursArr.count) {
                WeatherHoursCell *cell = [WeatherHoursCell myCellWithTableview:tableView withHourArr:_jdViewModel.hoursArr];
                [cell.hoursCollectionview reloadData];
                return cell;
            } else {
                return [[WeatherHoursCell alloc] init];
            }
        } else {//7日预报
            Forecast7dCell *cell = [Forecast7dCell myCellWithTableview:tableView];
            if (!_jdViewModel.dailyArr.count) {
                [cell setDataWithModel:nil withIndex:indexPath.row];
            } else {
                [cell setDataWithModel:_jdViewModel.dailyArr[indexPath.row-1] withIndex:indexPath.row];
            }
            
            return cell;
        }
    } else {//天气指数
        WeatherIndexCell *cell = [WeatherIndexCell myCellWithTableview:tableView];
        
        if ([_jdViewModel.sugMutDic allKeys].count && _jdViewModel.sugMutArr.count) {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[_jdViewModel.sugMutDic allValues]];
            [cell setDataForCellWithModel:_jdViewModel.sugMutArr[indexPath.row] title:arr[indexPath.row]];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [cell.layer addAnimation:scaleAnimation forKey:@"transform"];
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint point = [change[NSKeyValueChangeNewKey] CGPointValue];
        
        if (point.y > 20) {//20是随便设置的- 。-
            [UIView animateWithDuration:0.5 animations:^{
//                _eBgView.alpha = 0.8;
            }];
        } else {
            [UIView animateWithDuration:0.5 animations:^{
//                _eBgView.alpha = 0;
            }];
        }
    }
}

#pragma mark - 定位
//开始定位
- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled]){
//        CLog(@"--------开始定位");
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self; //控制定位精度,越高耗电量越
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer; // 总是授权
        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.distanceFilter = 10.0f;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
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
            self.cityNameStr = placemark.locality;
            self.cityNameStr = [self.cityNameStr stringByReplacingOccurrencesOfString:@"市" withString:@""];
            
            if (!self.cityNameStr) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                self.cityNameStr = placemark.administrativeArea;
            }
            NSLog(@"city定位城市 %@", self.cityNameStr);
            self.localCity = self.cityNameStr;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSArray *localArr = [defaults objectForKey:@"City"];
            NSMutableArray *newCityArr = [NSMutableArray arrayWithArray:localArr];
            if (newCityArr.count) {
                //如果有定位城市，则将选中的插入到第二个，定位的永远在第一个。否则就插入到第一个位置
                
                if ([localArr containsObject:self.cityNameStr]) {
                    //选择的城市，数组中存在
                    //遍历数组，将相同的元素移除，并将选中的插入第一个
                    for (NSString *myCity in localArr) {
                        if ([self.cityNameStr isEqualToString:myCity]) {
                            [newCityArr removeObject:myCity];
                                [newCityArr insertObject:myCity atIndex:0];
                            break;
                        } else {
                            [newCityArr insertObject:myCity atIndex:0];
                        }
                    }
                } else {
                    //选择的城市，数组中不存在
                    //将选中的城市插入第一个
                    [newCityArr insertObject:self.cityNameStr atIndex:0];
                    
                }
            } else {//数组没元素时直接添加
                [newCityArr addObject:self.cityNameStr];
            }
            self.cityArr = newCityArr;

            [self loadWeatherData];
            
            //重新保存修改后的数组
            [defaults setObject:self.cityArr forKey:@"City"];
            
            [self getCurrentCityWithName:self.cityNameStr];
            
        } else if (error == nil && [array count] == 0) {
            NSLog(@"No results were returned.");
        } else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

#pragma mark - dealloc
- (void)dealloc {
    [self.jdTable removeObserver:self forKeyPath:@"contentOffset"];
    [_jdViewModel cancelAllHTTPRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
