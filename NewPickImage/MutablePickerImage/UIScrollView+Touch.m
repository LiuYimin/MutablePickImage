//
//  UIScrollView+Touch.m
//  NewPickImage
//
//  Created by Liu on 16/7/28.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import "UIScrollView+Touch.h"
#import <objc/runtime.h>

@implementation UIScrollView (Touch)

const char * key;

- (void)setProhibitScrollView:(BOOL)prohibitScrollView {
    objc_setAssociatedObject(self, &key, [NSNumber numberWithBool:prohibitScrollView], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)prohibitScrollView {
    return [objc_getAssociatedObject(self, &key) boolValue];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.dragging)
    {
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.dragging)
    {
        [[self nextResponder] touchesMoved:touches withEvent:event];
    }
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.dragging)
    {
        [[self nextResponder] touchesEnded:touches withEvent:event];
    }
    [super touchesEnded:touches withEvent:event];
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    if (self.prohibitScrollView) {
//        return NO;
//    }
//    return NO;
//    return [super gestureRecognizerShouldBegin:gestureRecognizer];
//}




@end
