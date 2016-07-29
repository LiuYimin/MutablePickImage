//
//  PhotoAlbumListController.m
//  NewPickImage
//
//  Created by Liu on 16/7/27.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import "PhotoAlbumListController.h"
#import "MutablePickerController.h"
#import <Photos/Photos.h>
#import "PhotoAlbumCell.h"
#import "PHAssetCollection+GetPhotos.h"
#import "PhotoListController.h"

@interface PhotoAlbumListController ()

@property (nonatomic,strong) PHPhotoLibrary *photoLibrary;
@property (nonatomic,strong) NSMutableArray *groups;

@end

@implementation PhotoAlbumListController

#pragma mark -- LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];

    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"照片";
    self.navigationItem.backBarButtonItem = backItem;
}


#pragma mark -- Private

- (void)dismiss:(NSArray <PHAsset *> *)assets {
    MutablePickerController *mpc = (MutablePickerController *)self.navigationController;
    if (mpc.returnBlock) {
        NSMutableArray *mul = [NSMutableArray array];
        dispatch_group_t group = dispatch_group_create();
        for (PHAsset *asset in assets) {
            dispatch_queue_t queue = dispatch_queue_create("com.abc.liu", DISPATCH_QUEUE_CONCURRENT);
            dispatch_group_enter(group);
            dispatch_group_async(group, queue, ^{
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                options.synchronous = NO;
                options.resizeMode = PHImageRequestOptionsResizeModeExact;
                
                //因为直接取图片太占内存,故而这里先取图片的二进制数据,转换为Image放在外面进行.
                [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    [mul addObject:imageData];
                    dispatch_group_leave(group);//手动发送完成消息
                }];
            });
        }
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            if (mpc.returnBlock) {
                NSMutableArray *arr = [NSMutableArray array];
                for (NSData *data in mul) {
                    [arr addObject:[UIImage imageWithData:data]];
                }
                
                mpc.returnBlock(arr);
            }
        });
    }
    [mpc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- Setter && Getter

- (PHPhotoLibrary *)photoLibrary {
    if (_photoLibrary == nil) {
        _photoLibrary = [PHPhotoLibrary sharedPhotoLibrary];
    }
    return _photoLibrary;
}

- (NSMutableArray *)groups {
    if (_groups == nil) {
        _groups = [NSMutableArray array];
        dispatch_async(dispatch_get_main_queue(), ^{
            PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isHasPhoto] && ![obj.localizedTitle isEqualToString:@"Videos"] && ![obj.localizedTitle hasPrefix:@"Recently"] && ![obj.localizedTitle isEqualToString:@"Time-lapse"]) {
                    [_groups addObject:obj];
                }
            }];
            
            PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
            [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * collection, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([collection isHasPhoto]) {
                    [_groups addObject:collection];
                }
            }];
            
            [self.tableView reloadData];
        });
    }
    return _groups;
}


#pragma mark -- UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoAlbumCell *cell = [PhotoAlbumCell cellForTableView:tableView];
    
    cell.assetCollection = self.groups[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoListController *plc = [[PhotoListController alloc] init];
    plc.assetCollection = self.groups[indexPath.row];
    plc.assetsBlock = ^(NSArray <PHAsset *> * asstes) {
        [self dismiss:asstes];
    };
    [self.navigationController pushViewController:plc animated:YES];
}




@end
