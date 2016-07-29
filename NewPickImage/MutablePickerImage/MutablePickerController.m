//
//  MutablePickerController.m
//  NewPickImage
//
//  Created by Liu on 16/7/27.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import "MutablePickerController.h"
#import "PhotoAlbumListController.h"

@interface MutablePickerController ()

@property (nonatomic,strong) PhotoAlbumListController *albumController;

@end

@implementation MutablePickerController

- (instancetype)init {
    self = [super initWithRootViewController:self.albumController];
    if (self) {
        self.MaxCount = LONG_MAX;
        UINavigationBar *navBar = [UINavigationBar appearance];
        navBar.tintColor = [UIColor blueColor];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    return [self init];
}

//重写这行代码,可以阻止present本页面的touch调用,防止透传
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //...
}

#pragma mark -- Setter && Getter

- (PhotoAlbumListController *)albumController {
    if (_albumController == nil) {
        _albumController = [[PhotoAlbumListController alloc] init];
        _albumController.navigationItem.title = @"选择相册";
        
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
        _albumController.navigationItem.rightBarButtonItem = cancelItem;
    }
    return _albumController;
}

- (void)setMaxCount:(NSInteger)MaxCount {
    _MaxCount = MaxCount;
    if (_MaxCount > 0) {
        self.albumController.MaxCount = MaxCount;
    }
}

#pragma mark -- Private

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
