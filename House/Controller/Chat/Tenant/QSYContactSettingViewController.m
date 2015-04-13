//
//  QSYContactSettingViewController.m
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYContactSettingViewController.h"
#import "QSYContactRemarkSettinViewController.h"

@interface QSYContactSettingViewController ()

@property (nonatomic,copy) NSString *contactID;//!<联系人ID

@end

@implementation QSYContactSettingViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-04-13 15:04:00
 *
 *  @brief              根据联系人的ID，创建联系人信息设置页面
 *
 *  @param contactID    联系人ID
 *
 *  @return             返回当前创建的联系人设置页面
 *
 *  @since              1.0.0
 */
- (instancetype)initWithContactID:(NSString *)contactID
{

    if (self = [super init]) {
        
        ///保存投诉人的ID
        self.contactID = contactID;
        
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"资料设置"];

}

@end
