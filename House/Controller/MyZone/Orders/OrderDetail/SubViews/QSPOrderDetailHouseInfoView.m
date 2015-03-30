//
//  QSPOrderDetailHouseInfoView.m
//  House
//
//  Created by CoolTea on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailHouseInfoView.h"
#import "UIKit+AFNetworking.h"
#import "QSOrderListHouseInfoDataModel.h"
//上下间隙
#define     CONTENT_TOP_BOTTOM_OFFSETY     14.0f

////关联
//static char houseIDLabelKey;        //!<房源ID关联key
//static char contentImgViewKey;      //!<房源图片关联key
//static char houseTitleLabelKey;     //!<房源标题关联key

@interface QSPOrderDetailHouseInfoView ()

@property (nonatomic, strong) UILabel *houseTitleIDLabel;
@property (nonatomic, strong) UIImageView *contentImgView;
@property (nonatomic, strong) UILabel *nameLabel;

@end



@implementation QSPOrderDetailHouseInfoView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withHouseData:(id)houseData andCallBack:(void(^)(UIButton *button))callBack
{
    
    return [self initWithFrame:CGRectMake(topLeftPoint.x, topLeftPoint.y, SIZE_DEVICE_WIDTH, 0.0f) withHouseData:houseData andCallBack:callBack];
    
}

- (instancetype)initWithFrame:(CGRect)frame withHouseData:(id)houseData andCallBack:(void(^)(UIButton *button))callBack
{
    if (self = [super initWithFrame:frame]) {
        
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        
//        //房源编号
//        NSString *houseNum = @"";
//        //图片Url
//        NSString *houseSmallImgUrl = @"";
//        NSString *houseName = @"";
//        
//        if (houseData) {
//            
//            if ([houseData isKindOfClass:[QSOrderListHouseInfoDataModel class]]) {
//                
//                QSOrderListHouseInfoDataModel *data = (QSOrderListHouseInfoDataModel*)houseData;
//                
//                houseNum = [NSString stringWithFormat:@"房源编号 %@",data.house_no];
//                houseSmallImgUrl = data.attach_thumb;
//                houseName = data.title;
//                
//            }
//            
//        }
        
        //房源编号
        self.houseTitleIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, CONTENT_TOP_BOTTOM_OFFSETY, (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP), 22)];
        [self.houseTitleIDLabel setFont:[UIFont systemFontOfSize:FONT_BODY_12]];
        [self.houseTitleIDLabel setTextColor:COLOR_CHARACTERS_GRAY];
//        NSString *IDStr = [NSString stringWithFormat:@"%@  %@",TITLE_MYZONE_ORDER_DETAIL_HOUSE_ID_TITLE_TIP, @"128734823428962"];
//        [self.houseTitleIDLabel setText:houseNum];
        [self addSubview:self.houseTitleIDLabel];

        //图片
        self.contentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP-2, self.houseTitleIDLabel.frame.origin.y+self.houseTitleIDLabel.frame.size.height+4, 50, 50)];
//        [self.contentImgView setImageWithURL:[NSURL URLWithString:houseSmallImgUrl]];
        [self addSubview:self.contentImgView];
        
        UIImageView *contentCoverImgView = [[UIImageView alloc] initWithFrame:self.contentImgView.frame];
        [contentCoverImgView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_LIST_CELL_COVER_FRAME]];
        [self addSubview:contentCoverImgView];
        
        //小区名
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.contentImgView.frame.origin.x+self.contentImgView.frame.size.width+4, self.contentImgView.frame.origin.y+(self.contentImgView.frame.size.height-40)/2.0f, (SIZE_DEVICE_WIDTH - CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP)-self.contentImgView.frame.origin.x-self.contentImgView.frame.size.width-44, 40.0f)];
        [self.nameLabel setNumberOfLines:2];
        [self.nameLabel setFont:[UIFont systemFontOfSize:FONT_BODY_16]];
//        [self.nameLabel setText:houseName];
        [self addSubview:self.nameLabel];
        
        //右箭头
        UIImageView *rightArrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.nameLabel.frame.origin.x+self.nameLabel.frame.size.width+12, self.nameLabel.frame.origin.y+(self.nameLabel.frame.size.height-23.0f)/2.f, 13.0f, 23.0f)];
        [rightArrowImgView setImage:[UIImage imageNamed:IMAGE_PUBLIC_RIGHT_ARROW]];
        [self addSubview:rightArrowImgView];
        
        UIButton *clickBt = [UIButton createBlockButtonWithFrame:CGRectMake(self.contentImgView.frame.origin.x, self.contentImgView.frame.origin.y, rightArrowImgView.frame.origin.x+rightArrowImgView.frame.size.width+10, self.contentImgView.frame.size.height) andButtonStyle:[[QSBlockButtonStyleModel alloc] init] andCallBack:^(UIButton *button) {
            
            if (self.blockButtonCallBack) {
                self.blockButtonCallBack(button);
            }
            
        }];
        [self addSubview:clickBt];
        
        ///最下方边界区域
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, self.contentImgView.frame.origin.y+self.contentImgView.frame.size.height, (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP), CONTENT_TOP_BOTTOM_OFFSETY)];
        [bottomView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:bottomView];

        ///分隔线
        UILabel *bottomLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CONTENT_TOP_BOTTOM_OFFSETY-0.5f, (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP), 0.5f)];
        [bottomLineLablel setBackgroundColor:COLOR_CHARACTERS_BLACKH];
        [bottomView addSubview:bottomLineLablel];
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, bottomView.frame.origin.y+bottomView.frame.size.height)];
        
        self.blockButtonCallBack = callBack;
        
        [self setHouseData:houseData];
        
    }
    
    return self;
    
}

- (void)setHouseData:(id)houseData
{
    
    if (self.houseTitleIDLabel) {
        [self.houseTitleIDLabel setText:@""];
    }
    
    if (self.contentImgView) {
        [self.contentImgView setImage:nil];
    }
    
    if (self.nameLabel) {
        [self.nameLabel setText:@""];
    }
    
    if (houseData) {
        
        if ([houseData isKindOfClass:[QSOrderListHouseInfoDataModel class]]) {
            QSOrderListHouseInfoDataModel *data = (QSOrderListHouseInfoDataModel*)houseData;
            
            if (self.houseTitleIDLabel) {
                [self.houseTitleIDLabel setText:[NSString stringWithFormat:@"房源编号 %@",data.house_no]];
            }
            if (self.contentImgView) {
                [self.contentImgView setImageWithURL:[NSURL URLWithString:data.attach_thumb]];
            }
            if (self.nameLabel) {
                [self.nameLabel setText:data.title];
            }
            
        }
        
    }
    
}

@end
