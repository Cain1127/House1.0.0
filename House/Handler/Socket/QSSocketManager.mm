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

#include "QSChat.pb.h"

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
#import "QSYSendMessagePicture.h"
#import "QSYSendMessageVideo.h"
#import "QSYSendMessageSystem.h"
#import "QSYSendMessageSpecial.h"
#import "QSYSendMessageRecommendHouse.h"

#import "QSCoreDataManager+App.h"
#import "QSCoreDataManager+User.h"
#import "QSCoreDataManager+Message.h"

#import "QSUserSimpleDataModel.h"

using namespace std;

///服务端地址

#define QS_SOCKET_SERVER_IP @"192.168.1.145"    //!<测试环境
#define QS_SOCKET_SERVER_PORT 8000
//#define QS_SOCKET_SERVER_IP @"117.41.235.107"   //!<正式环境

@interface QSSocketManager () <AsyncSocketDelegate,NSStreamDelegate>

///当前聊天的回调
@property (nonatomic,copy) CURRENT_TALK_MESSAGE_NOTIFICATION currentTalkMessageCallBack;

///当前所有离线消息数量回调
@property (nonatomic,copy) APPOINT_MESSAGE_LASTCOUNT_NOTIFICATION currentUnReadMessageNumCallBack;

///系统消息数量监听
@property (nonatomic,copy) APPOINT_MESSAGE_LASTCOUNT_NOTIFICATION systemMessageCountNumCallBack;

///新消息进入时的提醒回调
@property (nonatomic,copy) INSTANT_MESSAGE_NOTIFICATION instantMessageNotification;

///被踢下线时的提醒回调
@property (nonatomic,copy) SERVER_OFF_LINE_NOTIFICATION serverOffLineNotification;

///socket连接器
@property (nonatomic,strong) AsyncSocket *tcpSocket;

@property (nonatomic,copy) NSString *currentContactUserID;      //!<当前对话用户的ID
@property (nonatomic,copy) NSString *currentDeviceUUID;         //!<当前设备的UUID
@property (atomic,retain) NSMutableArray *messageList;          //!<消息数据源
@property (assign) BOOL isWaitConnect;                          //!<当前是否等连接中

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
    self.isWaitConnect = NO;
    
    NSError *error = nil;
    [self.tcpSocket connectToHost:QS_SOCKET_SERVER_IP onPort:QS_SOCKET_SERVER_PORT withTimeout:-1 error:&error];
    
    if (error) {
        
        APPLICATION_LOG_INFO(@"TCP连接失败：", error)
        return;
        
    } else {
        
        APPLICATION_LOG_INFO(@"TCP连接成功：", @"无错误")
        
    }
    
    ///相关参数初始化
    self.currentDeviceUUID = [NSString getDeviceUUID];
    self.messageList = [[NSMutableArray alloc] init];

}

#pragma mark - 返回指定用户的消息
/**
 *  @author         yangshengmeng, 15-04-10 13:04:29
 *
 *  @brief          获取指定人员的当前内存离线消息
 *
 *  @param personID 用户ID
 *
 *  @return         返回指定用户未读消息
 *
 *  @since          1.0.0
 */
+ (NSArray *)getSpecialPersonMessage:(NSString *)personID
{
    
    QSSocketManager *socketManager = [QSSocketManager shareSocketManager];
    
    ///下载服务端的消息
    [socketManager sendContactServerUnReadMessage];
    NSString *localUserID = [QSCoreDataManager getUserID];

    ///临时数据
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:socketManager.messageList];
    NSMutableArray *resultArray = [NSMutableArray array];
    NSMutableArray *indexsArray = [NSMutableArray array];
    NSInteger sumMessage = [tempArray count];
    for (int i = 0; i < sumMessage; i++) {
        
        QSYSendMessageBaseModel *tempModel = socketManager.messageList[i];
        if ([tempModel.readTag isEqualToString:@"0"] &&
            [tempModel.fromID isEqualToString:personID] &&
            [tempModel.toID isEqualToString:localUserID]) {
            
            [resultArray addObject:tempModel];
            [indexsArray addObject:[NSString stringWithFormat:@"%d",i]];
            
            ///保存一个数据
            tempModel.readTag = @"1";
            [QSCoreDataManager saveMessageData:tempModel andMessageType:tempModel.msgType andCallBack:^(BOOL isSave) {
                
                if (isSave) {
                    
                    APPLICATION_LOG_INFO(@"离线消息->读取->保存本地", @"成功")
                    
                } else {
                
                    APPLICATION_LOG_INFO(@"离线消息->读取->保存本地", @"失败")
                
                }
                
            }];
            
        }
        
    }
    
    ///删除已取数据
    [socketManager clearCautchMessage:[NSArray arrayWithArray:indexsArray]];
    
    return [NSArray arrayWithArray:resultArray];

}

///删除指定的已读消息
- (void)clearCautchMessage:(NSArray *)cautchMessage
{
    
    ///遍历给定的已读数据
    for (int i = (int)[cautchMessage count]; i > 0; i--) {
        
        int index = [cautchMessage[i - 1] intValue];
        [self.messageList removeObjectAtIndex:index];
        
    }

    ///回调离线消息数量
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"readTag == %@",@"0"];
    NSArray *currentNoReadArray = [NSArray arrayWithArray:[self.messageList filteredArrayUsingPredicate:predicate]];
    
    ///回调消息数量
    if (self.currentUnReadMessageNumCallBack) {
        
        self.currentUnReadMessageNumCallBack((int)[currentNoReadArray count]);
        
    }

}

+ (NSArray *)getSystemUnReadMessages
{
    
    QSSocketManager *socketManager = [QSSocketManager shareSocketManager];
    
    ///临时数据
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:socketManager.messageList];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (int i = 0; i < [socketManager.messageList count]; i++) {
        
        QSYSendMessageBaseModel *tempModel = socketManager.messageList[i];
        if (tempModel.msgType == qQSCustomProtocolChatMessageTypeSystem) {
            
            [resultArray addObject:tempModel];
            [tempArray removeObjectAtIndex:i];
            
            ///保存一个数据
            tempModel.readTag = @"1";
            [QSCoreDataManager saveMessageData:tempModel andMessageType:tempModel.msgType andCallBack:^(BOOL isSave) {
                
                if (isSave) {
                    
                    APPLICATION_LOG_INFO(@"离线消息->读取->保存本地", @"成功")
                    
                } else {
                    
                    APPLICATION_LOG_INFO(@"离线消息->读取->保存本地", @"失败")
                    
                }
                
            }];
            
        }
        
    }
    
    ///更新本地数据
    [socketManager.messageList removeAllObjects];
    [socketManager.messageList addObjectsFromArray:tempArray];
    
    ///回调离线消息数量
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"readTag == %@",@"0"];
    NSArray *currentNoReadArray = [NSArray arrayWithArray:[socketManager.messageList filteredArrayUsingPredicate:predicate]];
    
    ///回调消息数量
    if (socketManager.currentUnReadMessageNumCallBack) {
        
        socketManager.currentUnReadMessageNumCallBack((int)[currentNoReadArray count]);
        
    }
    
    ///回调消息列表
    if (socketManager.instantMessageNotification) {
        
        socketManager.instantMessageNotification(qQSCustomProtocolChatMessageTypeSystem,0,nil,nil,nil);
        
    }
    
    return [NSArray arrayWithArray:resultArray];

}

/**
 *  @author             yangshengmeng, 15-04-10 13:04:30
 *
 *  @brief              获取用户，保存在数据库中的历史消息
 *
 *  @param personID     指定用户的ID
 *  @param timeStamp    当前最旧消息的时间戳
 *
 *  @return             返回最多十条历史消息，如果没有更多，则返回0条的空数组
 *
 *  @since              1.0.0
 */
+ (NSArray *)getSpecialPersonLocalMessage:(NSString *)personID andStarTimeStamp:(NSString *)timeStamp
{

    return [QSCoreDataManager getPersonLocalMessage:personID andStarTimeStamp:timeStamp];

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
    [socketManager sendOnLineMessage];

}

/**
 *  @author yangshengmeng, 15-04-18 09:04:56
 *
 *  @brief  发送下线消息
 *
 *  @since  1.0.0
 */
+ (void)sendOffLineMessage
{

    QSSocketManager *socketManager = [QSSocketManager shareSocketManager];
    [socketManager sendOffLineMessage];

}

