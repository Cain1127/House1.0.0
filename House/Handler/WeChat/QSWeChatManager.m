//
//  QSWeChatManager.m
//  House
//
//  Created by 王树朋 on 15/4/20.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWeChatManager.h"


@implementation QSWeChatManager

-(id)initWithVC:(QSSecondHouseDetailViewController *)viewController;
{
    
    if (self = [super init]) {
        
        _scene = WXSceneSession;
        
        //向微信注册
        [WXApi registerApp:@"wxc1d288df9337eb74" withDescription:@"houses 1.0.0"];

    }
    
    return self;

}


-(void) changeScene:(NSInteger)scene
{
    _scene = scene;
}

#pragma mark -请求
- (void)sendAuthRequest
{
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"; // @"post_timeline,sns"
    req.state = @"xxx";
    req.openID = @"0c806938e2413ce73eef92cc3";
    
    [WXApi sendAuthReq:req viewController:self delegate:self];
}


#pragma mark -发送信息
#define BUFFER_SIZE 1024 * 100
- (void) sendAppContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"App消息";
    message.description = @"这种消息只有App自己才能理解，由App指定打开方式！";
    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
    message.messageExt = @"这是第三方带的测试字段";
    message.messageAction = @"<action>dotaliTest</action>";
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = @"<xml>extend info</xml>";
    ext.url = @"http://weixin.qq.com";
    
    Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
    memset(pBuffer, 0, BUFFER_SIZE);
    NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
    free(pBuffer);
    
    ext.fileData = data;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

#pragma mark -返回结果
-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *temp = (SendAuthResp*)resp;
        
        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
        NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", temp.code, temp.state, temp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
//    else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]])
//    {
//        AddCardToWXCardPackageResp* temp = (AddCardToWXCardPackageResp*)resp;
//        NSMutableString* cardStr = [[NSMutableString alloc] init];
//        for (WXCardItem* cardItem in temp.cardAry) {
//            [cardStr appendString:[NSString stringWithFormat:@"cardid:%@ cardext:%@ cardstate:%lu\n",cardItem.cardId,cardItem.extMsg,cardItem.cardState]];
//        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"add card resp" message:cardStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
}



@end
