//
//  QSSocketManager.m
//  House
//
//  Created by ysmeng on 15/3/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSSocketManager.h"

#import "NSString+Format.h"
#import "NSDate+Formatter.h"
#import "NSString+Calculation.h"

#include "qschat.pb.h"

#import "ODSocket.h"
#include <iostream>
#include <string.h>
#include <endian.h>
#include <stdlib.h>

#import "AsyncSocket.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>

#import "QSYSendMessageWord.h"

#import "QSCoreDataManager+App.h"
#import "QSCoreDataManager+User.h"

#import "QSUserSimpleDataModel.h"

using namespace std;

///服务端地址
//#define QS_SOCKET_SERVER_IP @"192.168.1.145"
#define QS_SOCKET_SERVER_PORT 8000
#define QS_SOCKET_SERVER_IP @"117.41.235.107"

@interface QSSocketManager () <AsyncSocketDelegate,NSStreamDelegate>

///当前聊天的回调
@property (nonatomic,copy) void(^currentTalkMessageCallBack)(BOOL flag,id messageModel);

///当前所有离线消息数量回调
@property (nonatomic,copy) void(^currentUnReadMessageNumCallBack)(int msgNum);

///新消息进入时的提醒回调
@property (nonatomic,copy) void(^instantMessageNotification)(int msgNum,NSString *lastComment,QSYSendMessageBaseModel *lastMessage,QSUserSimpleDataModel *userInfo);

///socket连接器
@property (nonatomic,strong) AsyncSocket *tcpSocket;

@property (nonatomic,retain) QSUserSimpleDataModel *myUserMode; //!<当前用户的数据模型
@property (nonatomic,copy) NSString *currentDeviceUUID;         //!<当前设备的UUID

@end

static QSSocketManager *_socketManager = nil;
@implementation QSSocketManager

#pragma mark - socket单例管理器
///socket单例管理器
+ (QSSocketManager *)shareSocketManager
{

    if (nil == _socketManager) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            _socketManager = [[QSSocketManager alloc] init];
            [_socketManager initParams];
            
        });
        
    }
    
    return _socketManager;

}

#pragma mark - socket连接基本初始化
///socket连接基本初始化
- (void)initParams
{

    ///开始连接socket
    self.tcpSocket = [[AsyncSocket alloc] initWithDelegate:self];
    
    NSError *error = nil;
    [self.tcpSocket connectToHost:QS_SOCKET_SERVER_IP onPort:QS_SOCKET_SERVER_PORT withTimeout:-1 error:&error];
    
    if (error) {
        
        APPLICATION_LOG_INFO(@"TCP连接失败：", error)
        return;
        
    } else {
        
        APPLICATION_LOG_INFO(@"TCP连接成功：", @"无错误")
        
    }
    
    ///相关参数初始化
    self.myUserMode = (QSUserSimpleDataModel *)[QSCoreDataManager getCurrentUserDataModel];
    self.currentDeviceUUID = [NSString getDeviceUUID];

}

#pragma mark - 发送消息类方法
/**
 *  @author yangshengmeng, 15-03-31 23:03:31
 *
 *  @brief  发送上线消息
 *
 *  @since  1.0.0
 */
