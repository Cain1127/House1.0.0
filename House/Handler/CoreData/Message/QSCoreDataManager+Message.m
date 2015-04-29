//
//  QSCoreDataManager+Message.m
//  House
//
//  Created by ysmeng on 15/4/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSCoreDataManager+Message.h"
#import "QSCDChatMessagesDataModel.h"
#import "QSYSendMessageWord.h"
#import "QSYSendMessagePicture.h"
#import "QSYSendMessageVideo.h"
#import "QSYSendMessageSystem.h"
#import "NSDate+Formatter.h"

#import "QSCoreDataManager+User.h"

#import "QSYAppDelegate.h"

#define COREDATA_ENTITYNAME_MESSAGE @"QSCDChatMessagesDataModel"

@implementation QSCoreDataManager (Message)

#pragma mark - 查询历史消息
/**
 *  @author             yangshengmeng, 15-04-10 15:04:55
 *
 *  @brief              查询指定用户的历史消息
 *
 *  @param personID     指定用户ID
 *  @param timeStamp    开始的时间戳
 *
 *  @return             返回查询结果
 *
 *  @since              1.0.0
 */
+ (NSArray *)getPersonLocalMessage:(NSString *)personID andStarTimeStamp:(NSString *)timeStamp
{
    
    ///获取给定用户发送的离线消息
    NSString *currentUserID = [QSCoreDataManager getUserID];
    NSString *originalTime = [NSDate currentDateTimeStamp];
    NSString *starTime = APPLICATION_NSSTRING_SETTING(timeStamp, originalTime);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fromID == %@ && toID = %@ && timeStamp < %@",APPLICATION_NSSTRING_SETTING(personID, @""),APPLICATION_NSSTRING_SETTING(currentUserID, @"1"),starTime];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
    NSArray *persionSendArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_MESSAGE andCustomPredicate:predicate andCustomSort:sort];
    
    ///获取我发送指定用户的离线消息
    predicate = [NSPredicate predicateWithFormat:@"fromID == %@ && toID = %@ && timeStamp < %@",APPLICATION_NSSTRING_SETTING(currentUserID, @""),APPLICATION_NSSTRING_SETTING(personID, @""),starTime];
    NSArray *mySendArray = [self searchEntityListWithKey:COREDATA_ENTITYNAME_MESSAGE andCustomPredicate:predicate andCustomSort:sort];
    
    ///如果两个数组都为空，直接返回
    if (0 >= [persionSendArray count] &&
        0 >= [mySendArray count]) {
        
        return [NSArray array];
        
    }
    
    ///组合消息
    NSMutableArray *packArray = [NSMutableArray arrayWithArray:persionSendArray];
    [packArray addObjectsFromArray:mySendArray];
    
    ///排序
    [packArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        QSCDChatMessagesDataModel *firtModel = obj1;
        QSCDChatMessagesDataModel *secondModel = obj2;
        return [firtModel.timeStamp floatValue] > [secondModel.timeStamp floatValue];
        
    }];
    
    ///只返回最多十个记录
    NSMutableArray *tempResultArray = [NSMutableArray array];
    if ([packArray count] > 10) {
        
        [tempResultArray addObjectsFromArray:[packArray subarrayWithRange:NSMakeRange([packArray count] - 10, 10)]];
        
    } else {
    
        [tempResultArray addObjectsFromArray:packArray];
    
    }
    
    ///转换模型
    NSMutableArray *resultTempArray = [NSMutableArray array];
    for (int i = 0; i < [tempResultArray count]; i++) {
        
        QSCDChatMessagesDataModel *tempModel = tempResultArray[i];
        switch ([tempModel.msgType intValue]) {
                ///文字消息
            case qQSCustomProtocolChatMessageTypeHistoryWord:
            case qQSCustomProtocolChatMessageTypeWord:
                
                [resultTempArray addObject:[self message_ChangeMessageWordCDModel_TO_OCModel:tempModel]];
                
                break;
                
                ///图片消息
            case qQSCustomProtocolChatMessageTypeHistoryPicture:
            case qQSCustomProtocolChatMessageTypePicture:
                
                [resultTempArray addObject:[self message_ChangeMessagePictureCDModel_TO_OCModel:tempModel]];
                
                break;
                
                ///语音消息
            case qQSCustomProtocolChatMessageTypeHistoryVideo:
            case qQSCustomProtocolChatMessageTypeVideo:
                
                [resultTempArray addObject:[self message_ChangeMessageVideoCDModel_TO_OCModel:tempModel]];
                
                break;
                
                ///系统消息
            case qQSCustomProtocolChatMessageTypeSystem:
                
                [resultTempArray addObject:[self message_ChangeMessageSystemCDModel_TO_OCModel:tempModel]];
                
                break;
                
            default:
                break;
        }
        
    }
    
    return [NSArray arrayWithArray:resultTempArray];

}

