//
//  CFunction.m
//  VStoreB
//
//  Created by LiuYimin on 16/1/7.
//  Copyright © 2016年 LiuYimin. All rights reserved.
//

#import "CFunction.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation CFunction

float transForWidth(float w) {
    return (w/375.f)*ScreenWidth;
}

float transForHeight(float h) {
    return (h/667.f)*ScreenHeight;
}

bool isNotNilNull(id json) {
    if (json == [NSNull null]) {
        return NO;
    }
    if (json == nil) {
        return NO;
    }
    return YES;
}

bool isNotNilNullClass(id json,Class cls) {
    if (!isNotNilNull(json)) {
        return NO;
    }
    if ([json isKindOfClass:cls]) {
        return YES;
    }else {
        return NO;
    }
}

id checkNilNull(id json) {
    if (isNotNilNull(json)) {
        return json;
    }else {
        return @"";
    }
}

bool isValidateMobile(NSString *mobile) {
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|145|147|170|176|177|178)+\\d{8})$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}



@end
