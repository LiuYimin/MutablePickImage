//
//  UIButton+LP.h
//  NewPickImage
//
//  Created by Liu on 16/7/28.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LP)

/**
 *  扩张边界的大小
 */
@property (nonatomic,assign) CGFloat enlargedEdge;

/**
 *  扩张四个边界的大小
 */
- (void)setEnlargedEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end
