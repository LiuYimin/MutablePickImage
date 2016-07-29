//
//  PhotoListController.m
//  NewPickImage
//
//  Created by Liu on 16/7/27.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import "PhotoListController.h"
#import "PHAssetCollection+GetPhotos.h"
#import "UIButton+LP.h"
#import "NSArray+CheckOutIndex.h"
#import <QuartzCore/QuartzCore.h>

#define MARGIN 2
#define COL 4
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height



@interface CusPhotoModel : NSObject

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, assign) BOOL hasSelected;

@end

@implementation CusPhotoModel

@end


//
typedef void(^NotiyOptionResult)(CusPhotoModel *model);
@interface CusPhoto : UICollectionViewCell

@property (nonatomic, copy) NotiyOptionResult result;

@property (nonatomic, strong) CusPhotoModel *model;

@property (nonatomic, strong) UIImageView *backPhotoView;

@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, strong) UIView *selectedCoverView;

@end

@implementation CusPhoto

- (void)setModel:(CusPhotoModel *)model {
    _model = model;
    
    BOOL original = NO;
    
    // 是否要原图
    CGSize size = original ? CGSizeMake(model.asset.pixelWidth, model.asset.pixelHeight) : CGSizeMake(150, 150);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 从asset中获得图片
    [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.backPhotoView.image = result;
    }];
    
    self.selectedButton.selected = self.model.hasSelected;
    
    @try {
        [_model removeObserver:self forKeyPath:@"hasSelected"];
    }
    @catch (NSException *exception) {
    }

    [_model addObserver:self forKeyPath:@"hasSelected" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"hasSelected"]) {
        BOOL hasSelected = [[change objectForKey:@"new"] boolValue];
        self.selectedButton.selected = hasSelected;
    }else if ([keyPath isEqualToString:@"selected"]) {
        self.selectedCoverView.hidden = !self.selectedButton.selected;
    }
}

- (UIImageView *)backPhotoView {
    if (_backPhotoView == nil) {
        _backPhotoView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backPhotoView.contentMode = UIViewContentModeScaleAspectFill;
        _backPhotoView.clipsToBounds = YES;
        [self addSubview:_backPhotoView];
    }
    return _backPhotoView;
}

- (UIButton *)selectedButton {
    if (_selectedButton == nil) {
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedButton.frame = CGRectMake(self.bounds.size.width-25-3, self.bounds.size.height-25-3, 25, 25);
        [_selectedButton setImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateSelected];
        [_selectedButton addTarget:self action:@selector(selectedAction) forControlEvents:UIControlEventTouchUpInside];
        [_selectedButton setEnlargedEdgeWithTop:5+20 right:3 bottom:3 left:5+20];
        [self addSubview:_selectedButton];
        
        [_selectedButton addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _selectedButton;
}

- (UIView *)selectedCoverView {
    if (_selectedCoverView == nil) {
        _selectedCoverView = [[UIView alloc] initWithFrame:self.bounds];
        _selectedCoverView.backgroundColor = [UIColor whiteColor];
        _selectedCoverView.alpha = 0.2;
        _selectedCoverView.hidden = YES;
        [self addSubview:_selectedCoverView];
        [self insertSubview:_selectedCoverView belowSubview:self.selectedButton];
    }
    return _selectedCoverView;
}

- (void)selectedAction {
    self.model.hasSelected = !self.model.hasSelected;
    self.selectedButton.selected = self.model.hasSelected;
    
    if (self.result) {
        self.result(self.model);
    }
}

@end


struct CollectionCellPath {
    unsigned int row;
    unsigned int col;
};

@interface PhotoListController ()
{
    CGFloat _cellHeight;
    struct CollectionCellPath _startPath, _endPath;
    BOOL _isSelectOrUnSelect;
    UILabel *_titleMessageLabel;
}

@property (nonatomic, strong) NSArray * photos;

@property (nonatomic, strong) NSMutableArray *selectedPhotos;

@property (nonatomic, strong) NSMutableArray *tmpSelectedPhotos;

@end

@implementation PhotoListController

static NSString * const reuseIdentifier = @"CusPhotoCell";

//设置类型
- (instancetype)init
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = MARGIN;
    flowLayout.minimumInteritemSpacing = MARGIN;
    _cellHeight = (kWidth - (COL - 1) * MARGIN) / COL;
    flowLayout.itemSize = CGSizeMake(_cellHeight, _cellHeight);
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
    
    _startPath.row = -1;
    
    return [super initWithCollectionViewLayout:flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[CusPhoto class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //右侧完成按钮
    UIBarButtonItem *finish = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishSelecting)];
    self.navigationItem.rightBarButtonItem = finish;
    
    _titleMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.navigationItem.titleView = _titleMessageLabel;
    _titleMessageLabel.textAlignment = NSTextAlignmentCenter;
    _titleMessageLabel.text = @"选择项目";
    _titleMessageLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    _titleMessageLabel.adjustsFontSizeToFitWidth = YES;
    
    UIPanGestureRecognizer *pGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes:)];
    [self.view addGestureRecognizer:pGes];
}

