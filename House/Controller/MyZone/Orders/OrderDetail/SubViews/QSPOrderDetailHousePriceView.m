//
//  QSPOrderDetailHousePriceView.m
//  House
//
//  Created by CoolTea on 15/3/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderDetailHousePriceView.h"
#import "NSString+Calculation.h"
#import "CoreHeader.h"
#import "QSOrderListHouseInfoDataModel.h"

@interface QSPOrderDetailHousePriceView ()

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic,copy) void(^blockButtonCallBack)(UIButton *button);

@end

@implementation QSPOrderDetailHousePriceView

- (instancetype)initAtTopLeft:(CGPoint)topLeftPoint withHouseData:(id)houseData andCallBack:(void(^)(UIButton *button))callBack
{
    
    return [self initWithFrame:CGRectMake(topLeftPoint.x, topLeftPoint.y, SIZE_DEVICE_WIDTH, 0.0f) withHouseData:houseData andCallBack:callBack];
    
}

- (instancetype)initWithFrame:(CGRect)frame withHouseData:(id)houseData andCallBack:(void(^)(UIButton *button))callBack
{
    if (self = [super initWithFrame:frame]) {
        
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        
        //房价
        NSAttributedString *priceInfoString = nil;
        
        if (houseData) {
            
            if ([houseData isKindOfClass:[QSOrderListHouseInfoDataModel class]]) {
                
                QSOrderListHouseInfoDataModel *data = (QSOrderListHouseInfoDataModel*)houseData;
                
                NSString *totalPrice = data.house_price;
                NSString *areaStr = data.house_area;
                
                priceInfoString = [self priceInfoStringWithTotalPrice:totalPrice withAreaStr:areaStr];
            }
        }
        
        CGFloat labelWidth = (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP)-44.0f;
        CGFloat labelHeight = 0;//[addressStr calculateStringDisplayHeightByFixedWidth:labelWidth andFontSize:FONT_BODY_14];
        if (labelHeight<44.0f) {
            labelHeight = 44.0f;
        }
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, CONTENT_TOP_BOTTOM_OFFSETY, labelWidth, labelHeight)];
        [self.priceLabel setNumberOfLines:0];
        [self.priceLabel setFont:[UIFont systemFontOfSize:FONT_BODY_14]];
//        [self.priceLabel setText:addressStr];
        [self addSubview:self.priceLabel];
        if (priceInfoString) {
            [self.priceLabel setAttributedText:priceInfoString];
        }
        
        ///计算器按钮
        QSBlockButtonStyleModel *computerButtonStyle = [[QSBlockButtonStyleModel alloc] init];
        computerButtonStyle.imagesNormal = IMAGE_ZONE_ORDER_DETAIL_COMPUTER_BT_NORMAL;
        computerButtonStyle.imagesHighted = IMAGE_ZONE_ORDER_DETAIL_COMPUTER_BT_PRESSED;
        computerButtonStyle.imagesSelected = IMAGE_ZONE_ORDER_DETAIL_COMPUTER_BT_PRESSED;
        UIButton *computerButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEVICE_WIDTH-CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP-44, self.priceLabel.frame.origin.y+(self.priceLabel.frame.size.height-44.0f)/2.f, 44.0f, 44.0f) andButtonStyle:computerButtonStyle andCallBack:^(UIButton *button) {
            
            NSLog(@"computerButton");
            if (self.blockButtonCallBack) {
                self.blockButtonCallBack(button);
            }
            
        }];
        
//        ///大的点击区域
//        UIButton *clickBt = [UIButton createBlockButtonWithFrame:CGRectMake(self.priceLabel.frame.origin.x, self.priceLabel.frame.origin.y, computerButton.frame.origin.x+computerButton.frame.size.width+10, self.priceLabel.frame.size.height) andButtonStyle:[[QSBlockButtonStyleModel alloc] init] andCallBack:^(UIButton *button) {
//            
//            if (self.blockButtonCallBack) {
//                self.blockButtonCallBack(button);
//            }
//            
//        }];
//        [self addSubview:clickBt];
        
        [self addSubview:computerButton];
        
        ///最下方边界区域
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP, self.priceLabel.frame.origin.y+self.priceLabel.frame.size.height, (SIZE_DEVICE_WIDTH - 2.0f * CONTENT_VIEW_MARGIN_LEFT_RIGHT_GAP), CONTENT_TOP_BOTTOM_OFFSETY)];
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

- (NSAttributedString*)priceInfoStringWithTotalPrice:(NSString*)totalPriceStr withAreaStr:(NSString*)areaStr
{

    NSString *perPriceStr = @"";
    
    if (totalPriceStr&&[totalPriceStr isKindOfClass:[NSString class]]&&![totalPriceStr isEqualToString:@""]) {
        
        if (areaStr&&[areaStr isKindOfClass:[NSString class]]&&![areaStr isEqualToString:@""]) {
            
            CGFloat areaf = areaStr.floatValue;
            if (areaf==0) {
                
                perPriceStr = @"暂无单价";
                
            }else{
                
                CGFloat perPricef = totalPriceStr.floatValue/areaf;
                //转换单位为万的价格
                perPriceStr = [NSString stringWithFormat:@"%.1f",perPricef/10000];
                
            }
            
        }
        
        //转换单位为万的价格
        totalPriceStr = [NSString stringWithFormat:@"%d",(int)(totalPriceStr.floatValue/10000.0)];
        
    }
    
    NSMutableAttributedString *priceInfoString = nil;
    
    if (totalPriceStr&&[totalPriceStr isKindOfClass:[NSString class]]) {
        
        if (totalPriceStr&&[totalPriceStr isEqualToString:@""]) {
            
            totalPriceStr = @"暂无售价";
            
            priceInfoString = [[NSMutableAttributedString alloc] initWithString:totalPriceStr];
            [priceInfoString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_BODY_14] range:NSMakeRange(0, totalPriceStr.length)];
            
        }else{
            
            NSString* tempString = [NSString stringWithFormat:@"售价:%@万|单价:%@万/㎡",totalPriceStr,perPriceStr];
            priceInfoString = [[NSMutableAttributedString alloc] initWithString:tempString];
            [priceInfoString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_YELLOW range:NSMakeRange(3, totalPriceStr.length)];
            [priceInfoString addAttribute:NSForegroundColorAttributeName value:COLOR_CHARACTERS_YELLOW range:NSMakeRange(8+totalPriceStr.length, perPriceStr.length)];
            
            [priceInfoString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:FONT_BODY_14] range:NSMakeRange(0, priceInfoString.length)];
            [priceInfoString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_BODY_20] range:NSMakeRange(3, totalPriceStr.length)];
            [priceInfoString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:FONT_BODY_20] range:NSMakeRange(8+totalPriceStr.length, perPriceStr.length)];
            
        }
        
    }
    
    return priceInfoString;
    
}

- (void)setHouseData:(id)houseData{
    
    //房价
    NSAttributedString *priceInfoString = nil;
    
    if (houseData) {
        
        if ([houseData isKindOfClass:[QSOrderListHouseInfoDataModel class]]) {
            
            QSOrderListHouseInfoDataModel *data = (QSOrderListHouseInfoDataModel*)houseData;
            
            NSString *totalPrice = data.house_price;
            NSString *areaStr = data.house_area;
            
            priceInfoString = [self priceInfoStringWithTotalPrice:totalPrice withAreaStr:areaStr];
        }
    }
    
    if (priceInfoString) {
        [self.priceLabel setAttributedText:priceInfoString];
    }
    
}

@end
