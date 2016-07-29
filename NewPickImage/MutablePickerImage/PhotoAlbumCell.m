//
//  PhotoAlbumCell.m
//  NewPickImage
//
//  Created by Liu on 16/7/27.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import "PhotoAlbumCell.h"
#import "PHAssetCollection+GetPhotos.h"
#import "UIView+AddSubviews.h"

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

#define kDevice_Is_iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

@interface PhotoAlbumCell ()

@property (nonatomic,strong) NSArray <PHAsset *> *assetArray;

@property (nonatomic,strong) UIImageView *photoView, *flagView;

@property (nonatomic,strong) UILabel *albumTitle, *albumPhotoNumber;

@end

@implementation PhotoAlbumCell

static NSString * cellID = @"PhotoAlbumCellID";

+ (instancetype)cellForTableView:(UITableView *)tableView {
    PhotoAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[PhotoAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    _photoView = [[UIImageView alloc] init];
    _flagView = [[UIImageView alloc] init];
    _albumTitle = [[UILabel alloc] init];
    _albumPhotoNumber = [[UILabel alloc] init];
    [self setSubviewsFrame];
    [self setSubviewsAttribute];
    [self addSubviews:@[_photoView,_flagView,_albumTitle,_albumPhotoNumber]];
}

- (void)setSubviewsFrame {
    if (kDevice_Is_iPhone5) {
        //10  68
        _photoView.frame = CGRectMake(10, 10, 68, 68);
        _albumTitle.frame = CGRectMake(CGRectGetMaxX(_photoView.frame)+16, 25, 200, 25);
        _albumPhotoNumber.frame = CGRectMake(CGRectGetMinX(_albumTitle.frame), CGRectGetMaxY(_albumTitle.frame)+5, 200, 16);
        _flagView.frame = CGRectMake(ScreenWidth - 15 - 10, 0, 10, 16);
        _flagView.center = CGPointMake(ScreenWidth - 15 - 5, 44);
    }
}

- (void)setSubviewsAttribute {
    _photoView.contentMode = UIViewContentModeScaleAspectFill;
    _photoView.clipsToBounds = YES;
    _albumTitle.font = [UIFont systemFontOfSize:20];
    _albumPhotoNumber.font = [UIFont systemFontOfSize:12.5];
    _flagView.image = [UIImage imageNamed:@"flag"];
}

- (void)setAssetCollection:(PHAssetCollection *)assetCollection {
    _assetCollection = assetCollection;
    self.assetArray = [_assetCollection getAssetsInSelfAscending:YES];
    
    PHAsset *assetFirst = [self.assetArray lastObject];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = NO;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    
    //取小图,用于展示.减少内存消耗
    [[PHImageManager defaultManager] requestImageForAsset:assetFirst targetSize:CGSizeMake(150, 150) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        _photoView.image = result;
    }];
    
    _albumTitle.text = [self transformAblumTitle:_assetCollection.localizedTitle];
    
    _albumPhotoNumber.text = [NSString stringWithFormat:@"%ld",(unsigned long)self.assetArray.count];
}

- (NSString *)transformAblumTitle:(NSString *)title
{
    if ([title isEqualToString:@"Slo-mo"]) {
        return @"慢动作";
    } else if ([title isEqualToString:@"Recently Added"]) {
        return @"最近添加";
    } else if ([title isEqualToString:@"Favorites"]) {
        return @"个人收藏";
    } else if ([title isEqualToString:@"Recently Deleted"]) {
        return @"最近删除";
    } else if ([title isEqualToString:@"Videos"]) {
        return @"视频";
    } else if ([title isEqualToString:@"All Photos"]) {
        return @"所有照片";
    } else if ([title isEqualToString:@"Selfies"]) {
        return @"自拍";
    } else if ([title isEqualToString:@"Screenshots"]) {
        return @"屏幕快照";
    } else if ([title isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    } else if ([title isEqualToString:@"Panoramas"]) {
        return @"全景照片";
    } else if ([title isEqualToString:@"My Photo Stream"]) {
        return @"我的照片流";
    } else if ([title isEqualToString:@"Time-lapse"]) {
        return @"延时摄影";
    }
    
    
    return title;
}



- (NSArray *)assetArray {
    if (_assetArray == nil) {
        _assetArray = [NSArray array];
    }
    return _assetArray;
}

@end
