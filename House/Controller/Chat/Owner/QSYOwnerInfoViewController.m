//
//  QSYOwnerInfoViewController.m
//  House
//
//  Created by ysmeng on 15/3/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYOwnerInfoViewController.h"

@interface QSYOwnerInfoViewController ()

@property (nonatomic,copy) NSString *ownerName; //!<业主名
@property (nonatomic,copy) NSString *ownerID;   //!<业主ID

@end

@implementation QSYOwnerInfoViewController

#pragma mark - 初始化
- (instancetype)initWithName:(NSString *)ownerName  andOwnerID:(NSString *)ownerID
{

    if (self = [super init]) {
        
        ///保存业主信息
        self.ownerID = ownerID;
        self.ownerName = ownerName;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:self.ownerName];

}

@end