- (void)panGes:(UIPanGestureRecognizer *)ges {
    
    CGPoint point_inCollectionView = [ges locationInView:self.collectionView];
    CGPoint point_inView = [ges locationInView:self.view];
    
    unsigned int row = (point_inCollectionView.y-5)/(_cellHeight+MARGIN);
    unsigned int col = (point_inCollectionView.x)/(_cellHeight+MARGIN);
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        _startPath.row = row;
        _startPath.col = col;
        
        _endPath.row = row;
        _endPath.col = col;
        
        NSInteger startIndex = _startPath.row*COL+_startPath.col;
        CusPhotoModel *startModel = [self.photos objectAtIndexCheck:startIndex];
        _isSelectOrUnSelect = !startModel.hasSelected;
    }
    
    if (ges.state == UIGestureRecognizerStateChanged) {
        _endPath.row = row;
        _endPath.col = col;
        
        NSMutableArray *mul = [NSMutableArray array];
        if (_startPath.row <= _endPath.row) {
            NSInteger startIndex = _startPath.row*COL+_startPath.col;

            for (NSInteger i = startIndex; i <= _endPath.row*COL+_endPath.col; i++) {
                CusPhotoModel *model = [self.photos objectAtIndexCheck:i];
                model.hasSelected = _isSelectOrUnSelect;
                [mul addObject:model];
            }
            [self tmpSelectedPhotosAddCusPhotoModels:mul];
        }else if (_startPath.row > _endPath.row) {
            for (NSInteger i = _endPath.row*COL+_endPath.col; i <= _startPath.row*COL+_startPath.col; i++) {
                CusPhotoModel *model = [self.photos objectAtIndexCheck:i];
                model.hasSelected = _isSelectOrUnSelect;
                [mul addObject:model];
            }
            [self tmpSelectedPhotosAddCusPhotoModels:mul];
        }

    }
    
    if (ges.state == UIGestureRecognizerStateEnded) {
        for (CusPhotoModel *model in self.tmpSelectedPhotos) {
            [self selectedPhotosAddCusPhotoModel:model];
        }
        [self.tmpSelectedPhotos removeAllObjects];
        [self changeTitleMessage];
    }
    
    [self performSelector:@selector(scrollCollectionViewWithPointInView:) withObject:[NSValue valueWithCGPoint:point_inView]];
}

