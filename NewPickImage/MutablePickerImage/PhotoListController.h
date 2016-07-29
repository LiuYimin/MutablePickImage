//
//  PhotoListController.h
//  NewPickImage
//
//  Created by Liu on 16/7/27.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void(^ReturnBlock)(NSArray <PHAsset *>* assets);
@interface PhotoListController : UICollectionViewController

@property (nonatomic, copy) ReturnBlock assetsBlock;
@property (nonatomic, strong) PHAssetCollection *assetCollection;

@end
