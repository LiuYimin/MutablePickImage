//
//  LMAssetCell.h
//  NewPickImage
//
//  Created by Lim Liu on 2019/12/19.
//  Copyright © 2019 Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMAssetCell : UICollectionViewCell
@property (nonatomic, strong) PHAsset *asset;
@end

NS_ASSUME_NONNULL_END