#pragma mark - 保存消息
/**
 *  @author             yangshengmeng, 15-04-10 14:04:02
 *
 *  @brief              将消息保存到本地
 *
 *  @param messageModel 消息的数据模型
 *  @param msgType      消息类型
 *
 *  @since              1.0.0
 */
+ (void)saveMessageData:(id)messageModel andMessageType:(QSCUSTOM_PROTOCOL_CHAT_MESSAGE_TYPE)msgType andCallBack:(void(^)(BOOL isSave))callBack
{

    switch (msgType) {
            ///文字消息
        case qQSCustomProtocolChatMessageTypeWord:
        
            ///历史文字消息
        case qQSCustomProtocolChatMessageTypeHistoryWord:
        {
        
            [self saveWordMessage:messageModel andCallBack:callBack];
        
        }
            break;
            
            ///图片消息
        case qQSCustomProtocolChatMessageTypePicture:
            
            ///历史图片消息
        case qQSCustomProtocolChatMessageTypeHistoryPicture:
        {
            
            [self savePictureMessage:messageModel andCallBack:callBack];
            
        }
            break;
            
            ///音频消息
        case qQSCustomProtocolChatMessageTypeVideo:
        
            ///历史音频消息
        case qQSCustomProtocolChatMessageTypeHistoryVideo:
        {
            
            [self saveVideoMessage:messageModel andCallBack:callBack];
            
        }
            break;
            
            ///系统消息
        case qQSCustomProtocolChatMessageTypeSystem:
        {
            
            [self saveSystemMessage:messageModel andCallBack:callBack];
            
        }
            break;
            
        default:
            break;
    }

}

///保存文字消息
+ (void)saveWordMessage:(QSYSendMessageWord *)wordModel andCallBack:(void(^)(BOOL isSave))callBack
{
    
    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有context
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:COREDATA_ENTITYNAME_MESSAGE inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timeStamp == %@",wordModel.timeStamp];
    [fetchRequest setPredicate:predicate];
    
    NSError *error=nil;
    NSArray *fetchResultArray = [tempContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        
        NSLog(@"CoreData.SearchCollectedData.Error:%@",error);
        if (callBack) {
            
            callBack(NO);
            
        }
        return;
        
    }
    
    ///判断本地是否有数据
    if ([fetchResultArray count] > 0) {
        
        QSCDChatMessagesDataModel *cdCollectedModel = fetchResultArray[0];
        [self message_ChangeMessageWordOCModel_TO_CDModel:cdCollectedModel andOCModel:wordModel];
        [tempContext save:&error];
        
    } else {
        
        QSCDChatMessagesDataModel *cdCollectedModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_MESSAGE inManagedObjectContext:tempContext];
        [self message_ChangeMessageWordOCModel_TO_CDModel:cdCollectedModel andOCModel:wordModel];
        [tempContext save:&error];
        
    }
    
    ///判断是否保存成功
    if (error) {
        
        NSLog(@"CoreData.SaveCollectedData.Error:%@",error);
        if (callBack) {
            
            callBack(NO);
            
        }
        return;
        
    }
    
    ///保存数据到本地
    if ([NSThread isMainThread]) {
        
        [appDelegate saveContextWithWait:YES];
        
    } else {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [appDelegate saveContextWithWait:NO];
            
        });
        
    }
    
    ///回调
    if (callBack) {
        
        callBack(YES);
        
    }
    
}