+ (void)sendOnLineMessage
{

    ///自身单例
    QSSocketManager *socketManager = [QSSocketManager shareSocketManager];
    
    ///设置信息
    NSString *deviceName = [UIDevice currentDevice].name;                   //获取设备所有者的名称
    NSString *deviceType = [UIDevice currentDevice].model;                  //获取设备的类别
    NSString *deviceSystemName = [UIDevice currentDevice].systemName;       //获取设备的类别
    NSString *deviceSystemVersion = [UIDevice currentDevice].systemVersion; //获取设备的类别
    NSString *deviceInfoString = [NSString stringWithFormat:@"%@的%@(%@ %@)",deviceName,deviceType,deviceSystemName,deviceSystemVersion];
    
    ///设置发送消息
    QSChat::QuestionOnline onLineMessage;
    onLineMessage.set_token([[QSCoreDataManager getApplicationCurrentTokenID] UTF8String]);
    onLineMessage.set_user_id([[QSCoreDataManager getUserID] UTF8String]);
    onLineMessage.set_device_udid([socketManager.currentDeviceUUID UTF8String]);
    onLineMessage.set_device_info([deviceInfoString UTF8String]);
    onLineMessage.set_local_info([[QSCoreDataManager getCurrentUserCity] UTF8String]);
    
    int length = onLineMessage.ByteSize();
    int32_t messageLength = static_cast <int32_t> (length + 4);
    int32_t messageType = static_cast <int32_t> ([socketManager talk_ChangeOCEnumToCPP_MessageType:qQSCustomProtocolChatMessageTypeOnLine]);
    
    HTONL(messageLength);
    HTONL(messageType);
    
    char *buf = new char[length];
    onLineMessage.SerializeToArray(buf,length);
    
    ///先发送长度和类型
    [socketManager.tcpSocket writeData:[NSData dataWithBytes:&messageLength length:(sizeof messageLength)] withTimeout:-1 tag:7000];
    [socketManager.tcpSocket writeData:[NSData dataWithBytes:&messageType length:(sizeof messageType)] withTimeout:-1 tag:7001];
    
    ///再发主体信息
    [socketManager.tcpSocket writeData:[NSData dataWithBytes:buf length:length] withTimeout:-1 tag:7002];

}

/**
 *  @author         yangshengmeng, 15-03-17 19:03:05
 *
 *  @brief          一对一聊天时，发送消息
 *
 *  @param msgModel 消息数据模型
 *
 *  @since          1.0.0
 */
+ (void)sendMessageToPerson:(id)msgModel andMessageType:(QSCUSTOM_PROTOCOL_CHAT_MESSAGE_TYPE)messageType andCallBack:(void(^)(BOOL flag,id model))callBack
{
    
    switch (messageType) {
            ///文字聊天
        case qQSCustomProtocolChatMessageTypeWord:
            
            [self sendWordMessageToPersion:msgModel andCallBack:callBack];
            
            break;
            
        default:
            break;
    }
    
}

+ (void)sendWordMessageToPersion:(QSYSendMessageWord *)wordMessageModel andCallBack:(void(^)(BOOL flag,id model))callBack
{
    
    ///socket管理器
    QSSocketManager *socketManager = [QSSocketManager shareSocketManager];
    
    ///保存回调
    if (callBack) {
        
        socketManager.currentTalkMessageCallBack = callBack;
        
    }

    QSChat::QuestionWord sendMessage;
    
    ///设置消息体
    int32_t fromIDINT32 = [wordMessageModel.fromID intValue];
    sendMessage.set_mid(fromIDINT32);
    int32_t toIDINT32 = [wordMessageModel.toID intValue];
    sendMessage.set_tid(toIDINT32);
    sendMessage.set_ctype([socketManager talk_ChangeOCEnumToCPP_SendType:wordMessageModel.sendType]);
    sendMessage.set_message([wordMessageModel.message UTF8String]);
    
    sendMessage.set_time_stamp([wordMessageModel.timeStamp UTF8String]);
    
    sendMessage.set_m_avatar([wordMessageModel.f_avatar UTF8String]);
    sendMessage.set_m_name([wordMessageModel.f_name UTF8String]);
    sendMessage.set_m_leve([wordMessageModel.f_leve UTF8String]);
    sendMessage.set_m_user_type([wordMessageModel.f_user_type UTF8String]);
    
    sendMessage.set_t_avatar([wordMessageModel.t_avatar UTF8String]);
    sendMessage.set_t_name([wordMessageModel.t_name UTF8String]);
    sendMessage.set_t_leve([wordMessageModel.t_leve UTF8String]);
    sendMessage.set_t_user_type([wordMessageModel.t_user_type UTF8String]);
    
    int length = sendMessage.ByteSize();
    int32_t messageLength = static_cast <int32_t> (length + 4);
    int32_t messageType = static_cast <int32_t> (qQSCustomProtocolChatMessageTypeWord);
    
    HTONL(messageLength);
    HTONL(messageType);
    
    ///头信息
    char *buf = new char[length];
    sendMessage.SerializeToArray(buf,length);
    [socketManager.tcpSocket writeData:[NSData dataWithBytes:&messageLength length:(sizeof messageLength)] withTimeout:-1 tag:8000];
    [socketManager.tcpSocket writeData:[NSData dataWithBytes:&messageType length:(sizeof messageType)] withTimeout:-1 tag:8001];
    
    ///发主体信息
    [socketManager.tcpSocket writeData:[NSData dataWithBytes:buf length:length] withTimeout:-1 tag:8002];

}

