//
//  AddressView.m
//
//  Created by ZERO on 16/1/16.
//  Copyright © 2016年 ly. All rights reserved.//

#import "AddressView.h"
#import "UIPickerView+malPicker.h"

#define IPHONE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define IPHONE_HEIGHT ([UIScreen mainScreen].bounds.size.height)


@interface AddressView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) NSMutableArray *provinceArray;
@property (nonatomic, strong) NSMutableArray *cityArray;    // 城市数据
@property (nonatomic, strong) NSMutableArray *areaArray;    // 区信息
@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (nonatomic, strong) NSString *ProId;
@property (nonatomic, strong) NSString *CityId;
@property (nonatomic, strong) NSString *AreaId;

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView       *lineView;
/** 全部省*/
@property (nonatomic, strong) NSArray *allPro;
/** 全部市*/
@property (nonatomic, strong) NSArray *allCity;
/** 全部区*/
@property (nonatomic, strong) NSArray *allArea;

@end

@implementation AddressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWith:(AddressListType)type{
    self = [super init];
    if (self) {
        
        self.shadowView = [UIView new];
        self.shadowView.frame = [UIScreen mainScreen].bounds;
        self.shadowView.backgroundColor = [UIColor blackColor];
        self.shadowView.alpha = 0;
        self.shadowView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPicker)];
        [self.shadowView addGestureRecognizer:tap];
        
        self.backgroundColor = [UIColor whiteColor];
        self.bounds = CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 20, 284);
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 44, self.bounds.size.width, self.bounds.size.height - 44)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
  
        
        self.lineView = [UIView new];
        self.lineView.frame = CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 20, 44);
        _lineView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        
        UIView *bottoml = [UIView new];
        bottoml.frame = CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width - 20, 1);
        bottoml.backgroundColor = [UIColor colorWithRed:231/255.0 green:232/255.0 blue:234/255.0 alpha:1];
        [self.lineView addSubview:bottoml];

        UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftbtn.frame = CGRectMake(0, 0, 43, 44);
        leftbtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [leftbtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        [leftbtn addTarget:self action:@selector(dismissPicker) forControlEvents:UIControlEventTouchUpInside];
        [self.lineView addSubview:leftbtn];
        
        UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightbtn.frame = CGRectMake(self.lineView.frame.size.width - 45, 0, 43, 44);
        rightbtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [rightbtn setImage:[UIImage imageNamed:@"icon_ensure"] forState:UIControlStateNormal];
        [rightbtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self.lineView addSubview:rightbtn];
        
  
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.center = CGPointMake(self.lineView.center.x, self.lineView.center.y);
        titleLabel.text = @"请选择城市";
        [titleLabel setFont:[UIFont systemFontOfSize:15]];
        [titleLabel setTextColor:[UIColor blackColor]];
        [self.lineView addSubview:titleLabel];
        
        [self addSubview:self.lineView];
        
        // 选中行view
        UIView *view = [UIView new];
        view.userInteractionEnabled = YES;
        view.frame = CGRectMake(0, 105, [UIScreen mainScreen].bounds.size.width - 20, 30);
        view.backgroundColor = [UIColor lightGrayColor];
        view.alpha = 0.2;
        [_pickerView addSubview:view];
        
        self.type = type;

        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"AddressView.bundle" ofType:nil];
        NSBundle *AddressBundle = [[NSBundle alloc]initWithPath:bundlePath];
        
        NSString *provincePath = [AddressBundle pathForResource:@"province" ofType:@"plist"];
        self.allPro = [[NSArray alloc] initWithContentsOfFile:provincePath];
        [_allPro enumerateObjectsUsingBlock:^(NSDictionary  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.provinceArray addObject:obj];
        }];
        
        NSString *cityPath = [AddressBundle pathForResource:@"city" ofType:@"plist"];
        self.allCity = [[NSArray alloc] initWithContentsOfFile:cityPath];
        [_allCity enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"i_province_id"] isEqualToString:[self->_provinceArray firstObject][@"id"] ]) {
                [self.cityArray addObject:obj];
            }
        }];
        
        if (type == AddressListThreeLine) {
            NSString *countyPath = [AddressBundle pathForResource:@"county" ofType:@"plist"];
            self.allArea = [[NSArray alloc] initWithContentsOfFile:countyPath];
            [_allArea enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj[@"i_city_id"] isEqualToString:[self->_cityArray firstObject][@"nvc_code"] ]) {
                    [self.areaArray addObject:obj];
                }
            }];
        }
        
        [self addSubview:_pickerView];

        self.province = @"北京市";
        self.ProId = @"110000";
        self.city = @"";
        self.CityId = @"110100";
        self.area = @"昌平区";
        self.AreaId = @"110114";
    }
    return self;
}