- (void)sendOnLineMessage
{

    ///设置信息
    NSString *deviceName = [UIDevice currentDevice].name;                   //获取设备所有者的名称
    NSString *deviceType = [UIDevice currentDevice].model;                  //获取设备的类别
    NSString *deviceSystemName = [UIDevice currentDevice].systemName;       //获取设备的类别
    NSString *deviceSystemVersion = [UIDevice currentDevice].systemVersion; //获取设备的类别
    NSString *deviceInfoString = [NSString stringWithFormat:@"%@的%@(%@ %@)",deviceName,deviceType,deviceSystemName,deviceSystemVersion];
    
    ///设置发送消息
    QSChat::QuestionOnline onLineMessage;
    onLineMessage.set_token([APPLICATION_NSSTRING_SETTING([QSCoreDataManager getApplicationCurrentTokenID], @"-1") UTF8String]);
    onLineMessage.set_user_id([APPLICATION_NSSTRING_SETTING([QSCoreDataManager getUserID],@"-1") UTF8String]);
    onLineMessage.set_device_udid([APPLICATION_NSSTRING_SETTING(self.currentDeviceUUID,@"-1") UTF8String]);
    onLineMessage.set_device_info([deviceInfoString UTF8String]);
    onLineMessage.set_local_info([APPLICATION_NSSTRING_SETTING([QSCoreDataManager getCurrentUserCity],@"-1") UTF8String]);
    
    int length = onLineMessage.ByteSize();
    int32_t messageLength = static_cast <int32_t> (length + 4);
    int32_t messageType = static_cast <int32_t> ([self talk_ChangeOCEnumToCPP_MessageType:qQSCustomProtocolChatMessageTypeOnLine]);
    
    HTONL(messageLength);
    HTONL(messageType);
    
    char *buf = new char[length];
    onLineMessage.SerializeToArray(buf,length);
    
    ///先发送长度和类型
    [self.tcpSocket writeData:[NSData dataWithBytes:&messageLength length:(sizeof messageLength)] withTimeout:-1 tag:7000];
    [self.tcpSocket writeData:[NSData dataWithBytes:&messageType length:(sizeof messageType)] withTimeout:-1 tag:7001];
    
    ///再发主体信息
    [self.tcpSocket writeData:[NSData dataWithBytes:buf length:length] withTimeout:-1 tag:7002];

}

- (void)sendOffLineMessage
{
    
    ///设置信息
    NSString *deviceName = [UIDevice currentDevice].name;                   //获取设备所有者的名称
    NSString *deviceType = [UIDevice currentDevice].model;                  //获取设备的类别
    NSString *deviceSystemName = [UIDevice currentDevice].systemName;       //获取设备的类别
    NSString *deviceSystemVersion = [UIDevice currentDevice].systemVersion; //获取设备的类别
    NSString *deviceInfoString = [NSString stringWithFormat:@"%@的%@(%@ %@)",deviceName,deviceType,deviceSystemName,deviceSystemVersion];
    
    ///用户信息数据模型
    QSUserSimpleDataModel *userInfoModel = (QSUserSimpleDataModel *)[QSCoreDataManager getCurrentUserDataModel];
    
    ///设置发送消息
    QSChat::QuestionOffline onLineMessage;
    onLineMessage.set_token([APPLICATION_NSSTRING_SETTING([QSCoreDataManager getApplicationCurrentTokenID], @"-1") UTF8String]);
    onLineMessage.set_device_udid([APPLICATION_NSSTRING_SETTING(self.currentDeviceUUID,@"-1") UTF8String]);
    onLineMessage.set_device_info([APPLICATION_NSSTRING_SETTING(deviceInfoString,@"-1") UTF8String]);
    onLineMessage.set_local_info([APPLICATION_NSSTRING_SETTING([QSCoreDataManager getCurrentUserCity],@"-1") UTF8String]);
    onLineMessage.set_time_stamp([[NSDate currentDateTimeStamp] UTF8String]);
    
    int32_t fromIDINT32 = [userInfoModel.id_ intValue];
    onLineMessage.set_fid(fromIDINT32);
    onLineMessage.set_f_avatar([APPLICATION_NSSTRING_SETTING(userInfoModel.avatar, @"-1") UTF8String]);
    onLineMessage.set_f_name([APPLICATION_NSSTRING_SETTING(userInfoModel.username, @"-1") UTF8String]);
    onLineMessage.set_f_leve([APPLICATION_NSSTRING_SETTING(userInfoModel.level, @"-1") UTF8String]);
    onLineMessage.set_f_user_type([APPLICATION_NSSTRING_SETTING(userInfoModel.user_type, @"-1") UTF8String]);
    
    int length = onLineMessage.ByteSize();
    int32_t messageLength = static_cast <int32_t> (length + 4);
    int32_t messageType = static_cast <int32_t> ([self talk_ChangeOCEnumToCPP_MessageType:qQSCustomProtocolChatMessageTypeOffLine]);
    
    HTONL(messageLength);
    HTONL(messageType);
    
    char *buf = new char[length];
    onLineMessage.SerializeToArray(buf,length);
    
    ///先发送长度和类型
    [self.tcpSocket writeData:[NSData dataWithBytes:&messageLength length:(sizeof messageLength)] withTimeout:-1 tag:7100];
    [self.tcpSocket writeData:[NSData dataWithBytes:&messageType length:(sizeof messageType)] withTimeout:-1 tag:7101];
    
    ///再发主体信息
    [self.tcpSocket writeData:[NSData dataWithBytes:buf length:length] withTimeout:-1 tag:7102];
    
    self.isWaitConnect = YES;
    
}

/**
 *  @author yangshengmeng, 15-04-11 10:04:22
 *
 *  @brief  获取服务器上，对应用户的未读消息
 *
 *  @since  1.0.0
 */
