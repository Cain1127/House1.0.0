//
//  QSUserAssessCell.m
//  House
//
//  Created by 王树朋 on 15/3/23.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSUserAssessCell.h"
#import "DeviceSizeHeader.h"
#import "QSImageView.h"
#import "UIImageView+CacheImage.h"
#import "NSString+Calculation.h"

#include <objc/runtime.h>

///关联
static char AssessImageKey;     //!<评论人图片关联key
static char AssessUserKey;      //!<评论用户关联key
static char AssessDateKey;      //!<评论日期关联key
static char AssessTimeKey;      //!<评论时间关联key
static char AssessCommentKey;   //!<评论内容关联key

#define SIZE_DEFAULT_MARGIN_TAP (SIZE_DEVICE_WIDTH > 320.0f ? 30.0f : 20.0f)

@implementation QSUserAssessCell

-(instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createAssessCellUI];
    
    }

    return self;
    
}

-(void)createAssessCellUI
{

    CGFloat viewW=SIZE_DEVICE_WIDTH-2.0f*SIZE_DEFAULT_MARGIN_TAP;
    //CGFloat viewH=70.0f;
    
    ///头像
    QSImageView *userImageView = [[QSImageView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_TAP, SIZE_DEFAULT_MARGIN_TAP, 40.0f, 40.0f)];
    
    [self.contentView addSubview:userImageView];
    objc_setAssociatedObject(self, &AssessImageKey, userImageView, OBJC_ASSOCIATION_ASSIGN);
    
    ///评论人名称，日期
    UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(userImageView.frame.origin.x+userImageView.frame.size.width+5.0f, SIZE_DEFAULT_MARGIN_LEFT_RIGHT+2.5f, 70.0f, 15.0f)];
    userLabel.textColor = COLOR_CHARACTERS_BLACK;
    userLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    [self.contentView addSubview:userLabel];
    objc_setAssociatedObject(self, &AssessUserKey, userLabel, OBJC_ASSOCIATION_ASSIGN);

    
    UILabel *dataLabel=[[UILabel alloc] initWithFrame:CGRectMake(userLabel.frame.origin.x+userLabel.frame.size.width+5.0f, userLabel.frame.origin.y, 120.0f, 15.0f)];
    dataLabel.textColor = COLOR_CHARACTERS_BLACK;
    dataLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    [self.contentView addSubview:dataLabel];
    objc_setAssociatedObject(self, &AssessDateKey, dataLabel, OBJC_ASSOCIATION_ASSIGN);

    
    UILabel *timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(viewW-100.0f, dataLabel.frame.origin.y, 100.0f, 15.0f)];
    timeLabel.textColor = COLOR_CHARACTERS_BLACK;
    timeLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    [self.contentView addSubview:timeLabel];
    objc_setAssociatedObject(self, &AssessTimeKey, timeLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///评论内容
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(userLabel.frame.origin.x, userLabel.frame.origin.y+userLabel.frame.size.height+5.0f, SIZE_DEFAULT_MAX_WIDTH-70.0f, 15.0f)];
    commentLabel.textColor = COLOR_CHARACTERS_BLACK;
    commentLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_14];
    [self.contentView addSubview:commentLabel];
    objc_setAssociatedObject(self, &AssessCommentKey, commentLabel, OBJC_ASSOCIATION_ASSIGN);

}

-(void)updateAssessCellInfo:(QSCommentListDataModel *)CommentDataModel
{

    [self updateAssessImageKey:CommentDataModel.userInfo.avatar];
    [self updateAssessUserKey:CommentDataModel.userInfo.username];
    [self updateAssessDateKey:CommentDataModel.create_time];
    [self updateAssessTimeKey:CommentDataModel.update_time];
    [self updateAssessCommentKey:CommentDataModel.content];

}

-(void)updateAssessImageKey:(NSString*)image
{

    QSImageView *imageView=objc_getAssociatedObject(self, &AssessImageKey);
    if (imageView && image) {
        
        //imageView.image=[UIImage imageNamed:image];
        [imageView loadImageWithURL:[image getImageURL] placeholderImage:[UIImage imageNamed:@"icon80"]];
            
    }
    
}

-(void)updateAssessUserKey:(NSString *)userName
{
    UILabel *userLabel=objc_getAssociatedObject(self, &AssessUserKey);
    if (userLabel&&userName) {
        
        userLabel.text=userName;
        
    }

}

-(void)updateAssessDateKey:(NSString *)data
{
     UILabel *dataLabel=objc_getAssociatedObject(self, &AssessDateKey);
    if (data) {
        
        dataLabel.text=data;
        
    }

}

-(void)updateAssessTimeKey:(NSString *)time
{

    UILabel *timeLabel=objc_getAssociatedObject(self, &AssessTimeKey);
    if (time) {
        timeLabel.text=time;
    }

}

-(void)updateAssessCommentKey:(NSString *)comment
{


    UILabel *commentLabel=objc_getAssociatedObject(self, &AssessCommentKey);
    if (comment) {
        commentLabel.text=comment;
    }

}

@end
