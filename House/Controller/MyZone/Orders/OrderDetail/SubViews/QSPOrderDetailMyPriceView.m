//
//  QSPOrderDetailMyPriceView.m
//  House
//
//  Created by CoolTea on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailMyPriceView.h"
#import "NSString+Calculation.h"
#import "CoreHeader.h"
#import "QSOrderListReturnData.h"
#import "QSOrderDetailInfoDataModel.h"

@interface QSPOrderDetailMyPriceView ()

@property (nonatomic,copy) void(^blockButtonCallBack)(UIButton *button);
@property (nonatomic, strong) UILabel *myNameTipLabel;
@property (nonatomic, strong) UILabel *myPriceLabel;

@end

@implementation QSPOrderDetailMyPriceView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withOrderData:(id)orderData andCallBack:(void(^)(UIButton *button))callBack
{
    
    return [self initWithFrame:CGRectMake(topLeftPoint.x, topLeftPoint.y, SIZE_DEVICE_WIDTH, 0.0f) withOrderData:orderData andCallBack:callBack];
    
}

- (instancetype)initWithFrame:(CGRect)frame withOrderData:(id)orderData andCallBack:(void(^)(UIButton *button))callBack
{
    if (self = [super initWithFrame:frame]) {
        
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];

        QSOrderDetailInfoDataModel *tempOrderData = nil;
        
        if (orderData) {
            
            if ([orderData isKindOfClass:[QSOrderDetailInfoDataModel class]]) {
                
                tempOrderData = (QSOrderDetailInfoDataModel*)orderData;
                
            }
        }
        
        if (!tempOrderData) {
            NSLog(@"QSPOrderDetailMyPriceView orderdata 格式错误！");
            return self;
        }
        
        UIImageView *myPriceBgView = [[UIImageView alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, CONTENT_TOP_BOTTOM_OFFSETY, 73, 44)];
        [myPriceBgView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_DETAIL_MY_PRICE_YELLOW_BG]];
        
        //对方还价标题
        self.myNameTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, myPriceBgView.frame.size.width-4, myPriceBgView.frame.size.height)];
        [self.myNameTipLabel setFont:[UIFont systemFontOfSize:FONT_BODY_14]];
        [self.myNameTipLabel setText:@"我的出价"];
        [self.myNameTipLabel setTextColor:[UIColor blackColor]];
        [self.myNameTipLabel setTextAlignment:NSTextAlignmentCenter];
        [myPriceBgView addSubview:self.myNameTipLabel];
        
        self.myPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(myPriceBgView.frame.origin.x+myPriceBgView.frame.size.width-8, myPriceBgView.frame.origin.y+0.5f, SIZE_DEVICE_WIDTH-(myPriceBgView.frame.origin.x+myPriceBgView.frame.size.width-8)-CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP-44-10, myPriceBgView.frame.size.height-1.0f)];
        [self.myPriceLabel setFont:[UIFont systemFontOfSize:FONT_BODY_14]];
        [self.myPriceLabel setTextColor:COLOR_CHARACTERS_YELLOW];
        [self.myPriceLabel setTextAlignment:NSTextAlignmentCenter];
        [self.myPriceLabel.layer setCornerRadius:VIEW_SIZE_NORMAL_CORNERADIO];
        [self.myPriceLabel.layer setBorderWidth:0.5f];
        [self.myPriceLabel.layer setBorderColor:COLOR_CHARACTERS_YELLOW.CGColor];
        [self addSubview:self.myPriceLabel];
        
        if (tempOrderData) {
            
            [self.myPriceLabel setAttributedText:[tempOrderData priceStringOnMyPriceView]];
             
        }
        
        [self addSubview:myPriceBgView];
        
        ///接受议价按钮
        QSBlockButtonStyleModel *editePriceButtonStyle = [[QSBlockButtonStyleModel alloc] init];
        editePriceButtonStyle.imagesNormal = IMAGE_ZONE_ORDER_DETAIL_EDITE_PROCE_BT_NORMAL;
        editePriceButtonStyle.imagesHighted = IMAGE_ZONE_ORDER_DETAIL_EDITE_PRICE_BT_PRESSED;
        editePriceButtonStyle.imagesSelected = IMAGE_ZONE_ORDER_DETAIL_EDITE_PRICE_BT_PRESSED;
        UIButton *editePriceButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP-44, myPriceBgView.frame.origin.y, 44, 44) andButtonStyle:editePriceButtonStyle andCallBack:^(UIButton *button) {
            
            if (self.blockButtonCallBack) {
                self.blockButtonCallBack(button);
            }
            
            [self ResetOtherViewOffsetY];
            
        }];
        
        [self addSubview:editePriceButton];
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, myPriceBgView.frame.origin.y+myPriceBgView.frame.size.height)];
        
        self.showHeight = self.frame.size.height;
        
        self.blockButtonCallBack = callBack;
        
        
        USER_COUNT_TYPE userType = [tempOrderData getUserType];
        
        NSString *housePriceStr = tempOrderData.house_msg.house_price;
        if (housePriceStr) {
            CGFloat pricef = [housePriceStr floatValue]/10000.0;
            NSInteger priceInt = (NSInteger)pricef;
            housePriceStr = [NSString stringWithFormat:@"%ld",(long)priceInt];
        }
        
        NSString *salerPriceStr = tempOrderData.last_saler_bid;
        if (salerPriceStr) {
            CGFloat pricef = [salerPriceStr floatValue]/10000.0;
            NSInteger priceInt = (NSInteger)pricef;
            salerPriceStr = [NSString stringWithFormat:@"%ld",(long)priceInt];
        }
        
        NSString *buyerPriceStr = tempOrderData.last_buyer_bid;
        if (buyerPriceStr) {
            CGFloat pricef = [buyerPriceStr floatValue]/10000.0;
            NSInteger priceInt = (NSInteger)pricef;
            buyerPriceStr = [NSString stringWithFormat:@"%ld",(long)priceInt];
        }
        
        NSString *myPriceStr = nil;
        NSString *otherPriceStr = nil;
        
        NSString *userTypeStr = @"";
        if (uUserCountTypeTenant==userType) {
            //房客身份
            userTypeStr = @"业主";
            myPriceStr = buyerPriceStr;
            otherPriceStr = salerPriceStr;
            
        }else {
            //非房客身份
            userTypeStr = @"房客";
            myPriceStr = salerPriceStr;
            otherPriceStr = buyerPriceStr;
            if ([myPriceStr isEqualToString:housePriceStr]) {
                myPriceStr = @"";
            }
            
        }
        
        if (!myPriceStr || [myPriceStr isEqualToString:@""] || [myPriceStr isEqualToString:@"0"]) {
            
            [myPriceBgView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_DETAIL_OTHER_PRICE_GRAY_BG]];
            
            [editePriceButton setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_DETAIL_EDITE_PROCE_BT_NORMAL] forState:UIControlStateNormal];
            
            [self.myNameTipLabel setTextColor:[UIColor whiteColor]];
            [self.myPriceLabel.layer setBorderColor:COLOR_CHARACTERS_GRAY.CGColor];
            
        }
        
        if (uUserCountTypeTenant==userType) {
            //房客身份
            
            if ([@"500252" isEqualToString:tempOrderData.order_status]) {
                
                [editePriceButton setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_DETAIL_EDITE_PROCE_BT_NORMAL] forState:UIControlStateNormal];
                [editePriceButton setEnabled:NO];
                
            }
            
        }
        
    }
    
    return self;
    
}



@end