- (void)sendContactServerUnReadMessage
{

    ///设置发送消息
    QSChat::QuestionHistory onLineMessage;
    onLineMessage.set_token([APPLICATION_NSSTRING_SETTING([QSCoreDataManager getApplicationCurrentTokenID], @"-1") UTF8String]);
    onLineMessage.set_ctype(QSChat::ChatTypeSendPTP);
    onLineMessage.set_wid([APPLICATION_NSSTRING_SETTING(self.currentContactUserID,@"-1") UTF8String]);
    onLineMessage.set_page_num("999");
    onLineMessage.set_current_page("1");
    onLineMessage.set_last_id("-1");
    
    int length = onLineMessage.ByteSize();
    int32_t messageLength = static_cast <int32_t> (length + 4);
    int32_t messageType = static_cast <int32_t> ([self talk_ChangeOCEnumToCPP_MessageType:qQSCustomProtocolChatMessageTypeHistory]);
    
    HTONL(messageLength);
    HTONL(messageType);
    
    char *buf = new char[length];
    onLineMessage.SerializeToArray(buf,length);
    
    ///先发送长度和类型
    [self.tcpSocket writeData:[NSData dataWithBytes:&messageLength length:(sizeof messageLength)] withTimeout:-1 tag:6000];
    [self.tcpSocket writeData:[NSData dataWithBytes:&messageType length:(sizeof messageType)] withTimeout:-1 tag:6001];
    
    ///再发主体信息
    [self.tcpSocket writeData:[NSData dataWithBytes:buf length:length] withTimeout:-1 tag:6002];

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
+ (void)sendMessageToPerson:(id)msgModel andMessageType:(QSCUSTOM_PROTOCOL_CHAT_MESSAGE_TYPE)messageType
{
    
    switch (messageType) {
            ///文字聊天
        case qQSCustomProtocolChatMessageTypeWord:
            
            [self sendWordMessageToPersion:msgModel];
            
            break;
            
            ///图片聊天
        case qQSCustomProtocolChatMessageTypePicture:
            
            [self sendPictureMessageToPersion:msgModel];
            
            break;
            
            ///音频聊天
        case qQSCustomProtocolChatMessageTypeVideo:
            
            [self sendVideoMessageToPersion:msgModel];
            
            break;
            
            ///推荐房源
        case qQSCustomProtocolChatMessageTypeRecommendHouse:
            
            [self sendRecommendHouseMessageToPersion:msgModel];
            
            break;
            
        default:
            break;
    }
    
}

///发送文字消息
+ (void)sendWordMessageToPersion:(QSYSendMessageWord *)wordMessageModel
{
    
    ///socket管理器
    QSSocketManager *socketManager = [QSSocketManager shareSocketManager];
    
    QSChat::QuestionWord sendMessage;
    
    ///设置消息体
    int32_t fromIDINT32 = [wordMessageModel.fromID intValue];
    sendMessage.set_mid(fromIDINT32);
    int32_t toIDINT32 = [wordMessageModel.toID intValue];
    sendMessage.set_tid(toIDINT32);
    sendMessage.set_ctype([socketManager talk_ChangeOCEnumToCPP_SendType:qQSCustomProtocolChatSendTypePTP]);
    sendMessage.set_device_udid([APPLICATION_NSSTRING_SETTING(wordMessageModel.deviceUUID, @"-1") UTF8String]);
    sendMessage.set_message([APPLICATION_NSSTRING_SETTING(wordMessageModel.message,@"-1") UTF8String]);
    
    sendMessage.set_time_stamp([APPLICATION_NSSTRING_SETTING(wordMessageModel.timeStamp,@"-1") UTF8String]);
    
    sendMessage.set_m_avatar([APPLICATION_NSSTRING_SETTING(wordMessageModel.f_avatar,@"-1") UTF8String]);
    sendMessage.set_m_name([APPLICATION_NSSTRING_SETTING(wordMessageModel.f_name,@"-1") UTF8String]);
    sendMessage.set_m_leve([APPLICATION_NSSTRING_SETTING(wordMessageModel.f_leve,@"-1") UTF8String]);
    sendMessage.set_m_user_type([APPLICATION_NSSTRING_SETTING(wordMessageModel.f_user_type,@"-1") UTF8String]);
    
    sendMessage.set_t_avatar([APPLICATION_NSSTRING_SETTING(wordMessageModel.t_avatar,@"-1") UTF8String]);
    sendMessage.set_t_name([APPLICATION_NSSTRING_SETTING(wordMessageModel.t_name,@"-1") UTF8String]);
    sendMessage.set_t_leve([APPLICATION_NSSTRING_SETTING(wordMessageModel.t_leve,@"-1") UTF8String]);
    sendMessage.set_t_user_type([APPLICATION_NSSTRING_SETTING(wordMessageModel.t_user_type,@"-1") UTF8String]);
    
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
    
    ///保存消息
    wordMessageModel.readTag = @"1";
    [QSCoreDataManager saveMessageData:wordMessageModel andMessageType:qQSCustomProtocolChatMessageTypeWord andCallBack:^(BOOL isSave) {
        
        if (isSave) {
            
            APPLICATION_LOG_INFO(@"聊天消息保存日志->发出消息", @"成功")
            
        } else {
        
            APPLICATION_LOG_INFO(@"聊天消息保存日志->发出消息", @"失败")
        
        }
        
    }];

}

///发送图片信息
+ (void)sendPictureMessageToPersion:(QSYSendMessagePicture *)wordMessageModel
{
    
    ///socket管理器
    QSSocketManager *socketManager = [QSSocketManager shareSocketManager];
    
    QSChat::QuestionPic sendMessage;
    
    ///设置消息体
    int32_t fromIDINT32 = [wordMessageModel.fromID intValue];
    sendMessage.set_mid(fromIDINT32);
    int32_t toIDINT32 = [wordMessageModel.toID intValue];
    sendMessage.set_tid(toIDINT32);
    sendMessage.set_ctype([socketManager talk_ChangeOCEnumToCPP_SendType:qQSCustomProtocolChatSendTypePTP]);
    sendMessage.set_device_udid([APPLICATION_NSSTRING_SETTING(wordMessageModel.deviceUUID, @"-1") UTF8String]);
    
    ///获取图片
    NSData *imageData = [NSData dataWithContentsOfFile:wordMessageModel.pictureURL];
    
    if (0 >= [imageData length]) {
        
        if (socketManager.currentTalkMessageCallBack) {
            
            socketManager.currentTalkMessageCallBack(NO,nil);
            
        }
        
        return;
        
    }
    
    sendMessage.set_pic(imageData.bytes, [imageData length]);
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
    int32_t messageType = static_cast <int32_t> (qQSCustomProtocolChatMessageTypePicture);
    
    HTONL(messageLength);
    HTONL(messageType);
    
    ///头信息
    char *buf = new char[length];
    sendMessage.SerializeToArray(buf,length);
    [socketManager.tcpSocket writeData:[NSData dataWithBytes:&messageLength length:(sizeof messageLength)] withTimeout:-1 tag:8100];
    [socketManager.tcpSocket writeData:[NSData dataWithBytes:&messageType length:(sizeof messageType)] withTimeout:-1 tag:8101];
    
    ///发主体信息
    [socketManager.tcpSocket writeData:[NSData dataWithBytes:buf length:length] withTimeout:-1 tag:8102];
    
    ///保存消息
    wordMessageModel.readTag = @"1";
    [QSCoreDataManager saveMessageData:wordMessageModel andMessageType:qQSCustomProtocolChatMessageTypePicture andCallBack:^(BOOL isSave) {
        
        if (isSave) {
            
            APPLICATION_LOG_INFO(@"聊天消息保存日志->发出消息", @"成功")
            
        } else {
            
            APPLICATION_LOG_INFO(@"聊天消息保存日志->发出消息", @"失败")
            
        }
        
    }];
    
}

///发送音频消息
+ (void)sendVideoMessageToPersion:(QSYSendMessageVideo *)wordMessageModel
{
    
    ///socket管理器
    QSSocketManager *socketManager = [QSSocketManager shareSocketManager];
    
    QSChat::QuestionVideo sendMessage;
    
    ///设置消息体
    int32_t fromIDINT32 = [wordMessageModel.fromID intValue];
    sendMessage.set_mid(fromIDINT32);
    int32_t toIDINT32 = [wordMessageModel.toID intValue];
    sendMessage.set_tid(toIDINT32);
    sendMessage.set_ctype([socketManager talk_ChangeOCEnumToCPP_SendType:qQSCustomProtocolChatSendTypePTP]);
    sendMessage.set_device_udid([APPLICATION_NSSTRING_SETTING(wordMessageModel.deviceUUID, @"-1") UTF8String]);
    
    ///获取本地音频数据
    NSData *videoData = [NSData dataWithContentsOfFile:wordMessageModel.videoURL];
    sendMessage.set_video(videoData.bytes, [videoData length]);
    
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
    int32_t messageType = static_cast <int32_t> (qQSCustomProtocolChatMessageTypeVideo);
    
    HTONL(messageLength);
    HTONL(messageType);
    
    ///头信息
    char *buf = new char[length];
    sendMessage.SerializeToArray(buf,length);
    [socketManager.tcpSocket writeData:[NSData dataWithBytes:&messageLength length:(sizeof messageLength)] withTimeout:-1 tag:8200];
    [socketManager.tcpSocket writeData:[NSData dataWithBytes:&messageType length:(sizeof messageType)] withTimeout:-1 tag:8201];
    
    ///发主体信息
    [socketManager.tcpSocket writeData:[NSData dataWithBytes:buf length:length] withTimeout:-1 tag:8202];
    
    ///保存消息
    wordMessageModel.readTag = @"1";
    [QSCoreDataManager saveMessageData:wordMessageModel andMessageType:qQSCustomProtocolChatMessageTypeVideo andCallBack:^(BOOL isSave) {
        
        if (isSave) {
            
            APPLICATION_LOG_INFO(@"聊天消息保存日志->发出消息", @"成功")
            
        } else {
            
            APPLICATION_LOG_INFO(@"聊天消息保存日志->发出消息", @"失败")
            
        }
        
    }];
    
}

///发送推送房源消息
+ (void)sendRecommendHouseMessageToPersion:(QSYSendMessageRecommendHouse *)wordMessageModel
{
    
    ///socket管理器
    QSSocketManager *socketManager = [QSSocketManager shareSocketManager];
    
    QSChat::QuestionRecommendHouse sendMessage;
    
    ///设置消息体
    int32_t fromIDINT32 = [wordMessageModel.fromID intValue];
    sendMessage.set_mid(fromIDINT32);
    int32_t toIDINT32 = [wordMessageModel.toID intValue];
    sendMessage.set_tid(toIDINT32);
    sendMessage.set_ctype([socketManager talk_ChangeOCEnumToCPP_SendType:qQSCustomProtocolChatSendTypePTP]);
    
    sendMessage.set_house_id([APPLICATION_NSSTRING_SETTING(wordMessageModel.houseID, @"-1") UTF8String]);
    sendMessage.set_building_id([APPLICATION_NSSTRING_SETTING(wordMessageModel.buildingID, @"-1") UTF8String]);
    sendMessage.set_house_type([APPLICATION_NSSTRING_SETTING(wordMessageModel.houseType, @"-1") UTF8String]);
    sendMessage.set_attach_file([APPLICATION_NSSTRING_SETTING(wordMessageModel.originalImage, @"-1") UTF8String]);
    sendMessage.set_attach_thumb([APPLICATION_NSSTRING_SETTING(wordMessageModel.smallImage, @"-1") UTF8String]);
    sendMessage.set_areaid([APPLICATION_NSSTRING_SETTING(wordMessageModel.districtKey, @"-1") UTF8String]);
    sendMessage.set_area_val([APPLICATION_NSSTRING_SETTING(wordMessageModel.district, @"-1") UTF8String]);
    sendMessage.set_streetid([APPLICATION_NSSTRING_SETTING(wordMessageModel.streetKey, @"-1") UTF8String]);
    sendMessage.set_street_val([APPLICATION_NSSTRING_SETTING(wordMessageModel.street, @"-1") UTF8String]);
    sendMessage.set_house_shi([APPLICATION_NSSTRING_SETTING(wordMessageModel.houseShi, @"-1") UTF8String]);
    sendMessage.set_house_ting([APPLICATION_NSSTRING_SETTING(wordMessageModel.houseTing, @"-1") UTF8String]);
    sendMessage.set_house_area([APPLICATION_NSSTRING_SETTING(wordMessageModel.houseArea, @"-1") UTF8String]);
    sendMessage.set_house_price([APPLICATION_NSSTRING_SETTING(wordMessageModel.housePrice, @"-1") UTF8String]);
    sendMessage.set_rent_price([APPLICATION_NSSTRING_SETTING(wordMessageModel.rentPrice, @"-1") UTF8String]);
    sendMessage.set_title([APPLICATION_NSSTRING_SETTING(wordMessageModel.title, @"暂无") UTF8String]);
    
    sendMessage.set_time_stamp([APPLICATION_NSSTRING_SETTING(wordMessageModel.timeStamp,@"-1") UTF8String]);
    
    sendMessage.set_m_avatar([APPLICATION_NSSTRING_SETTING(wordMessageModel.f_avatar,@"-1") UTF8String]);
    sendMessage.set_m_name([APPLICATION_NSSTRING_SETTING(wordMessageModel.f_name,@"-1") UTF8String]);
    sendMessage.set_m_leve([APPLICATION_NSSTRING_SETTING(wordMessageModel.f_leve,@"-1") UTF8String]);
    sendMessage.set_m_user_type([APPLICATION_NSSTRING_SETTING(wordMessageModel.f_user_type,@"-1") UTF8String]);
    
    sendMessage.set_t_avatar([APPLICATION_NSSTRING_SETTING(wordMessageModel.t_avatar,@"-1") UTF8String]);
    sendMessage.set_t_name([APPLICATION_NSSTRING_SETTING(wordMessageModel.t_name,@"-1") UTF8String]);
    sendMessage.set_t_leve([APPLICATION_NSSTRING_SETTING(wordMessageModel.t_leve,@"-1") UTF8String]);
    sendMessage.set_t_user_type([APPLICATION_NSSTRING_SETTING(wordMessageModel.t_user_type,@"-1") UTF8String]);
    sendMessage.set_device_udid([APPLICATION_NSSTRING_SETTING(wordMessageModel.deviceUUID, @"-1") UTF8String]);
    
    int length = sendMessage.ByteSize();
    int32_t messageLength = static_cast <int32_t> (length + 4);
    int32_t messageType = static_cast <int32_t> (QSChat::QSCHAT_RECOMMEND_HOUSE);
    
    HTONL(messageLength);
    HTONL(messageType);
    
    ///头信息
    char *buf = new char[length];
    sendMessage.SerializeToArray(buf,length);
    [socketManager.tcpSocket writeData:[NSData dataWithBytes:&messageLength length:(sizeof messageLength)] withTimeout:-1 tag:8010];
    [socketManager.tcpSocket writeData:[NSData dataWithBytes:&messageType length:(sizeof messageType)] withTimeout:-1 tag:8011];
    
    ///发主体信息
    [socketManager.tcpSocket writeData:[NSData dataWithBytes:buf length:length] withTimeout:-1 tag:8012];
    
    ///保存消息
    wordMessageModel.readTag = @"1";
    [QSCoreDataManager saveMessageData:wordMessageModel andMessageType:qQSCustomProtocolChatMessageTypeRecommendHouse andCallBack:^(BOOL isSave) {
        
        if (isSave) {
            
            APPLICATION_LOG_INFO(@"聊天消息保存日志->发出消息", @"成功")
            
        } else {
            
            APPLICATION_LOG_INFO(@"聊天消息保存日志->发出消息", @"失败")
            
        }
        
    }];
    
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
+ (void)sendMessageToGroup:(id)msgModel andGroupID:(NSString *)groupID
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
+ (void)registCurrentTalkMessageNotificationWithUserID:(NSString *)userID andCallBack:(CURRENT_TALK_MESSAGE_NOTIFICATION)callBack
{

    QSSocketManager *socketManager = [QSSocketManager shareSocketManager];
    socketManager.currentContactUserID = userID;
    socketManager.currentTalkMessageCallBack = callBack;

}

+ (void)offsCurrentTalkCallBack
{

    QSSocketManager *socketManager = [QSSocketManager shareSocketManager];
    socketManager.currentContactUserID = nil;
    socketManager.currentTalkMessageCallBack = nil;

}

#pragma mark - socket代理
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
    [_tcpSocket readDataWithTimeout:-1 tag:3000];
    
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{

    APPLICATION_LOG_INFO(@"socket日志", @"socket连接已断开，正在重连")
    
    if (self.isWaitConnect) {
        
        return;
        
    }
    
    ///将当前连接状态设置为待连接
    self.isWaitConnect = YES;
    
    ///1秒后重连
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSError *error = nil;
        self.isWaitConnect = NO;
        [self.tcpSocket connectToHost:QS_SOCKET_SERVER_IP onPort:QS_SOCKET_SERVER_PORT withTimeout:-1 error:&error];
        
        if (error) {
            
            APPLICATION_LOG_INFO(@"socket日志->连接失败：", error)
            return;
            
        } else {
            
            APPLICATION_LOG_INFO(@"socket日志->连接成功：", @"无错误")
            [self sendOnLineMessage];
            
        }
        
    });

}

