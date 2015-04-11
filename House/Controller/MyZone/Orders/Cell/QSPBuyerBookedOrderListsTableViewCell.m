//
//  QSPBuyerBookedOrderListsTableViewCell.m
//  House
//
//  Created by CoolTea on 15/3/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPBuyerBookedOrderListsTableViewCell.h"
#import "UIKit+AFNetworking.h"
#import "CoreHeader.h"
#include <objc/runtime.h>
#import "QSOrderListReturnData.h"
#import "NSString+Calculation.h"
#import "QSYTalkPTPViewController.h"
#import "QSYPopCustomView.h"
#import "QSYCallTipsPopView.h"

///关联
static char leftTopTipViewKey;  //!<左上角图片关联key
static char nameLabelKey;       //!<名字Label关联key
static char stateLabelKey;      //!<状态Label关联key
static char contentImgViewKey;  //!<房源图片关联key
static char personNameLabelKey; //!<业主经济开发商Label关联key
static char infoLabelKey;       //!<时间,出价等简介Label关联key
static char leftActionBtKey;    //!<右部左边按钮关联key
static char rightActionBtKey;   //!<右部右边按钮关联key

@interface QSPBuyerBookedOrderListsTableViewCell ()

@property(nonatomic,strong) QSOrderListItemData *orderData;
@property(nonatomic,assign) NSInteger       selectedIndex;

@end


@implementation QSPBuyerBookedOrderListsTableViewCell

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
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(personNameLabel.frame.origin.x, personNameLabel.frame.origin.y+personNameLabel.frame.size.height, personNameLabel.frame.size.width, personNameLabel.frame.size.height)];
    [infoLabel setFont:[UIFont systemFontOfSize:FONT_BODY_12]];
    [self.contentView addSubview:infoLabel];
    
    objc_setAssociatedObject(self, &infoLabelKey, infoLabel, OBJC_ASSOCIATION_ASSIGN);
    
  
    //右部左按钮
    QSBlockButtonStyleModel *leftActionBtStyle = [[QSBlockButtonStyleModel alloc] init];
//    leftActionBtStyle.imagesNormal = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_NORMAL;
//    leftActionBtStyle.imagesHighted = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED;
    UIButton *leftBt = [UIButton createBlockButtonWithFrame:CGRectMake(MY_ZONE_ORDER_LIST_CELL_WIDTH-70.0f, stateLabel.frame.origin.y+stateLabel.frame.size.height+20.0f, 30.0f, 34.0f) andButtonStyle:leftActionBtStyle andCallBack:^(UIButton *button) {
        
        NSLog(@"leftActionBt");
        if (500210 == button.tag || 500203 == button.tag || 500213 == button.tag) {
            //打电话
            [self callPhone];
        }
        
    }];
    [self.contentView addSubview:leftBt];
    
    objc_setAssociatedObject(self, &leftActionBtKey, leftBt, OBJC_ASSOCIATION_ASSIGN);
    
    //右部右按钮
    QSBlockButtonStyleModel *rightActionBtStyle = [[QSBlockButtonStyleModel alloc] init];
