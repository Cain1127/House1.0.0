//
//  QSChatMessageListTableViewCell.m
//  House
//
//  Created by ysmeng on 15/2/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSChatMessageListTableViewCell.h"

#import "NSString+Calculation.h"

#import <objc/runtime.h>

///关联
static char IconKey;            //!<头像key
static char InfoCountTipsKey;   //!<消息数量提醒key
static char UserNameKey;        //!<用户名key
static char VIPFlagKey;         //!<vip标识图片key
static char LastTimeKey;        //!<最新消息日期key
static char CommentInfoKey;     //!<简述信息key

@interface QSChatMessageListTableViewCell ()

@property (nonatomic,assign) MESSAGELIST_CELL_TYPE cellType;//!<cell的类型

@end

@implementation QSChatMessageListTableViewCell

#pragma mark - 初始化
/**
 *  @author                 yangshengmeng, 15-02-09 14:02:25
 *
 *  @brief                  根据cell的类型，创建对应的消息提醒cell
 *
 *  @param style            cell的风格
 *  @param reuseIdentifier  复用标签
 *  @param cellType         消息cell的类型
 *
 *  @return                 返回当前创建的cell
 *
 *  @since                  1.0.0
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andCellType:(MESSAGELIST_CELL_TYPE)cellType
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        ///保存类型
        self.cellType = cellType;
        
        ///UI搭建
        [self createMessageListCellUI];
        
    }
    
    return self;

}

#pragma mark - UI搭建
///UI搭建
- (void)createMessageListCellUI
{
    
    ///宽度
    CGFloat width = SIZE_DEVICE_WIDTH - 2.0f * (SIZE_DEVICE_WIDTH > 320.0f ? 25.0f : 15.0f);
    
    ///头像
    QSImageView *iconImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, 40.0f, 40.0f)];
    [self.contentView addSubview:iconImageView];
    objc_setAssociatedObject(self, &IconKey, iconImageView, OBJC_ASSOCIATION_ASSIGN);
    
    ///设置默认图片
    UIImage *defaultIconImage;
    if (mMessageListCellTypeSystemInfo == self.cellType) {
        
        defaultIconImage = [UIImage imageNamed:IMAGE_CHAT_SYSTEMINFO];
        
    } else if (mMessageListCellTypeHouseRecommend == self.cellType) {
    
        defaultIconImage = [UIImage imageNamed:IMAGE_CHAT_RECOMMEND];
    
    } else {
    
        defaultIconImage = [UIImage imageNamed:IMAGE_USERICON_DEFAULT_80];
    
    }
    iconImageView.image = defaultIconImage;
    
    ///头像修成6角形的底图
    QSImageView *sixFormImage = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, iconImageView.frame.size.width, iconImageView.frame.size.height)];
    sixFormImage.image = [UIImage imageNamed:IMAGE_CHAT_SIXFORM_HOLLOW];
    [iconImageView addSubview:sixFormImage];
    
    ///消息条数提示
    UILabel *countTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.frame.size.width - 15.0f, iconImageView.frame.origin.y - 5.0f, 20.0f, 20.0f)];
    countTipsLabel.text = @"8";
    countTipsLabel.textColor = [UIColor whiteColor];
    countTipsLabel.backgroundColor = [UIColor redColor];
    countTipsLabel.textAlignment = NSTextAlignmentCenter;
    countTipsLabel.layer.cornerRadius = 10.0f;
    countTipsLabel.layer.masksToBounds = YES;
    countTipsLabel.font = [UIFont systemFontOfSize:FONT_BODY_12];
    [self.contentView addSubview:countTipsLabel];
    objc_setAssociatedObject(self, &InfoCountTipsKey, countTipsLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///姓名
    UILabel *nameLabel = [[QSLabel alloc] init];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    nameLabel.textColor = COLOR_CHARACTERS_BLACK;
    nameLabel.text = [self getSenderName];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:nameLabel];
    objc_setAssociatedObject(self, &UserNameKey, nameLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///是否vip认证
    QSImageView *vipImage = [[QSImageView alloc] init];
    vipImage.image = [UIImage imageNamed:IMAGE_PUBLIC_VIP];
    vipImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:vipImage];
    objc_setAssociatedObject(self, &VIPFlagKey, vipImage, OBJC_ASSOCIATION_ASSIGN);
    
    ///最新消息日期
    UILabel *lastTimeLabel = [[QSLabel alloc] init];
    lastTimeLabel.textAlignment = NSTextAlignmentRight;
    lastTimeLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    lastTimeLabel.textColor = COLOR_CHARACTERS_GRAY;
    lastTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    lastTimeLabel.text = @"2015-2-15";
    [self.contentView addSubview:lastTimeLabel];
    objc_setAssociatedObject(self, &LastTimeKey, lastTimeLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///约束参数
    NSDictionary *___viewsVFL = NSDictionaryOfVariableBindings(nameLabel,vipImage,lastTimeLabel);
    CGFloat ___xpointVFL = iconImageView.frame.origin.x + iconImageView.frame.size.width + 10.0f;
    NSDictionary *___sizeVFL = @{@"xpoint" : [NSString stringWithFormat:@"%.2f",___xpointVFL]};
    
    ///约束串
    NSString *___hVFL_all = @"H:|-xpoint-[nameLabel(>=30,<=150)][vipImage(20)]-(>=5)-[lastTimeLabel(90)]|";
    NSString *___vVFL_name = @"V:|-20-[nameLabel(20)]-40-|";
    NSString *___vVFL_vip = @"V:|-20-[vipImage(20)]-40-|";
    
    ///添加约束
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_all options:NSLayoutFormatAlignAllCenterY metrics:___sizeVFL views:___viewsVFL]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_name options:0 metrics:nil views:___viewsVFL]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_vip options:0 metrics:nil views:___viewsVFL]];
    
    ///最新消息的大概
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(___xpointVFL, 40.0f, width - ___xpointVFL, 20.0f)];
    commentLabel.textColor = COLOR_CHARACTERS_GRAY;
    commentLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    commentLabel.text = [self getDefaultCommendInfo];
    [self.contentView addSubview:commentLabel];
    objc_setAssociatedObject(self, &CommentInfoKey, commentLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///分隔线
    UILabel *sepLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 79.5f, width, 0.5f)];
    sepLineLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.contentView addSubview:sepLineLabel];

}

#pragma mark - 默认消息概述
///默认消息概述
- (NSString *)getDefaultCommendInfo
{

    switch (self.cellType) {
            ///系统消息
        case mMessageListCellTypeSystemInfo:
            
            return @"欢迎来到房当家，2.0版本已经上线。";
            
            break;
            
            ///推荐房源消息
        case mMessageListCellTypeHouseRecommend:
            
            return @"根据求租求购及您常浏览记录定制。";
            
            break;
            
        default:
            
            return @"";
            
            break;
    }

}

#pragma mark - 根据不同消息类型返回不同的默认图片
///根据不同消息类型返回不同的默认图片
- (NSString *)getDefaultImageName
{

    switch (self.cellType) {
            ///系统消息
        case mMessageListCellTypeSystemInfo:
            
            return IMAGE_CHAT_SYSTEMINFO;
            
            break;
            
            ///推荐房源消息
        case mMessageListCellTypeHouseRecommend:
            
            return IMAGE_CHAT_RECOMMEND;
            
            break;
            
        default:
            
            return IMAGE_USERICON_DEFAULT_80;
            
            break;
    }

}

#pragma mark - 根据不同的cell类型返回包字默认信息
///根据不同的cell类型返回包字默认信息
- (NSString *)getSenderName
{

    switch (self.cellType) {
            ///系统消息
        case mMessageListCellTypeSystemInfo:
            
            return @"房当家团队";
            
            break;
            
            ///推荐房源消息
        case mMessageListCellTypeHouseRecommend:
            
            return @"推荐房源";
            
            break;
            
        default:
            
            return @"";
            
            break;
    }

}

#pragma mark - 刷新UI

///更新消息提示
- (void)updateInfoCountTips:(NSString *)tips
{

    UILabel *label = objc_getAssociatedObject(self, &InfoCountTipsKey);
    if (label && tips) {
        
        label.text = tips;
        
    }

}

///更新用户头像
- (void)updateIcon:(NSString *)urlString
{

    UIImageView *imageView = objc_getAssociatedObject(self, &IconKey);
    if (imageView && urlString) {
        
        [imageView loadImageWithURL:[urlString getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_USERICON_DEFAULT_80]];
        
    }

}

@end