///接收到数据之后执行
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
 
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        __block NSData *tempData = [NSData dataWithData:data];
        do {
            
            ///获取消息长度
            char messageLengthBuf[4] = "\0";
            [tempData getBytes:messageLengthBuf range:NSMakeRange(0, 4)];
            int32_t messageLengthNetwork = intbytesToInt32(messageLengthBuf);
            NTOHL(messageLengthNetwork);
            
            ///获取消息类型
            char messageTypeBuf[4] = "\0";
            [tempData getBytes:messageTypeBuf range:NSMakeRange(4, 4)];
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
                {
                    
                    ///判断当前是否已下线
                    if (![QSCoreDataManager isLogin]) {
                        
                        return;
                        
                    }
                    
                    [QSCoreDataManager logoutCurrentUserCount:^(BOOL isLogout){
                        
                        ///为了保证能收到系统消息，重新发送上线
                        [self sendOnLineMessage];
                        
                        ///消息
                        char *messageBuf = (char *)malloc(messageLengthNetwork - 4);
                        [tempData getBytes:messageBuf range:NSMakeRange(8, messageLengthNetwork - 4)];
                        string messageString = string(messageBuf);
                        
                        ///返回的信息
                        QSChat::AnswerOffline offLineMessage = QSChat::AnswerOffline();
                        offLineMessage.ParseFromString(messageString);
                        
                        ///回调通知当前已被踢下线
                        if (self.serverOffLineNotification) {
                            
                            NSString *tipsString = [NSString stringWithUTF8String:offLineMessage.msg_id().c_str()];
                            dispatch_sync(dispatch_get_main_queue(),^(){
                                
                                self.serverOffLineNotification(lLoginCheckActionTypeOffLine,tipsString);
                                
                            });
                            
                        }
                        
                        ///更新消息数据列
                        tempData = [tempData subdataWithRange:NSMakeRange(messageLengthNetwork + 4, tempData.length - messageLengthNetwork - 4)];
                        
                    }];
                    
                }
                    break;
                    
                    ///历史文字聊天
                case QSChat::QSCHAT_HISTORY_WORD:
                    
                    ///文字聊天
                case QSChat::QSCHAT_WORD:
                {
                    
                    ///消息
                    char *messageBuf = (char *)malloc(messageLengthNetwork - 4);
                    [tempData getBytes:messageBuf range:NSMakeRange(8, messageLengthNetwork - 4)];
                    string messageString = string(messageBuf);
                    
                    ///返回的信息
                    QSChat::AnswerWord wordMessage = QSChat::AnswerWord();
                    wordMessage.ParseFromString(messageString);
                    
                    ///转模型关回调
                    [self handleReceiveWordMessage:[self talk_ChangeCPPToOCModel_Word:wordMessage]];
                    
                    ///更新消息数据列
                    tempData = [tempData subdataWithRange:NSMakeRange(messageLengthNetwork + 4, tempData.length - messageLengthNetwork - 4)];
                    
                }
                    break;
                    
                    ///历史图片聊天
                case QSChat::QSCHAT_HISTORY_PIC:
                    
                    ///图片聊天
                case QSChat::QSCHAT_PIC:
                {
                    
                    ///消息
                    char *messageBuf = (char *)malloc(messageLengthNetwork - 4);
                    [tempData getBytes:messageBuf range:NSMakeRange(8, messageLengthNetwork - 4)];
                    string messageString = string(messageBuf);
                    
                    ///返回的信息
                    QSChat::AnswerPic wordMessage = QSChat::AnswerPic();
                    wordMessage.ParseFromString(messageString);
                    
                    ///转模型关回调
                    [self handleReceivePictureMessage:[self talk_ChangeCPPToOCModel_Picture:wordMessage]];
                    
                    ///更新消息数据列
                    tempData = [tempData subdataWithRange:NSMakeRange(messageLengthNetwork + 4, tempData.length - messageLengthNetwork - 4)];
                    
                }
                    break;
                    
                    ///历史文字聊天
                case QSChat::QSCHAT_HISTORY_VIDEO:
                    
                    ///音频聊天
                case QSChat::QSCHAT_VIDEO:
                {
                    
                    ///消息
                    char *messageBuf = (char *)malloc(messageLengthNetwork - 4);
                    [tempData getBytes:messageBuf range:NSMakeRange(8, messageLengthNetwork - 4)];
                    string messageString = string(messageBuf);
                    
                    ///返回的信息
                    QSChat::AnswerVideo wordMessage = QSChat::AnswerVideo();
                    wordMessage.ParseFromString(messageString);
                    
                    ///转模型关回调
                    [self handleReceiveVideoMessage:[self talk_ChangeCPPToOCModel_Video:wordMessage]];
                    
                    ///更新消息数据列
                    tempData = [tempData subdataWithRange:NSMakeRange(messageLengthNetwork + 4, tempData.length - messageLengthNetwork - 4)];
                    
                }
                    break;
                    
                    ///历史推送房源消息
                case QSChat::QSCHAT_HISTORY_RECOMMEND_HOUSE:
                    
                    ///推送房源消息
                case QSChat::QSCHAT_RECOMMEND_HOUSE:
                {
                
                    ///消息
                    char *messageBuf = (char *)malloc(messageLengthNetwork - 4);
                    [tempData getBytes:messageBuf range:NSMakeRange(8, messageLengthNetwork - 4)];
                    string messageString = string(messageBuf);
                    
                    ///返回的信息
                    QSChat::AnswerRecHouse wordMessage = QSChat::AnswerRecHouse();
                    wordMessage.ParseFromString(messageString);
                    
                    ///转模型关回调
                    [self handleReceiveRecommendHouseMessage:[self talk_ChangeCPPToOCModel_RecommendHouse:wordMessage]];
                    
                    ///更新消息数据列
                    tempData = [tempData subdataWithRange:NSMakeRange(messageLengthNetwork + 4, tempData.length - messageLengthNetwork - 4)];
                
                }
                    break;
                    
                    ///推荐房源消息
                case QSChat::QSCHAT_SPECIAL:
                {
                    
                    ///消息
                    char *messageBuf = (char *)malloc(messageLengthNetwork - 4);
                    [tempData getBytes:messageBuf range:NSMakeRange(8, messageLengthNetwork - 4)];
                    string messageString = string(messageBuf);
                    
                    ///返回的信息
                    QSChat::AnswerSpecial wordMessage = QSChat::AnswerSpecial();
                    wordMessage.ParseFromString(messageString);
                    
                    ///转模型关回调
                    [self handleReceiveSpecialMessage:[self talk_ChangeCPPToOCModel_Special:wordMessage]];
                    
                    ///更新消息数据列
                    tempData = [tempData subdataWithRange:NSMakeRange(messageLengthNetwork + 4, tempData.length - messageLengthNetwork - 4)];
                    
                }
                    break;
                    
                    ///系统消息
                case QSChat::QSCHAT_SYSTEM:
                {
                    
                    ///消息
                    char *messageBuf = (char *)malloc(messageLengthNetwork - 4);
                    [tempData getBytes:messageBuf range:NSMakeRange(8, messageLengthNetwork - 4)];
                    string messageString = string(messageBuf);
                    
                    ///返回的信息
                    QSChat::AnswerSystem wordMessage = QSChat::AnswerSystem();
                    wordMessage.ParseFromString(messageString);
                    
                    ///转模型关回调
                    [self handleReceiveSystemMessage:[self talk_ChangeCPPToOCModel_System:wordMessage]];
                    
                    ///更新消息数据列
                    tempData = [tempData subdataWithRange:NSMakeRange(messageLengthNetwork + 4, tempData.length - messageLengthNetwork - 4)];
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        } while ([tempData length]);
        
    });
    
}

