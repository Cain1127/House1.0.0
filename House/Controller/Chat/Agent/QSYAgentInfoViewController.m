//
//  QSYAgentInfoViewController.m
//  House
//
//  Created by ysmeng on 15/3/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYAgentInfoViewController.h"

@interface QSYAgentInfoViewController ()

@property (nonatomic,copy) NSString *agentName; //!<经纪人名
@property (nonatomic,copy) NSString *agentID;   //!<经纪ID

@end

@implementation QSYAgentInfoViewController

#pragma mark - 初始化
- (instancetype)initWithName:(NSString *)agentName andAgentID:(NSString *)agentID
{

    if (self = [super init]) {
        
        ///保存信息
        self.agentID = agentID;
        self.agentName = agentName;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{
    
    [super createNavigationBarUI];
    [self setNavigationBarTitle:self.agentName];
    
}

@end
