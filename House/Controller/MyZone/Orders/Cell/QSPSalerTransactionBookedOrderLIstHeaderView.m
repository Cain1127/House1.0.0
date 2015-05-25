//
//  QSPSalerTransactionBookedOrderLIstHeaderView.m
//  House
//
//  Created by CoolTea on 15/3/30.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPSalerTransactionBookedOrderLIstHeaderView.h"
#import "UIKit+AFNetworking.h"
#import "CoreHeader.h"
#include <objc/runtime.h>
#import "QSOrderListReturnData.h"
#import "NSString+Calculation.h"

///关联
static char houseTypeTopTipViewKey;  //!<左上角图片关联key
static char nameLabelKey;       //!<名字Label关联key
static char contentImgViewKey;  //!<房源图片关联key
static char infoLabelKey;       //!<时间,出价等简介Label关联key
static char oepnActionBtKey;    //!<右部展开按钮关联key

@interface QSPSalerTransactionBookedOrderLIstHeaderView ()

@property (nonatomic, strong) id sectionData;

@end

@implementation QSPSalerTransactionBookedOrderLIstHeaderView
@synthesize orderTypeName;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self CreateUI];
        
    }
    return self;
}


- (void)CreateUI
{
    
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    //图片
    UIImageView *contentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (MY_ZONE_ORDER_LIST_HEADER_CELL_HEIGHT-50.0f)/2, 50, 50)];
    [self.contentView addSubview:contentImgView];
    
    objc_setAssociatedObject(self, &contentImgViewKey, contentImgView, OBJC_ASSOCIATION_ASSIGN);
    
    //左上角图标
    UIImageView *houseTypeIconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(contentImgView.frame.origin.x+(contentImgView.frame.size.width-18)/2, contentImgView.frame.origin.y, 16, 18)];
    [houseTypeIconImgView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_BUY_CION]];
    [self.contentView addSubview:houseTypeIconImgView];
    
    objc_setAssociatedObject(self, &houseTypeTopTipViewKey, houseTypeIconImgView, OBJC_ASSOCIATION_ASSIGN);
    
    UIImageView *contentCoverImgView = [[UIImageView alloc] initWithFrame:contentImgView.frame];
    [contentCoverImgView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_COVER_FRAME]];
    [self.contentView addSubview:contentCoverImgView];
    
    
    //小区名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentImgView.frame.origin.x+contentImgView.frame.size.width+4, contentImgView.frame.origin.y+6, 190.0f/325.0f * SIZE_DEVICE_WIDTH, 18)];
    [nameLabel setFont:[UIFont boldSystemFontOfSize:FONT_BODY_16]];
    [self.contentView addSubview:nameLabel];
    
    objc_setAssociatedObject(self, &nameLabelKey, nameLabel, OBJC_ASSOCIATION_ASSIGN);
    
    
    //订单数量信息
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+nameLabel.frame.size.height, 170.0f, 20)];
    [infoLabel setFont:[UIFont systemFontOfSize:FONT_BODY_14]];
    [self.contentView addSubview:infoLabel];
    
    objc_setAssociatedObject(self, &infoLabelKey, infoLabel, OBJC_ASSOCIATION_ASSIGN);
    
    QSBlockButtonStyleModel *buttonStyle = [[QSBlockButtonStyleModel alloc] init];
    buttonStyle.imagesNormal = IMAGE_ZONE_ORDER_DETAIL_DOWN_ARROW_BT;
    UIButton *downButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-2*CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP-44, (MY_ZONE_ORDER_LIST_HEADER_CELL_HEIGHT-44)/2, 44, 44) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        NSLog(@"QSPSalerTransactionBookedOrderLIstHeaderView downButton");
        