- (void)scrollCollectionViewWithPointInView:(NSValue *)pointView {
    
    CGPoint point_inView = pointView.CGPointValue;
    
    if (point_inView.y < 64+_cellHeight) {
        
        CGFloat distanceY = (_cellHeight+64-point_inView.y)/1.5;
        
        CGPoint offset = self.collectionView.contentOffset;
        
        offset.y -= distanceY;
        
        if (offset.y < -64) {
            offset.y = -64;
        }
        
        self.collectionView.contentOffset = offset;
        
    }else if (point_inView.y > kHeight-_cellHeight) {
        
        CGFloat distanceY = (point_inView.y - kHeight+_cellHeight)/1.5;
        
        CGPoint offset = self.collectionView.contentOffset;
        
        offset.y += distanceY;
        
        if (offset.y > self.collectionView.contentSize.height-self.collectionView.bounds.size.height) {
            offset.y = self.collectionView.contentSize.height-self.collectionView.bounds.size.height;
        }
        
        self.collectionView.contentOffset = offset;
    }
}


- (void)finishSelecting {
    NSMutableArray <PHAsset *> *array = nil;
    array = ({
        NSMutableArray * arr = [NSMutableArray array];
        
        for (CusPhotoModel *model in self.selectedPhotos) {
            [arr addObject:[model.asset copy]];
        }
        
        arr;
    });
    
    if (self.assetsBlock) {
        self.assetsBlock(array);
    }
}

#pragma mark -- Setter && Getter

- (void)setAssetCollection:(PHAssetCollection *)assetCollection {
    _assetCollection = assetCollection;
    [self.collectionView reloadData];
}

- (NSArray *)photos {
    if (_photos == nil) {
        NSArray *arr = [self.assetCollection getAssetsInSelfAscending:YES];
        NSMutableArray *mul = [NSMutableArray array];
        for (PHAsset *asset in arr) {
            CusPhotoModel *model = [[CusPhotoModel alloc] init];
            model.asset = asset;
            model.hasSelected = NO;
            [mul addObject:model];
        }
        _photos = [NSArray arrayWithArray:mul];
    }
    return _photos;
}

- (NSMutableArray *)selectedPhotos {
    if (_selectedPhotos == nil) {
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
}

- (NSMutableArray *)tmpSelectedPhotos {
    if (_tmpSelectedPhotos == nil) {
        _tmpSelectedPhotos = [NSMutableArray array];
    }
    return _tmpSelectedPhotos;
}

- (void)selectedPhotosAddCusPhotoModel:(CusPhotoModel *)model {
    if (model.hasSelected) {
        if (![self.selectedPhotos containsObject:model]) {
            [self.selectedPhotos addObject:model];
        }
    }else {
        for (CusPhotoModel *sModel in self.selectedPhotos) {
            if (sModel.asset == model.asset) {
                [self.selectedPhotos removeObject:sModel];
                break;
            }
        }
    }
    [self changeTitleMessage];
}

- (void)tmpSelectedPhotosAddCusPhotoModels:(NSMutableArray *)array {
    [self.tmpSelectedPhotos removeObjectsInArray:array];
    for (CusPhotoModel *model in self.tmpSelectedPhotos) {
        model.hasSelected = !model.hasSelected;
    }
    self.tmpSelectedPhotos = array;
    [self changeTitleMessage];
}

- (void)changeTitleMessage {
    NSInteger count = self.selectedPhotos.count;
    if (_isSelectOrUnSelect) {
        count += self.tmpSelectedPhotos.count;
    }else {
        count -= self.tmpSelectedPhotos.count;
    }
    NSString *message = [NSString stringWithFormat:@"已选择%lu张照片",(long)count];
    if (count == 0) {
        message = @"选择项目";
    }
    _titleMessageLabel.text = message;
}

#pragma mark -- UICollectionViewDataSource && UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CusPhoto *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    @try {
        [cell.model removeObserver:cell forKeyPath:@"hasSelected"];
        cell.model = nil;
    }
    @catch (NSException *exception) {
    }

    
    cell.model = self.photos[indexPath.item];
    
    cell.result = ^(CusPhotoModel *model) {
        [self selectedPhotosAddCusPhotoModel:model];
    };
    
    return cell;
}






@end
