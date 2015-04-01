//
//  QSSocketManager.m
//  House
//
//  Created by ysmeng on 15/3/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSSocketManager.h"

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

using namespace std;

///服务端地址
#define QS_SOCKET_SERVER_IP @"192.168.1.145"
#define QS_SOCKET_SERVER_PORT 8000
//#define QS_SOCKET_SERVER_IP @"117.41.235.107"

@interface QSSocketManager () <AsyncSocketDelegate,NSStreamDelegate>

///当前聊天的回调
@property (nonatomic,copy) void(^currentTalkMessageCallBack)(BOOL flag,id messageModel);

@property (nonatomic,strong) AsyncSocket *tcpSocket;//!<socket连接器

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
    
#if 0
    int32_t testLength = 10;
    char *testChar;
    sprintf(testChar, "%d", testLength);
    NSLog(@"%s",testChar);
    HTONL(testLength);
    sprintf(testChar, "%d",testLength);
#endif
    
    qschat::QuestionOnline onLineMessage;
//    onLineMessage.set_token([[QSCoreDataManager getApplicationCurrentTokenID] UTF8String]);
    onLineMessage.set_token([[QSCoreDataManager getUserID] UTF8String]);
    
    int length = onLineMessage.ByteSize();
    int32_t messageLength = static_cast <int32_t> (length + 4);
    int32_t messageType = static_cast <int32_t> ([socketManager talk_ChangeOCEnumToCPP_MessageType:qQSCustomProtocolChatMessageTypeOnLine]);
    
    HTONL(messageLength);
    HTONL(messageType);
    
    char *buf = new char[length];
    onLineMessage.SerializeToArray(buf,length);
    
    ///先发送长度和类型
    [socketManager.tcpSocket writeData:[NSData dataWithBytes:&messageLength length:(sizeof messageLength)] withTimeout:-1 tag:300];
    [socketManager.tcpSocket writeData:[NSData dataWithBytes:&messageType length:(sizeof messageType)] withTimeout:-1 tag:300];
    
    ///再发主体信息
    [socketManager.tcpSocket writeData:[NSData dataWithBytes:buf length:length] withTimeout:-1 tag:300];

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
    
    ///先发送长度和类型
    QSSocketManager *socketManager = [QSSocketManager shareSocketManager];
    
    ///保存回调
    if (callBack) {
        
        socketManager.currentTalkMessageCallBack = callBack;
        
    }

    qschat::QuestionWord sendMessage;
    
    ///设置消息体
    int32_t fromIDINT32 = [wordMessageModel.fromID intValue];
    sendMessage.set_mid(fromIDINT32);
    int32_t toIDINT32 = [wordMessageModel.toID intValue];
    sendMessage.set_tid(toIDINT32);
    sendMessage.set_ctype([socketManager talk_ChangeOCEnumToCPP_SendType:wordMessageModel.sendType]);
    sendMessage.set_message([wordMessageModel.message UTF8String]);
    
    int length = sendMessage.ByteSize();
    int32_t messageLength = static_cast <int32_t> (length + 4);
    int32_t messageType = static_cast <int32_t> (qQSCustomProtocolChatMessageTypeWord);
    
    HTONL(messageLength);
    HTONL(messageType);
    
    char *buf = new char[length];
    sendMessage.SerializeToArray(buf,length);
    [socketManager.tcpSocket writeData:[NSData dataWithBytes:&messageLength length:(sizeof messageLength)] withTimeout:-1 tag:300];
    [socketManager.tcpSocket writeData:[NSData dataWithBytes:&messageType length:(sizeof messageType)] withTimeout:-1 tag:300];
    
    ///再发主体信息
    [socketManager.tcpSocket writeData:[NSData dataWithBytes:buf length:length] withTimeout:-1 tag:300];

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
        case qschat::ONLINE:
            
            break;
            
            ///下线
        case qschat::OFFLINE:
            
            break;
            
            ///文字聊天
        case qschat::WORD:
        {
        
            ///消息
            char *messageBuf = (char *)malloc(messageLengthNetwork - 4);
            [data getBytes:messageBuf range:NSMakeRange(8, messageLengthNetwork - 4)];
            string messageString = string(messageBuf);
            
            ///返回的信息
            qschat::AnswerWord wordMessage = qschat::AnswerWord();
            wordMessage.ParseFromString(messageString);
            NSString *resultString = [NSString stringWithUTF8String:wordMessage.message().c_str()];
            APPLICATION_LOG_INFO(@"返回的消息", resultString)
            
            ///转模型关回调
            [self talk_ChangeCPPToOCModel_Word:wordMessage];
            
        }
            break;
            
            ///图片聊天
        case qschat::PIC:
            
            break;
            
            ///视频聊天
        case qschat::VIDEO:
            
            break;
            
            ///推荐房源消息
        case qschat::SPECIAL:
            
            break;
            
            ///系统消息
        case qschat::SYSTEM:
            
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 将C++数据模型转为OC的消息模型，然后判断回调
- (void)talk_ChangeCPPToOCModel_Word:(qschat::AnswerWord)cppWordModel
{
    
    ///OC数据模型
    QSYSendMessageWord *ocWordModel = [[QSYSendMessageWord alloc] init];
    ocWordModel.msgType = qQSCustomProtocolChatMessageTypeWord;
    ocWordModel.fromID = @"123";
    ocWordModel.toID = @"123";
    ocWordModel.message = [NSString stringWithUTF8String:cppWordModel.message().c_str()];
    ocWordModel.sendType = qQSCustomProtocolChatSendTypePTG;

    ///回调
    if (self.currentTalkMessageCallBack) {
        
        self.currentTalkMessageCallBack(YES,ocWordModel);
        
    }

}

///将OC的消息类型转为C++的消息类型
- (qschat::ChatMessageType)talk_ChangeOCEnumToCPP_MessageType:(QSCUSTOM_PROTOCOL_CHAT_MESSAGE_TYPE)ocType
{
    
    switch (ocType) {
            ///文字信息
        case qQSCustomProtocolChatMessageTypeWord:
            
            return qschat::WORD;
            
            ///图片信息
        case qQSCustomProtocolChatMessageTypePicture:
            
            return qschat::PIC;
            
            ///音频信息
        case qQSCustomProtocolChatMessageTypeVideo:
            
            return qschat::VIDEO;
            
            ///上线消息
        case qQSCustomProtocolChatMessageTypeOnLine:
            
            return qschat::ONLINE;
            
            ///下线消息
        case qQSCustomProtocolChatMessageTypeOffLine:
            
            return qschat::OFFLINE;
            
            ///推送房源
        case qQSCustomProtocolChatMessageTypeSpecial:
            
            return qschat::SPECIAL;
            
            ///系统消息
        case qQSCustomProtocolChatMessageTypeSystem:
            
            return qschat::SYSTEM;
            
        default:
            break;
    }
    
    return qschat::WORD;
    
}

///将OC的消息发送类型转为C++的发送类型
- (qschat::ChatRequestType)talk_ChangeOCEnumToCPP_SendType:(QSCUSTOM_PROTOCOL_CHAT_SEND_TYPE)ocType
{

    switch (ocType) {
            ///单聊
        case qQSCustomProtocolChatSendTypePTP:
            
            return qschat::ChatTypeSendPTP;
        
            ///群聊
        case qQSCustomProtocolChatSendTypePTG:
            
            return qschat::ChatTypeSendPTG;
            
        default:
            break;
    }
    
    return qschat::ChatTypeSendPTP;

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

@end
