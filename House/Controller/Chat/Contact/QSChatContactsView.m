//
//  QSChatContactsView.m
//  House
//
//  Created by ysmeng on 15/2/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSChatContactsView.h"

#import "QSBlockButtonStyleModel+Normal.h"

#import "QSCoreDataManager+User.h"

@interface QSChatContactsView ()

@property (nonatomic,assign) USER_COUNT_TYPE userType;//!<用户类型

@end

@implementation QSChatContactsView

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-02-09 11:02:22
 *
 *  @brief          根据用户类型创建联系人列表
 *
 *  @param frame    大小和位置
 *  @param userType 用户类型
 *
 *  @return         返回当前创建的联系人列表
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andUserType:(USER_COUNT_TYPE)userType
{
    
    if (self = [super initWithFrame:frame]) {
        
        ///保存类型
        self.userType = userType;
        
        ///搭建UI
        [self createChatContactsUI];
        
    }
    
    return self;
    
}

#pragma mark - UI搭建
///UI搭建
- (void)createChatContactsUI
{

    ///判断是否已登录
    if ([QSCoreDataManager isLogin]) {
        
        ///创建已登录的联系人列表
        [self createLoginedUI];
        
    } else {
    
        ///直接显示无联系人
        [self createNoContactUI:NO];
    
    }

}

///已登录时，先请求数据，再创建列表
- (void)createLoginedUI
{

    

}

///创建无联系人页面
- (void)createNoContactUI:(BOOL)flag
{

    ///提示图片
    QSImageView *tipsImageView = [[QSImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0f - 37.5f, 80.0f, 75.0f, 85.0f)];
    tipsImageView.image = [UIImage imageNamed:IMAGE_CHAT_NOCONTACTS];
    [self addSubview:tipsImageView];
    
    ///提示信息
    UILabel *tipsLabel = [[QSLabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0f - 60.0f, tipsImageView.frame.origin.y + tipsImageView.frame.size.height + 20.0f, 120.0f, 30.0f)];
    tipsLabel.text = flag ? @"您暂无联系人" : @"请先登录";
    tipsLabel.font = [UIFont boldSystemFontOfSize:22.0f];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = COLOR_CHARACTERS_BLACK;
    [self addSubview:tipsLabel];
    
    ///按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
    buttonStyle.title = @"看看二手房源";
    UIButton *lookButton = [UIButton createBlockButtonWithFrame:CGRectMake(30.0f, tipsLabel.frame.origin.y + tipsLabel.frame.size.height + 35.0f, SIZE_DEVICE_WIDTH - 60.0f, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        
        
    }];
    [self addSubview:lookButton];

}

@end
