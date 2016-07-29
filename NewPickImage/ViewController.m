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

- (void)mianshi {
    NSArray *arr = @[@1,@3,@2,@4,@1,@2,@3];
    
    float mianji = 0;
    
//    for (NSInteger i = 0; i<arr.count; i++) {
//        if (i==0 || i==arr.count-1) {
//            continue;
//        }
//        
//        float last = [arr[i-1] floatValue];
//        float now = [arr[i] floatValue];
//        float future = [arr[i+1] floatValue];
//        
//        BOOL now_last = now > last;
//        BOOL now_future = now > future;
//        
//        if (!now_last && !now_future) {
//            float LHeight = last - now;
//            float RHeight = future - now;
//            
//            float height = LHeight<RHeight?LHeight:RHeight;
//            
//            mianji += height*1;
//        }
//    }
    
    for (NSInteger i = 0; i<arr.count;) {
        if (i == 0 || i == arr.count-1) {
            i++;
            continue;
        }
        
        float now = [arr[i] floatValue];
        
        NSInteger j = i+1;
        NSInteger sMax = j;
        for (; j<arr.count; j++) {
            
            float next = [arr[j] floatValue];
            if (now > next) {
                if ([arr[sMax] floatValue] < [arr[j] floatValue]) {
                    sMax = j;
                }
                continue;
            }else {
                break;
            }
        }
        
        if (j == arr.count) {
            float tmpMianji = 0;
            
            for (NSInteger k = i+1; k<sMax; k++) {
                if (k == sMax) {
                    break;
                }
                
                float mid = [arr[k] floatValue];
                tmpMianji += mid*1;
            }
            
            mianji += [arr[sMax] floatValue]*(sMax-i-1) - tmpMianji;
            
            i = sMax;
        }else {
            float tmpMianji = 0;
            
            for (NSInteger k = i+1; k<j; k++) {
                if (k == j) {
                    break;
                }
                
                float mid = [arr[k] floatValue];
                tmpMianji += mid*1;
            }
            
            mianji += now*(j-i-1) - tmpMianji;
            
            i = j;
        }
    }
    
    
    NSLog(@"%.2f",mianji);
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

//#pragma mark - 获取指定相册内的所有图片
//- (NSArray<PHAsset *> *)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection ascending:(BOOL)ascending
//{
//    NSMutableArray<PHAsset *> *arr = [NSMutableArray array];
//    
//    PHFetchResult *result = [self fetchAssetsInAssetCollection:assetCollection ascending:ascending];
//    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOLBOOL * _Nonnull stop) {
//        [arr addObject:obj];//这个obj即PHAsset对象
//    }];
//    return arr;
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    MutablePickerController *mpc = [[MutablePickerController alloc] init];
    NSLog(@"Mutable origal %@",mpc);
    mpc.returnBlock = ^(NSArray *arr) {
        NSLog(@"aaaaa%@",arr);
    };
    [self presentViewController:mpc animated:YES completion:nil];
}



//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    _startPoint = [touch locationInView:self.view];
////    self.collectionView.prohibitScrollView = YES;
//    NSLog(@"startPoint: %@",NSStringFromCGPoint(_startPoint));
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    _endPoint = [touch locationInView:self.view];
//    NSLog(@"move: %@",NSStringFromCGPoint(_endPoint));
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    _endPoint = [touch locationInView:self.view];
//    NSLog(@"endPoint: %@",NSStringFromCGPoint(_endPoint));
//}
//
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    _startPoint = CGPointZero;
//    _endPoint = CGPointZero;
//    NSLog(@"cancel Touch");
//}


//#pragma mark - 获取相册内所有照片资源
//- (NSArray<PHAsset *> *)getAllAssetInPhotoAblumWithAscending:(BOOL)ascending
//{
//    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
//    
//    PHFetchOptions *option = [[PHFetchOptions alloc] init];
//    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
//    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
//    
//    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
//    
//    
//    
//    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        PHAsset *asset = (PHAsset *)obj;
//        NSLog(@"照片名%@", [asset valueForKey:@"filename"]);
//        [assets addObject:asset];
//    }];
//    
//    return assets;
//}

//- (NSMutableArray *)groups{
//    if (_groups == nil) {
//        _groups = [NSMutableArray array];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
//                if(group){
//                    [_groups addObject:group];
//                    [self.tableView reloadData];
//                }
//            } failureBlock:^(NSError *error) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"访问相册失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                [alertView show];
//            }];
//        });
//    }
//    return _groups;
//}
//
@end
