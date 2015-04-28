//
//  QSYMySettingChangeMobileViewController.m
//  House
//
//  Created by ysmeng on 15/4/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYMySettingChangeMobileViewController.h"

@interface QSYMySettingChangeMobileViewController ()

@property (nonatomic,copy) NSString *oldPhone;//!<原手机

///手机号码变更后的回调
@property (nonatomic,copy) void(^phoneChangeCallBack)(BOOL isChange,NSString *newPhone);

@end

@implementation QSYMySettingChangeMobileViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-04-28 14:04:54
 *
 *  @brief          创建一个修改用户手机的页面
 *
 *  @param phone    当前手机号码
 *  @param callBack 修改后的回调
 *
 *  @return         返回当前创建的手机号码变更页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPhone:(NSString *)phone andCallBack:(void(^)(BOOL isChange,NSString *newPhone))callBack
{

    if (self = [super init]) {
        
        self.oldPhone = phone;
        self.phoneChangeCallBack = callBack;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"修改手机号码"];

}

@end
