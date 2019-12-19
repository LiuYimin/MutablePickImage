//
//  ViewController.m
//  NewPickImage
//
//  Created by Liu on 16/7/26.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import "ViewController.h"
#import "PictureSelectedView.h"
#import <Photos/Photos.h>
#import "MutablePickerController.h"
#import "LMMainPickerVC.h"

@interface ViewController ()
{
    CGPoint _startPoint, _endPoint;
}

@property (nonatomic,strong) NSMutableArray *groups;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    PictureSelectedView *psv = [[PictureSelectedView alloc] initWithFrame:CGRectMake(10, 90, 300, 300)];
//    [self.view addSubview:psv];
//    psv.svc = self;
    
//    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"相册名字:%@", [self transformAblumTitle:obj.localizedTitle]);
//        NSMutableArray<PHAsset *> *arr = [NSMutableArray array];
//        
//    }];
//   
//    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
//    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * collection, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"用户相册名字:%@", collection.localizedTitle);
//    }];
    
//    NSArray *arr = [self getAllAssetInPhotoAblumWithAscending:YES];
//    NSLog(@"%@",arr);
//
    
//    [self mianshi];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)transformAblumTitle:(NSString *)title
{
    if ([title isEqualToString:@"Slo-mo"]) {
        return @"慢动作";
    } else if ([title isEqualToString:@"Recently Added"]) {
        return @"最近添加";
    } else if ([title isEqualToString:@"Favorites"]) {
        return @"最爱";
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    MutablePickerController *mpc = [[MutablePickerController alloc] init];
//    NSLog(@"Mutable origal %@",mpc);
//    mpc.returnBlock = ^(NSArray *arr) {
//        NSLog(@"aaaaa%@",arr);
//    };
//    mpc.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:mpc animated:YES completion:nil];
}
- (IBAction)onGotoPickerPage:(id)sender {
    LMMainPickerVC *vc = [[LMMainPickerVC alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}


@end
