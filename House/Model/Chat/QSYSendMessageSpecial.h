//
//  QSYSendMessageSpecial.h
//  House
//
//  Created by ysmeng on 15/4/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYSendMessageRootModel.h"

@interface QSYSendMessageSpecial : QSYSendMessageRootModel

/*
 *  required string name = 1;
 *  required string pic  = 2;
 *  required string desc = 3;
 *  required int64 fid   = 4;
 *  required string type = 5;
 */

@property (nonatomic,copy) NSString *timeStamp;                             //!<时间戳
@property (nonatomic,copy) NSString *title;                                 //!<标题
@property (nonatomic,copy) NSString *desc;                                  //!<信息内容
@property (nonatomic,copy) NSString *f_name;                                //!<推送房源的类型
@property (nonatomic,copy) NSString *f_avatar;                              //!<房源图片url
@property (nonatomic,copy) NSString *unread_count;                          //!<保存的是推送房源的fid

@end
