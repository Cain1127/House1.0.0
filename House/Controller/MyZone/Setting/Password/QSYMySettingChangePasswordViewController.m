//
//  QSYMySettingChangePasswordViewController.m
//  House
//
//  Created by ysmeng on 15/4/12.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYMySettingChangePasswordViewController.h"

@interface QSYMySettingChangePasswordViewController ()

@property (nonatomic,copy) NSString *oldPassword;//!<原密码

///密码修改后的回调
@property (nonatomic,copy) void(^passwordChangeCallBack)(BOOL isChange,NSString *newPsw);

@end

@implementation QSYMySettingChangePasswordViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-04-28 14:04:59
 *
 *  @brief          创建一个密码修改页面
 *
 *  @param psw      原密码
 *  @param callBack 修改后的回调
 *
 *  @return         返回当前创建的修改密码页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPassword:(NSString *)psw andCallBack:(void(^)(BOOL isChange,NSString *newPsw))callBack
{

    if (self = [super init]) {
        
        self.oldPassword = psw;
        self.passwordChangeCallBack = callBack;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"修改账户密码"];

}

- (void)createMainShowUI
{

    

}

@end
