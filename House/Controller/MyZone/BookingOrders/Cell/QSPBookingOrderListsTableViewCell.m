//
//  QSPBookingOrderListsTableViewCell.m
//  House
//
//  Created by CoolTea on 15/3/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPBookingOrderListsTableViewCell.h"
#import "UIKit+AFNetworking.h"
#import "CoreHeader.h"
#include <objc/runtime.h>

///关联
static char leftTopTipViewKey;  //!<左上角图片关联key
static char nameLabelKey;       //!<名字Label关联key
static char stateLabelKey;      //!<状态Label关联key
static char contentImgViewKey;  //!<房源图片关联key
static char personNameLabelKey; //!<业主经济开发商Label关联key
static char timeLabelKey;       //!<时间Label关联key
static char leftActionBtKey;    //!<右部左边按钮关联key
static char rightActionBtKey;   //!<右部右边按钮关联key

@implementation QSPBookingOrderListsTableViewCell

@synthesize parentViewController;

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        ///UI搭建
        [self createListCellUI];
        
    }
    return self;
    
}

- (void)createListCellUI
{
    
    //左上角图标
    UIImageView *leftIconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 16, 18)];
    [leftIconImgView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_BUY_CION]];
    [self.contentView addSubview:leftIconImgView];
    
    objc_setAssociatedObject(self, &leftTopTipViewKey, leftIconImgView, OBJC_ASSOCIATION_ASSIGN);
    
    //小区名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftIconImgView.frame.origin.x+leftIconImgView.frame.size.width+4, leftIconImgView.frame.origin.y+(leftIconImgView.frame.size.height-24)/2.0f, 190.0f/325.0f * SIZE_DEVICE_WIDTH, 24)];
    [nameLabel setFont:[UIFont systemFontOfSize:FONT_BODY_16]];
    [self.contentView addSubview:nameLabel];
    
    objc_setAssociatedObject(self, &nameLabelKey, nameLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //状态
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x+nameLabel.frame.size.width+2, nameLabel.frame.origin.y+(nameLabel.frame.size.height-24)/2.0f, MY_ZONE_ORDER_LIST_CELL_WIDTH-(nameLabel.frame.origin.x+nameLabel.frame.size.width)-6, 24)];
    [stateLabel setFont:[UIFont systemFontOfSize:FONT_BODY_12]];
    [stateLabel setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:stateLabel];
    
    objc_setAssociatedObject(self, &stateLabelKey, stateLabel, OBJC_ASSOCIATION_ASSIGN);
    
    
    //图片
    UIImageView *contentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, nameLabel.frame.origin.y+nameLabel.frame.size.height+10, 50, 50)];
    [self.contentView addSubview:contentImgView];
    
    objc_setAssociatedObject(self, &contentImgViewKey, contentImgView, OBJC_ASSOCIATION_ASSIGN);
    
    UIImageView *contentCoverImgView = [[UIImageView alloc] initWithFrame:contentImgView.frame];
    [contentCoverImgView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_COVER_FRAME]];
    [self.contentView addSubview:contentCoverImgView];
    
    
    //业主、经纪人、开发商
    UILabel *personNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentCoverImgView.frame.origin.x+contentCoverImgView.frame.size.width+4, contentCoverImgView.frame.origin.y+9, 170, 16)];
    [personNameLabel setFont:[UIFont systemFontOfSize:FONT_BODY_12]];
    [self.contentView addSubview:personNameLabel];
    
    objc_setAssociatedObject(self, &personNameLabelKey, personNameLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(personNameLabel.frame.origin.x, personNameLabel.frame.origin.y+personNameLabel.frame.size.height, personNameLabel.frame.size.width, personNameLabel.frame.size.height)];
    [timeLabel setFont:[UIFont systemFontOfSize:FONT_BODY_12]];
    [self.contentView addSubview:timeLabel];
    
    objc_setAssociatedObject(self, &timeLabelKey, timeLabel, OBJC_ASSOCIATION_ASSIGN);
    
  
    //右部左按钮
    QSBlockButtonStyleModel *leftActionBtStyle = [[QSBlockButtonStyleModel alloc] init];
