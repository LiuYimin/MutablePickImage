//
//  UIView+AddSubviews.m
//  NewPickImage
//
//  Created by Liu on 16/7/27.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import "UIView+AddSubviews.h"

@implementation UIView (AddSubviews)

- (void)addSubviews:(NSArray <UIView *> *)subviews {
    if (subviews.count == 0) {
        return;
    }
    
    for (id sub in subviews) {
        [self addSubview:sub];
    }
}

@end
