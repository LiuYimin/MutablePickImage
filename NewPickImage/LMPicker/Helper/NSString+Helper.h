//
//  NSString+Helper.h
//  NewPickImage
//
//  Created by Lim Liu on 2019/12/18.
//  Copyright © 2019 Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Helper)
- (CGFloat)calculateHeight:(CGFloat)maxWidth font:(CGFloat)fontSize;
- (CGFloat)calculateWidth:(CGFloat)maxHeight font:(CGFloat)fontSize;
@end

NS_ASSUME_NONNULL_END
