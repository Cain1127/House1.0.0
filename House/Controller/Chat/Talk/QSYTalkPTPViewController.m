//
//  QSYTalkPTPViewController.m
//  House
//
//  Created by ysmeng on 15/3/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYTalkPTPViewController.h"
#import "QSYTenantInfoViewController.h"
#import "QSYOwnerInfoViewController.h"
#import "QSSecondHouseDetailViewController.h"
#import "QSRentHouseDetailViewController.h"
#import "QSYShowImageDetailViewController.h"

#import "QSYMessageWordTableViewCell.h"
#import "QSYMessageVideoTableViewCell.h"
#import "QSYMessagePictureTableViewCell.h"
#import "QSYMessageRecommendHouseTableViewCell.h"
#import "QSYRecordSoundTipsPopView.h"

#import "QSBlockButtonStyleModel+NavigationBar.h"
#import "QSBlockButtonStyleModel+Normal.h"
#import "NSString+Format.h"
#import "NSString+Calculation.h"
#import "NSDate+Formatter.h"
#import "NSString+Calculation.h"

#import "QSSocketManager.h"
#import "QSCoreDataManager+User.h"

#import "QSUserSimpleDataModel.h"
#import "QSUserDataModel.h"
#import "QSYSendMessageWord.h"
#import "QSYSendMessageVideo.h"
#import "QSYSendMessagePicture.h"
#import "QSYSendMessageRecommendHouse.h"

#import "MJRefresh.h"

#import "UIImage+Orientaion.h"
#import "UIImage+Thumbnail.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface QSYTalkPTPViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,retain) QSUserSimpleDataModel *userModel;              //!<当前聊天对象数据模型
@property (nonatomic,retain) QSUserDataModel *myUserModel;                  //!<当前用户数据模型
@property (atomic,assign) BOOL isLocalMessage;                              //!<是否获取本地保存的消息

@property (nonatomic,strong) UIView *normalInputRootView;                   //!<普通消息发送功能底view
@property (nonatomic,strong) UIView *soundInputRootView;                    //!<语音消息发送功能底view
@property (nonatomic,strong) QSYRecordSoundTipsPopView *recordView;         //!<录音时的提示view
@property (nonatomic,strong) UITableView *messagesListView;                 //!<消息列表view
@property (nonatomic,strong) UILabel *noNetworkTipsLabel;                   //!<没有网络时的提示
@property (nonatomic,retain) NSMutableArray *messagesDataSource;            //!<消息数据

@end

@implementation QSYTalkPTPViewController

#pragma mark - 初始化
- (instancetype)initWithUserModel:(QSUserSimpleDataModel *)userModel;
{

    if (self = [super init]) {
        
        ///保存对话人
        self.userModel = userModel;
        
        ///初始化消息获取的类型
        self.isLocalMessage = NO;
        
        ///保存当前用户的信息
        self.myUserModel = [QSCoreDataManager getCurrentUserDataModel];
        
        ///初始化数据源
        self.messagesDataSource = [[NSMutableArray alloc] init];
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    
    ///计算姓名显示的宽度
    CGFloat widthTitle = [self.userModel.username calculateStringDisplayWidthByFixedHeight:44.0f andFontSize:FONT_NAVIGATIONBAR_TITLE];
    widthTitle = widthTitle > 160.0f ? 160.0f : (widthTitle < 40.0f ? 40.0f : widthTitle);
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - widthTitle) / 2.0f, 20.0f, widthTitle, 44.0f)];
    nameLabel.text = self.userModel.username;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont boldSystemFontOfSize:FONT_NAVIGATIONBAR_TITLE];
    nameLabel.textColor = COLOR_CHARACTERS_GRAY;
    [self.view addSubview:nameLabel];
    
    ///VIP标识
    if ([self.userModel.level intValue] == 3) {
        
        QSImageView *vipImage = [[QSImageView alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width, nameLabel.frame.origin.y + 11.0f, 20.0f, 20.0f)];
        vipImage.image = [UIImage imageNamed:IMAGE_PUBLIC_VIP];
        [self.view addSubview:vipImage];
        
    }
    
    ///查看联系人详情
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNavigationBarButtonStyleWithType:nNavigationBarButtonLocalTypeRight andButtonType:nNavigationBarButtonTypeUserDetail];
    
    UIButton *userDetailButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///判断用户类型
        if (uUserCountTypeAgency == [QSCoreDataManager getUserType]) {
            
            QSYTenantInfoViewController *agentInfoVC = [[QSYTenantInfoViewController alloc] initWithName:self.userModel.username andAgentID:self.userModel.id_];
            [self.navigationController pushViewController:agentInfoVC animated:YES];
            
        }
        
        ///普通房客户，则进入普通房客页面
        if (uUserCountTypeTenant == [self.userModel.user_type intValue]) {
            
            QSYTenantInfoViewController *agentInfoVC = [[QSYTenantInfoViewController alloc] initWithName:self.userModel.username andAgentID:self.userModel.id_];
            [self.navigationController pushViewController:agentInfoVC animated:YES];
            
        }
        
        if (uUserCountTypeOwner == [self.userModel.user_type intValue]) {
            
            QSYOwnerInfoViewController *ownerInfoVC = [[QSYOwnerInfoViewController alloc] initWithName:self.userModel.username andOwnerID:self.userModel.id_ andDefaultHouseType:fFilterMainTypeSecondHouse];
            [self.navigationController pushViewController:ownerInfoVC animated:YES];
            
        }
        
    }];
    [self setNavigationBarRightView:userDetailButton];

}

