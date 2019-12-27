//
//  LMPickerStorage.h
//  NewPickImage
//
//  Created by Lim Liu on 2019/12/18.
//  Copyright © 2019 Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "LMAsset.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMPickerStorage : NSObject
+ (instancetype)shared;
@property (nonatomic, strong) NSMutableArray *groups;

- (void)judgementHasRight:(void(^)(PHAuthorizationStatus))callBack;
- (void)fetchAllPhotos;
+ (NSString *)transformAblumTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
