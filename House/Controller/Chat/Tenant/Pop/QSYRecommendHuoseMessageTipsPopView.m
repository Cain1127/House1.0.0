//
//  QSYRecommendHuoseMessageTipsPopView.m
//  House
//
//  Created by ysmeng on 15/5/1.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSYRecommendHuoseMessageTipsPopView.h"

#import "QSBlockButtonStyleModel+Normal.h"
#import "NSString+Calculation.h"

#import "QSBaseModel.h"

#import "QSCoreDataManager+App.h"

@interface QSYRecommendHuoseMessageTipsPopView () <UITextFieldDelegate>

@property (nonatomic,unsafe_unretained) QSBaseModel *houseModel;//!<房源数据模型
@property (assign) FILTER_MAIN_TYPE houseType;                  //!<房源类型

///推荐房源提示回调
@property (nonatomic,copy) void(^recommendHouseTipsCallBack)(RECOMMEND_HOUSE_MESSAGE_ACTION_TYPE actionType,NSString *titleString);

@end

@implementation QSYRecommendHuoseMessageTipsPopView

#pragma mark - 初始化
/**
 *  @author         yangshengmeng, 15-05-01 16:05:21
 *
 *  @brief          创建推荐房源询问弹出框
 *
 *  @param frame    大小和位置
 *  @param callBack 提示页面的回调
 *
 *  @return         返回当前创建的推荐房源询问页面
 *
 *  @since          1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andHouseModel:(QSBaseModel *)houseModel andHouseType:(FILTER_MAIN_TYPE)houseType andCallBack:(void(^)(RECOMMEND_HOUSE_MESSAGE_ACTION_TYPE actionType,NSString *titleString))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///背景白色
        self.backgroundColor = [UIColor whiteColor];
        
        ///保存数据
        self.houseModel = houseModel;
        self.houseType = houseType;
        self.recommendHouseTipsCallBack = callBack;
        
        ///创建UI
        [self createRecommendHouseTipsViewUI];
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)createRecommendHouseTipsViewUI
{

    ///图片
    QSImageView *imageView = [[QSImageView alloc] initWithFrame:CGRectMake(3.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 20.0f, 69.0f * 4.0f / 3.0f, 70.0f)];
    [imageView loadImageWithURL:[[self.houseModel valueForKey:@"attach_file"] getImageURL] placeholderImage:[UIImage imageNamed:IMAGE_HOUSES_LOADING_FAIL330x250]];
    [self addSubview:imageView];
    
    ///地址信息
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 5.0f, imageView.frame.origin.y, self.frame.size.width - imageView.frame.size.width - 6.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT - 5.0f, 15.0f)];
    addressLabel.text = [NSString stringWithFormat:@"%@ / %@",[QSCoreDataManager getStreetValWithStreetKey:[self.houseModel valueForKey:@"street"]],[self.houseModel valueForKey:@"village_name"]];
    addressLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    addressLabel.textColor = COLOR_CHARACTERS_GRAY;
    [self addSubview:addressLabel];
    
    ///室厅面积信息
    NSString *houseNumString = [NSString stringWithFormat:@"%@室",[self.houseModel valueForKey:@"house_shi"]];
    if ([[self.houseModel valueForKey:@"house_ting"] length] > 0) {
        
        houseNumString = [houseNumString stringByAppendingString:[NSString stringWithFormat:@"%@厅",[self.houseModel valueForKey:@"house_ting"]]];
        
    }
    
    houseNumString = [houseNumString stringByAppendingString:@" / "];
    
    houseNumString = [houseNumString stringByAppendingString:[NSString stringWithFormat:@"%@㎡",[self.houseModel valueForKey:@"house_area"]]];
    
    UILabel *houseNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(addressLabel.frame.origin.x, addressLabel.frame.origin.y + addressLabel.frame.size.height, addressLabel.frame.size.width, addressLabel.frame.size.height)];
    houseNumLabel.font = [UIFont systemFontOfSize:FONT_BODY_14];
    houseNumLabel.text = houseNumString;
    houseNumLabel.textColor = COLOR_CHARACTERS_GRAY;
    [self addSubview:houseNumLabel];
    
    ///售价或租金
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(houseNumLabel.frame.origin.x, houseNumLabel.frame.origin.y + houseNumLabel.frame.size.height + 20.0f, 160.0f, 20.0f)];
    priceLabel.font = [UIFont boldSystemFontOfSize:FONT_BODY_20];
    [self addSubview:priceLabel];
    
    if (fFilterMainTypeRentalHouse == self.houseType) {
    
        priceLabel.text = [NSString stringWithFormat:@"%@元/月",[self.houseModel valueForKey:@"rent_price"]];
        
    }
    
    if (fFilterMainTypeSecondHouse == self.houseType) {
        
        priceLabel.text = [NSString stringWithFormat:@"%.0f万",[[self.houseModel valueForKey:@"house_price"] floatValue] / 10000.0f];
        
    }
    
    ///输入框
    __block UITextField *inputField = [[UITextField alloc] initWithFrame:CGRectMake(3.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, priceLabel.frame.origin.y + priceLabel.frame.size.height + 20.0f, self.frame.size.width - 6.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44.0f)];
    inputField.layer.borderWidth = 0.5f;
    inputField.layer.borderColor = [COLOR_CHARACTERS_GRAY CGColor];
    inputField.layer.cornerRadius = 6.0f;
    inputField.delegate = self;
    inputField.placeholder = @"请输入给房客的留言内容";
    [self addSubview:inputField];
    
    ///按钮风络
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhiteGray];
    
    ///出售物业
    buttonStyle.title = @"取消";
    UIButton *saleButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT * 3.0f, self.frame.size.height - 20.0f - 44.0f, (self.frame.size.width - 7.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.recommendHouseTipsCallBack) {
            
            self.recommendHouseTipsCallBack(rRecommendHouseMessageActionTypeCancel,nil);
            
        }
        
    }];
    [self addSubview:saleButton];
    
    ///出租物业
    buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerLightYellow];
    buttonStyle.title = @"发送";
    UIButton *rentButton = [UIButton createBlockButtonWithFrame:CGRectMake(saleButton.frame.origin.x + saleButton.frame.size.width + SIZE_DEFAULT_MARGIN_LEFT_RIGHT, saleButton.frame.origin.y, saleButton.frame.size.width, saleButton.frame.size.height) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.recommendHouseTipsCallBack) {
            
            self.recommendHouseTipsCallBack(rRecommendHouseMessageActionTypeConfirm,inputField.text);
            
        }
        
    }];
    [self addSubview:rentButton];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    return YES;

}

@end
