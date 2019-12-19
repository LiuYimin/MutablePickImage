//
//  NSString+Helper.m
//  NewPickImage
//
//  Created by Lim Liu on 2019/12/18.
//  Copyright © 2019 Liu. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)
- (CGFloat)calculateHeight:(CGFloat)maxWidth font:(CGFloat)fontSize
{
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [UIFont systemFontOfSize:fontSize];
    lab.numberOfLines = 0;
    lab.text = self;
    return [lab sizeThatFits:CGSizeMake(maxWidth, CGFLOAT_MAX)].height;
}

- (CGFloat)calculateWidth:(CGFloat)maxHeight font:(CGFloat)fontSize
{
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [UIFont systemFontOfSize:fontSize];
    lab.numberOfLines = 0;
    lab.text = self;
    return [lab sizeThatFits:CGSizeMake(CGFLOAT_MAX, maxHeight)].width;
}
@end
