//
//  QSYReleasePickCommunityTableViewCell.m
//  House
//
//  Created by ysmeng on 15/3/25.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYReleasePickCommunityTableViewCell.h"

#import "QSCommunityDataModel.h"

#import <objc/runtime.h>

///关联
static char TitleKey;//!<标题信息关联

@implementation QSYReleasePickCommunityTableViewCell

#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        ///搭建UI
        [self createReleasePickCommunityUI];
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createReleasePickCommunityUI
{
    
    ///小区标题信息
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 10.0f, SIZE_DEFAULT_MAX_WIDTH, 30.0f)];
    titleLabel.font = [UIFont systemFontOfSize:FONT_BODY_20];
    titleLabel.textColor = COLOR_CHARACTERS_GRAY;
    [self.contentView addSubview:titleLabel];
    objc_setAssociatedObject(self, &TitleKey, titleLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///分隔线
    UILabel *sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, titleLabel.frame.origin.y + titleLabel.frame.size.height + VIEW_SIZE_NORMAL_VIEW_VERTICAL_GAP, SIZE_DEFAULT_MAX_WIDTH, 0.25f)];
    sepLabel.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self.contentView addSubview:sepLabel];

}

#pragma mark - 刷新UI
- (void)updateReleasePickCommunityCellUI:(QSCommunityDataModel *)model
{

    ///理新标题
    UILabel *titleLabel = objc_getAssociatedObject(self, &TitleKey);
    if (titleLabel && model.title) {
        
        titleLabel.text = model.title;
        
    }

}

@end