///保存图片消息
+ (void)savePictureMessage:(QSYSendMessagePicture *)wordModel andCallBack:(void(^)(BOOL isSave))callBack
{
    
    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有context
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:COREDATA_ENTITYNAME_MESSAGE inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timeStamp == %@",wordModel.timeStamp];
    [fetchRequest setPredicate:predicate];
    
    NSError *error=nil;
    NSArray *fetchResultArray = [tempContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        
        NSLog(@"CoreData.SearchCollectedData.Error:%@",error);
        if (callBack) {
            
            callBack(NO);
            
        }
        return;
        
    }
    
    ///判断本地是否有数据
    if ([fetchResultArray count] > 0) {
        
        QSCDChatMessagesDataModel *cdCollectedModel = fetchResultArray[0];
        [self message_ChangeMessagePictureOCModel_TO_CDModel:cdCollectedModel andOCModel:wordModel];
        [tempContext save:&error];
        
    } else {
        
        QSCDChatMessagesDataModel *cdCollectedModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_MESSAGE inManagedObjectContext:tempContext];
        [self message_ChangeMessagePictureOCModel_TO_CDModel:cdCollectedModel andOCModel:wordModel];
        [tempContext save:&error];
        
    }
    
    ///判断是否保存成功
    if (error) {
        
        NSLog(@"CoreData.SaveCollectedData.Error:%@",error);
        if (callBack) {
            
            callBack(NO);
            
        }
        return;
        
    }
    
    ///保存数据到本地
    if ([NSThread isMainThread]) {
        
        [appDelegate saveContextWithWait:YES];
        
    } else {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [appDelegate saveContextWithWait:NO];
            
        });
        
    }
    
    ///回调
    if (callBack) {
        
        callBack(YES);
        
    }
    
}

///保存音频消息
+ (void)saveVideoMessage:(QSYSendMessageVideo *)wordModel andCallBack:(void(^)(BOOL isSave))callBack
{
    
    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有context
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:COREDATA_ENTITYNAME_MESSAGE inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timeStamp == %@",wordModel.timeStamp];
    [fetchRequest setPredicate:predicate];
    
    NSError *error=nil;
    NSArray *fetchResultArray = [tempContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        
        NSLog(@"CoreData.SearchCollectedData.Error:%@",error);
        if (callBack) {
            
            callBack(NO);
            
        }
        return;
        
    }
    
    ///判断本地是否有数据
    if ([fetchResultArray count] > 0) {
        
        QSCDChatMessagesDataModel *cdCollectedModel = fetchResultArray[0];
        [self message_ChangeMessageVideoOCModel_TO_CDModel:cdCollectedModel andOCModel:wordModel];
        [tempContext save:&error];
        
    } else {
        
        QSCDChatMessagesDataModel *cdCollectedModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_MESSAGE inManagedObjectContext:tempContext];
        [self message_ChangeMessageVideoOCModel_TO_CDModel:cdCollectedModel andOCModel:wordModel];
        [tempContext save:&error];
        
    }
    
    ///判断是否保存成功
    if (error) {
        
        NSLog(@"CoreData.SaveCollectedData.Error:%@",error);
        if (callBack) {
            
            callBack(NO);
            
        }
        return;
        
    }
    
    ///保存数据到本地
    if ([NSThread isMainThread]) {
        
        [appDelegate saveContextWithWait:YES];
        
    } else {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [appDelegate saveContextWithWait:NO];
            
        });
        
    }
    
    ///回调
    if (callBack) {
        
        callBack(YES);
        
    }
    
}

