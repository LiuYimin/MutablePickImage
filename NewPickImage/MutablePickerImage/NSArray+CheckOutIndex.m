//
//  NSArray+CheckOutIndex.m
//  NewPickImage
//
//  Created by Liu on 16/7/29.
//  Copyright © 2016年 Liu. All rights reserved.
//

#import "NSArray+CheckOutIndex.h"

@implementation NSArray (CheckOutIndex)

- (id)objectAtIndexCheck:(NSUInteger)index {
    if (self.count <= index) {
        return nil;
    }
    
    if (index < 0) {
        return nil;
    }
    
    return [self objectAtIndex:index];
}

@end