- (void)click{
    [self cancelPicker];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.type == AddressListThreeLine) {
        return 3;
    }
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.provinceArray.count;
    }else if(component == 1) {
        return self.cityArray.count;
    }else{
        return self.areaArray.count;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    

    if (component == 0) {
        [self.cityArray removeAllObjects];
   
        [_allCity enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"i_province_id"] isEqualToString:self->_allPro[row][@"id"] ]) {
                [self.cityArray addObject:obj];
            }
        }];
        
        if (self.type == AddressListThreeLine) {
            [self.areaArray removeAllObjects];
            for (NSDictionary *dic in _allArea) {
                if ([dic[@"i_city_id"] isEqualToString:[self.cityArray firstObject][@"nvc_code"] ]) {
                    [self.areaArray addObject:dic];
                }
            }
        }
        
        [pickerView reloadComponent:1];
        if (self.type == AddressListThreeLine) {
            [pickerView reloadComponent:2];
        }
        [pickerView selectRow:0 inComponent:1 animated:YES];
        if (self.type == AddressListThreeLine) {
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
    }else if (component == 1) {
        if (self.type == AddressListThreeLine) {
            [self.areaArray removeAllObjects];
 
            [_allArea enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj[@"i_city_id"] isEqualToString:self.cityArray[row][@"nvc_code"] ]) {
                    [self.areaArray addObject:obj];
                }
            }];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
    }else{
        
    }
    
    NSInteger index = [_pickerView selectedRowInComponent:0];
    NSInteger index1 = [_pickerView selectedRowInComponent:1];
    
    self.province = self.provinceArray[index][@"province"];
    self.ProId = self.provinceArray[index][@"id"];
    
    if (self.cityArray.count != 0) {
        self.city = self.cityArray[index1][@"nvc_name"];
        self.CityId = self.cityArray[index1][@"nvc_code"];
    }

    if (self.type == AddressListThreeLine) {
        NSInteger index2 = [_pickerView selectedRowInComponent:2];
        
        if (self.areaArray.count != 0) {
            self.area = self.areaArray[index2][@"nvc_name"];
            self.AreaId = self.areaArray[index2][@"nvc_code"];
        }else{
            self.area = @"";
        }
    }
    

}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return self.provinceArray[row][@"province"];
    }else if(component == 1){
        return self.cityArray[row][@"nvc_name"];
    }else{
        if (self.areaArray.count != 0) {
            return self.areaArray[row][@"nvc_name"];
        }else{
            return nil;
        }
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    [pickerView clearSpearatorLine];// 去分割线
    
    UILabel *lbl = [UILabel new];
    lbl.textAlignment = 1;
    if (component == 0) {
        lbl.text = [_provinceArray objectAtIndex:row][@"province"];
    }else if(component == 1){
        lbl.text = [_cityArray objectAtIndex:row][@"nvc_name"];
    }else{
        lbl.text = [_areaArray objectAtIndex:row][@"nvc_name"];
    }
    
    return lbl;
}
- (void)showInView
{
    self.frame = CGRectMake(10, self.shadowView.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(10, self.shadowView.frame.size.height - self.frame.size.height - 20, self.frame.size.width, self.frame.size.height);
        self.shadowView.alpha = 0.5;
    }];
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self.shadowView];
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    
}
- (void)dismissPicker{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(10, IPHONE_HEIGHT, self.frame.size.width, self.frame.size.height);
                         self.shadowView.alpha = 0;
                         
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         [self.shadowView removeFromSuperview];
                     }];

}
- (void)cancelPicker
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(10, IPHONE_HEIGHT, self.frame.size.width, self.frame.size.height);
                         self.shadowView.alpha = 0;

                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         // 处理直辖市
                         if ([self.city isEqualToString:@"北京市"]||[self.city isEqualToString:@"天津市"]||[self.city isEqualToString:@"上海市"]||[self.city isEqualToString:@"重庆市"]) {
                             self.city = @"";
                         }
                         
                         
                         if ([self.delegate respondsToSelector:@selector(reback:Pro:City:Area:ProId:CityId:AreaId:)]) {
                              [self.delegate reback:self Pro:self.province City:self.city Area:self.area ProId:self.ProId CityId:self.CityId AreaId:self.AreaId];
                         }
                        
                         if ([self.delegate respondsToSelector:@selector(SelectId:Pro:City:Area:)]) {
                             [self.delegate SelectId:self Pro:self.ProId City:self.CityId Area:self.AreaId];
                         }
                         
                         NSLog(@"省:%@   市:%@   县:%@",self.province,self.city, self.area);
                         [self.shadowView removeFromSuperview];
                     }];
    
}

- (NSMutableArray *)provinceArray{
    if (!_provinceArray) {
        self.provinceArray = [@[] mutableCopy];
    }
    return _provinceArray;
}

- (NSMutableArray *)cityArray{
    if (!_cityArray) {
        self.cityArray = [@[] mutableCopy];
    }
    return _cityArray;
}
- (NSMutableArray *)areaArray{
    if (!_areaArray) {
        self.areaArray = [@[] mutableCopy];
    }
    return _areaArray;
}
- (NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        self.selectedArray = [@[] mutableCopy];
    }
    return _selectedArray;
}
-(NSString *)ProId{
    if (!_ProId) {
        _ProId = @"";
    }
    return _ProId;
}

-(NSString *)CityId{
    if (!_CityId) {
        _CityId = @"";
    }
    return _CityId;
}

-(NSString *)AreaId{
    if (!_AreaId) {
        _AreaId = @"";
    }
    return _AreaId;
}

- (NSString *)province{
    if (!_province) {
        _province = @"";
    }
    return  _province;
}

- (NSString *)city{
    if (!_city) {
        _city = @"";
    }
    return _city;
}

- (NSString *)area{
    if (!_area) {
        _area = @"";
    }
    return _area;
}

@end