///保存文字消息
+ (void)saveSystemMessage:(QSYSendMessageSystem *)wordModel andCallBack:(void(^)(BOOL isSave))callBack
{

    __block QSYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [appDelegate mainObjectContext];
    
    ///创建私有context
    NSManagedObjectContext *tempContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tempContext.parentContext = mainContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:COREDATA_ENTITYNAME_MESSAGE inManagedObjectContext:tempContext];
    [fetchRequest setEntity:entity];
    
    ///设置查询过滤
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timeStamp == %@",wordModel.timeStamp];
    [fetchRequest setPredicate:predicate];
    
    NSError *error=nil;
    NSArray *fetchResultArray = [tempContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        
        NSLog(@"CoreData.SearchCollectedData.Error:%@",error);
        if (callBack) {
            
            callBack(NO);
            
        }
        return;
        
    }
    
    ///判断本地是否有数据
    if ([fetchResultArray count] > 0) {
        
        QSCDChatMessagesDataModel *cdCollectedModel = fetchResultArray[0];
        [self message_ChangeMessageSystemOCModel_TO_CDModel:cdCollectedModel andOCModel:wordModel];
        [tempContext save:&error];
        
    } else {
        
        QSCDChatMessagesDataModel *cdCollectedModel = [NSEntityDescription insertNewObjectForEntityForName:COREDATA_ENTITYNAME_MESSAGE inManagedObjectContext:tempContext];
        [self message_ChangeMessageSystemOCModel_TO_CDModel:cdCollectedModel andOCModel:wordModel];
        [tempContext save:&error];
        
    }
    
    ///判断是否保存成功
    if (error) {
        
        NSLog(@"CoreData.SaveCollectedData.Error:%@",error);
        if (callBack) {
            
            callBack(NO);
            
        }
        return;
        
    }
    
    ///保存数据到本地
    if ([NSThread isMainThread]) {
        
        [appDelegate saveContextWithWait:YES];
        
    } else {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [appDelegate saveContextWithWait:NO];
            
        });
        
    }
    
    ///回调
    if (callBack) {
        
        callBack(YES);
        
    }

}

#pragma mark - 数据模型转换
+ (void)message_ChangeMessageWordOCModel_TO_CDModel:(QSCDChatMessagesDataModel *)cdModel andOCModel:(QSYSendMessageWord *)ocModel
{

    cdModel.deviceUUID = APPLICATION_NSSTRING_SETTING(ocModel.deviceUUID, @"");
    cdModel.msgID = APPLICATION_NSSTRING_SETTING(ocModel.msgID, @"");
    cdModel.fromID = APPLICATION_NSSTRING_SETTING(ocModel.fromID, @"");
    cdModel.toID = APPLICATION_NSSTRING_SETTING(ocModel.toID, @"");
    cdModel.readTag = APPLICATION_NSSTRING_SETTING(ocModel.readTag, @"");
    
    NSString *showWidthString = [NSString stringWithFormat:@"%.2f",ocModel.showWidth];
    NSString *showHeightString = [NSString stringWithFormat:@"%.2f",ocModel.showHeight];
    cdModel.showWidth = APPLICATION_NSSTRING_SETTING(showWidthString, @"");
    cdModel.showHeight = APPLICATION_NSSTRING_SETTING(showHeightString, @"");
    
    cdModel.timeStamp = APPLICATION_NSSTRING_SETTING(ocModel.timeStamp, @"");
    cdModel.f_name = APPLICATION_NSSTRING_SETTING(ocModel.f_name, @"");
    cdModel.f_user_type = APPLICATION_NSSTRING_SETTING(ocModel.f_user_type, @"");
    cdModel.f_leve = APPLICATION_NSSTRING_SETTING(ocModel.f_leve, @"");
    cdModel.f_avatar = APPLICATION_NSSTRING_SETTING(ocModel.f_avatar, @"");
    cdModel.t_name = APPLICATION_NSSTRING_SETTING(ocModel.t_name, @"");
    cdModel.t_user_type = APPLICATION_NSSTRING_SETTING(ocModel.t_user_type, @"");
    cdModel.t_leve = APPLICATION_NSSTRING_SETTING(ocModel.t_leve, @"");
    cdModel.t_avatar = APPLICATION_NSSTRING_SETTING(ocModel.t_avatar, @"");
    cdModel.unread_count = APPLICATION_NSSTRING_SETTING(ocModel.unread_count, @"");
    
    NSString *sendTypeString = [NSString stringWithFormat:@"%d",ocModel.sendType];
    NSString *msgTypeString = [NSString stringWithFormat:@"%d",ocModel.msgType];
    cdModel.sendType = APPLICATION_NSSTRING_SETTING(sendTypeString, @"");
    cdModel.msgType = APPLICATION_NSSTRING_SETTING(msgTypeString, @"");
    cdModel.message = APPLICATION_NSSTRING_SETTING(ocModel.message, @"");
    

}