#pragma mark - 接收到的消息处理
- (void)handleReceiveWordMessage:(QSYSendMessageWord *)ocWordModel
{

    ///回调
    if (self.currentTalkMessageCallBack &&
        [self.currentContactUserID isEqualToString:ocWordModel.fromID]) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            self.currentTalkMessageCallBack(YES,ocWordModel);
            
        });
        
        ///由于当前用户已接收并显示消息，所以不再将消息保存在内存中，同时保存本
        ocWordModel.readTag = @"1";
        [QSCoreDataManager saveMessageData:ocWordModel andMessageType:ocWordModel.msgType andCallBack:^(BOOL isSave) {
            
            if (isSave) {
                
                APPLICATION_LOG_INFO(@"聊天消息->已回调当前窗口->保存本地", @"成功")
                
            } else {
            
                APPLICATION_LOG_INFO(@"聊天消息->已回调当前窗口->保存本地", @"失败")
            
            }
            
        }];
        
    } else {
        
        ///保存消息到内存容器
        [self.messageList addObject:ocWordModel];
        
        ///回调离线消息数量
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"readTag == %@",@"0"];
        NSArray *tempArray = [NSArray arrayWithArray:[self.messageList filteredArrayUsingPredicate:predicate]];
        
        ///回调消息数量
        if (self.currentUnReadMessageNumCallBack) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                self.currentUnReadMessageNumCallBack((int)[tempArray count]);
                
            });
            
        }
        
        ///回调消息列表
        if (self.instantMessageNotification) {
            
            QSUserSimpleDataModel *userSimple = [[QSUserSimpleDataModel alloc] init];
            
            userSimple.id_ = ocWordModel.fromID;
            userSimple.avatar = ocWordModel.f_avatar;
            userSimple.username = ocWordModel.f_name;
            userSimple.user_type = ocWordModel.f_user_type;
            userSimple.level = ocWordModel.f_leve;
            
            NSPredicate *personPredicate = [NSPredicate predicateWithFormat:@"fromID == %@ and toID == %@",ocWordModel.fromID,APPLICATION_NSSTRING_SETTING([QSCoreDataManager getUserID], @"-1")];
            NSArray *personArray = [NSArray arrayWithArray:[tempArray filteredArrayUsingPredicate:personPredicate]];
            
            int unreadCount = (int)[personArray count];
            if ([ocWordModel.unread_count intValue] > unreadCount) {
                
                unreadCount = [ocWordModel.unread_count intValue];
                
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                self.instantMessageNotification(ocWordModel.msgType,unreadCount,ocWordModel.message,ocWordModel,userSimple);
                
            });
            
        }
        
    }

}

