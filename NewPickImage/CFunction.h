//
//  CFunction.h
//  VStoreB
//
//  Created by LiuYimin on 16/1/7.
//  Copyright © 2016年 LiuYimin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CFunction : NSObject

float transForWidth(float w);
float transForHeight(float h);
bool isNotNilNullClass(id json,Class cls);
bool isNotNilNull(id json);
id checkNilNull(id json);
bool isValidateMobile(NSString *mobile);

@end