+ (QSYSendMessageWord *)message_ChangeMessageWordCDModel_TO_OCModel:(QSCDChatMessagesDataModel *)cdModel
{

    ///OC的消息数据模型
    QSYSendMessageWord *ocModel = [[QSYSendMessageWord alloc] init];
    
    ocModel.deviceUUID = APPLICATION_NSSTRING_SETTING(cdModel.deviceUUID, @"");
    ocModel.msgID = APPLICATION_NSSTRING_SETTING(cdModel.msgID, @"");
    ocModel.fromID = APPLICATION_NSSTRING_SETTING(cdModel.fromID, @"");
    ocModel.toID = APPLICATION_NSSTRING_SETTING(cdModel.toID, @"");
    ocModel.readTag = APPLICATION_NSSTRING_SETTING(cdModel.readTag, @"");
    
    ocModel.showWidth = [cdModel.showWidth floatValue];
    ocModel.showHeight = [cdModel.showHeight floatValue];
    
    ocModel.timeStamp = APPLICATION_NSSTRING_SETTING(cdModel.timeStamp, @"");
    ocModel.f_name = APPLICATION_NSSTRING_SETTING(cdModel.f_name, @"");
    ocModel.f_user_type = APPLICATION_NSSTRING_SETTING(cdModel.f_user_type, @"");
    ocModel.f_leve = APPLICATION_NSSTRING_SETTING(cdModel.f_leve, @"");
    ocModel.f_avatar = APPLICATION_NSSTRING_SETTING(cdModel.f_avatar, @"");
    ocModel.t_name = APPLICATION_NSSTRING_SETTING(cdModel.t_name, @"");
    ocModel.t_user_type = APPLICATION_NSSTRING_SETTING(cdModel.t_user_type, @"");
    ocModel.t_leve = APPLICATION_NSSTRING_SETTING(cdModel.t_leve, @"");
    ocModel.t_avatar = APPLICATION_NSSTRING_SETTING(cdModel.t_avatar, @"");
    ocModel.unread_count = APPLICATION_NSSTRING_SETTING(cdModel.unread_count, @"");
    
    ocModel.sendType = [cdModel.sendType intValue];
    ocModel.msgType = [cdModel.msgType intValue];
    ocModel.message = APPLICATION_NSSTRING_SETTING(cdModel.message, @"");
    
    return ocModel;

}

