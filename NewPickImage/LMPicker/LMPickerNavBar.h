//
//  LMPickerNavBar.h
//  NewPickImage
//
//  Created by Lim Liu on 2019/12/18.
//  Copyright © 2019 Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LMPickerNavBar : UIView
@property (nonatomic, copy) void(^onDismissCallback)(void);
@property (nonatomic, copy) void(^onFinishCallback)(void);
@end

NS_ASSUME_NONNULL_END
