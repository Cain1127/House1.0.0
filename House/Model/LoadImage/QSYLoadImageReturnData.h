//
//  QSYLoadImageReturnData.h
//  House
//
//  Created by ysmeng on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSHeaderDataModel.h"

@class QSYLoadImageHeaderData;
@interface QSYLoadImageReturnData : QSHeaderDataModel

@property (nonatomic,retain) QSYLoadImageHeaderData *imageModel;

@end

@interface QSYLoadImageHeaderData : QSBaseModel

@property (nonatomic,copy) NSString *smallImageURl;     //!<小图地址
@property (nonatomic,copy) NSString *originalImageURl;  //!<大图地址

@end