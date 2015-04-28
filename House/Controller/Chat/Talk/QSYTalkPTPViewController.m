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

#import "QSYMessageWordTableViewCell.h"
#import "QSYMessageVideoTableViewCell.h"
#import "QSYMessagePictureTableViewCell.h"

#import "QSBlockButtonStyleModel+NavigationBar.h"
#import "NSString+Format.h"
#import "NSString+Calculation.h"
#import "NSDate+Formatter.h"

#import "QSSocketManager.h"
#import "QSCoreDataManager+User.h"

#import "QSUserSimpleDataModel.h"
#import "QSUserDataModel.h"
#import "QSYSendMessageWord.h"
#import "QSYSendMessageVideo.h"
#import "QSYSendMessagePicture.h"

#import "MJRefresh.h"

#import "UIImage+Orientaion.h"
#import "UIImage+Thumbnail.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface QSYTalkPTPViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,retain) QSUserSimpleDataModel *userModel;              //!<当前聊天对象数据模型
@property (nonatomic,retain) QSUserDataModel *myUserModel;                  //!<当前用户数据模型
@property (atomic,assign) BOOL isLocalMessage;                              //!<是否获取本地保存的消息

@property (nonatomic,strong) UIView *rootView;                              //!<底view，方便滑动
@property (nonatomic,strong) UITableView *messagesListView;                 //!<消息列表view
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
    [self setNavigationBarTitle:self.userModel.username];
    
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
    
    ///分隔线
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.rootView.frame.size.height - 50.0f, SIZE_DEVICE_WIDTH, 0.25f)];
    lineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.rootView addSubview:lineLabel];
    
    ///文字输入框
    __block UITextField *inputField;
    
    ///相机
    UIButton *cameraButton = [UIButton createBlockButtonWithFrame:CGRectMake(5.0f, self.rootView.frame.size.height - 47.0f, 44.0f, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///回收键盘
        [inputField resignFirstResponder];
        
        ///弹出提示
        UIActionSheet *pickedImageAskSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [pickedImageAskSheet showInView:self.view];
        
    }];
    [cameraButton setImage:[UIImage imageNamed:IMAGE_CHAT_PHOTO_NORMAL] forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:IMAGE_CHAT_PHOTO_HIGHLIGHTED] forState:UIControlStateHighlighted];
    [self.rootView addSubview:cameraButton];
    
    ///文字输入框
    inputField = [[UITextField alloc] initWithFrame:CGRectMake(cameraButton.frame.origin.x + cameraButton.frame.size.width + 5.0f, self.rootView.frame.size.height - 45.0f, self.rootView.frame.size.width - 20.0f - 88.0f, 40.0f)];
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
    
    ///开始就请求历史数据
    [self.messagesListView.header beginRefreshing];

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
            
        }
        
        ///修改聊天消息的标识
        self.isLocalMessage = YES;
        
    } else {
        
        ///获取本地保存消息
        QSYSendMessageBaseModel *tempModel = self.messagesDataSource[0];
        NSArray *localMessageList = [QSSocketManager getSpecialPersonLocalMessage:self.userModel.id_ andStarTimeStamp:tempModel.timeStamp];
        if ([localMessageList count] > 0) {
            
            for (int i = [localMessageList count]; i > 0; i--) {
                
                [self.messagesDataSource insertObject:localMessageList[i-1] atIndex:0];
                
            }
            
        }
    
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.messagesListView reloadData];
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
        [self.messagesListView reloadData];
        
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
        NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.5f);
        
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
#if 0
       
        [QSSocketManager sendMessageToPerson:pictureMessageModel andMessageType:qQSCustomProtocolChatMessageTypePicture];
        
#endif
        
#if 1
        ///加载当前消息
        [self.messagesDataSource addObject:pictureMessageModel];
        
        ///刷新数据
        [self.messagesListView reloadData];
#endif
        
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
    [super gotoTurnBackAction];

}

@end
