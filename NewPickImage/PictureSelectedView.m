//
//  PictureSelectedView.m
//  ForANewWidget
//
//  Created by LiuYimin on 16/3/22.
//  Copyright © 2016年 LiuYimin. All rights reserved.
//

#import "PictureSelectedView.h"
#import "CFunction.h"
#import "MutableImagePickerController.h"

#define SRGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface PictureSelectedView ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    CGFloat _selfHeight, _selfWidth,_width,_height;
    
    UILabel *_titleLabel, *_message;
    
    UIButton *_addButton;
    UIImageView* _addImage;
    
    NSLock* _lock;
    
    NSInteger _count;
}

@end

@implementation PictureSelectedView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _selfHeight = frame.size.height;
        _selfWidth = frame.size.width;
        _maxCount = 3;
        _count = 0;
        _width = transForWidth(90.f);
        _height = transForHeight(90.f);
        _lock = [[NSLock alloc] init];
        [self setUI];
        
    }
    return self;
}

- (void)setUI {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 17, 80, 18)];
    _titleLabel.text = @"上传图片";
    _titleLabel.font = [UIFont systemFontOfSize:17.f];
    _titleLabel.textColor = SRGB(71, 86, 93, 1);
    [self addSubview:_titleLabel];
    
    _message = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame)+5, _titleLabel.frame.origin.y, _selfWidth - (CGRectGetMaxX(_titleLabel.frame)+5 + 15), _titleLabel.frame.size.height)];
    _message.textColor = SRGB(140, 149, 154, 1);
    _message.font = [UIFont systemFontOfSize:12.f];
    _message.text = [NSString stringWithFormat:@"(最多上传%ld张图片,选传)",(long)_maxCount];
    [self addSubview:_message];
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(_titleLabel.frame)+10, _width, _height);
    _addButton.backgroundColor = SRGB(186, 194, 199, 1);
    [_addButton addTarget:self action:@selector(addBUttClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addButton];
    
    _addImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
    _addImage.image = [UIImage imageNamed:@"PLUS"];
    _addImage.center = CGPointMake(_addButton.frame.size.width/2.f, _addButton.frame.size.height/2.f);
    [_addButton addSubview:_addImage];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addBUttClicked)];
    [_addImage addGestureRecognizer:tap];
    
}

- (void)setSubviewsFrame {
    _selfHeight = self.frame.size.height;
    _selfWidth = self.frame.size.width;
    
    _titleLabel.frame = CGRectMake(15, 17, 80, 18);
    _message.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame)+5, _titleLabel.frame.origin.y, _selfWidth - (CGRectGetMaxX(_titleLabel.frame)+5 + 15), _titleLabel.frame.size.height);
    _addButton.frame = CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(_titleLabel.frame)+10, _width, _height);
    _addImage.frame = CGRectMake(0, 0, 26, 26);
    _addImage.center = CGPointMake(_addButton.frame.size.width/2.f, _addButton.frame.size.height/2.f);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setSubviewsFrame];
}

- (void)addBUttClicked {
    [self chooseImage];
}

- (void)setMaxCount:(NSInteger)maxCount {
    _maxCount = maxCount;
    _message.text = [NSString stringWithFormat:@"(最多上传%ld张图片,选传)",(long)_maxCount];
}

- (void)chooseImage {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"选择" message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    
    //判断是否支持相机
    if ([MutableImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self alertClicked:UIImagePickerControllerSourceTypeCamera];
        }];
        [alertController addAction:deleteAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //        [self test:nil];
    }];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self alertClicked:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:archiveAction];
    
    
    if (self.svc) {
        [self.svc presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)alertClicked:(UIImagePickerControllerSourceType)sourceType {
    MutableImagePickerController* imagePickerController = [[MutableImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    if (self.svc) {
        [self.svc presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (void)addImageToSelf:(UIImage *)image {
    
    [_lock lock];
    
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:_addButton.frame];
    imgView.image = image;
    [self addSubview:imgView];
    
    CGRect rec = imgView.frame;
    rec.origin.x = CGRectGetMaxX(imgView.frame)+5.f;
    
    if (CGRectGetMaxX(rec)>_selfWidth - 15) {
        rec.origin.y = CGRectGetMaxY(imgView.frame)+10;
        rec.origin.x = _titleLabel.frame.origin.x;
    }
    
    _addButton.frame = rec;
    
    _count ++;
    
    if (_count >= _maxCount) {
        _addButton.hidden = YES;
        _addButton.enabled = NO;
    }
    
    [_lock unlock];
}


- (void)imagePickerController:(MutableImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self addImageToSelf:image];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
