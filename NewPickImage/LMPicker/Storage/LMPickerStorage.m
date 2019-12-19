//
//  LMPickerStorage.m
//  NewPickImage
//
//  Created by Lim Liu on 2019/12/18.
//  Copyright © 2019 Liu. All rights reserved.
//

#import "LMPickerStorage.h"
#import "../../MutablePickerImage/PHAssetCollection+GetPhotos.h"

@interface LMPickerStorage ()

@end

static LMPickerStorage *storage = nil;
@implementation LMPickerStorage
+ (instancetype)shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storage = [[LMPickerStorage alloc] init];
    });
    return storage;
}

- (void)judgementHasRight:(void(^)(PHAuthorizationStatus))callBack
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        callBack?callBack(status):nil;
    }];
}

- (void)fetchAllPhotos
{
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isHasPhoto] && ![obj.localizedTitle isEqualToString:@"Videos"] && ![obj.localizedTitle hasPrefix:@"Recently"] && ![obj.localizedTitle isEqualToString:@"Time-lapse"]) {
            NSArray *array = [obj getAssetsInSelfAscending:YES];
            [self.groups addObjectsFromArray:array];
        }
    }];
    
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * collection, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([collection isHasPhoto]) {
            NSArray *array = [collection getAssetsInSelfAscending:YES];
            [self.groups addObjectsFromArray:array];
        }
    }];
}

#pragma mark -- Tools
+ (NSString *)transformAblumTitle:(NSString *)title
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


#pragma mark -- Lazy
- (NSMutableArray *)groups {
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}


@end