//    leftActionBtStyle.imagesNormal = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_NORMAL;
//    leftActionBtStyle.imagesHighted = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED;
    UIButton *leftBt = [UIButton createBlockButtonWithFrame:CGRectMake(MY_ZONE_ORDER_LIST_CELL_WIDTH-70.0f, stateLabel.frame.origin.y+stateLabel.frame.size.height+20.0f, 30.0f, 34.0f) andButtonStyle:leftActionBtStyle andCallBack:^(UIButton *button) {
        
        NSLog(@"leftActionBt");
        
    }];
    [self.contentView addSubview:leftBt];
    
    objc_setAssociatedObject(self, &leftActionBtKey, leftBt, OBJC_ASSOCIATION_ASSIGN);
    
    //右部右按钮
    QSBlockButtonStyleModel *rightActionBtStyle = [[QSBlockButtonStyleModel alloc] init];
//    rightActionBtStyle.imagesNormal = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_NORMAL;
//    rightActionBtStyle.imagesHighted = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED;
    UIButton *rightBt = [UIButton createBlockButtonWithFrame:CGRectMake(leftBt.frame.origin.x+leftBt.frame.size.width+4.0f, leftBt.frame.origin.y, leftBt.frame.size.width, leftBt.frame.size.height) andButtonStyle:rightActionBtStyle andCallBack:^(UIButton *button) {
        
        NSLog(@"rightActionBt");
        
    }];
    [self.contentView addSubview:rightBt];
    
    objc_setAssociatedObject(self, &rightActionBtKey, rightBt, OBJC_ASSOCIATION_ASSIGN);
    
    ///分隔线
    UILabel *bottomLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, MY_ZONE_ORDER_LIST_CELL_HEIGHT-0.5f, MY_ZONE_ORDER_LIST_CELL_WIDTH, 0.5f)];
    [bottomLineLablel setBackgroundColor:COLOR_CHARACTERS_BLACKH];
    [self.contentView addSubview:bottomLineLablel];
    
}

- (void)updateCellWith:(id)Data
{
    
    UIImageView *leftIconImgView = objc_getAssociatedObject(self, &leftTopTipViewKey);
    if (leftIconImgView) {
        
        [leftIconImgView setImage:nil];
        
        //TODO: 图标逻辑
        //“购”图标
        [leftIconImgView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_BUY_CION]];
        
        //“租”图标
        [leftIconImgView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_RENT_CION]];
        
        //“新”图标
        [leftIconImgView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_NEW_CION]];
        
    }
    
    UILabel *nameLabel = objc_getAssociatedObject(self, &nameLabelKey);
    if (nameLabel) {
        
        [nameLabel setText:@""];
        
        [nameLabel setText:@"法规科大菊花并非是他去韩国小区"];
        
    }
    
    UILabel *stateLabel = objc_getAssociatedObject(self, &stateLabelKey);
    if (stateLabel) {
        
        [stateLabel setText:@""];
        
        [stateLabel setText:@"预约待确认"];
        
    }
    
    UIImageView *contentImgView = objc_getAssociatedObject(self, &contentImgViewKey);
    if (contentImgView) {
        
        [contentImgView setImage:nil];
        
        [contentImgView setImageWithURL:[NSURL URLWithString:@"http://admin.9dxz.com/files/%E5%A7%AC%E6%9D%BE%E8%8C%B8%E7%82%96%E9%B8%A1%E7%88%AA.jpg"]];
        
    }
    
    UILabel *personNameLabel = objc_getAssociatedObject(self, &personNameLabelKey);
    if (personNameLabel) {
        
        [personNameLabel setText:@""];
        
        [personNameLabel setText:@"业主：奥巴马"];
        
    }
    
    UILabel *timeLabel = objc_getAssociatedObject(self, &timeLabelKey);
    if (timeLabel) {
        
        [timeLabel setText:@""];
        
        [timeLabel setText:@"时间：2015-03-11 12：29"];
        
    }
    
    UIButton *leftBt = objc_getAssociatedObject(self, &leftActionBtKey);
    if (leftBt) {
        
        [leftBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_NORMAL] forState:UIControlStateNormal];
        [leftBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED] forState:UIControlStateHighlighted];
        [leftBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED] forState:UIControlStateSelected];
        
    }
    
    UIButton *rightBt = objc_getAssociatedObject(self, &rightActionBtKey);
    if (rightBt) {
        
        [rightBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_NORMAL] forState:UIControlStateNormal];
        [rightBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED] forState:UIControlStateHighlighted];
        [rightBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED] forState:UIControlStateSelected];
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
