//
//  QSPOrderDetailOtherPriceView.m
//  House
//
//  Created by CoolTea on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailOtherPriceView.h"
#import "NSString+Calculation.h"
#import "CoreHeader.h"
#import "QSOrderListReturnData.h"
#import "QSOrderDetailInfoDataModel.h"

@interface QSPOrderDetailOtherPriceView ()

@property (nonatomic,copy) void(^blockButtonCallBack)(UIButton *button);
@property (nonatomic, strong) UILabel *otherNameTipLabel;
@property (nonatomic, strong) UILabel *otherPriceLabel;

@end

@implementation QSPOrderDetailOtherPriceView

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
        
        UIImageView *otherPriceBgView = [[UIImageView alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, CONTENT_TOP_BOTTOM_OFFSETY, 73, 44)];
        [otherPriceBgView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_DETAIL_OTHER_PRICE_GRAY_BG]];
        
        //对方还价标题
        self.otherNameTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, otherPriceBgView.frame.size.width-4, otherPriceBgView.frame.size.height)];
        [self.otherNameTipLabel setFont:[UIFont systemFontOfSize:FONT_BODY_14]];
        [self.otherNameTipLabel setTextColor:[UIColor whiteColor]];
        [self.otherNameTipLabel setTextAlignment:NSTextAlignmentCenter];
        [otherPriceBgView addSubview:self.otherNameTipLabel];
        
        self.otherPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(otherPriceBgView.frame.origin.x+otherPriceBgView.frame.size.width-8, otherPriceBgView.frame.origin.y+0.5f, SIZE_DEVICE_WIDTH-(otherPriceBgView.frame.origin.x+otherPriceBgView.frame.size.width-8)-CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP-44-10, otherPriceBgView.frame.size.height-1.0f)];
        [self.otherPriceLabel setFont:[UIFont systemFontOfSize:FONT_BODY_14]];
        [self.otherPriceLabel setTextColor:COLOR_CHARACTERS_GRAY];
        [self.otherPriceLabel setTextAlignment:NSTextAlignmentCenter];
        [self.otherPriceLabel.layer setCornerRadius:VIEW_SIZE_NORMAL_CORNERADIO];
        [self.otherPriceLabel.layer setBorderWidth:0.5f];
        [self.otherPriceLabel.layer setBorderColor:COLOR_CHARACTERS_GRAY.CGColor];
        [self addSubview:self.otherPriceLabel];
        
        if (tempOrderData) {
            
            [self.otherPriceLabel setAttributedText:[tempOrderData priceStringOnOtherPriceView]];
            
        }

        [self addSubview:otherPriceBgView];
        
        ///接受议价按钮
        QSBlockButtonStyleModel *acceptButtonStyle = [[QSBlockButtonStyleModel alloc] init];
        acceptButtonStyle.imagesNormal = IMAGE_ZONE_ORDER_DETAIL_ACCEPT_BT_NORMAL;
        UIButton *acceptButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP-44, otherPriceBgView.frame.origin.y, 44, 44) andButtonStyle:acceptButtonStyle andCallBack:^(UIButton *button) {
            
            if (self.blockButtonCallBack) {
                self.blockButtonCallBack(button);
            }
            
        }];
        
        [self addSubview:acceptButton];
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, otherPriceBgView.frame.origin.y+otherPriceBgView.frame.size.height)];
        
        self.showHeight = self.frame.size.height;
        
        self.blockButtonCallBack = callBack;
        
        USER_COUNT_TYPE userType = [tempOrderData getUserType];
        
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
            
        }
        
        
        [self.otherNameTipLabel setText:[NSString stringWithFormat:@"%@还价",userTypeStr]];
        
        if (otherPriceStr && ![otherPriceStr isEqualToString:@""] && ![otherPriceStr isEqualToString:@"0"]) {
            
            [otherPriceBgView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_DETAIL_MY_PRICE_YELLOW_BG]];
            
            [acceptButton setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_DETAIL_ACCEPT_BT_PRESSED] forState:UIControlStateNormal];
            
            [self.otherNameTipLabel setTextColor:[UIColor blackColor]];
            [self.otherPriceLabel.layer setBorderColor:COLOR_CHARACTERS_YELLOW.CGColor];
            
        }
        
    }
    
    return self;
    
}

- (void)setOrderData:(id)orderData
{
    
}

@end
