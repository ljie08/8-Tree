//
//  ForestViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/9/18.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "ForestViewController.h"
#import "StepViewController.h"
#import <HealthKit/HealthKit.h>
#import "CloudsView.h"
#import "GonglueViewController.h"
#import "TreeViewController.h"
#import "TreeViewModel.h"
#import "HealthManager.h"

@interface ForestViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *sunView;//太阳
@property (nonatomic, strong) CloudsView *cloudsView;//云
@property (weak, nonatomic) IBOutlet UILabel *waterLab;//
@property (weak, nonatomic) IBOutlet UILabel *manureLab;//
@property (weak, nonatomic) IBOutlet UIButton *plantBtn;
@property (weak, nonatomic) IBOutlet UILabel *treeNumLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *treePadding;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *treeWidth;
@property (weak, nonatomic) IBOutlet UIImageView *tree;

@property (nonatomic, strong) TreeViewModel *viewmodel;

@end

@implementation ForestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sunAndCloudsWithAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger num = [[defaults objectForKey:@"num"] integerValue];
    if (!num) {
        [self checkIsAllow];
    }
    num++;
    [defaults setObject:[NSNumber numberWithInteger:num] forKey:@"num"];
    
//    [self checkIsAllow];
}

//判断是否有健康权限
- (void)checkIsAllow {
    HKHealthStore *store = [[HKHealthStore alloc] init];
    HKObjectType *type = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKAuthorizationStatus status = [store authorizationStatusForType:type];
    //没有获取健康权限
    if (status == HKAuthorizationStatusNotDetermined) {
        [self setAlert];
    }
}

- (void)setAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"是否允许获取健康权限", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureaction = [UIAlertAction actionWithTitle:NSLocalizedString(@"允许", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        HealthManager *manager = [HealthManager shareInstance];
        [manager authorizeHealthKit:^(BOOL success, NSError *error) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if (success) {
                //允许和设置都设为yes
                [defaults setObject:@"yes" forKey:@"isAllow"];
                [defaults setObject:@"yes" forKey:@"isSet"];
            } else {
                [defaults setObject:error.localizedDescription forKey:@"isAllow"];
            }
        }];
    }];
    UIAlertAction *cancleaction = [UIAlertAction actionWithTitle:@"不允许" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //允许和设置都设为yes
        [defaults setObject:@"no" forKey:@"isAllow"];
        [defaults setObject:@"no" forKey:@"isSet"];
    }];
    
    [alert addAction:sureaction];
    [alert addAction:cancleaction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//直接写在这里，再app进入后台运行的时候，再回来，不会走willApear这个方法，所以加个通知，当app进入后台后，再返回app时，调用这个动画
//如果在initUI里写的话，pop回来就没有动画了
- (void)viewWillAppear:(BOOL)animated {
    [self sunAndCloudsWithAnimation];
    
    [self getTreeData];
    
    if ((self.viewmodel.normal.water < 2000 && self.viewmodel.normal.water >= 0) || (self.viewmodel.normal.manure >= 0 && self.viewmodel.normal.manure < 1000)) {
        self.tree.image = [UIImage imageNamed:@"1"];
    } else if ((self.viewmodel.normal.water >=2000 && self.viewmodel.normal.water < 4000) || (self.viewmodel.normal.manure >= 1000 && self.viewmodel.normal.manure < 2000)) {
        self.tree.image = [UIImage imageNamed:@"2"];
    } else if ((self.viewmodel.normal.water >=4000 && self.viewmodel.normal.water < 6000) || (self.viewmodel.normal.manure >= 2000 && self.viewmodel.normal.manure < 3000)) {
        self.tree.image = [UIImage imageNamed:@"3"];
    } else if ((self.viewmodel.normal.water >=6000 && self.viewmodel.normal.water < 8000) || (self.viewmodel.normal.manure >= 3000 && self.viewmodel.normal.manure < 4000)) {
        self.tree.image = [UIImage imageNamed:@"4"];
    } else if ((self.viewmodel.normal.water >=8000 && self.viewmodel.normal.water <= 10000) || (self.viewmodel.normal.manure >= 4000 && self.viewmodel.normal.manure <= 5000))  {
        self.tree.image = [UIImage imageNamed:@"5"];
    } else {
        self.tree.image = [UIImage imageNamed:@""];
    }
}

#pragma mark - model
- (void)initViewModelBinding {
    self.viewmodel = [[TreeViewModel alloc] init];
}

- (void)setTreeData {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[defaults objectForKey:@"treeList"]];
    if (arr == nil) {
        arr = [NSMutableArray array];
    }
    NSString *today = [LJUtil getCurrentTimes];
    [arr addObject:today];
    
    [defaults setObject:arr forKey:@"treeList"];
    self.treeNumLab.text = [NSString stringWithFormat:@"×%ld", arr.count];
    self.viewmodel.normal.water -= 10000;
    self.viewmodel.normal.manure -= 5000;
    
    @weakSelf(self);
    [self.viewmodel saveTreeDataWithSuccess:^(BOOL result) {
        [weakSelf setData];
    } failure:^(NSString *errorString) {
        [weakSelf showMassage:errorString];
    }];
}

