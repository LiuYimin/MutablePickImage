//
//  LMPickerNavBar.m
//  NewPickImage
//
//  Created by Lim Liu on 2019/12/18.
//  Copyright © 2019 Liu. All rights reserved.
//

#import "LMPickerNavBar.h"
#import "NSString+Helper.h"
#import "Helper/LMPickerDefine.h"

@interface LMPickerNavBar ()
@property (nonatomic, strong) UIButton *dismissBtn;
@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) UIVisualEffectView *effectview;
@end

@implementation LMPickerNavBar
#pragma mark -- Public

#pragma mark -- Lifecycle
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initData];
    [self initUI];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutUI];
}

#pragma mark -- Intial Method
- (void)initData
{
    
}

- (void)initUI
{
    [self addSubview:self.effectview];
    [self addSubview:self.dismissBtn];
    [self addSubview:self.finishBtn];
}

#pragma mark -- Layout
- (void)layoutUI
{
    CGFloat W = self.bounds.size.width;
    CGFloat H = self.bounds.size.height;
    CGFloat DissmissW = [self.dismissBtn sizeThatFits:CGSizeMake(W, 44)].width + 16;
    CGFloat FinishW = [self.finishBtn sizeThatFits:CGSizeMake(W, 44)].width + 16;
    self.dismissBtn.frame = CGRectMake(0, H-44, DissmissW, 44);
    self.finishBtn.frame = CGRectMake(W-FinishW, H-44, FinishW, 44);
    self.effectview.frame = self.bounds;
}

#pragma mark -- Target Action
- (void)onDismiss
{
    if (self.onDismissCallback) {
        self.onDismissCallback();
    }
}

- (void)onFinish
{
    if (self.onFinishCallback) {
        self.onFinishCallback();
    }
}

#pragma mark -- ...

#pragma mark -- Lazy
- (UIButton *)dismissBtn {
    if (!_dismissBtn) {
        _dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dismissBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_dismissBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_dismissBtn addTarget:self action:@selector(onDismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBtn;
}

- (UIButton *)finishBtn {
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:RGBS(0x4D) forState:UIControlStateNormal];
        [_finishBtn addTarget:self action:@selector(onFinish) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}

- (UIVisualEffectView *)effectview {
    if (!_effectview) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    }
    return _effectview;
}

@end