+ (void)message_ChangeMessagePictureOCModel_TO_CDModel:(QSCDChatMessagesDataModel *)cdModel andOCModel:(QSYSendMessagePicture *)ocModel
{
    
    cdModel.deviceUUID = APPLICATION_NSSTRING_SETTING(ocModel.deviceUUID, @"");
    cdModel.msgID = APPLICATION_NSSTRING_SETTING(ocModel.msgID, @"");
    cdModel.fromID = APPLICATION_NSSTRING_SETTING(ocModel.fromID, @"");
    cdModel.toID = APPLICATION_NSSTRING_SETTING(ocModel.toID, @"");
    cdModel.readTag = APPLICATION_NSSTRING_SETTING(ocModel.readTag, @"");
    
    NSString *showWidthString = [NSString stringWithFormat:@"%.2f",ocModel.showWidth];
    NSString *showHeightString = [NSString stringWithFormat:@"%.2f",ocModel.showHeight];
    cdModel.showWidth = APPLICATION_NSSTRING_SETTING(showWidthString, @"");
    cdModel.showHeight = APPLICATION_NSSTRING_SETTING(showHeightString, @"");
    
    cdModel.timeStamp = APPLICATION_NSSTRING_SETTING(ocModel.timeStamp, @"");
    cdModel.f_name = APPLICATION_NSSTRING_SETTING(ocModel.f_name, @"");
    cdModel.f_user_type = APPLICATION_NSSTRING_SETTING(ocModel.f_user_type, @"");
    cdModel.f_leve = APPLICATION_NSSTRING_SETTING(ocModel.f_leve, @"");
    cdModel.f_avatar = APPLICATION_NSSTRING_SETTING(ocModel.f_avatar, @"");
    cdModel.t_name = APPLICATION_NSSTRING_SETTING(ocModel.t_name, @"");
    cdModel.t_user_type = APPLICATION_NSSTRING_SETTING(ocModel.t_user_type, @"");
    cdModel.t_leve = APPLICATION_NSSTRING_SETTING(ocModel.t_leve, @"");
    cdModel.t_avatar = APPLICATION_NSSTRING_SETTING(ocModel.t_avatar, @"");
    cdModel.unread_count = APPLICATION_NSSTRING_SETTING(ocModel.unread_count, @"");
    
    NSString *sendTypeString = [NSString stringWithFormat:@"%d",ocModel.sendType];
    NSString *msgTypeString = [NSString stringWithFormat:@"%d",ocModel.msgType];
    cdModel.sendType = APPLICATION_NSSTRING_SETTING(sendTypeString, @"");
    cdModel.msgType = APPLICATION_NSSTRING_SETTING(msgTypeString, @"");
    cdModel.pictureURL = APPLICATION_NSSTRING_SETTING(ocModel.pictureURL, @"");
    
}

+ (QSYSendMessagePicture *)message_ChangeMessagePictureCDModel_TO_OCModel:(QSCDChatMessagesDataModel *)cdModel
{
    
    ///OC的消息数据模型
    QSYSendMessagePicture *ocModel = [[QSYSendMessagePicture alloc] init];
    
    ocModel.deviceUUID = APPLICATION_NSSTRING_SETTING(cdModel.deviceUUID, @"");
    ocModel.msgID = APPLICATION_NSSTRING_SETTING(cdModel.msgID, @"");
    ocModel.fromID = APPLICATION_NSSTRING_SETTING(cdModel.fromID, @"");
    ocModel.toID = APPLICATION_NSSTRING_SETTING(cdModel.toID, @"");
    ocModel.readTag = APPLICATION_NSSTRING_SETTING(cdModel.readTag, @"");
    
    ocModel.showWidth = [cdModel.showWidth floatValue];
    ocModel.showHeight = [cdModel.showHeight floatValue];
    
    ocModel.timeStamp = APPLICATION_NSSTRING_SETTING(cdModel.timeStamp, @"");
    ocModel.f_name = APPLICATION_NSSTRING_SETTING(cdModel.f_name, @"");
    ocModel.f_user_type = APPLICATION_NSSTRING_SETTING(cdModel.f_user_type, @"");
    ocModel.f_leve = APPLICATION_NSSTRING_SETTING(cdModel.f_leve, @"");
    ocModel.f_avatar = APPLICATION_NSSTRING_SETTING(cdModel.f_avatar, @"");
    ocModel.t_name = APPLICATION_NSSTRING_SETTING(cdModel.t_name, @"");
    ocModel.t_user_type = APPLICATION_NSSTRING_SETTING(cdModel.t_user_type, @"");
    ocModel.t_leve = APPLICATION_NSSTRING_SETTING(cdModel.t_leve, @"");
    ocModel.t_avatar = APPLICATION_NSSTRING_SETTING(cdModel.t_avatar, @"");
    ocModel.unread_count = APPLICATION_NSSTRING_SETTING(cdModel.unread_count, @"");
    
    ocModel.sendType = [cdModel.sendType intValue];
    ocModel.msgType = [cdModel.msgType intValue];
    ocModel.pictureURL = APPLICATION_NSSTRING_SETTING(cdModel.pictureURL, @"");
    
    return ocModel;
    
}

