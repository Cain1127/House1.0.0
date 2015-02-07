//
//  QSDistrictPickerView.m
//  House
//
//  Created by ysmeng on 15/1/28.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSDistrictPickerView.h"
#import "QSBlockButtonStyleModel+Normal.h"

#import "QSCDBaseConfigurationDataModel.h"

@interface QSDistrictPickerView ()

///选择地区完成后的回调
@property (nonatomic,copy) void(^districtPickeredCallBack)(CUSTOM_DISTRICT_PICKER_ACTION_TYPE pickedActionType,QSCDBaseConfigurationDataModel *districtModel,QSCDBaseConfigurationDataModel *streetModel);

@property (nonatomic,assign) BOOL isUnLimited;                                          //!<当前是否是不限
@property (nonatomic,retain) QSCDBaseConfigurationDataModel *currentSelectedDistrict;   //!<当前选择的区
@property (nonatomic,retain) QSCDBaseConfigurationDataModel *currentSelectedStreet;     //!<当前选择的街道

@end

@implementation QSDistrictPickerView

#pragma mark - 初始化
/**
 *  @author                     yangshengmeng, 15-01-28 17:01:03
 *
 *  @brief                      根据给定的大小的位置，初始化一个地区选择view，同时只展现到给定的选择级别
 *
 *  @param frame               大小位置
 *  @param selectedDistrictKey 当前处于选择状态的区key
 *  @param selectedStreetKey   当前处于选择状态的街道key
 *  @param callBack            选择地点后的回调
 *
 *  @return                     返回当前创建的地区选择窗口对象
 *
 *  @since                      1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andSelectedStreetKey:(NSString *)selectedStreetKey andDistrictPickeredCallBack:(void(^)(CUSTOM_DISTRICT_PICKER_ACTION_TYPE pickedActionType,QSCDBaseConfigurationDataModel *distictModel,QSCDBaseConfigurationDataModel *streetModel))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///背景颜色
        self.backgroundColor = [UIColor whiteColor];
        
        ///初始化时，表示不限
        self.isUnLimited = selectedStreetKey ? NO : YES;
        
        ///保存回调
        if (callBack) {
            
            self.districtPickeredCallBack = callBack;
            
        }
        
        ///UI搭建
        [self createDistrictPickerUIWithSelectedStreetKey:selectedStreetKey];
        
    }
    
    return self;

}

#pragma mark - UI搭建
///UI搭建
- (void)createDistrictPickerUIWithSelectedStreetKey:(NSString *)selectedStreetKey
{
    
    QSDistrictListView *districtListView = [[QSDistrictListView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height - 84.0f) andSelectedStreetKey:selectedStreetKey andDistrictPickeredCallBack:^(CUSTOM_DISTRICT_PICKER_ACTION_TYPE pickedActionType, QSCDBaseConfigurationDataModel *distictModel, QSCDBaseConfigurationDataModel *streetModel) {
        
        ///判断选择的状态
        if (cCustomDistrictPickerActionTypeUnLimitedDistrict == pickedActionType) {
            
            ///标记为不限
            self.isUnLimited = YES;
            
        }
        
        if (cCustomDistrictPickerActionTypePickedStreet == pickedActionType) {
            
            ///标记为选择
            self.isUnLimited = NO;
            
            ///保存模型
            self.currentSelectedDistrict = distictModel;
            self.currentSelectedStreet = streetModel;
            
        }
        
    }];
    [self addSubview:districtListView];
    
    ///取消按钮
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerWhite];
    buttonStyle.title = @"取消";
    CGFloat widthOfButton = (SIZE_DEFAULT_MAX_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT) / 2.0f;
    UIButton *cancelButton = [UIButton createBlockButtonWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, self.frame.size.height - 69.0f, widthOfButton, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        if (self.districtPickeredCallBack) {
            
            self.districtPickeredCallBack(cCustomDistrictPickerActionTypeUnLimitedDistrict,nil,nil);
            
        }
        
    }];
    [self addSubview:cancelButton];
    
    ///确认按钮
    buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeCornerYellow];
    buttonStyle.title = @"确定";
    UIButton *confirmButton = [UIButton createBlockButtonWithFrame:CGRectMake(self.frame.size.width / 2.0f + SIZE_DEFAULT_MARGIN_LEFT_RIGHT / 2.0f, cancelButton.frame.origin.y, widthOfButton, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.districtPickeredCallBack) {
            
            ///判断是否不限
            if (self.isUnLimited) {
                
                self.districtPickeredCallBack(cCustomDistrictPickerActionTypeUnLimitedDistrict,nil,nil);
                
            } else {
            
                self.districtPickeredCallBack(cCustomDistrictPickerActionTypePickedStreet,self.currentSelectedDistrict,self.currentSelectedStreet);
            
            }
            
        }
        
    }];
    [self addSubview:confirmButton];
    
    ///分隔线
    UILabel *buttonLineLable = [[UILabel alloc] initWithFrame:CGRectMake(cancelButton.frame.origin.x, confirmButton.frame.origin.y - 14.5f, self.frame.size.width  - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.5f)];
    buttonLineLable.backgroundColor = COLOR_CHARACTERS_BLACKH;
    [self addSubview:buttonLineLable];

}

@end
