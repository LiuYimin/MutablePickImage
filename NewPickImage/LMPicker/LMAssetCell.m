//
//  LMAssetCell.m
//  NewPickImage
//
//  Created by Lim Liu on 2019/12/19.
//  Copyright © 2019 Liu. All rights reserved.
//

#import "LMAssetCell.h"
#import "../MutablePickerImage/PHAssetCollection+GetPhotos.h"
#import "Storage/LMPickerStorage.h"

@interface LMAssetCell()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *checkButton;
@end

@implementation LMAssetCell
#pragma mark -- Public
//- (void)setAsset:(PHAssetCollection *)asset {
//    _asset = asset;
//    PHAsset *assetFirst = [[asset getAssetsInSelfAscending:YES] lastObject];
//    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//    options.synchronous = NO;
//    options.resizeMode = PHImageRequestOptionsResizeModeExact;
//    
//    //取小图,用于展示.减少内存消耗
//    [[PHImageManager defaultManager] requestImageForAsset:assetFirst targetSize:CGSizeMake(150, 150) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        self.imageView.image = result;
//    }];
//    
//    NSLog(@"%@",[LMPickerStorage transformAblumTitle:asset.localizedTitle]);
//    NSLog(@"%ld", (unsigned long)[_asset getAssetsInSelfAscending:YES].count);
//}

- (void)setAsset:(LMAsset *)asset {
    _asset = asset;
    BOOL original = NO;
    // 是否要原图
    CGSize size = original ? CGSizeMake(asset.asset.pixelWidth, asset.asset.pixelHeight):CGSizeMake(150, 150);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 从asset中获得图片
    [[PHImageManager defaultManager] requestImageForAsset:asset.asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.imageView.image = result;
    }];
    [self updateUI];
}

#pragma mark -- Lifecycle
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initData];
    [self initUI];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutUI];
}

#pragma mark -- Intial Method
- (void)initData
{
    
}

- (void)initUI
{
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.checkButton];
}

#pragma mark -- Layout
- (void)layoutUI
{
    CGFloat W = self.bounds.size.width;
    self.imageView.frame = self.contentView.bounds;
    self.checkButton.frame = CGRectMake(W-25, 0, 25, 25);
}

- (void)updateUI
{
    [self.checkButton setImage:[UIImage imageNamed:(self.asset.isSelected?@"btn_selected":@"btn_unselected")] forState:UIControlStateNormal];
}

#pragma mark -- Target Action
- (void)onChecked
{
    self.asset.isSelected = !self.asset.isSelected;
    [self updateUI];
}

#pragma mark -- ...

#pragma mark -- Lazy
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIButton *)checkButton {
    if (!_checkButton) {
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkButton setImage:[UIImage imageNamed:@"btn_unselected"] forState:UIControlStateNormal];
        [_checkButton addTarget:self action:@selector(onChecked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkButton;
}
@end
