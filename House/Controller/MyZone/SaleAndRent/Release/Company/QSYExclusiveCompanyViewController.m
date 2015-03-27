//
//  QSYExclusiveCompanyViewController.m
//  House
//
//  Created by ysmeng on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYExclusiveCompanyViewController.h"

@interface QSYExclusiveCompanyViewController ()

///选择一家独家公司后的回调
@property (nonatomic,copy) void(^pickedExclusiveCompanyCallBack)(BOOL isPicked,id params);

@end

@implementation QSYExclusiveCompanyViewController

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-03-27 16:03:23
 *
 *  @brief          创建一个独家公司选择窗口
 *
 *  @param callBack 选择独家公司后的回调
 *
 *  @return         返回当前创建的独家公司列表页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithPickedCallBack:(void(^)(BOOL isPicked,id params))callBack
{

    if (self = [super init]) {
        
        ///保存回调
        if (callBack) {
            
            self.pickedExclusiveCompanyCallBack = callBack;
            
        }
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"独家公司"];
    
}

@end
