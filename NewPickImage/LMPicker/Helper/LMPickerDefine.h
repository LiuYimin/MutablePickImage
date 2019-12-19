//
//  LMPickerDefine.h
//  NewPickImage
//
//  Created by Lim Liu on 2019/12/18.
//  Copyright © 2019 Liu. All rights reserved.
//

#ifndef LMPickerDefine_h
#define LMPickerDefine_h

#define WeakSelf  __weak __typeof(self)weakSelf = self
#define __kWidth            [UIScreen mainScreen].bounds.size.width
#define __kHeight           [UIScreen mainScreen].bounds.size.height
#define __kWindow           [UIApplication sharedApplication].delegate.window
#define __kIsiPhoneX  ({\
    BOOL ret = NO;\
    if(@available(iOS 11.0, *)) {\
        if ([[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 0.0) ret = YES;\
    }else {\
        ret = NO;\
    }\
    ret;\
})
#define __kNavHeight        (__kIsiPhoneX?88:64)
#define __kTabHeight        (__kIsiPhoneX?82:49)
#define RGB(r,g,b)          [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r,g,b,a)       [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define CRGB(r,g,b)         RGB(r,g,b).CGColor
#define CRGBA(r,g,b,a)      RGBA(r,g,b,a).CGColor
#define RGBS(s)             RGB(s,s,s)
#define ColorFromHex(s)   [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]


#endif /* LMPickerDefine_h */
