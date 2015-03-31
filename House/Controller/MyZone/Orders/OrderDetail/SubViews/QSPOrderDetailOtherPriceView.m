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

//上下间隙
#define     CONTENT_TOP_BOTTOM_OFFSETY     14.0f

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
        
        NSString *ownerName = @"";
        
        NSString *phoneStr = @"";
        
        NSString *phoneTipStr = @"";
        
        if (orderData) {
            
            if ([orderData isKindOfClass:[QSOrderListItemData class]]) {
                
                QSOrderListOwnerMsgDataModel *owner = ((QSOrderListItemData*)orderData).ownerData;
                NSLog(@"owner:%@",owner);
                if (owner && [owner isKindOfClass:[QSOrderListOwnerMsgDataModel class]]) {
                    
                    ownerName = [NSString stringWithFormat:@"业主:%@",owner.username];
                    
                    NSString *tempPhoneStr = [NSString stringWithString:owner.mobile];
                    BOOL hidePhone = YES;
                    if (hidePhone) {
                        if ([tempPhoneStr length]>=8) {
                            tempPhoneStr = [tempPhoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                        }
                        phoneTipStr = @"(预约成功后开放)";
                    }else{
                        phoneTipStr = @"";
                    }
                    
                    phoneStr = [NSString stringWithFormat:@"电话:%@",tempPhoneStr];
                    
                }
            }
        }
        
        UIImageView *otherPriceBgView = [[UIImageView alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, CONTENT_TOP_BOTTOM_OFFSETY, 73, 44)];
        [otherPriceBgView setImage:[UIImage imageNamed:IMAGE_ZONE_ORDER_DETAIL_OTHER_PRICE_GRAY_BG]];
        
        //对方还价标题
        self.otherNameTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, otherPriceBgView.frame.size.width-4, otherPriceBgView.frame.size.height)];
        [self.otherNameTipLabel setFont:[UIFont systemFontOfSize:FONT_BODY_14]];
        [self.otherNameTipLabel setText:@"业主还价"];
        [self.otherNameTipLabel setTextColor:[UIColor whiteColor]];
        [self.otherNameTipLabel setTextAlignment:NSTextAlignmentCenter];
        [otherPriceBgView addSubview:self.otherNameTipLabel];
        
        self.otherPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(otherPriceBgView.frame.origin.x+otherPriceBgView.frame.size.width-8, otherPriceBgView.frame.origin.y, SIZE_DEVICE_WIDTH-(otherPriceBgView.frame.origin.x+otherPriceBgView.frame.size.width-8)-CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP-44-10, otherPriceBgView.frame.size.height)];
        [self.otherPriceLabel setFont:[UIFont systemFontOfSize:FONT_BODY_14]];
        [self.otherPriceLabel setTextColor:COLOR_CHARACTERS_GRAY];
        [self.otherPriceLabel setText:@"等待业主还价"];
        [self.otherPriceLabel setTextAlignment:NSTextAlignmentCenter];
        [self.otherPriceLabel.layer setCornerRadius:VIEW_SIZE_NORMAL_CORNERADIO];
        [self.otherPriceLabel.layer setBorderWidth:0.5f];
        [self.otherPriceLabel.layer setBorderColor:COLOR_CHARACTERS_GRAY.CGColor];
        [self addSubview:self.otherPriceLabel];

        [self addSubview:otherPriceBgView];
        
        ///接受议价按钮
        QSBlockButtonStyleModel *acceptButtonStyle = [[QSBlockButtonStyleModel alloc] init];
        acceptButtonStyle.imagesNormal = IMAGE_ZONE_ORDER_DETAIL_ACCEPT_BT_NORMAL;
        acceptButtonStyle.imagesHighted = IMAGE_ZONE_ORDER_DETAIL_ACCEPT_BT_PRESSED;
        acceptButtonStyle.imagesSelected = IMAGE_ZONE_ORDER_DETAIL_ACCEPT_BT_PRESSED;
        UIButton *acceptButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP-44, otherPriceBgView.frame.origin.y, 44, 44) andButtonStyle:acceptButtonStyle andCallBack:^(UIButton *button) {
            
            if (self.blockButtonCallBack) {
                self.blockButtonCallBack(button);
            }
            
        }];
        
        [self addSubview:acceptButton];
        
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, otherPriceBgView.frame.origin.y+otherPriceBgView.frame.size.height + 20)];
        
        self.blockButtonCallBack = callBack;
        
    }
    
    return self;
    
}

- (void)setOrderData:(id)orderData
{
    
}

@end
