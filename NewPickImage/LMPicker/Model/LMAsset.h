//
//  LMAsset.h
//  NewPickImage
//
//  Created by Lim Liu on 2019/12/23.
//  Copyright © 2019 Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMAsset : NSObject
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
