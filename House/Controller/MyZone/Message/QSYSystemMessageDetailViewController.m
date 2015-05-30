//
//  QSYSystemMessageDetailViewController.m
//  House
//
//  Created by ysmeng on 15/5/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYSystemMessageDetailViewController.h"

#import "QSYSystemMessageListDataModel.h"

#import "NSDate+Formatter.h"

@interface QSYSystemMessageDetailViewController ()

@end

@implementation QSYSystemMessageDetailViewController

- (void)createNavigationBarUI
{

    [super createNavigationBarUI];
    [self setNavigationBarTitle:@"系统消息"];

}

- (void)createMainShowUI
{

    ///指示头像
    QSImageView *iconImageView = [[QSImageView alloc] initWithFrame:CGRectMake(15.0f, 84.0f, 40.0f, 40.0f)];
    iconImageView.image = [UIImage imageNamed:IMAGE_CHAT_SYSTEMINFO];
    [self.view addSubview:iconImageView];
    
    ///头像修成6角形的底图
    QSImageView *sixFormImage = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, iconImageView.frame.size.width, iconImageView.frame.size.height)];
    sixFormImage.image = [UIImage imageNamed:IMAGE_CHAT_SIXFORM_HOLLOW];
    [iconImageView addSubview:sixFormImage];
    
    ///说明
    UILabel *nameLabel = [[QSLabel alloc] initWithFrame:CGRectMake(iconImageView.frame.origin.x + iconImageView.frame.size.width + 10.0f, iconImageView.frame.origin.y, 120.0f, 20.0f)];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_16];
    nameLabel.textColor = COLOR_CHARACTERS_BLACK;
    nameLabel.text = @"系统消息";
    nameLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:nameLabel];
    
    ///日期
    UILabel *lastTimeLabel = [[QSLabel alloc] initWithFrame:CGRectMake(SIZE_DEVICE_WIDTH - 15.0f - 160.0f, nameLabel.frame.origin.y, 160.0f, 20.0f)];
    lastTimeLabel.textAlignment = NSTextAlignmentRight;
    lastTimeLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    lastTimeLabel.textColor = COLOR_CHARACTERS_GRAY;
    lastTimeLabel.text = [[NSDate formatNSTimeToNSDateString:self.detailModel.send_time] substringToIndex:10];
    lastTimeLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:lastTimeLabel];

    ///标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y + nameLabel.frame.size.height, SIZE_DEVICE_WIDTH - 30.0f - 10.0f - iconImageView.frame.size.width, 20.0f)];
    titleLabel.textColor = COLOR_CHARACTERS_GRAY;
    titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    titleLabel.text = self.detailModel.title;
    [self.view addSubview:titleLabel];
    
    ///详情
    UITextView *detailField = [[UITextView alloc] initWithFrame:CGRectMake(15.0f, titleLabel.frame.origin.y + titleLabel.frame.size.height + 20.0f, SIZE_DEVICE_WIDTH - 30.0f, SIZE_DEVICE_HEIGHT - 20.0f - 40.0f - 84.0f)];
    detailField.editable = NO;
    detailField.showsHorizontalScrollIndicator = NO;
    detailField.showsVerticalScrollIndicator = NO;
    detailField.font = [UIFont systemFontOfSize:FONT_BODY_16];
    detailField.text = self.detailModel.content;
    [self.view addSubview:detailField];

}

@end
