////
////  GGAddressPickerHelper.m
////  YouYanChuApp
////
////  Created by James on 11/18/14.
////  Copyright (c) 2014 HGG. All rights reserved.
////
//
//#import "GGAddressPickerHelper.h"
//
//#define kMunicipality_Array @[@"北京", @"上海", @"天津", @"重庆"]
//
//static GGAddressPickerHelper *_helper;
//
//@interface GGAddressPickerHelper ()
//<
//    UIPickerViewDataSource,
//    UIPickerViewDelegate
//>
//
//@property (nonatomic, strong) UIPickerView *pickerView;
//@property (nonatomic, strong) UIView *containView;
//@property (nonatomic, strong) UIView *blackView;
//@property (nonatomic, strong) UIView *pickerToolbar;
//
////存储整理后的数据
//@property (nonatomic, strong) NSDictionary *areaDict;
//@property (nonatomic, strong) NSArray *areaArray;
//
////存储由字典整理得来的数组
//@property (nonatomic, strong) NSArray *cityArray;
//@property (nonatomic, strong) NSArray *provinceArray;
//@property (nonatomic, strong) NSArray *districtArray;
//
////存储初始的省市区
//@property (nonatomic, strong) NSString *presetProvince;
//@property (nonatomic, strong) NSString *presetCity;
//@property (nonatomic, strong) NSString *presetDistrict;
//
////存储选择的结果
//@property (nonatomic, strong) NSString *selectedProvince;
//@property (nonatomic, strong) NSString *selectedCity;
//@property (nonatomic, strong) NSString *selectedDistrict;
//
//@end
//
//@implementation GGAddressPickerHelper
//
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once (&onceToken, ^{
//        _helper = [GGAddressPickerHelper new];
//        _helper.pickerView = [UIPickerView new];
//        _helper.containView = [UIView new];
//        _helper.blackView = [UIView new];
//        _helper.pickerView.delegate = _helper;
//        _helper.pickerView.dataSource = _helper;
//        _helper.pickerToolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
//    });
//}
//
//+ (void)showPickerInView:(UIView *)view withStyle:(GGAddressPickerStyle)style province:(NSString *)province city:(NSString *)city district:(NSString *)district selectedClosure:(addressBlock)selectedClosure {
//    CGFloat width = view.width;
//    _helper.containView.frame = CGRectMake(0, 0, width, 216);
//    _helper.blackView.frame = view.bounds;
//    _helper.blackView.backgroundColor = [UIColor blackColor];
//    _helper.pickerStyle = style;
//    _helper.addressBlock = selectedClosure;
//    _helper.presetProvince = province ? province : @"";
//    _helper.presetCity = city ? city : @"";
//    _helper.presetDistrict = district ? district : @"";
//    
//    [_helper setupPickerViewWithProvince:_helper.presetProvince city:_helper.presetCity district:_helper.presetDistrict];
//    
//    [_helper.pickerToolbar setBackgroundColor:RGB(242, 242, 242)];
//    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 16, 36)];
//    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [cancelBtn setTitleColor:RGB(76, 76, 76) forState:UIControlStateNormal];
//    [cancelBtn addTarget:_helper action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 16, 36)];
//    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
//    [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [confirmBtn setTitleColor:RGB(213, 37, 51) forState:UIControlStateNormal];
//    [confirmBtn addTarget:_helper action:@selector(disMiss:) forControlEvents:UIControlEventTouchUpInside];
//    [_helper.pickerToolbar setWidth:width];
//    [_helper.pickerToolbar addSubview:cancelBtn];
//    [_helper.pickerToolbar addSubview:confirmBtn];
//    
//    [cancelBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
//    [cancelBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:30];
//    [confirmBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
//    [confirmBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:30];
//    
//    _helper.pickerView.frame = CGRectMake(0, 0, width, 216);
//    _helper.pickerView.backgroundColor = [UIColor whiteColor];
//    [_helper.containView addSubview:_helper.pickerView];
//    [_helper.containView addSubview:_helper.pickerToolbar];
//    [_helper showInView:view];
//}
//
////加载省市区数据并初始化
//- (void)setupPickerViewWithProvince:(NSString *)province city:(NSString *)city district:(NSString *)district {
//    
//    if (_helper.pickerStyle == GGAddressPickerWithProvinceCityAndDistrict) {
//        NSDictionary *areaDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"]];
//        _helper.areaDict = areaDict;
//        NSArray *sortedArray = [[areaDict allKeys] sortedArrayUsingComparator: ^NSComparisonResult(id obj1, id obj2) {
//            if ([obj1 integerValue] > [obj2 integerValue]) {
//                return (NSComparisonResult)NSOrderedDescending;
//            }
//            if ([obj1 integerValue] < [obj2 integerValue]) {
//                return (NSComparisonResult)NSOrderedAscending;
//            }
//            return (NSComparisonResult)NSOrderedSame;
//        }];
//        NSMutableArray *tempProvince = [NSMutableArray array];
//        for (int i = 0; i < [sortedArray count]; i++) {
//            NSArray *tmp = [areaDict[sortedArray[i]] allKeys];
//            [tempProvince addObject:[tmp objectAtIndex:0]];
//        }
//        _helper.provinceArray = [[NSArray alloc] initWithArray:tempProvince];
//        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:areaDict[sortedArray[0]][_helper.provinceArray[0]]];
//        NSDictionary *cityDict = [NSDictionary dictionaryWithDictionary:dict[[dict allKeys][0]]];
//        _helper.cityArray = [[NSArray alloc] initWithArray:[cityDict allKeys]];
//        _helper.districtArray = [[NSArray alloc] initWithArray:cityDict[_helper.cityArray[0]]];
//        
//        //James: 待添加设置 picker 初始位置的方法
//        
//        _helper.selectedProvince = _helper.provinceArray[0];
//        _helper.selectedCity = _helper.cityArray[0];
//        _helper.selectedDistrict = _helper.districtArray[0];
//    } else { //GGAddressPickerWithProvinceAndCity
//        NSArray *provinces =[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"profileArea" ofType:@"plist"]];
//        _helper.areaArray = provinces;
//        NSMutableArray *provinceArray = [NSMutableArray array];
//        for (int i = 0; i < provinces.count; i ++) {
//            [provinceArray addObject:provinces[i][@"State"]];
//        }
//        _helper.provinceArray = [provinceArray copy];
//        
//        NSInteger provinceRow;
//        if (![_helper.presetProvince isEqualToString:@""]) {
//            provinceRow = [_helper.provinceArray indexOfObject:province];
//            [_helper.pickerView selectRow:provinceRow inComponent:PROVINCE_COMPONENT animated:YES];
//            
//            NSMutableArray *cityArray = [NSMutableArray array];
//            for (int i = 0; i < [provinces[provinceRow][@"Cities"] count]; i++) {
//                [cityArray addObject:provinces[provinceRow][@"Cities"][i][@"city"]];
//            }
//            _helper.cityArray = [cityArray copy];
//            
//            [_helper.pickerView reloadAllComponents];
//            
//            if ([_helper.cityArray containsObject:_helper.presetCity]) {
//                [_helper.pickerView selectRow:[_helper.cityArray indexOfObject:_helper.presetCity] inComponent:CITY_COMPONENT animated:YES];
//            }
//            _helper.selectedProvince = _helper.presetProvince;
//            _helper.selectedCity = _helper.presetCity;
//        } else {
////            _helper.cityArray = @[];
////            if ([kMunicipality_Array containsObject:_helper.presetCity]) { //直辖市
////                [_helper.pickerView selectRow:[_helper.provinceArray indexOfObject:_helper.presetCity] inComponent:PROVINCE_COMPONENT animated:YES];
////                _helper.selectedProvince = _helper.presetCity;
////                _helper.selectedCity = @"";
////            } else {
////        }}
//            [_helper.pickerView selectRow:0 inComponent:PROVINCE_COMPONENT animated:YES];
//            _helper.selectedProvince = _helper.provinceArray[0];
//            NSMutableArray *cityArray = [NSMutableArray array];
//            for (int i = 0; i < [provinces[0][@"Cities"] count]; i++) {
//                [cityArray addObject:provinces[0][@"Cities"][i][@"city"]];
//            }
//            _helper.cityArray = [cityArray copy];
//            
//            [_helper.pickerView reloadAllComponents];
//            [_helper.pickerView selectRow:0 inComponent:CITY_COMPONENT animated:YES];
//            _helper.selectedCity = _helper.cityArray[0];
//        }
//    }
//}
//
//- (void)showInView:(UIView *)targetView{
//    [targetView addSubview:self.blackView];
//    [targetView addSubview:self.containView];
//    self.containView.top = targetView.height;
//    self.blackView.alpha = 0;
//    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.containView.bottom = targetView.height;
//        self.blackView.alpha = 0.3;
//        UITapGestureRecognizer *tapToSave = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction:)];
//        [self.blackView addGestureRecognizer:tapToSave];
//        self.blackView.userInteractionEnabled = YES;
//    } completion:NULL];
//}
//
//- (void)dismissWithAniamtion{
//    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.blackView.alpha = 0;
//        self.containView.top = self.blackView.superview.height;
//    } completion:^(BOOL finished) {
//        [self.blackView removeFromSuperview];
//        [self.containView removeFromSuperview];
//    }];
//}
//
//- (void)cancelAction:(id)sender{
//    [self dismissWithAniamtion];
//}
//
//- (void)disMiss:(id)sender{
//    if (self.addressBlock) {
//        switch (self.pickerStyle) {
//            case GGAddressPickerWithProvinceCityAndDistrict: {
//                self.addressBlock (self.selectedProvince, self.selectedCity, self.selectedDistrict);
//                break;
//            }
//            case GGAddressPickerWithProvinceAndCity: {
////                if ([@[@"北京", @"天津", @"上海", @"重庆"] containsObject:self.selectedProvince]) {
////                    self.selectedCity = self.selectedProvince;
////                    self.selectedProvince = @"";
////                }
//                self.addressBlock (self.selectedProvince, self.selectedCity, nil);
//                break;
//            }
//            default:
//                break;
//        }
//    }
//    [self dismissWithAniamtion];
//}
//
//#pragma mark - UIPickerViewDataSource
//
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    if (self.pickerStyle == GGAddressPickerWithProvinceCityAndDistrict) {
//        return GGAddressPickerWithProvinceCityAndDistrict;
//    } else { //GGAddressPickerWithProvinceAndCity
//        return GGAddressPickerWithProvinceAndCity;
//    }
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    if (self.pickerStyle == GGAddressPickerWithProvinceCityAndDistrict) {
//        switch (component) {
//            case 0: {
//                return self.provinceArray.count;
//                break;
//            }
//            case 1: {
//                return self.cityArray.count;
//                break;
//            }
//            case 2: {
//                return self.districtArray.count;
//                break;
//            }
//            default:
//                break;
//        }
//    } else { //GGAddressPickerWithProvinceAndCity
//        switch (component) {
//            case 0: {
//                return self.provinceArray.count;
//                break;
//            }
//            case 1: {
//                return self.cityArray.count;
//                break;
//            }
//            default:
//                break;
//        }
//    }
//    return 0;
//}
//
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (self.pickerStyle == GGAddressPickerWithProvinceCityAndDistrict) {
//        switch (component) {
//            case 0: {
//                return self.provinceArray[row];
//                break;
//            }
//            case 1: {
//                return self.cityArray[row];
//                break;
//            }
//            case 2: {
//                return self.districtArray[row];
//                break;
//            }
//            default:
//                break;
//        }
//    } else { //GGAddressPickerWithProvinceAndCity
//        switch (component) {
//            case 0: {
//                return self.provinceArray[row];
//                break;
//            }
//            case 1: {
//                return self.cityArray[row];
//                break;
//            }
//            default:
//                break;
//        }
//    }
//    return @"";
//}
//
//
//#pragma mark - UIPickerViewDelegate
//
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    if (self.pickerStyle == GGAddressPickerWithProvinceCityAndDistrict) {
//        if (component == PROVINCE_COMPONENT) {
//            self.selectedProvince = self.provinceArray[row];
//            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary:self.areaDict[@(row).stringValue]];
//            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:tmp[self.selectedProvince]];
//            NSArray *cityArray = [dic allKeys];
//            NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
//                
//                if ([obj1 integerValue] > [obj2 integerValue]) {
//                    return (NSComparisonResult)NSOrderedDescending;//递减
//                }
//                
//                if ([obj1 integerValue] < [obj2 integerValue]) {
//                    return (NSComparisonResult)NSOrderedAscending;//上升
//                }
//                return (NSComparisonResult) NSOrderedSame;
//            }];
//            
//            NSMutableArray *array = [[NSMutableArray alloc] init];
//            for (int i=0; i < [sortedArray count]; i++) {
//                NSArray *temp = [dic[sortedArray[i]] allKeys];
//                [array addObject:temp[0]];
//            }
//            
//            self.cityArray = [[NSArray alloc] initWithArray:array];
//            
//            NSDictionary *cityDic = dic[sortedArray[0]];
//            self.districtArray = [[NSArray alloc] initWithArray:cityDic[self.cityArray[0]]];
//            self.selectedCity = self.cityArray[0];
//            [self.pickerView selectRow:0 inComponent:CITY_COMPONENT animated:YES];
//            [self.pickerView reloadComponent:CITY_COMPONENT];
//            
//            self.selectedDistrict = self.districtArray[0];
//            [self.pickerView selectRow:0 inComponent:DISTRICT_COMPONENT animated:YES];
//            [self.pickerView reloadComponent:DISTRICT_COMPONENT];
//            
//        } else if (component == CITY_COMPONENT) {
//            self.selectedCity = self.cityArray[row];
//            NSString *provinceIndex = @([self.provinceArray indexOfObject:self.selectedProvince]).stringValue;
//            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary:self.areaDict[provinceIndex]];
//            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:tmp[self.selectedProvince]];
//            NSArray *dicKeyArray = [dic allKeys];
//            NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
//                
//                if ([obj1 integerValue] > [obj2 integerValue]) {
//                    return (NSComparisonResult)NSOrderedDescending;
//                }
//                
//                if ([obj1 integerValue] < [obj2 integerValue]) {
//                    return (NSComparisonResult)NSOrderedAscending;
//                }
//                return (NSComparisonResult)NSOrderedSame;
//            }];
//            
//            NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary:dic[sortedArray[row]]];
//            NSArray *cityKeyArray = [cityDic allKeys];
//            self.districtArray = [[NSArray alloc] initWithArray:cityDic[cityKeyArray[0]]];
//            self.selectedDistrict = self.districtArray[0];
//            [self.pickerView selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
//            [self.pickerView reloadComponent: DISTRICT_COMPONENT];
//        } else if (component == DISTRICT_COMPONENT) {
//            self.selectedDistrict = self.districtArray[row];
//        }
//    } else if (self.pickerStyle == GGAddressPickerWithProvinceAndCity) {
//        if (component == PROVINCE_COMPONENT) {
//            self.selectedProvince = self.provinceArray[row];
//            NSMutableArray *tmp = [NSMutableArray array];
//            for (int i = 0; i < [self.areaArray[row][@"Cities"] count]; i++) {
//                [tmp addObject:self.areaArray[row][@"Cities"][i][@"city"]];
//            }
//            self.cityArray = [tmp copy];
//            self.selectedCity = self.cityArray[0];
//            [self.pickerView selectRow:0 inComponent:CITY_COMPONENT animated:YES];
//            [self.pickerView reloadComponent:CITY_COMPONENT];
//        } else if (component == CITY_COMPONENT) {
//            self.selectedCity = self.cityArray[row];
//        }
//    }
//}
//
//
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    if (self.pickerStyle == GGAddressPickerWithProvinceCityAndDistrict) {
//        if (component == PROVINCE_COMPONENT) {
//            return 80;
//        }
//        else if (component == CITY_COMPONENT) {
//            return 100;
//        }
//        else {
//            return 115;
//        }
//    } else {
//        if (component == PROVINCE_COMPONENT) {
//            return 120;
//        } else if (component == CITY_COMPONENT){
//            return 120;
//        }
//    }
//    return 123;
//}
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UILabel *myView = nil;
//
//    if (self.pickerStyle == GGAddressPickerWithProvinceCityAndDistrict) {
//        if (component == PROVINCE_COMPONENT) {
//            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 78, 30)];
//            myView.adjustsFontSizeToFitWidth = YES;
//            myView.textAlignment = NSTextAlignmentLeft;
//            myView.text = self.provinceArray[row];
//            myView.font = [UIFont systemFontOfSize:16];
//            myView.backgroundColor = [UIColor clearColor];
//        } else if (component == CITY_COMPONENT) {
//            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, 30)];
//            myView.adjustsFontSizeToFitWidth = YES;
//            myView.textAlignment = NSTextAlignmentLeft;
//            myView.text = self.cityArray[row];
//            myView.font = [UIFont systemFontOfSize:16];
//            myView.backgroundColor = [UIColor clearColor];
//        } else if (component == DISTRICT_COMPONENT) {
//            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, 30)];
//            myView.adjustsFontSizeToFitWidth = YES;
//            myView.textAlignment = NSTextAlignmentLeft;
//            myView.text = self.districtArray[row];
//            myView.font = [UIFont systemFontOfSize:16];
//            myView.backgroundColor = [UIColor clearColor];
//        }
//    } else {
//        if (component == PROVINCE_COMPONENT) {
//            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 115, 30)];
//            myView.adjustsFontSizeToFitWidth = YES;
//            myView.textAlignment = NSTextAlignmentCenter;
//            myView.text = self.provinceArray[row];
//            myView.font = [UIFont systemFontOfSize:20];
//            myView.backgroundColor = [UIColor clearColor];
//        } else if (component == CITY_COMPONENT) {
//            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 115, 30)];
//            myView.adjustsFontSizeToFitWidth = YES;
//            myView.textAlignment = NSTextAlignmentCenter;
//            myView.text = self.cityArray[row];
//            myView.font = [UIFont systemFontOfSize:20];
//            myView.backgroundColor = [UIColor clearColor];
//        }
//    }
//    return myView;
//}
//
//
//
//@end
