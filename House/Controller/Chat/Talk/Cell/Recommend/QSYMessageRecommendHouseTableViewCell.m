//
//  QSYMessageRecommendHouseTableViewCell.m
//  House
//
//  Created by ysmeng on 15/5/8.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYMessageRecommendHouseTableViewCell.h"

#import "NSString+Calculation.h"
#import "NSDate+Formatter.h"

#import "QSYSendMessageRecommendHouse.h"

#import <objc/runtime.h>

///关联
static char UserIconKey;    //!<头像关联
static char TimeStampKey;   //!<时间戳关联
static char ImageKey;       //!<房源图片关联
static char AddressKey;     //!<地址信息关联
static char HouseAreaKey;   //!<房源室厅面积信息关联
static char PriceKey;       //!<房源售价或租金关联

@interface QSYMessageRecommendHouseTableViewCell ()

@property (nonatomic,assign) MESSAGE_FROM_TYPE messageType; //!<消息的归属类型

@end

@implementation QSYMessageRecommendHouseTableViewCell

#pragma mark - 初始化
/**
 *  @author                 yangshengmeng, 15-05-08 11:05:50
 *
 *  @brief                  创建
 *
 *  @param style            cell风格
 *  @param reuseIdentifier  复用标签
 *  @param isMyMessage      消息归属者类型
 *
 *  @return                 返回当前创建的消息展现cell
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andMessageType:(MESSAGE_FROM_TYPE)isMyMessage
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        ///保存类型
        self.messageType = isMyMessage;
        
        ///创建UI
        [self createRecommendHouseMessageUI];
        
        ///添加点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoHouseDetail:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createRecommendHouseMessageUI
{
    
    ///根据消息的类型，计算不同控件的坐标
    CGFloat xpointIcon = SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    CGFloat xpointArrow = xpointIcon + 40.0f + 3.0f;
    CGFloat xpointMessage = xpointArrow + 5.0f;
    CGFloat widthMessage = SIZE_DEVICE_WIDTH * 3.0f / 4.0f;
    if (mMessageFromTypeMY == self.messageType) {
        
        xpointIcon = SIZE_DEVICE_WIDTH - 40.0f - SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
        xpointArrow = xpointIcon - 3.0f - 5.0f;
        xpointMessage = xpointArrow - widthMessage;
        
    }
    
    ///时间戳
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((SIZE_DEVICE_WIDTH - 180.0f) / 2.0f, 15.0f, 180.0f, 15.0f)];
    timeLabel.font = [UIFont systemFontOfSize:FONT_BODY_12];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = COLOR_CHARACTERS_LIGHTGRAY;
    [self.contentView addSubview:timeLabel];
    objc_setAssociatedObject(self, &TimeStampKey, timeLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///头像
    QSImageView *iconView = [[QSImageView alloc] initWithFrame:CGRectMake(xpointIcon, timeLabel.frame.origin.y + timeLabel.frame.size.height + 8.0f, 40.0f, 40.0f)];
    iconView.image = [UIImage imageNamed:IMAGE_USERICON_DEFAULT_80];
    [self.contentView addSubview:iconView];
    objc_setAssociatedObject(self, &UserIconKey, iconView, OBJC_ASSOCIATION_ASSIGN);
    
    ///头像六角
    QSImageView *iconSixformView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, iconView.frame.size.width, iconView.frame.size.height)];
    iconSixformView.image = [UIImage imageNamed:IMAGE_USERICON_HOLLOW_80];
    [iconView addSubview:iconSixformView];
    
    ///指示三角
    QSImageView *arrowIndicator = [[QSImageView alloc] initWithFrame:CGRectMake(xpointArrow, iconView.frame.origin.y + 20.0f - 7.5f, 5.0f, 15.0f)];
    arrowIndicator.image = [UIImage imageNamed:IMAGE_CHAT_MESSAGE_SENDER_ARROW_HIGHLIGHTED];
    if (mMessageFromTypeMY == self.messageType) {
        
        arrowIndicator.image = [UIImage imageNamed:IMAGE_CHAT_MESSAGE_MY_ARROW_NORMAL];;
        
    }
    [self.contentView addSubview:arrowIndicator];
    
    ///消息底view
    UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(xpointMessage, iconView.frame.origin.y, widthMessage, 90.0f)];
    rootView.layer.cornerRadius = 4.0f;
    rootView.backgroundColor = COLOR_CHARACTERS_LIGHTGRAY;
    if (mMessageFromTypeMY == self.messageType) {
        
        rootView.backgroundColor = COLOR_CHARACTERS_YELLOW;
        
    }
    [self.contentView addSubview:rootView];
 
    ///图片
    QSImageView *imageView = [[QSImageView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 69.0f * 4.0f / 3.0f, 70.0f)];
    imageView.image = [UIImage imageNamed:IMAGE_HOUSES_LOADING_FAIL330x250];
    [rootView addSubview:imageView];
    objc_setAssociatedObject(self, &ImageKey, imageView, OBJC_ASSOCIATION_ASSIGN);
    
    ///地址信息
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 5.0f, imageView.frame.origin.y, rootView.frame.size.width - imageView.frame.size.width - 25.0f, 15.0f)];
    addressLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    addressLabel.textColor = [UIColor whiteColor];
    if (mMessageFromTypeMY == self.messageType) {
        
        addressLabel.textColor = COLOR_CHARACTERS_BLACK;
        
    }
    
    [rootView addSubview:addressLabel];
    objc_setAssociatedObject(self, &AddressKey, addressLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///室厅面积信息
    UILabel *houseNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(addressLabel.frame.origin.x, addressLabel.frame.origin.y + addressLabel.frame.size.height, addressLabel.frame.size.width, addressLabel.frame.size.height)];
    houseNumLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    houseNumLabel.textColor = [UIColor whiteColor];
    if (mMessageFromTypeMY == self.messageType) {
        
        houseNumLabel.textColor = COLOR_CHARACTERS_BLACK;
        
    }
    
    [rootView addSubview:houseNumLabel];
    objc_setAssociatedObject(self, &HouseAreaKey, houseNumLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///售价或租金
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(houseNumLabel.frame.origin.x, houseNumLabel.frame.origin.y + houseNumLabel.frame.size.height + 20.0f, 160.0f, 20.0f)];
    priceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    [rootView addSubview:priceLabel];
    objc_setAssociatedObject(self, &PriceKey, priceLabel, OBJC_ASSOCIATION_ASSIGN);
    
}

#pragma mark - 单击事件
- (void)gotoHouseDetail:(UITapGestureRecognizer *)tap
{

    if (self.singleTapCallBack) {
        
        self.singleTapCallBack();
        
    }

}

#pragma mark - 刷新UI
/**
 *  @author         yangshengmeng, 15-05-08 11:05:14
 *
 *  @brief          刷新UI
 *
 *  @param model    消息数据模型
 *
 *  @since          1.0.0
 */