- (void)handleReceivePictureMessage:(QSYSendMessagePicture *)ocWordModel
{
    
    ///回调
    if (self.currentTalkMessageCallBack &&
        [self.currentContactUserID isEqualToString:ocWordModel.fromID]) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            self.currentTalkMessageCallBack(YES,ocWordModel);
            
        });
        
        ///由于当前用户已接收并显示消息，所以不再将消息保存在内存中，同时保存本
        ocWordModel.readTag = @"1";
        [QSCoreDataManager saveMessageData:ocWordModel andMessageType:ocWordModel.msgType andCallBack:^(BOOL isSave) {
            
            if (isSave) {
                
                APPLICATION_LOG_INFO(@"聊天消息->已回调当前窗口->保存本地", @"成功")
                
            } else {
                
                APPLICATION_LOG_INFO(@"聊天消息->已回调当前窗口->保存本地", @"失败")
                
            }
            
        }];
        
    } else {
        
        ///保存消息
        [self.messageList addObject:ocWordModel];
        
        ///回调离线消息数量
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"readTag == %@",@"0"];
        NSArray *tempArray = [NSArray arrayWithArray:[self.messageList filteredArrayUsingPredicate:predicate]];
        
        ///回调消息数量
        if (self.currentUnReadMessageNumCallBack) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                self.currentUnReadMessageNumCallBack((int)[tempArray count]);
                
            });
            
        }
        
        ///回调消息列表
        if (self.instantMessageNotification) {
            
            QSUserSimpleDataModel *userSimple = [[QSUserSimpleDataModel alloc] init];
            userSimple.id_ = ocWordModel.fromID;
            userSimple.avatar = ocWordModel.f_avatar;
            userSimple.username = ocWordModel.f_name;
            userSimple.user_type = ocWordModel.f_user_type;
            userSimple.level = ocWordModel.f_leve;
            
            NSPredicate *personPredicate = [NSPredicate predicateWithFormat:@"fromID == %@ and toID == %@",ocWordModel.fromID,APPLICATION_NSSTRING_SETTING([QSCoreDataManager getUserID], @"-1")];
            NSArray *personArray = [NSArray arrayWithArray:[tempArray filteredArrayUsingPredicate:personPredicate]];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                self.instantMessageNotification(ocWordModel.msgType,(int)[personArray count],nil,ocWordModel,userSimple);
                
            });
            
        }
        
    }
    
}

- (void)handleReceiveVideoMessage:(QSYSendMessageVideo *)ocWordModel
{
    
    ///回调
    if (self.currentTalkMessageCallBack &&
        [self.currentContactUserID isEqualToString:ocWordModel.fromID]) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            self.currentTalkMessageCallBack(YES,ocWordModel);
            
        });
        
        ///由于当前用户已接收并显示消息，所以不再将消息保存在内存中，同时保存本
        ocWordModel.readTag = @"1";
        [QSCoreDataManager saveMessageData:ocWordModel andMessageType:ocWordModel.msgType andCallBack:^(BOOL isSave) {
            
            if (isSave) {
                
                APPLICATION_LOG_INFO(@"聊天消息->已回调当前窗口->保存本地", @"成功")
                
            } else {
                
                APPLICATION_LOG_INFO(@"聊天消息->已回调当前窗口->保存本地", @"失败")
                
            }
            
        }];
        
    } else {
        
        ///保存消息
        [self.messageList addObject:ocWordModel];
        
        ///回调离线消息数量
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"readTag == %@",@"0"];
        NSArray *tempArray = [NSArray arrayWithArray:[self.messageList filteredArrayUsingPredicate:predicate]];
        
        ///回调消息数量
        if (self.currentUnReadMessageNumCallBack) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                self.currentUnReadMessageNumCallBack((int)[tempArray count]);
                
            });
            
        }
        
        ///回调消息列表
        if (self.instantMessageNotification) {
            
            QSUserSimpleDataModel *userSimple = [[QSUserSimpleDataModel alloc] init];
            userSimple.id_ = ocWordModel.fromID;
            userSimple.avatar = ocWordModel.f_avatar;
            userSimple.username = ocWordModel.f_name;
            userSimple.user_type = ocWordModel.f_user_type;
            userSimple.level = ocWordModel.f_leve;
            
            NSPredicate *personPredicate = [NSPredicate predicateWithFormat:@"fromID == %@ and toID == %@",ocWordModel.fromID,APPLICATION_NSSTRING_SETTING([QSCoreDataManager getUserID], @"-1")];
            NSArray *personArray = [NSArray arrayWithArray:[tempArray filteredArrayUsingPredicate:personPredicate]];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                self.instantMessageNotification(ocWordModel.msgType,(int)[personArray count],nil,ocWordModel,userSimple);
                
            });
            
        }
        
    }
    
}

- (void)handleReceiveRecommendHouseMessage:(QSYSendMessageRecommendHouse *)ocWordModel
{
    
    ///回调
    if (self.currentTalkMessageCallBack &&
        [self.currentContactUserID isEqualToString:ocWordModel.fromID]) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            self.currentTalkMessageCallBack(YES,ocWordModel);
            
        });
        
        ///由于当前用户已接收并显示消息，所以不再将消息保存在内存中，同时保存本地
        ocWordModel.readTag = @"1";
        [QSCoreDataManager saveMessageData:ocWordModel andMessageType:ocWordModel.msgType andCallBack:^(BOOL isSave) {
            
            if (isSave) {
                
                APPLICATION_LOG_INFO(@"聊天消息->已回调当前窗口->保存本地", @"成功")
                
            } else {
                
                APPLICATION_LOG_INFO(@"聊天消息->已回调当前窗口->保存本地", @"失败")
                
            }
            
        }];
        
    } else {
        
        ///保存消息
        [self.messageList addObject:ocWordModel];
        
        ///回调离线消息数量
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"readTag == %@",@"0"];
        NSArray *tempArray = [NSArray arrayWithArray:[self.messageList filteredArrayUsingPredicate:predicate]];
        
        ///回调消息数量
        if (self.currentUnReadMessageNumCallBack) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                self.currentUnReadMessageNumCallBack((int)[tempArray count]);
                
            });
            
        }
        
        ///回调消息列表
        if (self.instantMessageNotification) {
            
            QSUserSimpleDataModel *userSimple = [[QSUserSimpleDataModel alloc] init];
            userSimple.id_ = ocWordModel.fromID;
            userSimple.avatar = ocWordModel.f_avatar;
            userSimple.username = ocWordModel.f_name;
            userSimple.user_type = ocWordModel.f_user_type;
            userSimple.level = ocWordModel.f_leve;
            
            NSPredicate *personPredicate = [NSPredicate predicateWithFormat:@"fromID == %@ and toID == %@",ocWordModel.fromID,APPLICATION_NSSTRING_SETTING([QSCoreDataManager getUserID], @"-1")];
            NSArray *personArray = [NSArray arrayWithArray:[tempArray filteredArrayUsingPredicate:personPredicate]];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                self.instantMessageNotification(ocWordModel.msgType,(int)[personArray count],nil,ocWordModel,userSimple);
                
            });
            
        }
        
    }
    
}

- (void)handleReceiveSystemMessage:(QSYSendMessageSystem *)ocWordModel
{
    
    ///回调
    if (self.currentTalkMessageCallBack) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            self.currentTalkMessageCallBack(YES,ocWordModel);
            
        });
        
        ///由于当前用户已接收并显示消息，所以不再将消息保存在内存中，同时保存本
        ocWordModel.readTag = @"1";
        [QSCoreDataManager saveMessageData:ocWordModel andMessageType:ocWordModel.msgType andCallBack:^(BOOL isSave) {
            
            if (isSave) {
                
                APPLICATION_LOG_INFO(@"聊天消息->已回调当前窗口->保存本地", @"成功")
                
            } else {
                
                APPLICATION_LOG_INFO(@"聊天消息->已回调当前窗口->保存本地", @"失败")
                
            }
            
        }];
        
    } else {
        
        ///保存消息
        [self.messageList addObject:ocWordModel];
        
        ///回调离线消息数量
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"readTag == %@",@"0"];
        NSArray *tempArray = [NSArray arrayWithArray:[self.messageList filteredArrayUsingPredicate:predicate]];
        
        ///回调消息数量
        if (self.currentUnReadMessageNumCallBack) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                self.currentUnReadMessageNumCallBack((int)[tempArray count]);
                
            });
            
        }
        
        ///如果当前有监听系统消息，则回调系统消息
        if (self.systemMessageCountNumCallBack) {
            
            NSPredicate *systemPredicate = [NSPredicate predicateWithFormat:@"msgType == %@",ocWordModel.fromID,ocWordModel.msgType];
            NSArray *systemArray = [NSArray arrayWithArray:[tempArray filteredArrayUsingPredicate:systemPredicate]];
            self.systemMessageCountNumCallBack((int)[systemArray count]);
            
        }
        
        ///回调消息列表
        if (self.instantMessageNotification) {
            
            QSUserSimpleDataModel *userSimple = [[QSUserSimpleDataModel alloc] init];
            userSimple.id_ = ocWordModel.fromID;
            userSimple.avatar = ocWordModel.f_avatar;
            userSimple.username = ocWordModel.f_name;
            userSimple.user_type = @"-1";
            userSimple.level = @"-1";
            
            NSPredicate *personPredicate = [NSPredicate predicateWithFormat:@"fromID == %@ and msgType == %@",ocWordModel.fromID,ocWordModel.msgType];
            NSArray *personArray = [NSArray arrayWithArray:[tempArray filteredArrayUsingPredicate:personPredicate]];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                self.instantMessageNotification(ocWordModel.msgType,(int)[personArray count],ocWordModel.title,nil,userSimple);
                
            });
            
        }
        
    }
    
}

