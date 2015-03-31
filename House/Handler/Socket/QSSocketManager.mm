//
//  QSSocketManager.m
//  House
//
//  Created by ysmeng on 15/3/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSSocketManager.h"

#import "Chat.pb.h"

#import "ODSocket.h"
#include <iostream>
#include <string.h>

#import "AsyncSocket.h"

using namespace std;

@interface QSSocketManager () <AsyncSocketDelegate,NSStreamDelegate>

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
    [self.tcpSocket connectToHost:@"117.41.235.107" onPort:8000 withTimeout:-1 error:&error];
    
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
+ (void)sendMessageToPerson:(id)msgModel andCallBack:(void(^)(BOOL flag,id model))callBack
{
    
    ///自身单例
    QSSocketManager *socketManager = [QSSocketManager shareSocketManager];

    ///发消息
    chat::Question sendMessage;
    sendMessage.set_tid(20);
    sendMessage.set_mid(10);
    sendMessage.set_type(chat::ChatRequestType::ChatTypeSendPTP);
    sendMessage.set_message(string("发送消息"));
    
    int length = sendMessage.ByteSize();
    char *buf = new char[length];
    sendMessage.SerializeToArray(buf,length);
    
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

#pragma mark - socket调试
///socket连接到服务器时执行
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    
    NSLog(@"连接成功");
    
}

///准备读取数据
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    
    APPLICATION_LOG_INFO(@"socket调试", @"准备接收数据")
    
    ///准备读取数据
    [_tcpSocket readDataWithTimeout:-1 tag:300];
    
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{

    APPLICATION_LOG_INFO(@"socket日志", @"socket连接已断开，正在重连")
    NSError *error = nil;
    [self.tcpSocket connectToHost:@"117.41.235.107" onPort:8000 withTimeout:-1 error:&error];
    
    if (error) {
        
        APPLICATION_LOG_INFO(@"TCP连接失败：", error)
        return;
        
    } else {
        
        APPLICATION_LOG_INFO(@"TCP连接成功：", @"无错误")
        
    }

}

///接收到数据之后执行
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    APPLICATION_LOG_INFO(@"socket返回信息", data)
    
    char recvBuf[1024] = "\0";
    [data getBytes:recvBuf length:data.length];
    string rec_msg = string(recvBuf);
    
    ///返回的信息
    chat::Answer answer = chat::Answer();
    answer.ParseFromString(rec_msg);
    NSLog(@"返回的信息：%s",rec_msg.c_str());
    NSLog(@"解析出来的信息：%s",answer.message().c_str());
    NSString *resultString = [NSString stringWithUTF8String:answer.message().c_str()];
    NSLog(@"转换后的信息：%@",resultString);
    
}

@end
