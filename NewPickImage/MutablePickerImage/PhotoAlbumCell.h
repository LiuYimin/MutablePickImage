//
//  PhotoAlbumCell.h
//  NewPickImage
//
//  Created by Liu on 16/7/27.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface PhotoAlbumCell : UITableViewCell

@property (nonatomic, strong) PHAssetCollection *assetCollection;
+ (instancetype)cellForTableView:(UITableView *)tableView;

@end