///推送房源
- (void)handleReceiveSpecialMessage:(QSYSendMessageSpecial *)ocWordModel
{
    
    ///回调
    if (self.currentTalkMessageCallBack &&
        [self.currentContactUserID isEqualToString:ocWordModel.fromID]) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            self.currentTalkMessageCallBack(YES,ocWordModel);
            
        });
        
        ///由于当前用户已接收并显示消息，所以不再将消息保存在内存中，同时保存本
        ocWordModel.readTag = @"1";
        [QSCoreDataManager saveMessageData:ocWordModel andMessageType:ocWordModel.msgType andCallBack:^(BOOL isSave) {
            
            if (isSave) {
                
                APPLICATION_LOG_INFO(@"聊天消息->已回调当前窗口->保存本地", @"成功")
                
            } else {
                
                APPLICATION_LOG_INFO(@"聊天消息->已回调当前窗口->保存本地", @"失败")
                
            }
            
        }];
        
    } else {
        
        ///保存消息
        NSPredicate *addPredicate = [NSPredicate predicateWithFormat:@"msgType == %@",ocWordModel.msgType];
        NSArray *tempAddArray = [self.messageList filteredArrayUsingPredicate:addPredicate];
        if ([tempAddArray count] > 0) {
            
            QSYSendMessageSpecial *localModel = tempAddArray[0];
            NSInteger localIndex = [self.messageList indexOfObject:localModel];
            if (localIndex >= 0 && localIndex < [self.messageList count]) {
                
                [self.messageList replaceObjectAtIndex:localIndex withObject:ocWordModel];
                
            }
            
        } else {
        
            [self.messageList addObject:ocWordModel];
        
        }
        
        ///回调离线消息数量
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"readTag == %@",@"0"];
        NSArray *tempArray = [NSArray arrayWithArray:[self.messageList filteredArrayUsingPredicate:predicate]];
        
        ///回调消息数量
        if (self.currentUnReadMessageNumCallBack) {
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                self.currentUnReadMessageNumCallBack((int)[tempArray count]);
                
            });
            
        }
        
        ///回调消息列表
        if (self.instantMessageNotification) {
            
            QSUserSimpleDataModel *userSimple = [[QSUserSimpleDataModel alloc] init];
            userSimple.id_ = ocWordModel.fromID;
            userSimple.avatar = ocWordModel.f_avatar;
            userSimple.username = ocWordModel.f_name;
            userSimple.user_type = @"-1";
            userSimple.level = @"-1";
            
            NSPredicate *personPredicate = [NSPredicate predicateWithFormat:@"fromID == %@ and msgType = %@",ocWordModel.fromID,ocWordModel.msgType];
            NSArray *personArray = [NSArray arrayWithArray:[tempArray filteredArrayUsingPredicate:personPredicate]];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                self.instantMessageNotification(ocWordModel.msgType,(int)[personArray count],ocWordModel.title,ocWordModel,userSimple);
                
            });
            
        }
        
    }
    
}

#pragma mark - 将C++数据模型转为OC的消息模型，然后判断回调
///将C++数据模型转为OC的消息模型，然后判断回调
- (QSYSendMessageWord *)talk_ChangeCPPToOCModel_Word:(QSChat::AnswerWord)cppWordModel
{
    
    ///OC数据模型
    QSYSendMessageWord *ocWordModel = [[QSYSendMessageWord alloc] init];
    ocWordModel.msgType = qQSCustomProtocolChatMessageTypeWord;
    ocWordModel.sendType = qQSCustomProtocolChatSendTypePTP;
    ocWordModel.msgID = [NSString stringWithUTF8String:cppWordModel.msg_id().c_str()];
    ocWordModel.readTag = @"0";
    ocWordModel.deviceUUID = [NSString stringWithUTF8String:cppWordModel.device_udid().c_str()];
    
    int64_t fIDINT32 = cppWordModel.fid();
    ocWordModel.fromID = [NSString stringWithFormat:@"%d",(int)fIDINT32];
    ocWordModel.toID = APPLICATION_NSSTRING_SETTING([QSCoreDataManager getUserID], @"-1");
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

    return ocWordModel;

}

- (QSYSendMessagePicture *)talk_ChangeCPPToOCModel_Picture:(QSChat::AnswerPic)cppWordModel
{
    
    ///OC数据模型
    QSYSendMessagePicture *ocWordModel = [[QSYSendMessagePicture alloc] init];
    ocWordModel.msgType = qQSCustomProtocolChatMessageTypeWord;
    ocWordModel.sendType = qQSCustomProtocolChatSendTypePTP;
    ocWordModel.msgID = [NSString stringWithUTF8String:cppWordModel.msg_id().c_str()];
    ocWordModel.readTag = @"0";
    
    int64_t fIDINT32 = cppWordModel.fid();
    ocWordModel.fromID = [NSString stringWithFormat:@"%d",(int)fIDINT32];
    ocWordModel.toID = APPLICATION_NSSTRING_SETTING([QSCoreDataManager getUserID], @"-1");
    ocWordModel.timeStamp = [NSString stringWithUTF8String:cppWordModel.time_stamp().c_str()];
    
    ///获取图片，保存本地
    NSString *imageDataString = [NSString stringWithUTF8String:cppWordModel.pic().c_str()];
    NSData *imageData = [imageDataString dataUsingEncoding:NSUTF8StringEncoding];
    UIImage *imageSend = [UIImage imageWithData:imageData];
    NSString *rootPath = [self getTalkImageSavePath];
    NSString *savePath = [rootPath stringByAppendingString:ocWordModel.timeStamp];
    
    BOOL isSave = [imageData writeToFile:savePath atomically:YES];
    if (isSave) {
        
        ocWordModel.pictureURL = savePath;
        
    } else {
    
        APPLICATION_LOG_INFO(@"图片消息", @"图片保存失败")
    
    }
    
    ocWordModel.f_avatar = [NSString stringWithUTF8String:cppWordModel.f_avatar().c_str()];
    ocWordModel.f_name = [NSString stringWithUTF8String:cppWordModel.f_name().c_str()];
    ocWordModel.f_user_type = [NSString stringWithUTF8String:cppWordModel.f_user_type().c_str()];
    ocWordModel.f_leve = [NSString stringWithUTF8String:cppWordModel.f_leve().c_str()];
    ocWordModel.unread_count = [NSString stringWithUTF8String:cppWordModel.f_unread_count().c_str()];
    
    CGFloat showWidth = imageSend.size.width;
    CGFloat showHeight = imageSend.size.height;
    if (showWidth > SIZE_DEVICE_WIDTH * 2.0f / 5.0f) {
        
        showWidth = SIZE_DEVICE_WIDTH * 2.0f / 5.0f;
        showHeight = showWidth * imageSend.size.height / imageSend.size.height;
        
    }
    
    showWidth = showWidth + 20.0f;
    showHeight = showHeight + 20.0f;
    ocWordModel.showWidth = showWidth;
    ocWordModel.showHeight = showHeight;
    
    return ocWordModel;
    
}

