//
//  QSWDeveloperActivityTableViewCell.m
//  House
//
//  Created by 王树朋 on 15/4/14.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWDeveloperActivityTableViewCell.h"

#import <objc/runtime.h>

///关联
static char UserImageViewKey;       //!<头像
static char TitleLabelKey;          //!<主题
static char CommentLabelKey;        //!<内容
static char SignUpCountKey;         //!<报名人数

@implementation QSWDeveloperActivityTableViewCell

-(instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        
        [self createActivityInfoCellUI];
        
    }

    return self;
    
}

#pragma mark -创建UI
-(void)createActivityInfoCellUI
{

    
    ///业主
    QSImageView *userImageView = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 40.0f, 40.0f)];

    [self.contentView addSubview:userImageView];
    objc_setAssociatedObject(self, &UserImageViewKey, userImageView, OBJC_ASSOCIATION_ASSIGN);
    
    ///镂空六角形
    QSImageView *userIconSixForm = [[QSImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, userImageView.frame.size.width, userImageView.frame.size.height)];
    userIconSixForm.image = [UIImage imageNamed:IMAGE_CHAT_SIXFORM_HOLLOW];
    [userImageView addSubview:userIconSixForm];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(userImageView.frame.origin.x+userImageView.frame.size.width+5.0f, userImageView.frame.origin.y, 200.0f, 17.0f)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self.contentView addSubview:titleLabel];
    objc_setAssociatedObject(self, &TitleLabelKey, titleLabel, OBJC_ASSOCIATION_ASSIGN);

    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y+titleLabel.frame.size.height+10.0f, 150.0f, 13.0f)];
    commentLabel.textAlignment = NSTextAlignmentLeft;
    commentLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:commentLabel];
    objc_setAssociatedObject(self, &CommentLabelKey, commentLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *signUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-120.0f, commentLabel.frame.origin.y, 80.0f, 13.0f)];
    signUpLabel.text = @"报名人数:";
    signUpLabel.textAlignment = NSTextAlignmentRight;
    signUpLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:signUpLabel];
    
    UILabel *signUpCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(signUpLabel.frame.origin.x+signUpLabel.frame.size.width, signUpLabel.frame.origin.y, 40.0f, signUpLabel.frame.size.height)];
    signUpCountLabel.textAlignment = NSTextAlignmentLeft;
    signUpCountLabel.font = [UIFont systemFontOfSize:16.0f];
    signUpCountLabel.textColor = COLOR_CHARACTERS_YELLOW;
    [self.contentView addSubview:signUpCountLabel];
    objc_setAssociatedObject(self, &SignUpCountKey, signUpCountLabel, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark -更新数据模型
-(void)updateDeveloperActivityModel
{

    QSImageView *userImageView = objc_getAssociatedObject(self, &UserImageViewKey);
    userImageView.image = [UIImage imageNamed:IMAGE_USERICON_DEFAULT_80];
    //    if ([self.detailInfo.user.avatar length] > 0) {
    //
    //        [userImageView loadImageWithURL:[self.detailInfo.user.avatar getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_USERICON_DEFAULT_80]];
    
    //}
    
    UILabel *titleLabel = objc_getAssociatedObject(self, &TitleLabelKey);
    titleLabel.text = @"江南水乡";
    
    UILabel *commentLabel = objc_getAssociatedObject(self, &CommentLabelKey);
    commentLabel.text = @"10月1日看房团";
    
    UILabel *signUpCountLabel = objc_getAssociatedObject(self, &SignUpCountKey);
    signUpCountLabel.text = @"10";
}

@end