/**
 *  @author         yangshengmeng, 15-03-17 19:03:27
 *
 *  @brief          群发消息
 *
 *  @param msgModel 消息数据模型
 *  @param groupID  群ID
 *
 *  @since          1.0.0
 */
+ (void)sendMessageToGroup:(id)msgModel andGroupID:(NSString *)groupID andCallBack:(void(^)(BOOL flag,id model))callBack
{

    

}

#pragma mark - 注销特定功能的回调block
/**
 *  @author yangshengmeng, 15-04-01 12:04:28
 *
 *  @brief  注销当前聊天的即里回调
 *
 *  @since  1.0.0
 */
+ (void)offsCurrentTalkCallBack
{

    QSSocketManager *socketManager = [QSSocketManager shareSocketManager];
    socketManager.currentTalkMessageCallBack = nil;

}

#pragma mark - socket调试
///socket连接到服务器时执行
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
 
    APPLICATION_LOG_INFO(@"socket日志", @"连接成功")
    
}

///准备读取数据
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    
    APPLICATION_LOG_INFO(@"socket日志", @"准备接收数据")
    
    ///准备读取数据
    [_tcpSocket readDataWithTimeout:-1 tag:300];
    
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{

    APPLICATION_LOG_INFO(@"socket日志", @"socket连接已断开，正在重连")
    NSError *error = nil;
    [self.tcpSocket connectToHost:QS_SOCKET_SERVER_IP onPort:QS_SOCKET_SERVER_PORT withTimeout:-1 error:&error];
    
    if (error) {
        
        APPLICATION_LOG_INFO(@"socket日志->连接失败：", error)
        return;
        
    } else {
        
        APPLICATION_LOG_INFO(@"socket日志->连接成功：", @"无错误")
        
    }

}

