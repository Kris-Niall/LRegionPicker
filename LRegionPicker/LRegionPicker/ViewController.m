//
//  ViewController.m
//  LRegionPicker
//
//  Created by ZERO on 2018/8/6.
//  Copyright © 2018年 com.ZERO.podstest. All rights reserved.
//

#import "ViewController.h"
#import "AddressView.h"

@interface ViewController ()<AddressDelegate>
@property (strong, nonatomic) AddressView      *addressViewTwo;
@property (strong, nonatomic) AddressView      *addressViewThree;

@property (weak, nonatomic) IBOutlet UILabel *regionLabel1;

@property (weak, nonatomic) IBOutlet UILabel *regionLabel2;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.addressViewTwo = [[AddressView alloc] initWith:AddressListTwoLine];
    self.addressViewTwo.delegate = self;
    
    self.addressViewThree = [[AddressView alloc] initWith:AddressListThreeLine];
    self.addressViewThree.delegate = self;
    
    
}
- (IBAction)selectActions:(UIButton *)sender {
    [_addressViewTwo showInView];
}

- (IBAction)selectAction:(UIButton *)sender {
    [_addressViewThree showInView];
}

#pragma -------   三级联动地区选择代理
-(void)reback:(AddressView *)addressView Pro:(NSString *)pro City:(NSString *)city Area:(NSString *)area ProId:(NSString *)proId CityId:(NSString *)cityId AreaId:(NSString *)areaId{
    
    if (addressView == self.addressViewTwo) {
        NSString *region = [NSString stringWithFormat:@"%@%@", pro, city];
        self.regionLabel1.text = region;

    }
    
    if (addressView == self.addressViewThree) {
        NSString *region = [NSString stringWithFormat:@"%@%@%@", pro, city, area];
        self.regionLabel2.text = region;
    }
    
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