//    rightActionBtStyle.imagesNormal = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_NORMAL;
//    rightActionBtStyle.imagesHighted = IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED;
    UIButton *rightBt = [UIButton createBlockButtonWithFrame:CGRectMake(leftBt.frame.origin.x+leftBt.frame.size.width+4.0f, leftBt.frame.origin.y, leftBt.frame.size.width, leftBt.frame.size.height) andButtonStyle:rightActionBtStyle andCallBack:^(UIButton *button) {
        
        NSLog(@"rightActionBt");
        if (500210 == button.tag || 500203 == button.tag || 500213 == button.tag) {
            //跳转去聊天
            [self goToChat];
            
        }
        
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
    
    self.orderData = (QSOrderListItemData*)Data;
    
    UIImageView *leftIconImgView = objc_getAssociatedObject(self, &leftTopTipViewKey);
    if (leftIconImgView) {
        [leftIconImgView setImage:nil];
    }
    
    UILabel *nameLabel = objc_getAssociatedObject(self, &nameLabelKey);
    if (nameLabel) {
        [nameLabel setText:@""];
    }
    
    UILabel *stateLabel = objc_getAssociatedObject(self, &stateLabelKey);
    if (stateLabel) {
        [stateLabel setText:@""];
    }
    
    UIImageView *contentImgView = objc_getAssociatedObject(self, &contentImgViewKey);
    if (contentImgView) {
        [contentImgView setImage:nil];
    }
    
    UILabel *personNameLabel = objc_getAssociatedObject(self, &personNameLabelKey);
    if (personNameLabel) {
        [personNameLabel setText:@""];
    }
    
    UILabel *infoLabel = objc_getAssociatedObject(self, &infoLabelKey);
    if (infoLabel) {
        [infoLabel setText:@""];
    }
    
    UIButton *rightBt = objc_getAssociatedObject(self, &rightActionBtKey);
    if (rightBt) {
        [rightBt setTag:0];
        [rightBt setHidden:YES];
    }
    
    UIButton *leftBt = objc_getAssociatedObject(self, &leftActionBtKey);
    if (leftBt) {
        [leftBt setTag:0];
        [leftBt setHidden:YES];
    }
    
//    QSOrderListItemData
    if (!Data || ![Data isKindOfClass:[QSOrderListItemData class]]) {
        return;
    }
    
    if (leftIconImgView) {
        
//        //TODO: 图标逻辑
//        //“购”图标
//        [leftIconImgView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_BUY_CION]];
//        
//        //“租”图标
//        [leftIconImgView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_RENT_CION]];
//        
//        //“新”图标
//        [leftIconImgView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_NEW_CION]];
        [leftIconImgView setImage:[UIImage imageNamed:[self.orderData getHouseTypeImg]]];
    }
    
    if (nameLabel) {
        
//        [nameLabel setText:@"法规科大菊花并非是他去韩国小区"];
        [nameLabel setText:[self.orderData getHouseTitle]];
        
    }
    
    if (stateLabel) {
        
//        [stateLabel setText:@"预约待确认"];
        
        if ([self.orderData getUserIsOwnerFlag]) {
            //非房客
            
        }else{
            //房客
            if (self.orderData.orderInfoList&&[self.orderData.orderInfoList count]>0) {
                
                QSOrderListOrderInfoDataModel *orderInfoData = [self.orderData.orderInfoList objectAtIndex:0];
                if (orderInfoData&&[orderInfoData isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
                    
                    [stateLabel setText:[orderInfoData getStatusTitle]];
                    
                    NSLog(@"%@ StatusTitle:%@",orderInfoData.order_status,stateLabel.text);
                    
                }
            }
        }
        
    }
    
    if (contentImgView) {
        
//        [contentImgView setImageWithURL:[NSURL URLWithString:@"http://admin.9dxz.com/files/%E5%A7%AC%E6%9D%BE%E8%8C%B8%E7%82%96%E9%B8%A1%E7%88%AA.jpg"]];
        [contentImgView setImageWithURL:[[self.orderData getHouseSmallImgUrl] getImageURL]];
        
    }
    
    if (personNameLabel) {
        
//        [personNameLabel setText:@"业主：奥巴马"];
        
        if ([self.orderData getUserIsOwnerFlag]) {
            
            
        }else{
            //房客
            if (self.orderData.ownerData) {
                [personNameLabel setText:[NSString stringWithFormat:@"%@:%@",[self.orderData.ownerData getUserTypeStr],self.orderData.ownerData.username]];
            }
            
        }
        
    }
    
    if (infoLabel) {
      
        [infoLabel setAttributedText:[self.orderData getSummaryOnCellAttributedString]];
        
    }
    
    if ([self.orderData getUserIsOwnerFlag]) {
        
        
    }else{
        //房客
        if (self.orderData.orderInfoList&&[self.orderData.orderInfoList count]>0) {
            
            QSOrderListOrderInfoDataModel *orderInfoData = [self.orderData.orderInfoList objectAtIndex:0];
            if (orderInfoData&&[orderInfoData isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
                
                NSArray *btList = [orderInfoData getButtonSource];
                
                if (btList&&[btList isKindOfClass:[NSArray class]]&&[btList count]>0) {
                    
                    if ([btList count]==1) {
                        
                        QSOrderButtonActionModel *rightBtAction = [btList objectAtIndex:0];
                        
                        if (rightBtAction&&[rightBtAction isKindOfClass:[QSOrderButtonActionModel class]]&&rightBt) {
                            
                            [rightBt setTag:rightBtAction.bottionActionTag];
                            [rightBt setImage:[UIImage imageNamed:rightBtAction.normalImg] forState:UIControlStateNormal];
                            [rightBt setImage:[UIImage imageNamed:rightBtAction.highLightImg] forState:UIControlStateHighlighted];
                            [rightBt setImage:[UIImage imageNamed:rightBtAction.highLightImg] forState:UIControlStateSelected];
                        
                        }
                        
                    }else if ([btList count]==2) {
                        
                        QSOrderButtonActionModel *rightBtAction = [btList objectAtIndex:0];
                        
                        if (rightBtAction&&[rightBtAction isKindOfClass:[QSOrderButtonActionModel class]]&&rightBt) {
                            
                            [rightBt setTag:rightBtAction.bottionActionTag];
                            [rightBt setImage:[UIImage imageNamed:rightBtAction.normalImg] forState:UIControlStateNormal];
                            [rightBt setImage:[UIImage imageNamed:rightBtAction.highLightImg] forState:UIControlStateHighlighted];
                            [rightBt setImage:[UIImage imageNamed:rightBtAction.highLightImg] forState:UIControlStateSelected];
                            [rightBt setHidden:NO];
                            
                        }
                        
                        QSOrderButtonActionModel *leftBtAction = [btList objectAtIndex:1];
                        
                        if (leftBtAction&&[leftBtAction isKindOfClass:[QSOrderButtonActionModel class]]&&leftBt) {
                            
                            [leftBt setTag:leftBtAction.bottionActionTag];
                            [leftBt setImage:[UIImage imageNamed:leftBtAction.normalImg] forState:UIControlStateNormal];
                            [leftBt setImage:[UIImage imageNamed:leftBtAction.highLightImg] forState:UIControlStateHighlighted];
                            [leftBt setImage:[UIImage imageNamed:leftBtAction.highLightImg] forState:UIControlStateSelected];
                            [leftBt setHidden:NO];
                            
                        }
                    }
                    
                }
                
            }
        }
        
    }
    
//    if (leftBt) {
//        
//        [leftBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_NORMAL] forState:UIControlStateNormal];
//        [leftBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED] forState:UIControlStateHighlighted];
//        [leftBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED] forState:UIControlStateSelected];
//        
//    }
//    
//    if (rightBt) {
//        
//        [rightBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_NORMAL] forState:UIControlStateNormal];
//        [rightBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED] forState:UIControlStateHighlighted];
//        [rightBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED] forState:UIControlStateSelected];
//        
//    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)goToChat
{
    
    if (self.orderData) {
        
        QSOrderListOwnerMsgDataModel *personInfo = nil;
        if ([self.orderData isKindOfClass:[QSOrderListItemData class]]) {
            
            if (self.orderData.ownerData && [self.orderData.ownerData isKindOfClass:[QSOrderListOwnerMsgDataModel class]]) {
                
                personInfo = self.orderData.ownerData;
                
            }
            
        }
        
        if (self.parentViewController && personInfo) {
            
            QSYTalkPTPViewController *talkVC = [[QSYTalkPTPViewController alloc] initWithUserModel:[personInfo transformToSimpleDataModel]];
            [self.parentViewController.navigationController pushViewController:talkVC animated:YES];
            
        }
        
    }
    
}

- (void)callPhone
{
    
    if (self.orderData) {
        
        QSOrderListOwnerMsgDataModel *personInfo = nil;
        if ([self.orderData isKindOfClass:[QSOrderListItemData class]]) {
            
            if (self.orderData.ownerData && [self.orderData.ownerData isKindOfClass:[QSOrderListOwnerMsgDataModel class]]) {
                
                personInfo = self.orderData.ownerData;
                
            }
            
        }
        
        if (self.parentViewController && personInfo) {
            
            NSString *phoneStr = personInfo.mobile;
            NSString *ownerNameStr = personInfo.username;
            
            if (phoneStr&&![phoneStr isEqualToString:@""]) {
                
                ///弹出框
                __block QSYPopCustomView *popView;
                
                QSYCallTipsPopView *callTipsView = [[QSYCallTipsPopView alloc] initWithFrame:CGRectMake(0.0f, SIZE_DEVICE_HEIGHT - 130.0f, SIZE_DEVICE_WIDTH, 130.0f) andName:ownerNameStr andPhone:phoneStr andCallBack:^(CALL_TIPS_CALLBACK_ACTION_TYPE actionType) {
                    
                    ///回收弹框
                    [popView hiddenCustomPopview];
                    
                    ///确认打电话
                    if (cCallTipsCallBackActionTypeConfirm == actionType) {
                        
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneStr]]];
                        
                    }
                    
                }];
                
                popView = [QSYPopCustomView popCustomViewWithoutChangeFrame:callTipsView andPopViewActionCallBack:^(CUSTOM_POPVIEW_ACTION_TYPE actionType, id params, int selectedIndex) {
                    
                }];
            }
        }
    }
    
}


@end
