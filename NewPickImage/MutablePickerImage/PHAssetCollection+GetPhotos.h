//
//  PHAssetCollection+GetPhotos.h
//  NewPickImage
//
//  Created by Liu on 16/7/27.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAssetCollection (GetPhotos)

- (NSArray<PHAsset *> *)getAssetsInSelfAscending:(BOOL)ascending;

- (BOOL)isHasPhoto;

@end