- (void)createMainShowUI
{
    
    ///无网络状态提示
    self.noNetworkTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, 0.0f)];
    self.noNetworkTipsLabel.alpha = 0.0f;
    self.noNetworkTipsLabel.backgroundColor = COLOR_CHARACTERS_LIGHTGRAY;
    self.noNetworkTipsLabel.textColor = COLOR_CHARACTERS_BLACK;
    self.noNetworkTipsLabel.text = @"当前网络未连接，请检查你的网络设置";
    self.noNetworkTipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.noNetworkTipsLabel];
    
    ///消息列表
    self.messagesListView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 64.0f - 50.0f) style:UITableViewStylePlain];
    
    ///取消滚动条
    self.messagesListView.showsHorizontalScrollIndicator = NO;
    self.messagesListView.showsVerticalScrollIndicator = NO;
    
    ///取消分隔样式
    self.messagesListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    ///设置数据源
    self.messagesListView.dataSource = self;
    self.messagesListView.delegate = self;
    
    [self.view addSubview:self.messagesListView];
    [self.messagesListView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadUnReadMessage)];
    
    ///分隔线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEVICE_HEIGHT - 50.0f, SIZE_DEVICE_WIDTH, 0.25f)];
    lineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.view addSubview:lineLabel];
    
    ///普通消息发送功能底view
    self.normalInputRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEVICE_HEIGHT - 49.0f, SIZE_DEVICE_WIDTH, 49.0f)];
    [self.view addSubview:self.normalInputRootView];
    
    ///文字输入框
    __block UITextField *inputField;
    
    ///相机
    UIButton *cameraButton = [UIButton createBlockButtonWithFrame:CGRectMake(5.0f, 2.0f, 44.0f, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///回收键盘
        [inputField resignFirstResponder];
        
        ///弹出提示
        UIActionSheet *pickedImageAskSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [pickedImageAskSheet showInView:self.view];
        
    }];
    [cameraButton setImage:[UIImage imageNamed:IMAGE_CHAT_PHOTO_NORMAL] forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:IMAGE_CHAT_PHOTO_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [self.normalInputRootView addSubview:cameraButton];
    
    ///文字输入框
    inputField = [[UITextField alloc] initWithFrame:CGRectMake(cameraButton.frame.origin.x + cameraButton.frame.size.width + 5.0f, 4.5f, self.normalInputRootView.frame.size.width - 20.0f - 88.0f, 40.0f)];
    inputField.borderStyle = UITextBorderStyleRoundedRect;
    inputField.delegate = self;
    inputField.placeholder = @"请输入信息……";
    inputField.returnKeyType = UIReturnKeySend;
    [self.normalInputRootView addSubview:inputField];
    
    ///音频
    UIButton *soundButton = [UIButton createBlockButtonWithFrame:CGRectMake(self.normalInputRootView.frame.size.width - 5.0f - 44.0f, 2.0f, 44.0f, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///进入录制音频
        [UIView animateWithDuration:0.3f animations:^{
            
            self.normalInputRootView.frame = CGRectMake(self.normalInputRootView.frame.origin.x, SIZE_DEVICE_HEIGHT - 2.0f * self.normalInputRootView.frame.size.height, self.normalInputRootView.frame.size.width, self.normalInputRootView.frame.size.height);
            self.normalInputRootView.alpha = 0.0f;
            
            self.soundInputRootView.frame = CGRectMake(self.soundInputRootView.frame.origin.x, SIZE_DEVICE_HEIGHT - self.soundInputRootView.frame.size.height, self.soundInputRootView.frame.size.width, self.soundInputRootView.frame.size.height);
            self.soundInputRootView.alpha = 1.0f;
            
        }];
        
    }];
    [soundButton setImage:[UIImage imageNamed:IMAGE_CHAT_SOUND_NORMAL] forState:UIControlStateNormal];
    [soundButton setImage:[UIImage imageNamed:IMAGE_CHAT_SOUND_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [self.normalInputRootView addSubview:soundButton];
    
    ///发送语音功能底view
    self.soundInputRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEVICE_HEIGHT + 49.0f, SIZE_DEVICE_WIDTH, 49.0f)];
    self.soundInputRootView.alpha = 0.0f;
    [self.view addSubview:self.soundInputRootView];
    
    ///返回
    UIButton *soundBackButton = [UIButton createBlockButtonWithFrame:CGRectMake(5.0f, 2.0f, 44.0f, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///返回普通输入
        [UIView animateWithDuration:0.3f animations:^{
            
            self.normalInputRootView.frame = CGRectMake(self.normalInputRootView.frame.origin.x, SIZE_DEVICE_HEIGHT - self.normalInputRootView.frame.size.height, self.normalInputRootView.frame.size.width, self.normalInputRootView.frame.size.height);
            self.normalInputRootView.alpha = 1.0f;
            
            self.soundInputRootView.frame = CGRectMake(self.soundInputRootView.frame.origin.x, SIZE_DEVICE_HEIGHT + self.soundInputRootView.frame.size.height, self.soundInputRootView.frame.size.width, self.soundInputRootView.frame.size.height);
            self.soundInputRootView.alpha = 0.0f;
            
        }];
        
    }];
    [soundBackButton setImage:[UIImage imageNamed:IMAGE_CHAT_SOUND_BACK_NORMAL] forState:UIControlStateNormal];
    [soundBackButton setImage:[UIImage imageNamed:IMAGE_CHAT_SOUND_BACK_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [self.soundInputRootView addSubview:soundBackButton];
    
    ///按住录音按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhite];
    buttonStyle.title = @"按住录音";
    buttonStyle.titleFont = [UIFont systemFontOfSize:FONT_BODY_14];
    buttonStyle.titleNormalColor = COLOR_CHARACTERS_GRAY;
    buttonStyle.titleHightedColor = COLOR_CHARACTERS_YELLOW;
    
    UIButton *recordSoundButton = [UIButton createBlockButtonWithFrame:CGRectMake(soundBackButton.frame.origin.x + soundBackButton.frame.size.width + 5.0f, 7.0f, self.soundInputRootView.frame.size.width - 20.0f - 88.0f, 35.0f) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {}];
    [self.soundInputRootView addSubview:recordSoundButton];
    [recordSoundButton addTarget:self action:@selector(recordSoundBeginAction:) forControlEvents:UIControlEventTouchDown];
    [recordSoundButton addTarget:self action:@selector(recordSoundCheckDataAction:) forControlEvents:UIControlEventTouchUpInside];
    [recordSoundButton addTarget:self action:@selector(recordSoundCancelAction:) forControlEvents:UIControlEventTouchUpOutside];
    
    ///将功能view移到背后
    [self.view sendSubviewToBack:self.normalInputRootView];
    [self.view sendSubviewToBack:self.soundInputRootView];
    
    ///注册消息监听
    [QSSocketManager registCurrentTalkMessageNotificationWithUserID:self.userModel.id_ andCallBack:^(BOOL flag, id messageModel) {
        
        ///绑定消息回调
        [self addNewMessage:messageModel];
        
        ///排序
        [self resortCurrentMessage];
        
        ///刷新消息列表
        [self.messagesListView reloadData];
        
        ///显示最后一行
        if ([self.messagesDataSource count] > 5) {
            
            [self.messagesListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.messagesDataSource count] - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
        }
        
    }];
    
    ///注册无网络监听
    [QSSocketManager registCurrentSocketLinkStatusNotification:^(BOOL isLink) {
        
        ///回收提示
        if (isLink) {
            
            ///判断
            if (self.noNetworkTipsLabel.frame.size.height > 10.0f) {
                
                ///销定用户操作
                self.view.userInteractionEnabled = NO;
                [UIView animateWithDuration:0.3f animations:^{
                    
                    self.noNetworkTipsLabel.alpha = 0.0f;
                    self.noNetworkTipsLabel.frame = CGRectMake(self.noNetworkTipsLabel.frame.origin.x, self.noNetworkTipsLabel.frame.origin.y, self.noNetworkTipsLabel.frame.size.width, 0.0f);
                    self.messagesListView.frame = CGRectMake(self.messagesListView.frame.origin.x, 64.0f, self.messagesListView.frame.size.width, SIZE_DEVICE_HEIGHT - 64.0f - 50.0f);
                    
                } completion:^(BOOL finished) {
                    
                    self.view.userInteractionEnabled = YES;
                    
                }];
                
            }
            
        } else {
            
            ///判断
            if (self.noNetworkTipsLabel.frame.size.height > 10.0f) {
                
                return;
                
            }
        
            ///弹出提示
            self.view.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.3f animations:^{
                
                self.noNetworkTipsLabel.alpha = 1.0f;
                self.noNetworkTipsLabel.frame = CGRectMake(self.noNetworkTipsLabel.frame.origin.x, self.noNetworkTipsLabel.frame.origin.y, self.noNetworkTipsLabel.frame.size.width, 44.0f);
                self.messagesListView.frame = CGRectMake(self.messagesListView.frame.origin.x, 64.0f + 44.0f, self.messagesListView.frame.size.width, SIZE_DEVICE_HEIGHT - 64.0f - 50.0f - 44.0f);
                
            } completion:^(BOOL finished) {
                
                self.view.userInteractionEnabled = YES;
                
            }];
        
        }
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        ///开始就请求历史数据
        [self.messagesListView.header beginRefreshing];
        
    });

}

///返回录单view
- (QSYRecordSoundTipsPopView *)recordView
{

    if (nil == _recordView) {
        
        _recordView = [[QSYRecordSoundTipsPopView alloc] initWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - 115.0f) / 2.0f, (SIZE_DEVICE_HEIGHT - 115.0f) / 2.0f, 115.0f, 115.0f) withUserID:self.userModel.id_];
        _recordView.alpha = 0.0f;
        
    }
    
    return _recordView;

}