+ (void)message_ChangeMessageVideoOCModel_TO_CDModel:(QSCDChatMessagesDataModel *)cdModel andOCModel:(QSYSendMessageVideo *)ocModel
{
    
    cdModel.deviceUUID = APPLICATION_NSSTRING_SETTING(ocModel.deviceUUID, @"");
    cdModel.msgID = APPLICATION_NSSTRING_SETTING(ocModel.msgID, @"");
    cdModel.fromID = APPLICATION_NSSTRING_SETTING(ocModel.fromID, @"");
    cdModel.toID = APPLICATION_NSSTRING_SETTING(ocModel.toID, @"");
    cdModel.readTag = APPLICATION_NSSTRING_SETTING(ocModel.readTag, @"");
    
    NSString *showWidthString = [NSString stringWithFormat:@"%.2f",ocModel.showWidth];
    NSString *showHeightString = [NSString stringWithFormat:@"%.2f",ocModel.showHeight];
    cdModel.showWidth = APPLICATION_NSSTRING_SETTING(showWidthString, @"");
    cdModel.showHeight = APPLICATION_NSSTRING_SETTING(showHeightString, @"");
    
    cdModel.timeStamp = APPLICATION_NSSTRING_SETTING(ocModel.timeStamp, @"");
    cdModel.f_name = APPLICATION_NSSTRING_SETTING(ocModel.f_name, @"");
    cdModel.f_user_type = APPLICATION_NSSTRING_SETTING(ocModel.f_user_type, @"");
    cdModel.f_leve = APPLICATION_NSSTRING_SETTING(ocModel.f_leve, @"");
    cdModel.f_avatar = APPLICATION_NSSTRING_SETTING(ocModel.f_avatar, @"");
    cdModel.t_name = APPLICATION_NSSTRING_SETTING(ocModel.t_name, @"");
    cdModel.t_user_type = APPLICATION_NSSTRING_SETTING(ocModel.t_user_type, @"");
    cdModel.t_leve = APPLICATION_NSSTRING_SETTING(ocModel.t_leve, @"");
    cdModel.t_avatar = APPLICATION_NSSTRING_SETTING(ocModel.t_avatar, @"");
    cdModel.unread_count = APPLICATION_NSSTRING_SETTING(ocModel.unread_count, @"");
    
    NSString *sendTypeString = [NSString stringWithFormat:@"%d",ocModel.sendType];
    NSString *msgTypeString = [NSString stringWithFormat:@"%d",ocModel.msgType];
    cdModel.sendType = APPLICATION_NSSTRING_SETTING(sendTypeString, @"");
    cdModel.msgType = APPLICATION_NSSTRING_SETTING(msgTypeString, @"");
    cdModel.videoURL = APPLICATION_NSSTRING_SETTING(ocModel.videoURL, @"");
    cdModel.playTime = APPLICATION_NSSTRING_SETTING(ocModel.playTime, @"");
    
}

