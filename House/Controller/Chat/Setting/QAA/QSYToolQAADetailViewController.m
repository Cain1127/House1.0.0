//
//  QSYToolQAADetailViewController.m
//  House
//
//  Created by ysmeng on 15/4/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYToolQAADetailViewController.h"

@interface QSYToolQAADetailViewController ()

@property (assign) QSSDETAIL_TYPE detailType;//!<文档类型

@end

@implementation QSYToolQAADetailViewController

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-04-13 15:04:03
 *
 *  @brief              说明/指南页面
 *
 *  @param detailType   当前的说明文档类型
 *
 *  @return             返回指定说明文档
 *
 *  @since              1.0.0
 */
- (instancetype)initWithDetailType:(QSSDETAIL_TYPE)detailType
{

    if (self = [super init]) {
        
        ///保存说明
        self.detailType = detailType;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"说明"];

}

@end