///接收到数据之后执行
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    APPLICATION_LOG_INFO(@"socket日志->接收返回信息", data)
    
    ///获取消息长度
    char messageLengthBuf[4] = "\0";
    [data getBytes:messageLengthBuf range:NSMakeRange(0, 4)];
    int32_t messageLengthNetwork = intbytesToInt32(messageLengthBuf);
    NTOHL(messageLengthNetwork);
    
    ///获取消息类型
    char messageTypeBuf[4] = "\0";
    [data getBytes:messageTypeBuf range:NSMakeRange(4, 4)];
    int32_t messageTypeNetwork;
    messageTypeNetwork = intbytesToInt32(messageTypeBuf);
    NTOHL(messageTypeNetwork);
    
    ///根据不同的类型，转不同的模型
    switch (messageTypeNetwork) {
            ///上线
        case QSChat::QSCHAT_ONLINE:
            
            break;
            
            ///下线
        case QSChat::QSCHAT_OFFLINE:
            
            break;
            
            ///文字聊天
        case QSChat::QSCHAT_WORD:
        {
        
            ///消息
            char *messageBuf = (char *)malloc(messageLengthNetwork - 4);
            [data getBytes:messageBuf range:NSMakeRange(8, messageLengthNetwork - 4)];
            string messageString = string(messageBuf);
            
            ///返回的信息
            QSChat::AnswerWord wordMessage = QSChat::AnswerWord();
            wordMessage.ParseFromString(messageString);
            
            ///转模型关回调
            [self talk_ChangeCPPToOCModel_Word:wordMessage];
            
        }
            break;
            
            ///图片聊天
        case QSChat::QSCHAT_PIC:
            
            break;
            
            ///视频聊天
        case QSChat::QSCHAT_VIDEO:
            
            break;
            
            ///推荐房源消息
        case QSChat::QSCHAT_SPECIAL:
            
            break;
            
            ///系统消息
        case QSChat::QSCHAT_SYSTEM:
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 将C++数据模型转为OC的消息模型，然后判断回调
- (void)talk_ChangeCPPToOCModel_Word:(QSChat::AnswerWord)cppWordModel
{
    
    ///OC数据模型
    QSYSendMessageWord *ocWordModel = [[QSYSendMessageWord alloc] init];
    ocWordModel.msgType = qQSCustomProtocolChatMessageTypeWord;
    ocWordModel.sendType = qQSCustomProtocolChatSendTypePTP;
    ocWordModel.msgID = [NSString stringWithUTF8String:cppWordModel.msg_id().c_str()];
    
    int64_t fIDINT32 = cppWordModel.fid();
    ocWordModel.fromID = [NSString stringWithFormat:@"%d",(int)fIDINT32];
    ocWordModel.toID = self.myUserMode.id_;
    ocWordModel.message = [NSString stringWithUTF8String:cppWordModel.message().c_str()];
    
    ocWordModel.timeStamp = [NSString stringWithUTF8String:cppWordModel.time_stamp().c_str()];
    
    ocWordModel.f_avatar = [NSString stringWithUTF8String:cppWordModel.f_avatar().c_str()];
    ocWordModel.f_name = [NSString stringWithUTF8String:cppWordModel.f_name().c_str()];
    ocWordModel.f_user_type = [NSString stringWithUTF8String:cppWordModel.f_user_type().c_str()];
    ocWordModel.f_leve = [NSString stringWithUTF8String:cppWordModel.f_leve().c_str()];
    ocWordModel.unread_count = [NSString stringWithUTF8String:cppWordModel.f_unread_count().c_str()];
    
    CGFloat showHeight = 30.0f;
    CGFloat showWidth = [ocWordModel.message calculateStringDisplayWidthByFixedHeight:showHeight andFontSize:FONT_BODY_16];
    if (showWidth > (SIZE_DEVICE_WIDTH * 3.0f / 5.0f - 20.0f)) {
        
        showWidth = (SIZE_DEVICE_WIDTH * 3.0f / 5.0f - 20.0f);
        showHeight = [ocWordModel.message calculateStringDisplayHeightByFixedWidth:showWidth andFontSize:FONT_BODY_16];
        
    }
    
    showWidth = showWidth + 20.0f;
    showHeight = showHeight + 20.0f;
    ocWordModel.showWidth = showWidth;
    ocWordModel.showHeight = showHeight;

    ///回调
    if (self.currentTalkMessageCallBack) {
        
        self.currentTalkMessageCallBack(YES,ocWordModel);
        
    } else {
    
        ///回调通知
        if (self.instantMessageNotification) {
            
            QSUserSimpleDataModel *userSimple = [[QSUserSimpleDataModel alloc] init];
            userSimple.id_ = [NSString stringWithFormat:@"%d",(int)fIDINT32];
            userSimple.avatar = [NSString stringWithUTF8String:cppWordModel.f_avatar().c_str()];
            userSimple.username = [NSString stringWithUTF8String:cppWordModel.f_name().c_str()];
            userSimple.user_type = [NSString stringWithUTF8String:cppWordModel.f_user_type().c_str()];
            userSimple.level = [NSString stringWithUTF8String:cppWordModel.f_leve().c_str()];
            self.instantMessageNotification(1,ocWordModel.message,ocWordModel,userSimple);
            
        }
    
    }

}

///将OC的消息类型转为C++的消息类型
- (QSChat::QSChatMessageType)talk_ChangeOCEnumToCPP_MessageType:(QSCUSTOM_PROTOCOL_CHAT_MESSAGE_TYPE)ocType
{
    
    switch (ocType) {
            ///文字信息
        case qQSCustomProtocolChatMessageTypeWord:
            
            return QSChat::QSCHAT_WORD;
            
            ///图片信息
        case qQSCustomProtocolChatMessageTypePicture:
            
            return QSChat::QSCHAT_PIC;
            
            ///音频信息
        case qQSCustomProtocolChatMessageTypeVideo:
            
            return QSChat::QSCHAT_VIDEO;
            
            ///上线消息
        case qQSCustomProtocolChatMessageTypeOnLine:
            
            return QSChat::QSCHAT_ONLINE;
            
            ///下线消息
        case qQSCustomProtocolChatMessageTypeOffLine:
            
            return QSChat::QSCHAT_OFFLINE;
            
            ///推送房源
        case qQSCustomProtocolChatMessageTypeSpecial:
            
            return QSChat::QSCHAT_SPECIAL;
            
            ///系统消息
        case qQSCustomProtocolChatMessageTypeSystem:
            
            return QSChat::QSCHAT_SYSTEM;
            
            ///系统消息
        case qQSCustomProtocolChatMessageTypeHistoryWord:
            
            return QSChat::QSCHAT_HISTORY_WORD;
            
            ///系统消息
        case qQSCustomProtocolChatMessageTypeHistoryPicture:
            
            return QSChat::QSCHAT_HISTORY_PIC;
            
            ///系统消息
        case qQSCustomProtocolChatMessageTypeHistoryVideo:
            
            return QSChat::QSCHAT_HISTORY_VIDEO;
            
        default:
            break;
    }
    
    return QSChat::QSCHAT_WORD;
    
}

///将OC的消息发送类型转为C++的发送类型
- (QSChat::ChatRequestType)talk_ChangeOCEnumToCPP_SendType:(QSCUSTOM_PROTOCOL_CHAT_SEND_TYPE)ocType
{

    switch (ocType) {
            ///单聊
        case qQSCustomProtocolChatSendTypePTP:
            
            return QSChat::ChatTypeSendPTP;
        
            ///群聊
        case qQSCustomProtocolChatSendTypePTG:
            
            return QSChat::ChatTypeSendPTG;
            
        default:
            break;
    }
    
    return QSChat::ChatTypeSendPTP;

}

#pragma mark - C数据格式化及转换
int32_t intbytesToInt32(char *bytes)
{
    
    int32_t addr = bytes[0] & 0xFF;
    addr |= ((bytes[1] << 8) & 0xFF00);
    addr |= ((bytes[2] << 16) & 0xFF0000);
    addr |= ((bytes[3] << 24) & 0xFF000000);
    return addr;
    
}

void int32ToByte(int32_t i,char *bytes)
{
    
    memset(bytes,0,sizeof(char) *  4);
    bytes[0] = (char) (0xff & i);
    bytes[1] = (char) ((0xff00 & i) >> 8);
    bytes[2] = (char) ((0xff0000 & i) >> 16);
    bytes[3] = (char) ((0xff000000 & i) >> 24);
    return ;
    
}

#pragma mark - 注册消息监听回调
/**
 *  @author yangshengmeng, 15-04-02 13:04:23
 *
 *  @brief  注册当前所有未读消息的回调通知
 *
 *  @since  1.0.0
 */
+ (void)registCurrentUnReadMessageCountNotification:(void(^)(int msgNum))callBack
{

    QSSocketManager *manager = [self shareSocketManager];
    if (callBack) {
        
        manager.currentUnReadMessageNumCallBack = callBack;
        
    }

}

+ (void)offsCurrentUnReadMessageCountNotification
{
    
    QSSocketManager *manager = [self shareSocketManager];
    manager.currentUnReadMessageNumCallBack = nil;

}

/**
 *  @author         yangshengmeng, 15-04-02 14:04:13
 *
 *  @brief          注册当前有消息进入时的回调，返回当前消息的发送人，及发送人的未读消息数量
 *
 *  @param callBack 当有新的消息来时，回调
 *
 *  @since          1.0.0
 */
+ (void)registInstantMessageReceiveNotification:(void(^)(int msgNum,NSString *lastComment,QSYSendMessageBaseModel *lastMessage,QSUserSimpleDataModel *userInfo))callBack
{

    if (callBack) {
        
        QSSocketManager *manager = [self shareSocketManager];
        manager.instantMessageNotification = callBack;
        
    }

}

+ (void)offsInstantMessageReceiveNotification
{

    QSSocketManager *manager = [self shareSocketManager];
    manager.instantMessageNotification = nil;

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

@end
