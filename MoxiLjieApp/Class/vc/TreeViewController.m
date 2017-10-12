//
//  TreeViewController.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/9/20.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "TreeViewController.h"
#import "TreeCell.h"

@interface TreeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *treeCollection;
@property (nonatomic, strong) NSArray *treeList;

@end

@implementation TreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getTreeList];
}

- (void)getTreeList {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[defaults objectForKey:@"treeList"]];
    if (arr == nil) {
        arr = [NSMutableArray array];
    }
    self.treeList = [NSArray arrayWithArray:arr];
    if (self.treeList.count<= 0) {
        sleep(0.5);
        [self setNoDataAlertView];
    }
}

#pragma mark - collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.treeList.count;
//    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TreeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TreeCell" forIndexPath:indexPath];
    [cell setDateWithString:self.treeList[indexPath.row]];
    
    return cell;
}

#pragma mark - ui
- (void)initUIView {
    self.navigationItem.title = NSLocalizedString(@"已长成的树", nil);
    [self setBackButton:YES];
    
    [self setCollectionviewLayout];
}

- (void)setNoDataAlertView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"还没有长大的树", nil) message:NSLocalizedString(@"你还没有养成的大树，快去走路获取水和肥料来养棵树吧~", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureaction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [super goBack];
    }];
    [alert addAction:sureaction];
    [self presentViewController:alert animated:YES completion:nil];
}

//collectionview相关
- (void)setCollectionviewLayout {
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    [flow setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    flow.minimumLineSpacing = 20;
    flow.minimumInteritemSpacing = 20;
    
    flow.itemSize = CGSizeMake((Screen_Width-60-20)/2, 110);
    
    self.treeCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(30, 20, Screen_Width-60, Screen_Height) collectionViewLayout:flow];
    self.treeCollection.backgroundColor = [UIColor clearColor];
    self.treeCollection.delegate = self;
    self.treeCollection.dataSource = self;
    self.treeCollection.showsHorizontalScrollIndicator = NO;
    self.treeCollection.showsVerticalScrollIndicator = NO;
    [self.treeCollection registerNib:[UINib nibWithNibName:@"TreeCell" bundle:nil] forCellWithReuseIdentifier:@"TreeCell"];
    [self.view addSubview:self.treeCollection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