- (void)updateMessageWordUI:(QSYSendMessageRecommendHouse *)model
{

    ///更新时间戳
    UILabel *timeLabel = objc_getAssociatedObject(self, &TimeStampKey);
    if (timeLabel && [model.timeStamp length] > 0) {
        
        timeLabel.text = [NSDate formatNSTimeToNSDateString:model.timeStamp];
        
    } else {
    
        timeLabel.text = nil;
    
    }
    
    ///更新头像
    UIImageView *icontView = objc_getAssociatedObject(self, &UserIconKey);
    if (icontView && [model.f_avatar length] > 0) {
        
        [icontView loadImageWithURL:[model.f_avatar getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_USERICON_DEFAULT_80]];
        
    } else {
    
        icontView.image = [UIImage imageNamed:IMAGE_USERICON_DEFAULT_80];
    
    }
    
    ///更新房源图片
    UIImageView *houseImage = objc_getAssociatedObject(self, &ImageKey);
    if ([model.originalImage length] > 0) {
        
        [houseImage loadImageWithURL:[model.originalImage getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_HOUSES_LOADING_FAIL330x250]];
        
    } else {
    
        houseImage.image = [UIImage imageNamed:IMAGE_HOUSES_LOADING_FAIL330x250];
    
    }
    
    ///更新街道信息
    UILabel *addressLabel = objc_getAssociatedObject(self, &AddressKey);
    if ([model.street length] > 0) {
        
        addressLabel.text = [NSString stringWithFormat:@"%@ / %@",model.street,model.district];;
        
    } else {
    
        addressLabel.text = nil;
    
    }
    
    ///更新室厅面积
    UILabel *houseNumLabel = objc_getAssociatedObject(self, &HouseAreaKey);
    if ([model.houseShi intValue] > 0) {
        
        NSString *houseNumString = [NSString stringWithFormat:@"%@室",model.houseShi];
        if ([model.houseTing intValue] > 0) {
            
            houseNumString = [houseNumString stringByAppendingString:[NSString stringWithFormat:@"%@厅",model.houseTing]];
            
        }
        
        houseNumString = [houseNumString stringByAppendingString:@" / "];
        
        houseNumString = [houseNumString stringByAppendingString:[NSString stringWithFormat:@"%@㎡",model.houseArea]];
        
        houseNumLabel.text = houseNumString;
        
    } else {
    
        houseNumLabel.text = nil;
    
    }
    
    ///售价或租金
    UILabel *priceLabel = objc_getAssociatedObject(self, &PriceKey);
    if (fFilterMainTypeSecondHouse == [model.houseType intValue]) {
        
        priceLabel.text = [NSString stringWithFormat:@"%.0f万",[model.housePrice floatValue] / 10000.0f];
        
    } else if (fFilterMainTypeRentalHouse == [model.houseType intValue]) {
        
        priceLabel.text = [NSString stringWithFormat:@"%.2f元/月",[model.rentPrice floatValue]];
        
    } else {
    
        priceLabel.text = nil;
    
    }

}

@end