+ (QSYSendMessageVideo *)message_ChangeMessageVideoCDModel_TO_OCModel:(QSCDChatMessagesDataModel *)cdModel
{
    
    ///OC的消息数据模型
    QSYSendMessageVideo *ocModel = [[QSYSendMessageVideo alloc] init];
    
    ocModel.deviceUUID = APPLICATION_NSSTRING_SETTING(cdModel.deviceUUID, @"");
    ocModel.msgID = APPLICATION_NSSTRING_SETTING(cdModel.msgID, @"");
    ocModel.fromID = APPLICATION_NSSTRING_SETTING(cdModel.fromID, @"");
    ocModel.toID = APPLICATION_NSSTRING_SETTING(cdModel.toID, @"");
    ocModel.readTag = APPLICATION_NSSTRING_SETTING(cdModel.readTag, @"");
    
    ocModel.showWidth = [cdModel.showWidth floatValue];
    ocModel.showHeight = [cdModel.showHeight floatValue];
    
    ocModel.timeStamp = APPLICATION_NSSTRING_SETTING(cdModel.timeStamp, @"");
    ocModel.f_name = APPLICATION_NSSTRING_SETTING(cdModel.f_name, @"");
    ocModel.f_user_type = APPLICATION_NSSTRING_SETTING(cdModel.f_user_type, @"");
    ocModel.f_leve = APPLICATION_NSSTRING_SETTING(cdModel.f_leve, @"");
    ocModel.f_avatar = APPLICATION_NSSTRING_SETTING(cdModel.f_avatar, @"");
    ocModel.t_name = APPLICATION_NSSTRING_SETTING(cdModel.t_name, @"");
    ocModel.t_user_type = APPLICATION_NSSTRING_SETTING(cdModel.t_user_type, @"");
    ocModel.t_leve = APPLICATION_NSSTRING_SETTING(cdModel.t_leve, @"");
    ocModel.t_avatar = APPLICATION_NSSTRING_SETTING(cdModel.t_avatar, @"");
    ocModel.unread_count = APPLICATION_NSSTRING_SETTING(cdModel.unread_count, @"");
    
    ocModel.sendType = [cdModel.sendType intValue];
    ocModel.msgType = [cdModel.msgType intValue];
    ocModel.videoURL = APPLICATION_NSSTRING_SETTING(cdModel.videoURL, @"");
    ocModel.playTime = APPLICATION_NSSTRING_SETTING(cdModel.playTime, @"");
    
    return ocModel;
    
}

+ (void)message_ChangeMessageSystemOCModel_TO_CDModel:(QSCDChatMessagesDataModel *)cdModel andOCModel:(QSYSendMessageSystem *)ocModel
{
    
    cdModel.fromID = APPLICATION_NSSTRING_SETTING(ocModel.fromID, @"");
    cdModel.readTag = APPLICATION_NSSTRING_SETTING(ocModel.readTag, @"");
    
    cdModel.timeStamp = APPLICATION_NSSTRING_SETTING(ocModel.timeStamp, @"");
    cdModel.pictureURL = APPLICATION_NSSTRING_SETTING(ocModel.title, @"");
    cdModel.message = APPLICATION_NSSTRING_SETTING(ocModel.desc, @"");
    cdModel.f_name = APPLICATION_NSSTRING_SETTING(ocModel.f_name, @"");
    cdModel.f_avatar = APPLICATION_NSSTRING_SETTING(ocModel.f_avatar, @"");
    cdModel.unread_count = APPLICATION_NSSTRING_SETTING(ocModel.unread_count, @"");
    
    NSString *msgTypeString = [NSString stringWithFormat:@"%d",ocModel.msgType];
    cdModel.msgType = APPLICATION_NSSTRING_SETTING(msgTypeString, @"");
    
}

+ (QSYSendMessageSystem *)message_ChangeMessageSystemCDModel_TO_OCModel:(QSCDChatMessagesDataModel *)cdModel
{
    
    QSYSendMessageSystem *ocModel = [[QSYSendMessageSystem alloc] init];
    
    ocModel.fromID = APPLICATION_NSSTRING_SETTING(cdModel.fromID, @"");
    ocModel.readTag = APPLICATION_NSSTRING_SETTING(cdModel.readTag, @"");
    
    ocModel.timeStamp = APPLICATION_NSSTRING_SETTING(cdModel.timeStamp, @"");
    ocModel.title = APPLICATION_NSSTRING_SETTING(cdModel.pictureURL, @"");
    ocModel.title = APPLICATION_NSSTRING_SETTING(cdModel.message, @"");
    ocModel.f_name = APPLICATION_NSSTRING_SETTING(cdModel.f_name, @"");
    ocModel.f_avatar = APPLICATION_NSSTRING_SETTING(cdModel.f_avatar, @"");
    ocModel.unread_count = APPLICATION_NSSTRING_SETTING(cdModel.unread_count, @"");
    
    ocModel.msgType = [cdModel.msgType intValue];
    
    return ocModel;
    
}

@end
