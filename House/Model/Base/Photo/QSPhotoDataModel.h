//
//  QSPhotoDataModel.h
//  House
//
//  Created by ysmeng on 15/3/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSPhotoDataModel : QSBaseModel

@property (nonatomic,copy) NSString *id_;           //!<图片ID
@property (nonatomic,copy) NSString *type;          //!<图片对应的房子类型：新房、二手房
@property (nonatomic,copy) NSString *title;         //!<标题
@property (nonatomic,copy) NSString *mark;          //!<图片简介
@property (nonatomic,copy) NSString *attach_file;   //!<大图地址
@property (nonatomic,copy) NSString *attach_thumb;  //!<小图地址


@end