#pragma mark - 录音
- (void)recordSoundBeginAction:(UIButton *)button
{

    ///按下时
    [self.view addSubview:self.recordView];
    
    ///显示录音图标
    [UIView animateWithDuration:0.3f animations:^{
        
        self.recordView.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            [self.recordView starRecordingSoundMessage];
            
        }
        
    }];

}

- (void)recordSoundCheckDataAction:(UIButton *)button
{

    ///判断
    if (self.recordView) {
        
        ///判断是否存在数据
        [self.recordView stopRecordingSoundMessage];
        if (self.recordView.isHaveSoundData) {
            
            QSYSendMessageVideo *tempModel = [self.recordView starSendingSoundMessage:self.userModel];
            
            ///判断消息是否有效
            if (tempModel) {
                
                ///发送消息
                [QSSocketManager sendMessageToPerson:tempModel andMessageType:qQSCustomProtocolChatMessageTypeVideo];
                
                ///绑定消息回调
                [self.messagesDataSource addObject:tempModel];
                
                ///刷新数据
                [self.messagesListView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.messagesDataSource count] - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
                
                [self.messagesListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.messagesDataSource count] - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                
            }
            
            ///隐藏录音
            [self recordSoundCancelAction:button];
            
        } else {
        
            [self recordSoundCancelAction:button];
        
        }
        
    }

}

