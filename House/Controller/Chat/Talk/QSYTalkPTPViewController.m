//
//  QSYTalkPTPViewController.m
//  House
//
//  Created by ysmeng on 15/3/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYTalkPTPViewController.h"
#import "QSYAgentInfoViewController.h"
#import "QSYOwnerInfoViewController.h"

#import "QSBlockButtonStyleModel+NavigationBar.h"

#import "QSUserSimpleDataModel.h"

#import "MJRefresh.h"

@interface QSYTalkPTPViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

///对话人的数据
@property (nonatomic,retain) QSUserSimpleDataModel *userModel;

@property (nonatomic,strong) UIView *rootView;                  //!<底view，方便滑动
@property (nonatomic,strong) UITableView *messagesListView;     //!<消息列表view
@property (nonatomic,retain) NSMutableArray *messagesDataSource;//!<消息数据

@end

@implementation QSYTalkPTPViewController

#pragma mark - 初始化
- (instancetype)initWithUserModel:(QSUserSimpleDataModel *)userModel;
{

    if (self = [super init]) {
        
        ///保存对话人
        self.userModel = userModel;
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:self.userModel.username];
    
    ///查看联系人详情
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeUserDetail];
    
    UIButton *userDetailButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断用户类型
        if (uUserCountTypeAgency == [self.userModel.user_type intValue]) {
            
            QSYAgentInfoViewController *agentInfoVC = [[QSYAgentInfoViewController alloc] initWithName:self.userModel.username andAgentID:self.userModel.id_];
            [self.navigationController pushViewController:agentInfoVC animated:YES];
            
        }
        
        if (uUserCountTypeOwner == [self.userModel.user_type intValue]) {
            
            QSYOwnerInfoViewController *ownerInfoVC = [[QSYOwnerInfoViewController alloc] initWithName:self.userModel.username andOwnerID:self.userModel.id_];
            [self.navigationController pushViewController:ownerInfoVC animated:YES];
            
        }
        
    }];
    [self setNavigationBarRightView:userDetailButton];

}

- (void)createMainShowUI
{

    ///底view，方便弹出键盘时，往上滑动
    self.rootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f)];
    [self.view addSubview:self.rootView];
    
    ///消息列表
    self.messagesListView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, self.rootView.frame.size.height - 50.0f) style:UITableViewStylePlain];
    
    ///取消滚动条
    self.messagesListView.showsHorizontalScrollIndicator = NO;
    self.messagesListView.showsVerticalScrollIndicator = NO;
    
    ///取消分隔样式
    self.messagesListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    ///设置数据源
    self.messagesListView.dataSource = self;
    self.messagesListView.delegate = self;
    
    [self.rootView addSubview:self.messagesListView];
    
    [self.messagesListView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadUnReadMessage)];
    [self.messagesListView.header beginRefreshing];
    
    ///分隔线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.rootView.frame.size.height - 50.0f, SIZE_DEVICE_WIDTH, 0.25f)];
    lineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.rootView addSubview:lineLabel];
    
    ///相机
    UIButton *cameraButton = [UIButton createBlockButtonWithFrame:CGRectMake(5.0f, self.rootView.frame.size.height - 47.0f, 44.0f, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///弹出图片选择，或拍照
        
        
    }];
    [cameraButton setImage:[UIImage imageNamed:IMAGE_CHAT_PHOTO_NORMAL] forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:IMAGE_CHAT_PHOTO_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [self.rootView addSubview:cameraButton];
    
    ///文字输入框
    UITextField *inputField = [[UITextField alloc] initWithFrame:CGRectMake(cameraButton.frame.origin.x + cameraButton.frame.size.width + 5.0f, self.rootView.frame.size.height - 45.0f, self.rootView.frame.size.width - 20.0f - 88.0f, 40.0f)];
    inputField.borderStyle = UITextBorderStyleRoundedRect;
    inputField.delegate = self;
    inputField.placeholder = @"请输入信息……";
    inputField.returnKeyType = UIReturnKeySend;
    [self.rootView addSubview:inputField];
    
    ///音频
    UIButton *soundButton = [UIButton createBlockButtonWithFrame:CGRectMake(self.rootView.frame.size.width - 5.0f - 44.0f, self.rootView.frame.size.height - 47.0f, 44.0f, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///进入录制音频
        
        
    }];
    [soundButton setImage:[UIImage imageNamed:IMAGE_CHAT_SOUND_NORMAL] forState:UIControlStateNormal];
    [soundButton setImage:[UIImage imageNamed:IMAGE_CHAT_SOUND_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [self.rootView addSubview:soundButton];
    
    ///注册键盘弹出和回收的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboarShowAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboarHideAction:) name:UIKeyboardWillHideNotification object:nil];

}

#pragma mark - 键盘弹出和回收
- (void)keyboarShowAction:(NSNotification *)sender
{
    
    //上移：需要知道键盘高度和移动时间
    CGRect keyBoardRect = [[sender.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval anTime;
    [[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&anTime];
    CGRect frame = CGRectMake(self.rootView.frame.origin.x,
                              64.0f - keyBoardRect.size.height,
                              self.rootView.frame.size.width,
                              self.rootView.frame.size.height);
    [UIView animateWithDuration:anTime animations:^{
        
        self.rootView.frame = frame;
        
    }];
    
}

- (void)keyboarHideAction:(NSNotification *)sender
{
    
    NSTimeInterval anTime;
    [[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&anTime];
    CGRect frame = CGRectMake(self.rootView.frame.origin.x,
                              64.0f,
                              self.rootView.frame.size.width,
                              self.rootView.frame.size.height);
    [UIView animateWithDuration:anTime animations:^{
        
        self.rootView.frame = frame;
        
    }];
    
}

#pragma mark - 消息数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.messagesDataSource count];

}

#pragma mark - 消息显示的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ///根据消息的类型，返回不同的高度
    return 44.0f;

}

#pragma mark - 返回消息
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *wordsCell = @"wordsCell";
    UITableViewCell *cellNormaMessage = [tableView dequeueReusableCellWithIdentifier:wordsCell];
    if (nil == cellNormaMessage) {
        
        cellNormaMessage = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:wordsCell];
        
        ///取消选择样式
        cellNormaMessage.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    ///刷新数据
    
    return cellNormaMessage;

}

#pragma mark - 获取离线消息
- (void)loadUnReadMessage
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.messagesListView.header endRefreshing];
        
    });

}

#pragma mark - 点击发送按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    
    ///发送消息
    
    return YES;

}

@end