- (void)getTreeData {
    @weakSelf(self);
    [self.viewmodel getTreeDataWithSuccess:^(BOOL result) {
        [weakSelf setData];
        
    } failure:^(NSString *errorString) {
        [weakSelf showMassage:errorString];
    }];
}

- (void)setData {
    self.waterLab.text = [NSString stringWithFormat:@"%.1fg", self.viewmodel.normal.water];
    self.manureLab.text = [NSString stringWithFormat:@"%.1fg", self.viewmodel.normal.manure];
}

#pragma mark - 方法
- (IBAction)plantTree:(UIButton *)sender {
    if (self.viewmodel.normal.water < 10000 && self.viewmodel.normal.manure < 5000) {
        [self showMassage:NSLocalizedString(@"水和肥料还不够呢~", nil)];
    } else {
        NSString *message = [NSString stringWithFormat:@"%@%.1fg%@，%.1fg%@", NSLocalizedString(@"已经收集了", nil), self.viewmodel.normal.water, NSLocalizedString(@"水", nil), self.viewmodel.normal.manure, NSLocalizedString(@"肥料", nil)];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"小树已经长大了~", nil) message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *sureaction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showMassage:NSLocalizedString(@"恭喜你，又多了一棵小树", nil)];
            self.tree.image = [UIImage imageNamed:@"1"];
            [self setTreeData];
        }];
        [alert addAction:cancelaction];
        [alert addAction:sureaction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (IBAction)seeTreeList:(id)sender {
    NSLog(@"---列表---");
    TreeViewController *tree = [[TreeViewController alloc] init];
    [self.navigationController pushViewController:tree animated:YES];
}

- (void)gotoStepVC {
    StepViewController *step = [[StepViewController alloc] init];
    [self.navigationController pushViewController:step animated:YES];
}

- (void)gotoGonglueVC {
    GonglueViewController *gonglue = [[GonglueViewController alloc] init];
    [self.navigationController presentViewController:gonglue animated:YES completion:nil];
}

- (void)treeAnimation {
    
}

#pragma mark - UI
- (void)initUIView {
    self.navigationItem.title = NSLocalizedString(@"森林", nil);
    [self setNav];
    self.treePadding.constant = 130*Heigt_Scale;
    self.treeWidth.constant = 150*Width_Scale;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[defaults objectForKey:@"treeList"]];
    if (arr == nil) {
        arr = [NSMutableArray array];
    }
    
    [defaults setObject:arr forKey:@"treeList"];
    self.treeNumLab.text = [NSString stringWithFormat:@"×%ld", arr.count];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(treeAnimation)];
    [self.tree addGestureRecognizer:tap];
}

- (void)setNav {
    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showBtn.frame = CGRectMake(0, 0, 25, 25);
    [showBtn setImage:[UIImage imageNamed:@"foot"] forState:UIControlStateNormal];
    [showBtn addTarget:self action:@selector(gotoStepVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *gonglueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gonglueBtn.frame = CGRectMake(0, 0, 20, 25);
    [gonglueBtn setImage:[UIImage imageNamed:@"book"] forState:UIControlStateNormal];
    [gonglueBtn addTarget:self action:@selector(gotoGonglueVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:gonglueBtn];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:showBtn];
    [self addNavigationWithTitle:nil leftItem:leftItem rightItem:rightItem titleView:nil];
}

#pragma mark - 动画
//带有动画的太阳和云
- (void)sunAndCloudsWithAnimation {
    //旋转的太阳
    CABasicAnimation *tAnimation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    tAnimation.fromValue = [NSNumber numberWithFloat:0.f];
    
    tAnimation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    //旋转速度，数字越大旋转越慢
    tAnimation.duration  = 10;
    
    tAnimation.autoreverses = NO;
    
    tAnimation.fillMode =kCAFillModeForwards;
    
    tAnimation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.sunView.layer addAnimation:tAnimation forKey:nil];
    
    self.cloudsView = [[CloudsView alloc] initWithFrame:CGRectMake(-Screen_Width, CGRectGetMinY(self.sunView.frame), Screen_Width, 130*Heigt_Scale)];
    
    [self.view addSubview:self.cloudsView];
    
    //移动的云
    CABasicAnimation *pAnimation =  [CABasicAnimation animationWithKeyPath:@"position"];
    
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    pAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-Screen_Width/2, CGRectGetMidY(self.cloudsView.frame))];
    
    pAnimation.toValue =  [NSValue valueWithCGPoint:CGPointMake(Screen_Width*1.5, CGRectGetMidY(self.cloudsView.frame))];
    //旋转速度，数字越大旋转越慢
    pAnimation.duration  = 20;
    
    pAnimation.autoreverses = NO;
    
    pAnimation.fillMode =kCAFillModeForwards;
    
    pAnimation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.cloudsView.layer addAnimation:pAnimation forKey:nil];
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
