//
//  QSSinglePickerView.m
//  House
//
//  Created by ysmeng on 15/2/4.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSSinglePickerView.h"
#import "QSCustomSelectedView.h"
#import "QSCDBaseConfigurationDataModel.h"
#import "QSBlockButtonStyleModel+Normal.h"

@interface QSSinglePickerView ()

///单选后的回调
@property (nonatomic,copy) void(^singlePickedCallBack)(SINGLE_PICKVIEW_PICKEDTYPE pickedType,id params);
@property (nonatomic,assign) BOOL isUnLimited;//!<是否不限标识

@end

@implementation QSSinglePickerView

#pragma mark - 初始化
/**
 *  @author             yangshengmeng, 15-02-04 09:02:48
 *
 *  @brief              创建一个给定数据源的单选项view
 *
 *  @param frame        大小和位置
 *  @param dataSource   数据源
 *  @param selectedKey  当前选择状态的key
 *  @param callBack     选择一项内容的一的回调
 *
 *  @return             返回当前创建的单选项窗口
 *
 *  @since              1.0.0
 */
- (instancetype)initWithFrame:(CGRect)frame andDataSource:(NSArray *)dataSource andSelectedKey:(NSString *)selectedKey andPickedCallBack:(void(^)(SINGLE_PICKVIEW_PICKEDTYPE pickedType,id params))callBack
{

    if (self = [super initWithFrame:frame]) {
        
        ///背景颜色
        self.backgroundColor = [UIColor whiteColor];
        
        ///保存回调
        if (callBack) {
            
            self.singlePickedCallBack = callBack;
            
        }
        
        ///取消滚动条
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        ///初始化不限标识
        self.isUnLimited = NO;
        
        ///UI搭建
        [self createSinglePickerViewUI:dataSource andSelectedKey:selectedKey];
        
    }
    
    return self;

}

#pragma mark - UI搭建
/**
 *  @author yangshengmeng, 15-02-04 09:02:29
 *
 *  @brief  单选项的UI搭建
 *
 *  @since  1.0.0
 */
- (void)createSinglePickerViewUI:(NSArray *)dataSource andSelectedKey:(NSString *)selectedKey
{
    
    ///按钮风格
    QSBlockButtonStyleModel *buttonStyle = [QSBlockButtonStyleModel createNormalButtonWithType:nNormalButtonTypeClearGray];
    buttonStyle.titleSelectedColor = COLOR_CHARACTERS_YELLOW;
    
    ///不限
    buttonStyle.title = @"不限";
    UIButton *unlimitedButton = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
        
        ///回调
        if (self.singlePickedCallBack) {
            
            self.singlePickedCallBack(sSinglePickviewPickedTypeUnLimited,nil);
            
        }
        
    }];
    [self addSubview:unlimitedButton];
    if (!selectedKey) {
        
        unlimitedButton.selected = YES;
        
    }

    ///循环创建选择项
    for (int i = 0; i < [dataSource count]; i++) {
        
        ///选择项模型
        QSCDBaseConfigurationDataModel *tempModel = dataSource[i];
        
        ///重置标题
        buttonStyle.title = tempModel.val;
        
        __block UIButton *tempSelectedItem = [UIButton createBlockButtonWithFrame:CGRectMake(0.0f, 44.0f + i * VIEW_SIZE_NORMAL_BUTTON_HEIGHT, self.frame.size.width, VIEW_SIZE_NORMAL_BUTTON_HEIGHT) andButtonStyle:buttonStyle andCallBack:^(UIButton *button) {
            
            ///回调
            if (self.singlePickedCallBack) {
                
                self.singlePickedCallBack(sSinglePickviewPickedTypePicked,tempModel);
                
            }
            
        }];
        tempSelectedItem.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:tempSelectedItem];
        
        ///判断选择标识
        if (selectedKey && [selectedKey isEqualToString:tempModel.key]) {
            
            tempSelectedItem.selected = YES;
            
        } else {
        
            tempSelectedItem.selected = NO;
        
        }
        
    }
    
    ///判断是否需要创建滚动
    CGFloat maxHeight = VIEW_SIZE_NORMAL_BUTTON_HEIGHT * ([dataSource count] + 1);
    if (maxHeight > self.frame.size.height) {
        
        self.contentSize = CGSizeMake(self.frame.size.width, maxHeight + 10.0f);
        
    }

}

@end
