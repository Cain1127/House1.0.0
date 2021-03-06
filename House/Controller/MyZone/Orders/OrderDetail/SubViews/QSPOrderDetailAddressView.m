//
//  QSPOrderDetailAddressView.m
//  House
//
//  Created by CoolTea on 15/3/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailAddressView.h"
#import "NSString+Calculation.h"
#import "CoreHeader.h"
#import "QSOrderListHouseInfoDataModel.h"

@interface QSPOrderDetailAddressView ()

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic,copy) void(^blockButtonCallBack)(UIButton *button);

@end


@implementation QSPOrderDetailAddressView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withHouseData:(id)houseData andCallBack:(void(^)(UIButton *button))callBack
{
    
    return [self initWithFrame:CGRectMake(topLeftPoint.x, topLeftPoint.y, SIZE_DEVICE_WIDTH, 0.0f) withHouseData:houseData andCallBack:callBack];
    
}

- (instancetype)initWithFrame:(CGRect)frame withHouseData:(id)houseData andCallBack:(void(^)(UIButton *button))callBack
{
    if (self = [super initWithFrame:frame]) {
        
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        
        //地址
        NSString *addressStr = @"";
        
        if (houseData) {
            
            if ([houseData isKindOfClass:[QSOrderListHouseInfoDataModel class]]) {
                
                QSOrderListHouseInfoDataModel *data = (QSOrderListHouseInfoDataModel*)houseData;
                
                addressStr = data.address;
            }
            
        }
        
        CGFloat labelWidth = (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP)-44.0f;
        CGFloat labelHeight = [addressStr calculateStringDisplayHeightByFixedWidth:labelWidth andFontSize:FONT_BODY_14];
        if (labelHeight<44.0f) {
            labelHeight = 44.0f;
        }
        
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, CONTENT_TOP_BOTTOM_OFFSETY, labelWidth, labelHeight)];
        [self.addressLabel setNumberOfLines:0];
        [self.addressLabel setFont:[UIFont systemFontOfSize:FONT_BODY_14]];
        [self.addressLabel setText:addressStr];
        [self addSubview:self.addressLabel];
        
        ///地图定位按钮
        QSBlockButtonStyleModel *mapButtonStyle = [[QSBlockButtonStyleModel alloc] init];
        mapButtonStyle.imagesNormal = IMAGE_ZONE_ORDER_DETAIL_MAP_BT_NORMAL;
        mapButtonStyle.imagesHighted = IMAGE_ZONE_ORDER_DETAIL_MAP_BT_PRESSED;
        mapButtonStyle.imagesSelected = IMAGE_ZONE_ORDER_DETAIL_MAP_BT_PRESSED;
        UIButton *mapButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP-44, self.addressLabel.frame.origin.y+(self.addressLabel.frame.size.height-44.0f)/2.f, 44, 44) andButtonStyle:mapButtonStyle andCallBack:^(UIButton *button) {
            
            NSLog(@"mapButton");
            if (self.blockButtonCallBack) {
                self.blockButtonCallBack(button);
            }
            
        }];
        
        ///大的点击区域
        UIButton *clickBt = [UIButton createBlockButtonWithFrame:CGRectMake(self.addressLabel.frame.origin.x, self.addressLabel.frame.origin.y, mapButton.frame.origin.x+mapButton.frame.size.width+10, self.addressLabel.frame.size.height) andButtonStyle:[[QSBlockButtonStyleModel alloc] init] andCallBack:^(UIButton *button) {
            
            if (self.blockButtonCallBack) {
                self.blockButtonCallBack(button);
            }
            
        }];
        [self addSubview:clickBt];

        [self addSubview:mapButton];
        
        ///最下方边界区域
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, self.addressLabel.frame.origin.y+self.addressLabel.frame.size.height, (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP), CONTENT_TOP_BOTTOM_OFFSETY)];
        [bottomView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:bottomView];
        
        ///分隔线
        UILabel *bottomLineLablel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CONTENT_TOP_BOTTOM_OFFSETY-0.5f, (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP), 0.5f)];
        [bottomLineLablel setBackgroundColor:COLOR_CHARACTERS_BLACKH];
        [bottomView addSubview:bottomLineLablel];
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, bottomView.frame.origin.y+bottomView.frame.size.height)];
        
        self.showHeight = self.frame.size.height;
        
        self.blockButtonCallBack = callBack;
        
    }
    
    return self;
    
}

- (void)setHouseData:(id)houseData{
    
    //地址
    NSString *addressStr = @"";
    
    if (houseData) {
        if ([houseData isKindOfClass:[QSOrderListHouseInfoDataModel class]]) {
            QSOrderListHouseInfoDataModel *data = (QSOrderListHouseInfoDataModel*)houseData;
            addressStr = data.address;
        }
    }
    
    
    CGFloat labelWidth = (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP)-44.0f;
    CGFloat labelHeight = [addressStr calculateStringDisplayHeightByFixedWidth:labelWidth andFontSize:FONT_BODY_14];
    if (labelHeight<44.0f) {
        labelHeight = 44.0f;
    }
    
    if (self.addressLabel) {
        [self.addressLabel setText:addressStr];
        [self.addressLabel setFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, CONTENT_TOP_BOTTOM_OFFSETY, labelWidth, labelHeight)];
    }
    
}


@end