- (void)recordSoundCancelAction:(UIButton *)button
{

    if (self.recordView) {
        
        [self.recordView stopRecordingSoundMessage];
        [UIView animateWithDuration:0.3f animations:^{
            
            self.recordView.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            
            [self.recordView removeFromSuperview];
            self.recordView = nil;
            
        }];
        
    }

}

#pragma mark - 消息按时间排序
- (void)resortCurrentMessage
{

    [self.messagesDataSource sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSYSendMessageBaseModel *firstMessgae = obj1;
        QSYSendMessageBaseModel *secondMessgae = obj2;
        return [firstMessgae.timeStamp floatValue] > [secondMessgae.timeStamp floatValue];
        
    }];

}

#pragma mark - 添加消息
- (void)addNewMessage:(QSYSendMessageBaseModel *)newMessage
{

    for (QSYSendMessageBaseModel *obj in self.messagesDataSource) {
        
        if ([obj.msgID isEqualToString:newMessage.msgID]) {
            
            return;
            
        }
        
    }
    
    [self.messagesDataSource addObject:newMessage];

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
    QSYSendMessageBaseModel *tempModel = self.messagesDataSource[indexPath.row];
    
    ///30表示消息体的上下各15间隙；23:表示时间戳信息的高度+时间戳和头像之间的间距
    return tempModel.showHeight + 30.0f + 23.0f;

}

