//
//  QSPSalerBookedOrderListsTableViewCell.m
//  House
//
//  Created by CoolTea on 15/3/26.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPSalerBookedOrderListsTableViewCell.h"
#import "UIKit+AFNetworking.h"
#import "CoreHeader.h"
#include <objc/runtime.h>
#import "QSOrderListReturnData.h"

///关联
static char stateLabelKey;      //!<状态Label关联key
static char personNameLabelKey; //!<房客名字Label关联key
static char infoLabelKey;       //!<时间,出价等简介Label关联key
static char leftActionBtKey;    //!<右部左边按钮关联key
static char rightActionBtKey;   //!<右部右边按钮关联key

@implementation QSPSalerBookedOrderListsTableViewCell

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
    
    //状态
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 16.0f, MY_ZONE_ORDER_LIST_CELL_WIDTH-100, 24)];
    [stateLabel setFont:[UIFont systemFontOfSize:FONT_BODY_14]];
    [self.contentView addSubview:stateLabel];
    
    objc_setAssociatedObject(self, &stateLabelKey, stateLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //业主、经纪人、开发商
    UILabel *personNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(stateLabel.frame.origin.x, stateLabel.frame.origin.y+stateLabel.frame.size.height+4, stateLabel.frame.size.width, 20)];
    [personNameLabel setFont:[UIFont systemFontOfSize:FONT_BODY_14]];
    [self.contentView addSubview:personNameLabel];
    
    objc_setAssociatedObject(self, &personNameLabelKey, personNameLabel, OBJC_ASSOCIATION_ASSIGN);
    
    //时间
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(personNameLabel.frame.origin.x, personNameLabel.frame.origin.y+personNameLabel.frame.size.height, personNameLabel.frame.size.width, personNameLabel.frame.size.height)];
    [infoLabel setFont:[UIFont systemFontOfSize:FONT_BODY_14]];
    [self.contentView addSubview:infoLabel];
    
    objc_setAssociatedObject(self, &infoLabelKey, infoLabel, OBJC_ASSOCIATION_ASSIGN);
    
    
    //右部左按钮
    QSBlockButtonStyleModel *leftActionBtStyle = [[QSBlockButtonStyleModel alloc] init];
    //    leftActionBtStyle.imagesNormal = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_NORMAL;
    //    leftActionBtStyle.imagesHighted = IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED;
    UIButton *leftBt = [UIButton createBlockButtonWithFrame:CGRectMake(MY_ZONE_ORDER_LIST_CELL_WIDTH-70.0f, stateLabel.frame.origin.y+stateLabel.frame.size.height+8, 30.0f, 34.0f) andButtonStyle:leftActionBtStyle andCallBack:^(UIButton *button) {
        
        NSLog(@"leftActionBt");
        if (self.parentViewController) {
            
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
        if (self.parentViewController) {
            
        }
        
    }];
    [self.contentView addSubview:rightBt];
    
    objc_setAssociatedObject(self, &rightActionBtKey, rightBt, OBJC_ASSOCIATION_ASSIGN);
    
    ///分隔线
    UILabel *bottomLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, MY_ZONE_ORDER_LIST_CELL_HEIGHT-0.5f, MY_ZONE_ORDER_LIST_CELL_WIDTH, 0.5f)];
    [bottomLineLablel setBackgroundColor:COLOR_CHARACTERS_BLACKH];
    [self.contentView addSubview:bottomLineLablel];
    
}

- (void)updateCellWith:(id)Data withIndex:(NSInteger)index
{
    
    [self setTag:index];
    
    UILabel *stateLabel = objc_getAssociatedObject(self, &stateLabelKey);
    if (stateLabel) {
        [stateLabel setText:@""];
    }
    
    UILabel *personNameLabel = objc_getAssociatedObject(self, &personNameLabelKey);
    if (personNameLabel) {
        [personNameLabel setText:@""];
    }
    
    UILabel *infoLabel = objc_getAssociatedObject(self, &infoLabelKey);
    if (infoLabel) {
        [infoLabel setAttributedText:nil];
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
    
    QSOrderListItemData *orderData = (QSOrderListItemData*)Data;

    if ([orderData getUserIsOwnerFlag]) {
        //非房客
        if (orderData.orderInfoList&&[orderData.orderInfoList count]>0) {
            
            QSOrderListOrderInfoDataModel *orderInfoData = [orderData.orderInfoList objectAtIndex:index];
            if (orderInfoData&&[orderInfoData isKindOfClass:[QSOrderListOrderInfoDataModel class]]) {
                
                if (stateLabel) {
                    [stateLabel setText:[orderInfoData getStatusTitle]];
                }
                
                NSLog(@"%@ StatusTitle:%@",orderInfoData.order_status,stateLabel.text);
                
                if (personNameLabel) {
                    [personNameLabel setText:[NSString stringWithFormat:@"房客:%@",orderInfoData.buyer_name]];
                }
                
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
      
        
    }else{
        //房客

    }
    
    if (infoLabel) {
        
        [infoLabel setAttributedText:[orderData getSummaryOnCellAttributedString]];
        
    }

    
//        if (leftBt) {
//    
//            [leftBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_NORMAL] forState:UIControlStateNormal];
//            [leftBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED] forState:UIControlStateHighlighted];
//            [leftBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_CALL_BT_SELECTED] forState:UIControlStateSelected];
//    
//        }
//    
//        if (rightBt) {
//    
//            [rightBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_NORMAL] forState:UIControlStateNormal];
//            [rightBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED] forState:UIControlStateHighlighted];
//            [rightBt setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_ASK_BT_SELECTED] forState:UIControlStateSelected];
//    
//        }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
