//
//  QSYContactRemarkSettinViewController.m
//  House
//
//  Created by ysmeng on 15/4/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYContactRemarkSettinViewController.h"

@interface QSYContactRemarkSettinViewController ()

@property (nonatomic,copy) NSString *contactID;//!<联系人ID

@end

@implementation QSYContactRemarkSettinViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-04-13 16:04:24
 *
 *  @brief              根据联系人的ID创建备注联系人信息的页面
 *
 *  @param contactID    联系人ID
 *
 *  @return             返回当前创建的联系人备注页面
 *
 *  @since              1.0.0
 */
- (instancetype)initWithContactID:(NSString *)contactID
{

    if (self = [super init]) {
        
        ///保存联系人ID
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"备注信息"];
    
}

@end
