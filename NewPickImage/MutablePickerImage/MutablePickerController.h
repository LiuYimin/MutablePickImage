//
//  MutablePickerController.h
//  NewPickImage
//
//  Created by Liu on 16/7/27.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void(^ResultBlock)(NSArray <UIImage *>* assets);
@interface MutablePickerController : UINavigationController

@property (nonatomic, assign) NSInteger MaxCount;
@property (nonatomic, copy) ResultBlock returnBlock;

@end
