//
//  AddressView.m
//
//  Created by ZERO on 16/1/16.
//  Copyright © 2016年 ly. All rights reserved.//
//

#import <UIKit/UIKit.h>

@class AddressView;

typedef NS_ENUM(NSInteger, AddressListType){
    AddressListTwoLine = 0,   // 二级
    AddressListThreeLine,     // 三级
};

@protocol AddressDelegate <NSObject>

- (void)reback:(AddressView *)addressView Pro:(NSString *)pro City:(NSString *)city Area:(NSString *)area ProId:(NSString  *)proId CityId:(NSString *)cityId AreaId:(NSString  *)areaId;

@optional

- (void)SelectId:(AddressView *)addressView Pro:(NSString  *)proId City:(NSString  *)cityId Area:(NSString  *)areaId;


@end


@interface AddressView : UIView
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIView       *shadowView;// 阴影

- (instancetype)initWith:(AddressListType)type;

@property (nonatomic, copy) NSString *province; // 选中省份
@property (nonatomic, copy) NSString *city;  // 选中城市
@property (nonatomic, copy) NSString *area;  // 选中地区

- (void)cancelPicker;   // 完成
- (void)dismissPicker; // 退出
- (void)showInView;

@property (nonatomic, assign)id <AddressDelegate> delegate;

@property (nonatomic, assign) AddressListType type;


@end