#pragma mark - 返回消息
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ///消息类型
    QSYSendMessageBaseModel *tempModel = self.messagesDataSource[indexPath.row];
    
    switch (tempModel.msgType) {
            ///文字聊天
        case qQSCustomProtocolChatMessageTypeWord:
        {
            
            ///消息归属类型
            if ([tempModel.fromID isEqualToString:self.myUserModel.id_]) {
                
                static NSString *wordsMessageMYCell = @"myMessageWord";
                QSYMessageWordTableViewCell *cellWordsMesssageMYCell = [tableView dequeueReusableCellWithIdentifier:wordsMessageMYCell];
                if (nil == cellWordsMesssageMYCell) {
                    
                    cellWordsMesssageMYCell = [[QSYMessageWordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:wordsMessageMYCell andMessageType:mMessageFromTypeMY];
                    
                    ///取消选择样式
                    cellWordsMesssageMYCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                
                QSYSendMessageWord *wordModel = (QSYSendMessageWord *)tempModel;
                [cellWordsMesssageMYCell updateMessageWordUI:wordModel];
                
                return cellWordsMesssageMYCell;
                
            } else {
                
                static NSString *wordsMessageFromCell = @"fromMessageWord";
                QSYMessageWordTableViewCell *cellWordsMessageFrom = [tableView dequeueReusableCellWithIdentifier:wordsMessageFromCell];
                if (nil == cellWordsMessageFrom) {
                    
                    cellWordsMessageFrom = [[QSYMessageWordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:wordsMessageFromCell andMessageType:mMessageFromTypeFriends];
                    
                    ///取消选择样式
                    cellWordsMessageFrom.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                
                QSYSendMessageWord *wordModel = (QSYSendMessageWord *)tempModel;
                [cellWordsMessageFrom updateMessageWordUI:wordModel];
                
                return cellWordsMessageFrom;
                
            }
            
        }
            break;
            
            ///图片聊天
        case qQSCustomProtocolChatMessageTypePicture:
            
            ///消息归属类型
            if ([tempModel.fromID isEqualToString:self.myUserModel.id_]) {
                
                static NSString *pictureMessageMYCell = @"myMessagePicture";
                QSYMessagePictureTableViewCell *cellPictureMessageMY = [tableView dequeueReusableCellWithIdentifier:pictureMessageMYCell];
                if (nil == cellPictureMessageMY) {
                    
                    cellPictureMessageMY = [[QSYMessagePictureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pictureMessageMYCell andMessageType:mMessageFromTypeMY];
                    
                    ///取消选择样式
                    cellPictureMessageMY.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                
                QSYSendMessagePicture *wordModel = (QSYSendMessagePicture *)tempModel;
                [cellPictureMessageMY updateMessageWordUI:wordModel];
                
                ///查看大图
                cellPictureMessageMY.lookOriginalImage = ^(UIImage *image){
                
                    if (image) {
                        
                        QSYShowImageDetailViewController *imageVC = [[QSYShowImageDetailViewController alloc] initWithImage:image andTitle:@"原图" andType:sShowImageOriginalVCTypeSingleEdit andCallBack:^(SHOW_IMAGE_ORIGINAL_ACTION_TYPE actionType, id deleteObject, int deleteIndex) {
                            
                        }];
                        [self.navigationController pushViewController:imageVC animated:YES];
                        
                    }
                
                };
                
                return cellPictureMessageMY;
                
            } else {
                
                static NSString *pictureMessageFromCell = @"fromMessagePicture";
                QSYMessagePictureTableViewCell *cellPictureMessageFrom = [tableView dequeueReusableCellWithIdentifier:pictureMessageFromCell];
                if (nil == cellPictureMessageFrom) {
                    
                    cellPictureMessageFrom = [[QSYMessagePictureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pictureMessageFromCell andMessageType:mMessageFromTypeFriends];
                    
                    ///取消选择样式
                    cellPictureMessageFrom.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                
                QSYSendMessagePicture *wordModel = (QSYSendMessagePicture *)tempModel;
                [cellPictureMessageFrom updateMessageWordUI:wordModel];
                
                return cellPictureMessageFrom;
                
            }
            break;
            
            ///音频聊天
        case qQSCustomProtocolChatMessageTypeVideo:
        {
            
            ///消息归属类型
            if ([tempModel.fromID isEqualToString:self.myUserModel.id_]) {
                
                static NSString *videoMessageMYCell = @"myMessageVideo";
                QSYMessageVideoTableViewCell *cellVideoMessageMY = [tableView dequeueReusableCellWithIdentifier:videoMessageMYCell];
                if (nil == cellVideoMessageMY) {
                    
                    cellVideoMessageMY = [[QSYMessageVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoMessageMYCell andMessageType:mMessageFromTypeMY];
                    
                    ///取消选择样式
                    cellVideoMessageMY.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                
                QSYSendMessageVideo *wordModel = (QSYSendMessageVideo *)tempModel;
                [cellVideoMessageMY updateMessageWordUI:wordModel];
                
                return cellVideoMessageMY;
                
            } else {
                
                static NSString *videoMessageFromCell = @"fromMessageVideo";
                QSYMessageVideoTableViewCell *cellVideoMessageFrom = [tableView dequeueReusableCellWithIdentifier:videoMessageFromCell];
                if (nil == cellVideoMessageFrom) {
                    
                    cellVideoMessageFrom = [[QSYMessageVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoMessageFromCell andMessageType:mMessageFromTypeFriends];
                    
                    ///取消选择样式
                    cellVideoMessageFrom.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                
                QSYSendMessageVideo *wordModel = (QSYSendMessageVideo *)tempModel;
                [cellVideoMessageFrom updateMessageWordUI:wordModel];
                
                return cellVideoMessageFrom;
                
            }
            
        }
            break;
            
            ///推荐房源
        case qQSCustomProtocolChatMessageTypeRecommendHouse:
        {
            
            ///消息归属类型
            if ([tempModel.fromID isEqualToString:self.myUserModel.id_]) {
                
                static NSString *wordsMessageMYCell = @"myMessageRecommend";
                QSYMessageRecommendHouseTableViewCell *cellWordsMesssageMYCell = [tableView dequeueReusableCellWithIdentifier:wordsMessageMYCell];
                if (nil == cellWordsMesssageMYCell) {
                    
                    cellWordsMesssageMYCell = [[QSYMessageRecommendHouseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:wordsMessageMYCell andMessageType:mMessageFromTypeMY];
                    
                    ///取消选择样式
                    cellWordsMesssageMYCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                
                QSYSendMessageRecommendHouse *wordModel = (QSYSendMessageRecommendHouse *)tempModel;
                [cellWordsMesssageMYCell updateMessageWordUI:wordModel];
                
                ///单击进入房源详情
                cellWordsMesssageMYCell.singleTapCallBack = ^(void){
                
                    ///进入出租房详情
                    if (fFilterMainTypeRentalHouse == [wordModel.houseType intValue]) {
                        
                        QSRentHouseDetailViewController *detailVC = [[QSRentHouseDetailViewController alloc] initWithTitle:wordModel.title andDetailID:wordModel.houseID];
                        [self.navigationController pushViewController:detailVC animated:YES];
                        return;
                        
                    }
                    
                    ///进入二手房详情
                    if (fFilterMainTypeSecondHouse == [wordModel.houseType intValue]) {
                        
                        QSSecondHouseDetailViewController *detailVC = [[QSSecondHouseDetailViewController alloc] initWithTitle:wordModel.title andDetailID:wordModel.houseID];
                        [self.navigationController pushViewController:detailVC animated:YES];
                        return;
                        
                    }
                
                };
                
                return cellWordsMesssageMYCell;
                
            } else {
                
                static NSString *wordsMessageFromCell = @"fromMessageRecommend";
                QSYMessageRecommendHouseTableViewCell *cellWordsMessageFrom = [tableView dequeueReusableCellWithIdentifier:wordsMessageFromCell];
                if (nil == cellWordsMessageFrom) {
                    
                    cellWordsMessageFrom = [[QSYMessageRecommendHouseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:wordsMessageFromCell andMessageType:mMessageFromTypeFriends];
                    
                    ///取消选择样式
                    cellWordsMessageFrom.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                
                QSYSendMessageRecommendHouse *wordModel = (QSYSendMessageRecommendHouse *)tempModel;
                [cellWordsMessageFrom updateMessageWordUI:wordModel];
                
                ///单击进入房源详情
                cellWordsMessageFrom.singleTapCallBack = ^(void){
                    
                    ///进入出租房详情
                    if (fFilterMainTypeRentalHouse == [wordModel.houseType intValue]) {
                        
                        QSRentHouseDetailViewController *detailVC = [[QSRentHouseDetailViewController alloc] initWithTitle:wordModel.title andDetailID:wordModel.houseID];
                        [self.navigationController pushViewController:detailVC animated:YES];
                        return;
                        
                    }
                    
                    ///进入二手房详情
                    if (fFilterMainTypeSecondHouse == [wordModel.houseType intValue]) {
                        
                        QSSecondHouseDetailViewController *detailVC = [[QSSecondHouseDetailViewController alloc] initWithTitle:wordModel.title andDetailID:wordModel.houseID];
                        [self.navigationController pushViewController:detailVC animated:YES];
                        return;
                        
                    }
                    
                };
                
                return cellWordsMessageFrom;
                
            }
            
        }
            break;
            
        default:
            break;
    }
    
    static NSString *normalCell = @"normalCell";
    UITableViewCell *cellNormaMessage = [tableView dequeueReusableCellWithIdentifier:normalCell];
    
    if (nil == cellNormaMessage) {
        
        cellNormaMessage = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalCell];
        
    }
    
    return cellNormaMessage;

}

#pragma mark - 获取离线消息
- (void)loadUnReadMessage
{

    ///获取内存消息
    if (!self.isLocalMessage) {
        
        NSArray *unReadMessageList = [QSSocketManager getSpecialPersonMessage:self.userModel.id_];
        if ([unReadMessageList count] > 0) {
            
            [self.messagesDataSource addObjectsFromArray:unReadMessageList];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.messagesListView reloadData];
                
                if ([self.messagesDataSource count] > 0) {
                    
                    ///显示最后一行
                    [self.messagesListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.messagesDataSource count] - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    
                }
                
                [self.messagesListView.header endRefreshing];
                
            });
            
        } else {
        
            [self loadLocalSaveUnReadMessage];
        
        }
        
        ///修改聊天消息的标识
        self.isLocalMessage = YES;
        
    } else {
        
        [self loadLocalSaveUnReadMessage];
    
    }

}

- (void)loadLocalSaveUnReadMessage
{

    ///获取本地保存消息
    QSYSendMessageBaseModel *tempModel = [self.messagesDataSource count] > 0 ? self.messagesDataSource[0] : nil;
    NSArray *localMessageList = [QSSocketManager getSpecialPersonLocalMessage:self.userModel.id_ andStarTimeStamp:tempModel.timeStamp];
    if ([localMessageList count] > 0) {
        
        for (int i = (int)[localMessageList count]; i > 0; i--) {
            
            [self.messagesDataSource insertObject:localMessageList[i-1] atIndex:0];
            
        }
        
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.messagesListView reloadData];
        
        if ([self.messagesDataSource count] > 0) {
            
            ///显示最后一行
            [self.messagesListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.messagesDataSource count] - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
        }
        
        [self.messagesListView.header endRefreshing];
        
    });

}

#pragma mark - 点击发送按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    
    ///判断是否存在文字消息
    if ([textField.text length] > 0) {
        
        ///保存消息
        NSString *sendMessage = [NSString stringWithString:textField.text];
        textField.text = nil;
        
        QSYSendMessageWord *wordMessageModel = [[QSYSendMessageWord alloc] init];
        wordMessageModel.msgType = qQSCustomProtocolChatMessageTypeWord;
        wordMessageModel.fromID = APPLICATION_NSSTRING_SETTING(self.myUserModel.id_,@"-1");
        wordMessageModel.toID = APPLICATION_NSSTRING_SETTING(self.userModel.id_,@"-1");
        
        QSYSendMessageBaseModel *lastMessage = [self.messagesDataSource lastObject];
        wordMessageModel.deviceUUID = APPLICATION_NSSTRING_SETTING(lastMessage.deviceUUID,@"-1");
        wordMessageModel.message = APPLICATION_NSSTRING_SETTING(sendMessage,@"-1");
        wordMessageModel.timeStamp = APPLICATION_NSSTRING_SETTING([NSDate currentDateTimeStamp],@"-1");
        
        wordMessageModel.f_name = APPLICATION_NSSTRING_SETTING(self.myUserModel.username,@"-1");
        wordMessageModel.f_avatar = APPLICATION_NSSTRING_SETTING(self.myUserModel.avatar,@"-1");
        wordMessageModel.f_leve = APPLICATION_NSSTRING_SETTING(self.myUserModel.level,@"-1");
        wordMessageModel.f_user_type = APPLICATION_NSSTRING_SETTING(self.myUserModel.user_type,@"-1");
        
        wordMessageModel.t_name = APPLICATION_NSSTRING_SETTING(self.userModel.username,@"-1");
        wordMessageModel.t_avatar = APPLICATION_NSSTRING_SETTING(self.userModel.avatar,@"-1");
        wordMessageModel.t_leve = APPLICATION_NSSTRING_SETTING(self.userModel.level,@"-1");
        wordMessageModel.t_user_type = APPLICATION_NSSTRING_SETTING(self.userModel.user_type,@"-1");
        
        CGFloat showHeight = 30.0f;
        CGFloat showWidth = [sendMessage calculateStringDisplayWidthByFixedHeight:showHeight andFontSize:FONT_BODY_16];
        if (showWidth > (SIZE_DEVICE_WIDTH * 3.0f / 5.0f - 20.0f)) {
            
            showWidth = (SIZE_DEVICE_WIDTH * 3.0f / 5.0f - 20.0f);
            showHeight = [sendMessage calculateStringDisplayHeightByFixedWidth:showWidth andFontSize:FONT_BODY_16];
            
        }
        
        showWidth = showWidth + 20.0f;
        showHeight = showHeight + 20.0f;
        wordMessageModel.showWidth = showWidth;
        wordMessageModel.showHeight = showHeight;
        
        ///显示当前自已发送的消息
        [self.messagesDataSource addObject:wordMessageModel];
        
        ///刷新消息列表
        [self.messagesListView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.messagesDataSource count] - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
        
        ///显示最后一行
        [self.messagesListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.messagesDataSource count] - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        ///发送消息
        [QSSocketManager sendMessageToPerson:wordMessageModel andMessageType:qQSCustomProtocolChatMessageTypeWord];
        
    }
    
    return YES;

}

#pragma mark - 选择图片时相册/拍照提示
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    ///从新拍照
    if (0 == buttonIndex) {
        
        ///拍照：如果是要准备进行拍照，一定要判断设备是否支持拍照
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera]) {
            
            ///如果是拍照
            [self loadImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
            
        } else {
            
            ///如果不支持拍照
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"当前设备不支持拍照", 1.0f, ^(){})
            
        }
        
    }
    
    ///从相册选择图片
    if (1 == buttonIndex) {
        
        //需要判断是否支持取本地相册
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            //如果支持取本地相册：则调用本地相册
            [self loadImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            
        } else {
            
            ///如果不支持读取相册
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"无法获取本地相册", 1.0f, ^(){})
            
        }
        
    }
    
}

#pragma mark - 拍照或者从相册中选择图片
///拍照 和 取本地相册，都是一个代理，不过是区分资源
///UIImagePickerController 这是管理本地的控件器
///UIImagePickerControllerSourceTypePhotoLibrary : 相册
///UIImagePickerControllerSourceTypeCamera : 照相机
///UIImagePickerControllerSourceTypeSavedPhotosAlbum : 胶卷
- (void)loadImageWithSourceType:(UIImagePickerControllerSourceType)type
{
    if (type == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        //根据不同的资源类型，加载不同的界面
        UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
        pickVC.delegate = self;
        pickVC.sourceType = type;
        pickVC.allowsEditing = YES;//允许编辑
        
        //用模式跳转窗体
        [self presentViewController:pickVC animated:YES completion:^{}];
        
    } else if(type == UIImagePickerControllerSourceTypeCamera){
        
        //根据不同的资源类型，加载不同的界面
        UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
        pickVC.delegate = self;
        pickVC.sourceType = type;
        pickVC.allowsEditing = YES;//允许编辑
        
        //用模式跳转窗体
        [self presentViewController:pickVC animated:YES completion:^{}];
        
    }
    
}

#pragma mark - 获取拍照/本地图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    /*
     *  将图片转化成NSData 存入应用的沙盒中
     */
    NSString *sourceType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([sourceType isEqualToString:(NSString *)kUTTypeImage]) {
        
        ///原图片
        UIImage *pickedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
        
        ///修改图片
        UIImage *rightImage = [pickedImage fixOrientation:pickedImage];
        
        ///压缩图片
        UIImage *smallImage = [rightImage thumbnailWithSize:CGSizeMake(SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT * 0.5f)];
        
        ///获取时间戳
        NSString *timeStamp = [NSDate currentDateTimeStamp];
        NSString *rootPath = [self getTalkImageSavePath];
        NSString *savePath = [rootPath stringByAppendingString:timeStamp];
        NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.2f);
        
        ///保存本地
        BOOL isSave = [imageData writeToFile:savePath atomically:YES];
        if (!isSave) {
            
            ///提示发送失败
            TIPS_ALERT_MESSAGE_ANDTURNBACK(@"发送失败", 1.5f, ^(){})
            return;
            
        }
        
        ///保存图片消息
        QSYSendMessagePicture *pictureMessageModel = [[QSYSendMessagePicture alloc] init];
        pictureMessageModel.msgType = qQSCustomProtocolChatMessageTypePicture;
        pictureMessageModel.fromID = APPLICATION_NSSTRING_SETTING(self.myUserModel.id_, @"-1");
        pictureMessageModel.toID = APPLICATION_NSSTRING_SETTING(self.userModel.id_,@"-1");
        
        QSYSendMessageBaseModel *lastMessage = [self.messagesDataSource lastObject];
        pictureMessageModel.deviceUUID = APPLICATION_NSSTRING_SETTING(lastMessage.deviceUUID,@"-1");
        pictureMessageModel.pictureURL = APPLICATION_NSSTRING_SETTING(savePath,@"-1");
        
        pictureMessageModel.timeStamp = [NSDate currentDateTimeStamp];
        
        pictureMessageModel.f_name = APPLICATION_NSSTRING_SETTING(self.myUserModel.username,@"-1");
        pictureMessageModel.f_avatar = APPLICATION_NSSTRING_SETTING(self.myUserModel.avatar,@"-1");
        pictureMessageModel.f_leve = APPLICATION_NSSTRING_SETTING(self.myUserModel.level,@"-1");
        pictureMessageModel.f_user_type = APPLICATION_NSSTRING_SETTING(self.myUserModel.user_type,@"-1");
        
        pictureMessageModel.t_name = APPLICATION_NSSTRING_SETTING(self.userModel.username,@"-1");
        pictureMessageModel.t_avatar = APPLICATION_NSSTRING_SETTING(self.userModel.avatar,@"-1");
        pictureMessageModel.t_leve = APPLICATION_NSSTRING_SETTING(self.userModel.level,@"-1");
        pictureMessageModel.t_user_type = APPLICATION_NSSTRING_SETTING(self.userModel.user_type,@"-1");
        
        CGFloat showWidth = smallImage.size.width;
        showWidth = (showWidth > (SIZE_DEVICE_WIDTH * 2.0f / 5.0f)) ? (SIZE_DEVICE_WIDTH * 2.0f / 5.0f) : showWidth;
        CGFloat showHeight = showWidth * (smallImage.size.height / smallImage.size.width);
        showWidth = showWidth + 20.0f;
        showHeight = showHeight + 20.0f;
        pictureMessageModel.showWidth = showWidth;
        pictureMessageModel.showHeight = showHeight;
        
        ///发送消息
#if 1
       
        [QSSocketManager sendMessageToPerson:pictureMessageModel andMessageType:qQSCustomProtocolChatMessageTypePicture];
        
#endif
        
        ///加载当前消息
        [self.messagesDataSource addObject:pictureMessageModel];
        
        ///刷新数据
        [self.messagesListView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.messagesDataSource count] - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
        
        [self.messagesListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.messagesDataSource count] - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    }
    
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}

#pragma mark - 聊天图片沙盒目录
- (NSString *)getTalkImageSavePath
{

    ///沙盒目录
    NSString *rootPath = [self getContactRootPath];
    NSString *path = [rootPath stringByAppendingPathComponent:@"/image"];
    
    ///判断文件夹是否存在，存在直接返回，不存在则创建
    BOOL isDir = NO;
    BOOL isExitDirector = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    
    ///如果已存在对应的路径，返回
    if (isDir && isExitDirector) {
        
        return path;
        
    }
    
    ///不存在创建
    BOOL isCreateSuccessDirector = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    if (isCreateSuccessDirector) {
        
        return path;
        
    }
    
    return nil;

}

- (NSString *)getTalkVideoSavePath
{
    
    ///沙盒目录
    NSString *rootPath = [self getContactRootPath];
    NSString *path = [rootPath stringByAppendingPathComponent:@"/video"];
    
    ///判断文件夹是否存在，存在直接返回，不存在则创建
    BOOL isDir = NO;
    BOOL isExitDirector = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    
    ///如果已存在对应的路径，返回
    if (isDir && isExitDirector) {
        
        return path;
        
    }
    
    ///不存在创建
    BOOL isCreateSuccessDirector = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    if (isCreateSuccessDirector) {
        
        return path;
        
    }
    
    return nil;
    
}

- (NSString *)getContactRootPath
{

    ///沙盒目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/contact"];
    
    ///判断文件夹是否存在，存在直接返回，不存在则创建
    BOOL isDir = NO;
    BOOL isExitDirector = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    
    ///如果已存在对应的路径，返回
    if (isDir && isExitDirector) {
        
        return path;
        
    }
    
    ///不存在创建
    BOOL isCreateSuccessDirector = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    if (isCreateSuccessDirector) {
        
        return path;
        
    }
    
    return nil;

}

#pragma mark - 返回上一级页面时，注销当前用户聊天的监听
- (void)gotoTurnBackAction
{

    [QSSocketManager offsCurrentTalkCallBack];
    [QSSocketManager offCurrentSocketLinkStatusNotification];
    [super gotoTurnBackAction];

}

@end
