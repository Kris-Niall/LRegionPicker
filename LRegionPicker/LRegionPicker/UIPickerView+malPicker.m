//
//  UIPickerView+malPicker.m
//  LRegionPicker
//
//  Created by ZERO on 2018/8/7.
//  Copyright © 2018年 com.ZERO.podstest. All rights reserved.
//

#import "UIPickerView+malPicker.h"

@implementation UIPickerView (malPicker)


- (void)clearSpearatorLine
{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.frame.size.height < 1)
        {
            [obj setBackgroundColor:[UIColor clearColor]];
        }
    }];
}

@end