//        [UIView animateWithDuration:0.3f animations:^{
//            
//            
//        } completion:^(BOOL finished) {
//            
//            
//        }];
        if (_delegate) {
            [_delegate clickItemInHeaderViewWithData:self.sectionData withSection:self.tag];
        }
        
    }];
    [self addSubview:downButton];
    
    objc_setAssociatedObject(self, &oepnActionBtKey, downButton, OBJC_ASSOCIATION_ASSIGN);
    
    ///分隔线
    UILabel *bottomLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, MY_ZONE_ORDER_LIST_HEADER_CELL_HEIGHT-0.5f, MY_ZONE_ORDER_LIST_HEADER_CELL_WIDTH, 0.5f)];
    [bottomLineLablel setBackgroundColor:COLOR_CHARACTERS_BLACKH];
    [self.contentView addSubview:bottomLineLablel];
    
}

- (void)updateData:(id)data
{
    
    UIImageView *houseTypeIconImgView = objc_getAssociatedObject(self, &houseTypeTopTipViewKey);
    if (houseTypeIconImgView) {
        [houseTypeIconImgView setImage:nil];
    }
    
    UILabel *nameLabel = objc_getAssociatedObject(self, &nameLabelKey);
    if (nameLabel) {
        [nameLabel setText:@""];
    }
    
    UIImageView *contentImgView = objc_getAssociatedObject(self, &contentImgViewKey);
    if (contentImgView) {
        [contentImgView setImage:nil];
    }
    
    UILabel *infoLabel = objc_getAssociatedObject(self, &infoLabelKey);
    if (infoLabel) {
        [infoLabel setAttributedText:nil];
    }
    
    if (!data || ![data isKindOfClass:[QSOrderListItemData class]]) {
        NSLog(@"data is not QSOrderListItemData class");
        return;
    }
    
    self.sectionData = (QSOrderListItemData*)data;
    
    if (houseTypeIconImgView) {
        [houseTypeIconImgView setImage:[UIImage imageNamed:[self.sectionData getHouseTypeImg]]];
    }
    
    if (nameLabel) {
        [nameLabel setText:[self.sectionData getHouseTitle]];
    }

    if (contentImgView) {
        [contentImgView setImageWithURL:[[self.sectionData getHouseLargeImgUrl] getImageURL]];
    }
    
    if ([self.sectionData orderInfoList]&&[[self.sectionData orderInfoList] count]>0)
    {
        if (infoLabel) {
            [infoLabel setAttributedText:[self orderNumStringWithCount:[[self.sectionData orderInfoList] count]]];
        }
    }
    
}

- (NSAttributedString*)orderNumStringWithCount:(NSInteger)count
{
    
    NSString *countStr = [NSString stringWithFormat:@"(%ld)",(long)count];
    NSString *lastString = @"条订单";//TODO:三种状态判断
    if (orderTypeName && ![orderTypeName isEqualToString:@""]) {
        lastString = [NSString stringWithFormat:@"条%@订单",orderTypeName];
    }
    NSString *tempString = [NSString stringWithFormat:@"共有%@%@",countStr,lastString];
    NSMutableAttributedString *summaryString = [[NSMutableAttributedString alloc] initWithString:tempString];
    [summaryString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_GRAY range:NSMakeRange(0, tempString.length)];
    [summaryString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_YELLOW range:NSMakeRange(2, countStr.length)];
    //设置字体大小
    [summaryString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_BODY_14] range:NSMakeRange(0, summaryString.length)];
    [summaryString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_BODY_16] range:NSMakeRange(2, countStr.length)];
    return summaryString;
    
}

- (void)setShowButtonOpenOrClose:(BOOL)flag
{
    
    UIButton *showButton = objc_getAssociatedObject(self, &oepnActionBtKey);
    if (showButton) {
        
        if (flag) {
            
            [showButton setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_DETAIL_UP_ARROW_BT] forState:UIControlStateNormal];
            
        }else{
            
            [showButton setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_DETAIL_DOWN_ARROW_BT] forState:UIControlStateNormal];
            
        }
    }
}

@end
