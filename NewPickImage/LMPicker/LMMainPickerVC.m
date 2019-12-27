//
//  LMMainPickerVC.m
//  NewPickImage
//
//  Created by Lim Liu on 2019/12/18.
//  Copyright © 2019 Liu. All rights reserved.
//

#import "LMMainPickerVC.h"
#import "LMPickerNavBar.h"
#import "Storage/LMPickerStorage.h"
#import "LMAssetCell.h"

#define H_Dis 20

@interface LMMainPickerVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>
@property (nonatomic, strong) LMPickerNavBar *navBar;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionLayout;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, assign) BOOL beginChanging;//开始批量改变状态
@property (nonatomic, assign) BOOL beginStatus;//开始选择的状态
@property (nonatomic, assign) CGPoint beginPoint;
@end

@implementation LMMainPickerVC
#pragma mark -- Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutUI];
}
#pragma mark -- Initial Method
- (void)initData
{
    [[LMPickerStorage shared] judgementHasRight:^(PHAuthorizationStatus status) {
        
    }];
    [[LMPickerStorage shared] fetchAllPhotos];
    [self.collectionView reloadData];
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navBar];
    [self.view addSubview:self.collectionView];
}
#pragma mark -- Network
#pragma mark -- Private
- (void)layoutUI
{
    CGFloat W = self.view.bounds.size.width;
//    CGFloat H = self.view.bounds.size.height;
    self.navBar.frame = CGRectMake(0, 0, W, __kNavHeight);
    self.collectionView.frame = self.view.bounds;//CGRectMake(0, CGRectGetMaxY(self.navBar.frame), W, H - CGRectGetMaxY(self.navBar.frame));
    [self.view bringSubviewToFront:self.navBar];
}

#pragma mark -- Target Actions
- (void)onDismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onFinish
{
    
}

- (void)panGestureAction:(UIPanGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.beginPoint = [gesture locationInView:self.collectionView];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStatePossible:
        {
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark -- UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [LMPickerStorage shared].groups.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LMAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LMAssetCell" forIndexPath:indexPath];
    if ([LMPickerStorage shared].groups.count > indexPath.item) {
        cell.asset = [LMPickerStorage shared].groups[indexPath.item];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = (collectionView.bounds.size.width-2*3)/4.0;
    return CGSizeMake(w, w);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    LMAssetCell *cell = (LMAssetCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
}

#pragma mark -- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewDelayedTouchesBeganGestureRecognizer")]) {
        return NO;
    }
    return YES;
}

#pragma mark -- Lazy
- (LMPickerNavBar *)navBar {
    if (!_navBar) {
        WeakSelf;
        _navBar = [[LMPickerNavBar alloc] init];
        _navBar.onDismissCallback = ^{
            [weakSelf onDismiss];
        };
        _navBar.onFinishCallback = ^{
            [weakSelf onFinish];
        };
    }
    return _navBar;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[LMAssetCell class] forCellWithReuseIdentifier:@"LMAssetCell"];
        [_collectionView addGestureRecognizer:self.panGesture];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionLayout {
    if (!_collectionLayout) {
        _collectionLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionLayout.minimumLineSpacing = 2;
        _collectionLayout.minimumInteritemSpacing = 2;
        _collectionLayout.sectionInset = UIEdgeInsetsMake(44, 0, 0, 0);
    }
    return _collectionLayout;
}

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        _panGesture.delegate = self;
    }
    return _panGesture;
}

@end
