//
//  QSSocketManager.m
//  House
//
//  Created by ysmeng on 15/3/17.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSSocketManager.h"

#import "AsyncSocket.h"

#import "Chat.pb.h"

static QSSocketManager *_socketManager = nil;
@interface QSSocketManager () <AsyncSocketDelegate>

@property (nonatomic,strong) AsyncSocket *tcpSocket;

@end

@implementation QSSocketManager

#pragma mark - Socket管理器
/**
 *  @author yangshengmeng, 15-03-17 14:03:18
 *
 *  @brief  socket单例
 *
 *  @return 返回当前的socket管理器
 *
 *  @since  1.0.0
 */
+ (instancetype)shareSocketManager
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

#pragma mark - 初始化参数
- (void)initParams
{
    
    NSError *error = nil;

    ///socket链
    self.tcpSocket = [[AsyncSocket alloc] initWithDelegate:self];
    [_tcpSocket connectToHost:@"117.41.235.107" onPort:8000 withTimeout:-1 error:&error];
    
    if (error) {
        
        APPLICATION_LOG_INFO(@"TCP连接失败：", error)
        return;
        
    } else {
        
        APPLICATION_LOG_INFO(@"TCP连接成功：", @"无错误")
        
    }

}

#pragma mark - 发送消息
- (void)sendMessageToPersion:(NSString *)tID andMessage:(NSString *)msg
{

    ///toID
    NSString *toID = tID ? tID : @"20";
    NSString *myID = @"10";
    int64_t toIDINT = atoll([toID UTF8String]);
    int64_t myIDINT = atoll([myID UTF8String]);
    
//    Question *sendInfo = [Question defaultInstance];
//    [sendInfo.builder setTid:toIDINT];
//    [sendInfo.builder setMid:myIDINT];
//    [sendInfo.builder setType:ChatRequestTypeChatTypeSendPtp];
//    [sendInfo.builder setMessage:msg ? msg : @"阿定是傻冒"];
    Question *sendInfo = [[[[[Question builder] setMid:myIDINT] setTid:toIDINT] setType:ChatRequestTypeChatTypeSendPtp] setMessage:@"我是消息"].build;
    
    ///ChatMsg.Question question = ChatMsg.Question.newBuilder().setMessage("我是消息").setMid(10).setTid(20).setType(ChatMsg.ChatRequestType.ChatTypeSendPTP).build();
    
    NSData *msgData = [NSData dataWithData:[sendInfo data]];
//    uint32_t length = (uint32_t)(msgData.length + 4);
//    int length = (int)msgData.length;
//    length = EndianIntConvertLToBig(length);
//    HTONL(length);
//    char headerData[sizeof(uint32_t)] = {'0','0','0','0'};
//    char headerData[sizeof(UInt32)];
//    sprintf(headerData, "%d",length);
    
//    NSString *lengthString = [NSString stringWithFormat:@"%d",length];
//    [self.tcpSocket writeData:[lengthString dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:300];
    
//    NSMutableData *tempSendData = [[NSMutableData alloc] initWithBytes:headerData length:sizeof(UInt32)];
//    NSMutableData *tempSendData = [NSMutableData dataWithData:[lengthString dataUsingEncoding:NSUTF8StringEncoding]];
//    [tempSendData appendData:msgData];
    
    ///发送一些测试信息
    [self.tcpSocket writeData:msgData withTimeout:-1 tag:300];

}

int EndianIntConvertLToBig(int InputNum)
{
    
    int k = InputNum;
    char *p = (char *)&k;
    for (int i = 0; i < sizeof(k); i++) {
        
        NSLog(@"%d",p[i]);
        
    }
    
    unsigned int num,num1,num2,num3,num4;
    num1 = (unsigned int)(*p) << 24;
    num2 = ((unsigned int) *(p+1)) << 16;
    num3 = ((unsigned int) *(p+2)) << 8;
    num4 = ((unsigned int) *(p+3));
    num = num1 + num2 + num3 + num4;
    NSLog(@"num is %d",num);
    char * q = (char *)&num;
    
    for (int i = 0; i < sizeof(num); i++) {
        
        NSLog(@"%d",q[i]);
        
    }
    
    return num;
    
}

#pragma mark - socket调试
///socket连接到服务器时执行
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    
    NSLog(@"连接成功");
    
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    
    APPLICATION_LOG_INFO(@"将要断开连接", err)
    
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{

    APPLICATION_LOG_INFO(@"已断开连接", @"已断开连接")
    NSError *error = nil;
    [_tcpSocket connectToHost:@"117.41.235.107" onPort:8000 withTimeout:-1 error:&error];

}

///准备读取数据
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    
    APPLICATION_LOG_INFO(@"socket调试", @"准备接收数据")
    
    ///准备读取数据
    [_tcpSocket readDataWithTimeout:-1 tag:300];
    
}

///接收到数据之后执行
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    Answer *answer = [Answer parseFromData:data];
    APPLICATION_LOG_INFO(@"socket返回信息：", answer.message);
//    NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSString *showString = [NSString stringWithFormat:@"服务器：%@\n返回数据：%@",sock.connectedHost,resultString];
//    APPLICATION_LOG_INFO(@"socket返回信息:", showString);
    
}

@end