- (QSYSendMessageVideo *)talk_ChangeCPPToOCModel_Video:(QSChat::AnswerVideo)cppWordModel
{
    
    ///OC数据模型
    QSYSendMessageVideo *ocWordModel = [[QSYSendMessageVideo alloc] init];
    ocWordModel.msgType = qQSCustomProtocolChatMessageTypeWord;
    ocWordModel.sendType = qQSCustomProtocolChatSendTypePTP;
    ocWordModel.msgID = [NSString stringWithUTF8String:cppWordModel.msg_id().c_str()];
    ocWordModel.readTag = @"0";
    
    int64_t fIDINT32 = cppWordModel.fid();
    ocWordModel.fromID = [NSString stringWithFormat:@"%d",(int)fIDINT32];
    ocWordModel.toID = APPLICATION_NSSTRING_SETTING([QSCoreDataManager getUserID], @"-1");
    ocWordModel.timeStamp = [NSString stringWithUTF8String:cppWordModel.time_stamp().c_str()];
    
    ///获取音频消息
    ocWordModel.f_avatar = [NSString stringWithUTF8String:cppWordModel.f_avatar().c_str()];
    ocWordModel.f_name = [NSString stringWithUTF8String:cppWordModel.f_name().c_str()];
    ocWordModel.f_user_type = [NSString stringWithUTF8String:cppWordModel.f_user_type().c_str()];
    ocWordModel.f_leve = [NSString stringWithUTF8String:cppWordModel.f_leve().c_str()];
    ocWordModel.unread_count = [NSString stringWithUTF8String:cppWordModel.f_unread_count().c_str()];
    
//    CGFloat showHeight = 30.0f;
//    CGFloat showWidth = [ocWordModel.message calculateStringDisplayWidthByFixedHeight:showHeight andFontSize:FONT_BODY_16];
//    if (showWidth > (SIZE_DEVICE_WIDTH * 3.0f / 5.0f - 20.0f)) {
//        
//        showWidth = (SIZE_DEVICE_WIDTH * 3.0f / 5.0f - 20.0f);
//        showHeight = [ocWordModel.message calculateStringDisplayHeightByFixedWidth:showWidth andFontSize:FONT_BODY_16];
//        
//    }
    
//    showWidth = showWidth + 20.0f;
//    showHeight = showHeight + 20.0f;
//    ocWordModel.showWidth = showWidth;
//    ocWordModel.showHeight = showHeight;
    
    return ocWordModel;
    
}

- (QSYSendMessageRecommendHouse *)talk_ChangeCPPToOCModel_RecommendHouse:(QSChat::AnswerRecHouse)cppWordModel
{
    
    ///OC数据模型
    QSYSendMessageRecommendHouse *ocWordModel = [[QSYSendMessageRecommendHouse alloc] init];
    ocWordModel.msgType = qQSCustomProtocolChatMessageTypeRecommendHouse;
    ocWordModel.sendType = qQSCustomProtocolChatSendTypePTP;
    ocWordModel.msgID = [NSString stringWithUTF8String:cppWordModel.msg_id_().c_str()];
    ocWordModel.readTag = @"0";
    
    int64_t fIDINT32 = cppWordModel.finfo().fid();
    ocWordModel.fromID = [NSString stringWithFormat:@"%d",(int)fIDINT32];
    ocWordModel.toID = APPLICATION_NSSTRING_SETTING([QSCoreDataManager getUserID], @"-1");
    ocWordModel.timeStamp = [NSString stringWithUTF8String:cppWordModel.msg_id_().c_str()];
    
    ///房源信息
    ocWordModel.houseID = [NSString stringWithUTF8String:cppWordModel.finfo().house_id().c_str()];
    ocWordModel.buildingID = [NSString stringWithUTF8String:cppWordModel.finfo().building_id().c_str()];
    ocWordModel.houseType = [NSString stringWithUTF8String:cppWordModel.finfo().house_type().c_str()];
    ocWordModel.originalImage = [NSString stringWithUTF8String:cppWordModel.attach_file().c_str()];
    ocWordModel.smallImage = [NSString stringWithUTF8String:cppWordModel.attach_thumb().c_str()];
    ocWordModel.districtKey = [NSString stringWithUTF8String:cppWordModel.areaid().c_str()];
    ocWordModel.district = [NSString stringWithUTF8String:cppWordModel.area_val().c_str()];
    ocWordModel.streetKey = [NSString stringWithUTF8String:cppWordModel.streetid().c_str()];
    ocWordModel.street = [NSString stringWithUTF8String:cppWordModel.street_val().c_str()];
    ocWordModel.houseShi = [NSString stringWithUTF8String:cppWordModel.house_shi().c_str()];
    ocWordModel.houseTing = [NSString stringWithUTF8String:cppWordModel.house_ting().c_str()];
    ocWordModel.houseArea = [NSString stringWithUTF8String:cppWordModel.house_area().c_str()];
    ocWordModel.housePrice = [NSString stringWithUTF8String:cppWordModel.house_price().c_str()];
    ocWordModel.rentPrice = [NSString stringWithUTF8String:cppWordModel.rent_price().c_str()];
    ocWordModel.title = [NSString stringWithUTF8String:cppWordModel.title_().c_str()];
    
    ocWordModel.f_avatar = [NSString stringWithUTF8String:cppWordModel.finfo().f_avatar().c_str()];
    ocWordModel.f_name = [NSString stringWithUTF8String:cppWordModel.finfo().f_name().c_str()];
    ocWordModel.f_user_type = [NSString stringWithUTF8String:cppWordModel.finfo().f_user_type().c_str()];
    ocWordModel.f_leve = [NSString stringWithUTF8String:cppWordModel.finfo().f_leve().c_str()];
    ocWordModel.unread_count = [NSString stringWithUTF8String:cppWordModel.finfo().f_unread_count().c_str()];
    ocWordModel.deviceUUID = @"-1";
    
    ocWordModel.showWidth = SIZE_DEVICE_WIDTH * 3.0f / 4.0f;
    ocWordModel.showHeight = 90.0f;
    
    return ocWordModel;
    
}

- (QSYSendMessageSystem *)talk_ChangeCPPToOCModel_System:(QSChat::AnswerSystem)cppWordModel
{
    
    ///OC数据模型
    QSYSendMessageSystem *ocWordModel = [[QSYSendMessageSystem alloc] init];
    
    
    return ocWordModel;
    
}

- (QSYSendMessageSpecial *)talk_ChangeCPPToOCModel_Special:(QSChat::AnswerSpecial)cppWordModel
{

    ///OC数据模型
    QSYSendMessageSpecial *ocWordModel = [[QSYSendMessageSpecial alloc] init];
    
    
    return ocWordModel;

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
            
            ///历史文字消息
        case qQSCustomProtocolChatMessageTypeHistoryWord:
            
            return QSChat::QSCHAT_HISTORY_WORD;
            
            ///历史图片消息
        case qQSCustomProtocolChatMessageTypeHistoryPicture:
            
            return QSChat::QSCHAT_HISTORY_PIC;
            
            ///历史语音消息
        case qQSCustomProtocolChatMessageTypeHistoryVideo:
            
            return QSChat::QSCHAT_HISTORY_VIDEO;
            
            ///指定联系人的历史未读消息
        case qQSCustomProtocolChatMessageTypeHistory:
            
            return QSChat::QSCHAT_HISTORY;
            
            ///推荐房源
        case qQSCustomProtocolChatMessageTypeRecommendHouse:
            
            return QSChat::QSCHAT_RECOMMEND_HOUSE;
            
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
+ (void)registInstantMessageReceiveNotification:(INSTANT_MESSAGE_NOTIFICATION)callBack
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

/**
 *  @author         yangshengmeng, 15-04-11 10:04:06
 *
 *  @brief          注册系统消息监听，当有系统消息到来时，回调当前最新系统消息及总消息数量
 *
 *  @param callBack 监听的回调
 *
 *  @since          1.0.0
 */
+ (void)registSystemMessageReceiveNotification:(APPOINT_MESSAGE_LASTCOUNT_NOTIFICATION)callBack
{

    if (callBack) {
        
        QSSocketManager *socketManager = [QSSocketManager shareSocketManager];
        socketManager.systemMessageCountNumCallBack = callBack;
        
    }

}

+ (void)offsSystemMessageReceiveNotification
{

    QSSocketManager *socketManager = [QSSocketManager shareSocketManager];
    socketManager.systemMessageCountNumCallBack = nil;

}

/**
 *  @author         yangshengmeng, 15-04-21 10:04:09
 *
 *  @brief          被踢下线时的回调监听
 *
 *  @param callBack 回调block
 *
 *  @since          1.0.0
 */
+ (void)registSocketServerOffLineNotification:(SERVER_OFF_LINE_NOTIFICATION)callBack
{

    if (callBack) {
        
        QSSocketManager *socketManager = [QSSocketManager shareSocketManager];
        socketManager.serverOffLineNotification = callBack;
        
    } else {
    
        QSSocketManager *socketManager = [QSSocketManager shareSocketManager];
        socketManager.serverOffLineNotification = nil;
        
    }

}

+ (void)offRegistSocketServerOffLineNotification
{

    QSSocketManager *socketManager = [QSSocketManager shareSocketManager];
    socketManager.serverOffLineNotification = nil;

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
